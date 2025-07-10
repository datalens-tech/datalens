#!/usr/bin/env python3
import sys
import json
import datetime
from typing import Dict, Any, Optional
from rich.console import Console
from rich.text import Text

console = Console()

# Log levels mapping (both numeric and string)
LOG_LEVELS = {
    # Numeric levels (pino style)
    10: ("TRACE", "dim white"),
    20: ("DEBUG", "blue"),
    30: ("INFO", "green"),
    40: ("WARN", "yellow"),
    50: ("ERROR", "red"),
    60: ("FATAL", "bold red"),
    # String levels (Python logging style)
    "TRACE": ("TRACE", "dim white"),
    "DEBUG": ("DEBUG", "blue"),
    "INFO": ("INFO", "green"),
    "WARN": ("WARN", "yellow"),
    "WARNING": ("WARN", "yellow"),
    "ERROR": ("ERROR", "red"),
    "CRITICAL": ("FATAL", "bold red"),
    "FATAL": ("FATAL", "bold red"),
}


def format_timestamp(timestamp: Any) -> str:
    """Format timestamp in a human-readable format."""
    try:
        if isinstance(timestamp, (int, float)):
            # Unix timestamp in seconds or milliseconds
            if timestamp > 1e12:  # milliseconds or nanoseconds
                if timestamp > 1e15:  # nanoseconds
                    timestamp = timestamp / 1e9
                else:  # milliseconds
                    timestamp = timestamp / 1000
            dt = datetime.datetime.fromtimestamp(timestamp)
        elif isinstance(timestamp, str):
            # Try different ISO formats
            timestamp_clean = timestamp.replace("Z", "+00:00")
            try:
                dt = datetime.datetime.fromisoformat(timestamp_clean)
            except ValueError:
                # Try parsing without timezone info
                dt = datetime.datetime.strptime(
                    timestamp.split(".")[0], "%Y-%m-%d %H:%M:%S"
                )
        else:
            return str(timestamp)

        return dt.strftime("%H:%M:%S.%f")[:-3]  # HH:MM:SS.mmm format
    except Exception:
        return str(timestamp)


def get_log_level_info(level: Any) -> tuple[str, str]:
    """Get log level name and color."""
    if level is None:
        return "INFO", "green"

    level_key = level
    if isinstance(level, str):
        level_key = level.upper()

    if level_key in LOG_LEVELS:
        return LOG_LEVELS[level_key]
    else:
        return str(level).upper(), "white"


def extract_log_fields(log_obj: Dict[str, Any]) -> Dict[str, Any]:
    """Extract and normalize log fields from various formats."""
    # Possible field mappings
    field_mappings = {
        "timestamp": ["timestamp", "time", "@timestamp", "ts", "isotimestamp"],
        "level": ["level", "levelname", "severity", "log_level"],
        "message": ["message", "msg", "text", "description"],
        "name": ["name", "logger", "logger_name", "category"],
        "hostname": ["hostname", "host", "server"],
        "pid": ["pid", "process_id"],
        "request_id": ["request_id", "requestId", "req_id"],
        "trace_id": ["trace_id", "traceId", "trace"],
        "app_name": ["app_name", "application", "service"],
        "funcName": ["funcName", "function", "func"],
        "lineno": ["lineno", "line", "line_number"],
        "exc_info": ["exc_info", "exception", "error_info"],
        "exc_type": ["exc_type", "exception_type", "error_type"],
    }

    extracted = {}
    used_keys = set()

    # Extract known fields
    for target_field, possible_keys in field_mappings.items():
        for key in possible_keys:
            if key in log_obj:
                extracted[target_field] = log_obj[key]
                used_keys.add(key)
                break

    # Add remaining fields as extra
    extra_fields = {}
    for key, value in log_obj.items():
        if key not in used_keys:
            extra_fields[key] = value

    extracted["extra"] = extra_fields
    return extracted


def format_log(log_obj: Dict[str, Any]) -> Text:
    """Format any JSON log object in pino-like format."""
    fields = extract_log_fields(log_obj)
    text = Text()

    # Format timestamp
    timestamp = fields.get("timestamp")
    if timestamp:
        formatted_time = format_timestamp(timestamp)
        text.append(f"[{formatted_time}] ", style="dim")

    # Format log level
    level = fields.get("level", "INFO")
    level_name, level_color = get_log_level_info(level)
    text.append(f"{level_name:5} ", style=level_color)

    # Format process info
    pid = fields.get("pid")
    if pid:
        text.append(f"({pid}) ", style="dim")

    # Format app/service name
    app_name = fields.get("app_name")
    name = fields.get("name")

    if app_name and name:
        # Extract just the last part of the logger name for brevity
        short_name = name.split(".")[-1] if "." in name else name
        text.append(f"{app_name}/{short_name}: ", style="cyan")
    elif app_name:
        text.append(f"{app_name}: ", style="cyan")
    elif name:
        # Extract just the last part of the logger name for brevity
        short_name = name.split(".")[-1] if "." in name else name
        text.append(f"{short_name}: ", style="cyan")

    # Format message
    message = fields.get("message")
    if message:
        message_str = str(message)
        # Check if message is very long and might contain structured data
        if len(message_str) > 200 and (
            "headers:" in message_str or "method:" in message_str
        ):
            # Try to format structured message more nicely
            text.append(format_structured_message(message_str), style="white")
        else:
            text.append(message_str, style="white")

    # Add context information on new lines
    context_added = False

    # Request/Trace IDs (only show if we have detailed context)
    request_id = fields.get("request_id")
    trace_id = fields.get("trace_id")

    # Only show request/trace IDs if we have other context fields (not for simple logs)
    has_context = any(
        [fields.get("funcName"), fields.get("lineno"), fields.get("app_name")]
    )

    if (request_id or trace_id) and has_context:
        if not context_added:
            text.append("\n")
            context_added = True

        if request_id:
            # Shorten long request IDs for readability
            display_req_id = request_id
            if len(str(request_id)) > 50:
                display_req_id = str(request_id)[:20] + "..." + str(request_id)[-20:]
            text.append(f"    req_id: ", style="dim blue")
            text.append(str(display_req_id), style="dim")
            text.append("\n")

        if trace_id:
            text.append(f"    trace_id: ", style="dim blue")
            text.append(str(trace_id), style="dim")
            text.append("\n")

    # Function and line info
    func_name = fields.get("funcName")
    lineno = fields.get("lineno")

    if func_name or lineno:
        if not context_added:
            text.append("\n")
            context_added = True

        location_parts = []
        if func_name:
            location_parts.append(f"func={func_name}")
        if lineno:
            location_parts.append(f"line={lineno}")

        if location_parts:
            text.append(f"    location: ", style="dim blue")
            text.append(" ".join(location_parts), style="dim")
            text.append("\n")

    # Exception info
    exc_info = fields.get("exc_info")
    exc_type = fields.get("exc_type")

    if exc_info or exc_type:
        if not context_added:
            text.append("\n")
            context_added = True

        if exc_type:
            text.append(f"    exception: ", style="dim red")
            text.append(str(exc_type), style="red")
            text.append("\n")

        if exc_info and exc_info != "null" and exc_info is not None:
            text.append(f"    exc_info: ", style="dim red")
            if isinstance(exc_info, str):
                text.append(exc_info, style="red")
            else:
                text.append(json.dumps(exc_info, indent=2), style="red")
            text.append("\n")

    # Add other extra fields (but be more selective for simple logs)
    extra_fields = fields.get("extra", {})
    if extra_fields and has_context:
        if not context_added:
            text.append("\n")
            context_added = True

        for key, value in extra_fields.items():
            # Skip some noisy fields
            if key in ["timestampns", "tags", "app_instance", "app_version"] and (
                not value or value == "null"
            ):
                continue

            text.append(f"    {key}: ", style="dim blue")

            if isinstance(value, (dict, list)):
                if value:  # Only show non-empty collections
                    text.append(json.dumps(value, indent=2), style="dim")
                else:
                    text.append("null", style="dim")
            else:
                text.append(str(value), style="dim")
            text.append("\n")

    return text


def format_structured_message(message: str) -> str:
    """Format structured messages (like HTTP requests) more nicely."""
    # Try to break up long structured messages
    if "headers:" in message:
        parts = message.split("headers:")
        if len(parts) == 2:
            prefix = parts[0].strip()
            headers_part = parts[1].strip()

            # Try to parse headers if they look like a dict
            if headers_part.startswith("{") and headers_part.endswith("}"):
                try:
                    # Extract just the method and path for the main line
                    method_match = prefix.find("method:")
                    path_match = prefix.find("path:")

                    if method_match != -1 and path_match != -1:
                        # Extract method and path
                        method_part = (
                            prefix[method_match:]
                            .split(",")[0]
                            .replace("method:", "")
                            .strip()
                        )
                        path_part = (
                            prefix[path_match:]
                            .split(",")[0]
                            .replace("path:", "")
                            .strip()
                        )
                        return f"{method_part} {path_part}"
                except:
                    pass

    # For other structured messages, try to extract key info
    if "method:" in message and "path:" in message:
        try:
            method_start = message.find("method:") + 7
            method_end = message.find(",", method_start)
            if method_end == -1:
                method_end = message.find(" ", method_start)

            path_start = message.find("path:") + 5
            path_end = message.find(",", path_start)
            if path_end == -1:
                path_end = message.find(" ", path_start)

            if method_end > method_start and path_end > path_start:
                method = message[method_start:method_end].strip()
                path = message[path_start:path_end].strip()
                return f"{method} {path}"
        except:
            pass

    return message


def pretty_print_log(line: str) -> None:
    """Pretty print a single log line."""
    try:
        log_obj = json.loads(line.strip())

        if isinstance(log_obj, dict):
            formatted = format_log(log_obj)
            console.print(formatted)
        else:
            # Not a dict, just print as JSON
            console.print(json.dumps(log_obj, indent=2))

    except json.JSONDecodeError:
        # Not JSON, print as-is
        console.print(line, end="")
    except Exception as e:
        # Any other error, print original line
        console.print(f"[dim red]Error formatting log: {e}[/dim red]")
        console.print(line, end="")


def main():
    """Main function to process stdin."""
    try:
        for line in sys.stdin:
            if line.strip():  # Skip empty lines
                pretty_print_log(line)
    except KeyboardInterrupt:
        pass
    except BrokenPipeError:
        # Handle broken pipe gracefully (e.g., when piping to head)
        pass


if __name__ == "__main__":
    main()
