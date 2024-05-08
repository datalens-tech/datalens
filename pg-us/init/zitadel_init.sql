CREATE DATABASE zitadel;
GRANT ALL PRIVILEGES ON DATABASE zitadel TO us;
\c zitadel;

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.14
-- Dumped by pg_dump version 13.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminapi; Type: SCHEMA; Schema: -; Owner: us
--

CREATE SCHEMA adminapi;


ALTER SCHEMA adminapi OWNER TO us;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: us
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO us;

--
-- Name: eventstore; Type: SCHEMA; Schema: -; Owner: us
--

CREATE SCHEMA eventstore;


ALTER SCHEMA eventstore OWNER TO us;

--
-- Name: logstore; Type: SCHEMA; Schema: -; Owner: us
--

CREATE SCHEMA logstore;


ALTER SCHEMA logstore OWNER TO us;

--
-- Name: projections; Type: SCHEMA; Schema: -; Owner: us
--

CREATE SCHEMA projections;


ALTER SCHEMA projections OWNER TO us;

--
-- Name: system; Type: SCHEMA; Schema: -; Owner: us
--

CREATE SCHEMA system;


ALTER SCHEMA system OWNER TO us;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: current_sequences; Type: TABLE; Schema: adminapi; Owner: us
--

CREATE TABLE adminapi.current_sequences (
    view_name text NOT NULL,
    current_sequence bigint,
    event_date timestamp with time zone,
    last_successful_spooler_run timestamp with time zone,
    instance_id text NOT NULL
);


ALTER TABLE adminapi.current_sequences OWNER TO us;

--
-- Name: failed_events; Type: TABLE; Schema: adminapi; Owner: us
--

CREATE TABLE adminapi.failed_events (
    view_name text NOT NULL,
    failed_sequence bigint NOT NULL,
    failure_count smallint,
    err_msg text,
    instance_id text NOT NULL,
    last_failed timestamp with time zone
);


ALTER TABLE adminapi.failed_events OWNER TO us;

--
-- Name: locks; Type: TABLE; Schema: adminapi; Owner: us
--

CREATE TABLE adminapi.locks (
    locker_id text,
    locked_until timestamp(3) with time zone,
    view_name text NOT NULL,
    instance_id text NOT NULL
);


ALTER TABLE adminapi.locks OWNER TO us;

--
-- Name: styling; Type: TABLE; Schema: adminapi; Owner: us
--

CREATE TABLE adminapi.styling (
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    label_policy_state smallint DEFAULT (0)::smallint NOT NULL,
    sequence bigint,
    primary_color text,
    background_color text,
    warn_color text,
    font_color text,
    primary_color_dark text,
    background_color_dark text,
    warn_color_dark text,
    font_color_dark text,
    logo_url text,
    icon_url text,
    logo_dark_url text,
    icon_dark_url text,
    font_url text,
    err_msg_popup boolean,
    disable_watermark boolean,
    hide_login_name_suffix boolean,
    instance_id text NOT NULL
);


ALTER TABLE adminapi.styling OWNER TO us;

--
-- Name: styling2; Type: TABLE; Schema: adminapi; Owner: us
--

CREATE TABLE adminapi.styling2 (
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    label_policy_state smallint DEFAULT (0)::smallint NOT NULL,
    sequence bigint,
    primary_color text,
    background_color text,
    warn_color text,
    font_color text,
    primary_color_dark text,
    background_color_dark text,
    warn_color_dark text,
    font_color_dark text,
    logo_url text,
    icon_url text,
    logo_dark_url text,
    icon_dark_url text,
    font_url text,
    err_msg_popup boolean,
    disable_watermark boolean,
    hide_login_name_suffix boolean,
    instance_id text NOT NULL,
    owner_removed boolean DEFAULT false
);


ALTER TABLE adminapi.styling2 OWNER TO us;

--
-- Name: auth_requests; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.auth_requests (
    id text NOT NULL,
    request jsonb,
    code text,
    request_type smallint,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    instance_id text NOT NULL
);


ALTER TABLE auth.auth_requests OWNER TO us;

--
-- Name: current_sequences; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.current_sequences (
    view_name text NOT NULL,
    current_sequence bigint,
    event_date timestamp with time zone,
    last_successful_spooler_run timestamp with time zone,
    instance_id text NOT NULL
);


ALTER TABLE auth.current_sequences OWNER TO us;

--
-- Name: failed_events; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.failed_events (
    view_name text NOT NULL,
    failed_sequence bigint NOT NULL,
    failure_count smallint,
    err_msg text,
    instance_id text NOT NULL,
    last_failed timestamp with time zone
);


ALTER TABLE auth.failed_events OWNER TO us;

--
-- Name: idp_configs; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.idp_configs (
    idp_config_id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    sequence bigint,
    aggregate_id text,
    name text,
    idp_state smallint,
    idp_provider_type smallint,
    is_oidc boolean,
    oidc_client_id text,
    oidc_client_secret jsonb,
    oidc_issuer text,
    oidc_scopes text[],
    oidc_idp_display_name_mapping smallint,
    oidc_idp_username_mapping smallint,
    styling_type smallint,
    oauth_authorization_endpoint text,
    oauth_token_endpoint text,
    auto_register boolean,
    jwt_endpoint text,
    jwt_keys_endpoint text,
    jwt_header_name text,
    instance_id text NOT NULL
);


ALTER TABLE auth.idp_configs OWNER TO us;

--
-- Name: idp_configs2; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.idp_configs2 (
    idp_config_id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    sequence bigint,
    aggregate_id text,
    name text,
    idp_state smallint,
    idp_provider_type smallint,
    is_oidc boolean,
    oidc_client_id text,
    oidc_client_secret jsonb,
    oidc_issuer text,
    oidc_scopes text[],
    oidc_idp_display_name_mapping smallint,
    oidc_idp_username_mapping smallint,
    styling_type smallint,
    oauth_authorization_endpoint text,
    oauth_token_endpoint text,
    auto_register boolean,
    jwt_endpoint text,
    jwt_keys_endpoint text,
    jwt_header_name text,
    instance_id text NOT NULL,
    owner_removed boolean DEFAULT false
);


ALTER TABLE auth.idp_configs2 OWNER TO us;

--
-- Name: idp_providers; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.idp_providers (
    aggregate_id text NOT NULL,
    idp_config_id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    sequence bigint,
    name text,
    idp_config_type smallint,
    idp_provider_type smallint,
    idp_state smallint,
    styling_type smallint,
    instance_id text NOT NULL
);


ALTER TABLE auth.idp_providers OWNER TO us;

--
-- Name: idp_providers2; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.idp_providers2 (
    aggregate_id text NOT NULL,
    idp_config_id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    sequence bigint,
    name text,
    idp_config_type smallint,
    idp_provider_type smallint,
    idp_state smallint,
    styling_type smallint,
    instance_id text NOT NULL,
    owner_removed boolean DEFAULT false
);


ALTER TABLE auth.idp_providers2 OWNER TO us;

--
-- Name: locks; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.locks (
    locker_id text,
    locked_until timestamp(3) with time zone,
    view_name text NOT NULL,
    instance_id text NOT NULL
);


ALTER TABLE auth.locks OWNER TO us;

--
-- Name: org_project_mapping; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.org_project_mapping (
    org_id text NOT NULL,
    project_id text NOT NULL,
    project_grant_id text,
    instance_id text NOT NULL
);


ALTER TABLE auth.org_project_mapping OWNER TO us;

--
-- Name: org_project_mapping2; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.org_project_mapping2 (
    org_id text NOT NULL,
    project_id text NOT NULL,
    project_grant_id text,
    instance_id text NOT NULL,
    owner_removed boolean DEFAULT false
);


ALTER TABLE auth.org_project_mapping2 OWNER TO us;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.refresh_tokens (
    id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    resource_owner text,
    token text,
    client_id text NOT NULL,
    user_agent_id text NOT NULL,
    user_id text NOT NULL,
    auth_time timestamp with time zone,
    idle_expiration timestamp with time zone,
    expiration timestamp with time zone,
    sequence bigint,
    scopes text[],
    audience text[],
    amr text[],
    instance_id text NOT NULL,
    actor jsonb
);


ALTER TABLE auth.refresh_tokens OWNER TO us;

--
-- Name: tokens; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.tokens (
    id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    resource_owner text,
    application_id text,
    user_agent_id text,
    user_id text,
    expiration timestamp with time zone,
    sequence bigint,
    scopes text[],
    audience text[],
    preferred_language text,
    refresh_token_id text,
    is_pat boolean DEFAULT false NOT NULL,
    instance_id text NOT NULL,
    actor jsonb
);


ALTER TABLE auth.tokens OWNER TO us;

--
-- Name: user_external_idps; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.user_external_idps (
    external_user_id text NOT NULL,
    idp_config_id text NOT NULL,
    user_id text,
    idp_name text,
    user_display_name text,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    sequence bigint,
    resource_owner text,
    instance_id text NOT NULL
);


ALTER TABLE auth.user_external_idps OWNER TO us;

--
-- Name: user_external_idps2; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.user_external_idps2 (
    external_user_id text NOT NULL,
    idp_config_id text NOT NULL,
    user_id text,
    idp_name text,
    user_display_name text,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    sequence bigint,
    resource_owner text,
    instance_id text NOT NULL,
    owner_removed boolean DEFAULT false
);


ALTER TABLE auth.user_external_idps2 OWNER TO us;

--
-- Name: user_sessions; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.user_sessions (
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    resource_owner text,
    state smallint,
    user_agent_id text NOT NULL,
    user_id text NOT NULL,
    user_name text,
    password_verification timestamp with time zone,
    second_factor_verification timestamp with time zone,
    multi_factor_verification timestamp with time zone,
    sequence bigint,
    second_factor_verification_type smallint,
    multi_factor_verification_type smallint,
    user_display_name text,
    login_name text,
    external_login_verification timestamp with time zone,
    selected_idp_config_id text,
    passwordless_verification timestamp with time zone,
    avatar_key text,
    instance_id text NOT NULL
);


ALTER TABLE auth.user_sessions OWNER TO us;

--
-- Name: users; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.users (
    id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    resource_owner text,
    user_state smallint,
    password_set boolean,
    password_change_required boolean,
    password_change timestamp with time zone,
    last_login timestamp with time zone,
    user_name text,
    login_names text[],
    preferred_login_name text,
    first_name text,
    last_name text,
    nick_name text,
    display_name text,
    preferred_language text,
    gender smallint,
    email text,
    is_email_verified boolean,
    phone text,
    is_phone_verified boolean,
    country text,
    locality text,
    postal_code text,
    region text,
    street_address text,
    otp_state smallint,
    mfa_max_set_up smallint,
    mfa_init_skipped timestamp with time zone,
    sequence bigint,
    init_required boolean,
    username_change_required boolean,
    machine_name text,
    machine_description text,
    user_type text,
    u2f_tokens bytea,
    passwordless_tokens bytea,
    avatar_key text,
    passwordless_init_required boolean,
    password_init_required boolean,
    instance_id text NOT NULL
);


ALTER TABLE auth.users OWNER TO us;

--
-- Name: users2; Type: TABLE; Schema: auth; Owner: us
--

CREATE TABLE auth.users2 (
    id text NOT NULL,
    creation_date timestamp with time zone,
    change_date timestamp with time zone,
    resource_owner text,
    user_state smallint,
    password_set boolean,
    password_change_required boolean,
    password_change timestamp with time zone,
    last_login timestamp with time zone,
    user_name text,
    login_names text[],
    preferred_login_name text,
    first_name text,
    last_name text,
    nick_name text,
    display_name text,
    preferred_language text,
    gender smallint,
    email text,
    is_email_verified boolean,
    phone text,
    is_phone_verified boolean,
    country text,
    locality text,
    postal_code text,
    region text,
    street_address text,
    otp_state smallint,
    mfa_max_set_up smallint,
    mfa_init_skipped timestamp with time zone,
    sequence bigint,
    init_required boolean,
    username_change_required boolean,
    machine_name text,
    machine_description text,
    user_type text,
    u2f_tokens bytea,
    passwordless_tokens bytea,
    avatar_key text,
    passwordless_init_required boolean,
    password_init_required boolean,
    instance_id text NOT NULL,
    owner_removed boolean DEFAULT false,
    otp_sms_added boolean DEFAULT false,
    otp_email_added boolean DEFAULT false
);


ALTER TABLE auth.users2 OWNER TO us;

--
-- Name: events2; Type: TABLE; Schema: eventstore; Owner: us
--

CREATE TABLE eventstore.events2 (
    instance_id text NOT NULL,
    aggregate_type text NOT NULL,
    aggregate_id text NOT NULL,
    event_type text NOT NULL,
    sequence bigint NOT NULL,
    revision smallint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    payload jsonb,
    creator text NOT NULL,
    owner text NOT NULL,
    "position" numeric NOT NULL,
    in_tx_order integer NOT NULL
);


ALTER TABLE eventstore.events2 OWNER TO us;

--
-- Name: system_seq; Type: SEQUENCE; Schema: eventstore; Owner: us
--

CREATE SEQUENCE eventstore.system_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE eventstore.system_seq OWNER TO us;

--
-- Name: unique_constraints; Type: TABLE; Schema: eventstore; Owner: us
--

CREATE TABLE eventstore.unique_constraints (
    instance_id text NOT NULL,
    unique_type text NOT NULL,
    unique_field text NOT NULL
);


ALTER TABLE eventstore.unique_constraints OWNER TO us;

--
-- Name: access; Type: TABLE; Schema: logstore; Owner: us
--

CREATE TABLE logstore.access (
    log_date timestamp with time zone NOT NULL,
    protocol integer NOT NULL,
    request_url text NOT NULL,
    response_status integer NOT NULL,
    request_headers jsonb,
    response_headers jsonb,
    instance_id text NOT NULL,
    project_id text NOT NULL,
    requested_domain text,
    requested_host text
);


ALTER TABLE logstore.access OWNER TO us;

--
-- Name: execution; Type: TABLE; Schema: logstore; Owner: us
--

CREATE TABLE logstore.execution (
    log_date timestamp with time zone NOT NULL,
    took interval,
    message text NOT NULL,
    loglevel integer NOT NULL,
    instance_id text NOT NULL,
    action_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE logstore.execution OWNER TO us;

--
-- Name: actions3; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.actions3 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    action_state smallint NOT NULL,
    sequence bigint NOT NULL,
    name text NOT NULL,
    script text DEFAULT ''::text NOT NULL,
    timeout bigint DEFAULT 0 NOT NULL,
    allowed_to_fail boolean DEFAULT false NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.actions3 OWNER TO us;

--
-- Name: apps6; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.apps6 (
    id text NOT NULL,
    name text NOT NULL,
    project_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    state smallint NOT NULL,
    sequence bigint NOT NULL
);


ALTER TABLE projections.apps6 OWNER TO us;

--
-- Name: apps6_api_configs; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.apps6_api_configs (
    app_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb,
    auth_method smallint NOT NULL
);


ALTER TABLE projections.apps6_api_configs OWNER TO us;

--
-- Name: apps6_oidc_configs; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.apps6_oidc_configs (
    app_id text NOT NULL,
    instance_id text NOT NULL,
    version smallint NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb,
    redirect_uris text[],
    response_types smallint[],
    grant_types smallint[],
    application_type smallint NOT NULL,
    auth_method_type smallint NOT NULL,
    post_logout_redirect_uris text[],
    is_dev_mode boolean NOT NULL,
    access_token_type smallint NOT NULL,
    access_token_role_assertion boolean DEFAULT false NOT NULL,
    id_token_role_assertion boolean DEFAULT false NOT NULL,
    id_token_userinfo_assertion boolean DEFAULT false NOT NULL,
    clock_skew bigint DEFAULT 0 NOT NULL,
    additional_origins text[],
    skip_native_app_success_page boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.apps6_oidc_configs OWNER TO us;

--
-- Name: apps6_saml_configs; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.apps6_saml_configs (
    app_id text NOT NULL,
    instance_id text NOT NULL,
    entity_id text NOT NULL,
    metadata bytea NOT NULL,
    metadata_url text NOT NULL
);


ALTER TABLE projections.apps6_saml_configs OWNER TO us;

--
-- Name: apps7; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.apps7 (
    id text NOT NULL,
    name text NOT NULL,
    project_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    state smallint NOT NULL,
    sequence bigint NOT NULL
);


ALTER TABLE projections.apps7 OWNER TO us;

--
-- Name: apps7_api_configs; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.apps7_api_configs (
    app_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret text,
    auth_method smallint NOT NULL
);


ALTER TABLE projections.apps7_api_configs OWNER TO us;

--
-- Name: apps7_oidc_configs; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.apps7_oidc_configs (
    app_id text NOT NULL,
    instance_id text NOT NULL,
    version smallint NOT NULL,
    client_id text NOT NULL,
    client_secret text,
    redirect_uris text[],
    response_types smallint[],
    grant_types smallint[],
    application_type smallint NOT NULL,
    auth_method_type smallint NOT NULL,
    post_logout_redirect_uris text[],
    is_dev_mode boolean NOT NULL,
    access_token_type smallint NOT NULL,
    access_token_role_assertion boolean DEFAULT false NOT NULL,
    id_token_role_assertion boolean DEFAULT false NOT NULL,
    id_token_userinfo_assertion boolean DEFAULT false NOT NULL,
    clock_skew bigint DEFAULT 0 NOT NULL,
    additional_origins text[],
    skip_native_app_success_page boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.apps7_oidc_configs OWNER TO us;

--
-- Name: apps7_saml_configs; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.apps7_saml_configs (
    app_id text NOT NULL,
    instance_id text NOT NULL,
    entity_id text NOT NULL,
    metadata bytea NOT NULL,
    metadata_url text NOT NULL
);


ALTER TABLE projections.apps7_saml_configs OWNER TO us;

--
-- Name: auth_requests; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.auth_requests (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    login_client text NOT NULL,
    client_id text NOT NULL,
    redirect_uri text NOT NULL,
    scope text[] NOT NULL,
    prompt smallint[],
    ui_locales text[],
    max_age bigint,
    login_hint text,
    hint_user_id text
);


ALTER TABLE projections.auth_requests OWNER TO us;

--
-- Name: authn_keys2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.authn_keys2 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    aggregate_id text NOT NULL,
    sequence bigint NOT NULL,
    object_id text NOT NULL,
    expiration timestamp with time zone NOT NULL,
    identifier text NOT NULL,
    public_key bytea NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    type smallint DEFAULT 0 NOT NULL
);


ALTER TABLE projections.authn_keys2 OWNER TO us;

--
-- Name: current_sequences; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.current_sequences (
    projection_name text NOT NULL,
    aggregate_type text NOT NULL,
    current_sequence bigint,
    instance_id text NOT NULL,
    "timestamp" timestamp with time zone
);


ALTER TABLE projections.current_sequences OWNER TO us;

--
-- Name: current_states; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.current_states (
    projection_name text NOT NULL,
    instance_id text NOT NULL,
    last_updated timestamp with time zone,
    aggregate_id text,
    aggregate_type text,
    sequence bigint,
    event_date timestamp with time zone,
    "position" numeric,
    filter_offset integer
);


ALTER TABLE projections.current_states OWNER TO us;

--
-- Name: custom_texts2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.custom_texts2 (
    aggregate_id text NOT NULL,
    instance_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    is_default boolean NOT NULL,
    template text NOT NULL,
    language text NOT NULL,
    key text NOT NULL,
    text text NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.custom_texts2 OWNER TO us;

--
-- Name: device_auth_requests; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.device_auth_requests (
    client_id text NOT NULL,
    device_code text NOT NULL,
    user_code text NOT NULL,
    scopes text[] NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    instance_id text NOT NULL
);


ALTER TABLE projections.device_auth_requests OWNER TO us;

--
-- Name: device_auth_requests2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.device_auth_requests2 (
    client_id text NOT NULL,
    device_code text NOT NULL,
    user_code text NOT NULL,
    scopes text[],
    audience text[],
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    instance_id text NOT NULL
);


ALTER TABLE projections.device_auth_requests2 OWNER TO us;

--
-- Name: domain_policies2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.domain_policies2 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    user_login_must_be_domain boolean NOT NULL,
    validate_org_domains boolean NOT NULL,
    smtp_sender_address_matches_instance_domain boolean NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.domain_policies2 OWNER TO us;

--
-- Name: executions; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.executions (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    sequence bigint NOT NULL,
    targets text[],
    includes text[]
);


ALTER TABLE projections.executions OWNER TO us;

--
-- Name: failed_events; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.failed_events (
    projection_name text NOT NULL,
    failed_sequence bigint NOT NULL,
    failure_count smallint,
    error text,
    instance_id text NOT NULL,
    last_failed timestamp with time zone
);


ALTER TABLE projections.failed_events OWNER TO us;

--
-- Name: failed_events2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.failed_events2 (
    projection_name text NOT NULL,
    instance_id text NOT NULL,
    aggregate_type text NOT NULL,
    aggregate_id text NOT NULL,
    event_creation_date timestamp with time zone NOT NULL,
    failed_sequence bigint NOT NULL,
    failure_count smallint DEFAULT 0,
    error text,
    last_failed timestamp with time zone
);


ALTER TABLE projections.failed_events2 OWNER TO us;

--
-- Name: flow_triggers3; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.flow_triggers3 (
    flow_type smallint NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    trigger_type smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    trigger_sequence bigint NOT NULL,
    action_id text NOT NULL
);


ALTER TABLE projections.flow_triggers3 OWNER TO us;

--
-- Name: idp_login_policy_links5; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_login_policy_links5 (
    idp_id text NOT NULL,
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    provider_type smallint NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.idp_login_policy_links5 OWNER TO us;

--
-- Name: idp_templates5; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    state smallint NOT NULL,
    name text,
    owner_type smallint NOT NULL,
    type smallint NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL,
    is_creation_allowed boolean DEFAULT false NOT NULL,
    is_linking_allowed boolean DEFAULT false NOT NULL,
    is_auto_creation boolean DEFAULT false NOT NULL,
    is_auto_update boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.idp_templates5 OWNER TO us;

--
-- Name: idp_templates5_apple; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_apple (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    team_id text NOT NULL,
    key_id text NOT NULL,
    private_key jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates5_apple OWNER TO us;

--
-- Name: idp_templates5_azure; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_azure (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text,
    tenant text,
    is_email_verified boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.idp_templates5_azure OWNER TO us;

--
-- Name: idp_templates5_github; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_github (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates5_github OWNER TO us;

--
-- Name: idp_templates5_github_enterprise; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_github_enterprise (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    authorization_endpoint text NOT NULL,
    token_endpoint text NOT NULL,
    user_endpoint text NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates5_github_enterprise OWNER TO us;

--
-- Name: idp_templates5_gitlab; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_gitlab (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates5_gitlab OWNER TO us;

--
-- Name: idp_templates5_gitlab_self_hosted; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_gitlab_self_hosted (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    issuer text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates5_gitlab_self_hosted OWNER TO us;

--
-- Name: idp_templates5_google; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_google (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates5_google OWNER TO us;

--
-- Name: idp_templates5_jwt; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_jwt (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    issuer text NOT NULL,
    jwt_endpoint text NOT NULL,
    keys_endpoint text NOT NULL,
    header_name text
);


ALTER TABLE projections.idp_templates5_jwt OWNER TO us;

--
-- Name: idp_templates5_ldap2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_ldap2 (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    servers text[] NOT NULL,
    start_tls boolean NOT NULL,
    base_dn text NOT NULL,
    bind_dn text NOT NULL,
    bind_password jsonb NOT NULL,
    user_base text NOT NULL,
    user_object_classes text[] NOT NULL,
    user_filters text[] NOT NULL,
    timeout bigint NOT NULL,
    id_attribute text,
    first_name_attribute text,
    last_name_attribute text,
    display_name_attribute text,
    nick_name_attribute text,
    preferred_username_attribute text,
    email_attribute text,
    email_verified text,
    phone_attribute text,
    phone_verified_attribute text,
    preferred_language_attribute text,
    avatar_url_attribute text,
    profile_attribute text
);


ALTER TABLE projections.idp_templates5_ldap2 OWNER TO us;

--
-- Name: idp_templates5_oauth2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_oauth2 (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    authorization_endpoint text NOT NULL,
    token_endpoint text NOT NULL,
    user_endpoint text NOT NULL,
    scopes text[],
    id_attribute text NOT NULL
);


ALTER TABLE projections.idp_templates5_oauth2 OWNER TO us;

--
-- Name: idp_templates5_oidc; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_oidc (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    issuer text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[],
    id_token_mapping boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.idp_templates5_oidc OWNER TO us;

--
-- Name: idp_templates5_saml; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates5_saml (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    metadata bytea NOT NULL,
    key jsonb NOT NULL,
    certificate bytea NOT NULL,
    binding text,
    with_signed_request boolean
);


ALTER TABLE projections.idp_templates5_saml OWNER TO us;

--
-- Name: idp_templates6; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    state smallint NOT NULL,
    name text,
    owner_type smallint NOT NULL,
    type smallint NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL,
    is_creation_allowed boolean DEFAULT false NOT NULL,
    is_linking_allowed boolean DEFAULT false NOT NULL,
    is_auto_creation boolean DEFAULT false NOT NULL,
    is_auto_update boolean DEFAULT false NOT NULL,
    auto_linking smallint DEFAULT 0 NOT NULL
);


ALTER TABLE projections.idp_templates6 OWNER TO us;

--
-- Name: idp_templates6_apple; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_apple (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    team_id text NOT NULL,
    key_id text NOT NULL,
    private_key jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates6_apple OWNER TO us;

--
-- Name: idp_templates6_azure; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_azure (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text,
    tenant text,
    is_email_verified boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.idp_templates6_azure OWNER TO us;

--
-- Name: idp_templates6_github; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_github (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates6_github OWNER TO us;

--
-- Name: idp_templates6_github_enterprise; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_github_enterprise (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    authorization_endpoint text NOT NULL,
    token_endpoint text NOT NULL,
    user_endpoint text NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates6_github_enterprise OWNER TO us;

--
-- Name: idp_templates6_gitlab; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_gitlab (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates6_gitlab OWNER TO us;

--
-- Name: idp_templates6_gitlab_self_hosted; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_gitlab_self_hosted (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    issuer text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates6_gitlab_self_hosted OWNER TO us;

--
-- Name: idp_templates6_google; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_google (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[]
);


ALTER TABLE projections.idp_templates6_google OWNER TO us;

--
-- Name: idp_templates6_jwt; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_jwt (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    issuer text NOT NULL,
    jwt_endpoint text NOT NULL,
    keys_endpoint text NOT NULL,
    header_name text
);


ALTER TABLE projections.idp_templates6_jwt OWNER TO us;

--
-- Name: idp_templates6_ldap2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_ldap2 (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    servers text[] NOT NULL,
    start_tls boolean NOT NULL,
    base_dn text NOT NULL,
    bind_dn text NOT NULL,
    bind_password jsonb NOT NULL,
    user_base text NOT NULL,
    user_object_classes text[] NOT NULL,
    user_filters text[] NOT NULL,
    timeout bigint NOT NULL,
    id_attribute text,
    first_name_attribute text,
    last_name_attribute text,
    display_name_attribute text,
    nick_name_attribute text,
    preferred_username_attribute text,
    email_attribute text,
    email_verified text,
    phone_attribute text,
    phone_verified_attribute text,
    preferred_language_attribute text,
    avatar_url_attribute text,
    profile_attribute text
);


ALTER TABLE projections.idp_templates6_ldap2 OWNER TO us;

--
-- Name: idp_templates6_oauth2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_oauth2 (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    authorization_endpoint text NOT NULL,
    token_endpoint text NOT NULL,
    user_endpoint text NOT NULL,
    scopes text[],
    id_attribute text NOT NULL
);


ALTER TABLE projections.idp_templates6_oauth2 OWNER TO us;

--
-- Name: idp_templates6_oidc; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_oidc (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    issuer text NOT NULL,
    client_id text NOT NULL,
    client_secret jsonb NOT NULL,
    scopes text[],
    id_token_mapping boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.idp_templates6_oidc OWNER TO us;

--
-- Name: idp_templates6_saml; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_templates6_saml (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    metadata bytea NOT NULL,
    key jsonb NOT NULL,
    certificate bytea NOT NULL,
    binding text,
    with_signed_request boolean
);


ALTER TABLE projections.idp_templates6_saml OWNER TO us;

--
-- Name: idp_user_links3; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idp_user_links3 (
    idp_id text NOT NULL,
    user_id text NOT NULL,
    external_user_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    display_name text NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.idp_user_links3 OWNER TO us;

--
-- Name: idps3; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idps3 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    state smallint NOT NULL,
    name text NOT NULL,
    styling_type smallint NOT NULL,
    owner_type smallint NOT NULL,
    auto_register boolean DEFAULT false NOT NULL,
    type smallint,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.idps3 OWNER TO us;

--
-- Name: idps3_jwt_config; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idps3_jwt_config (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    issuer text,
    keys_endpoint text,
    header_name text,
    endpoint text
);


ALTER TABLE projections.idps3_jwt_config OWNER TO us;

--
-- Name: idps3_oidc_config; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.idps3_oidc_config (
    idp_id text NOT NULL,
    instance_id text NOT NULL,
    client_id text,
    client_secret jsonb,
    issuer text,
    scopes text[],
    display_name_mapping smallint,
    username_mapping smallint,
    authorization_endpoint text,
    token_endpoint text
);


ALTER TABLE projections.idps3_oidc_config OWNER TO us;

--
-- Name: instance_domains; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.instance_domains (
    instance_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    domain text NOT NULL,
    is_generated boolean NOT NULL,
    is_primary boolean NOT NULL
);


ALTER TABLE projections.instance_domains OWNER TO us;

--
-- Name: instance_features2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.instance_features2 (
    instance_id text NOT NULL,
    key text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    value jsonb NOT NULL
);


ALTER TABLE projections.instance_features2 OWNER TO us;

--
-- Name: instance_members4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.instance_members4 (
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    user_id text NOT NULL,
    user_resource_owner text NOT NULL,
    roles text[],
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    id text NOT NULL
);


ALTER TABLE projections.instance_members4 OWNER TO us;

--
-- Name: instances; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.instances (
    id text NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    change_date timestamp with time zone NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    default_org_id text DEFAULT ''::text NOT NULL,
    iam_project_id text DEFAULT ''::text NOT NULL,
    console_client_id text DEFAULT ''::text NOT NULL,
    console_app_id text DEFAULT ''::text NOT NULL,
    sequence bigint NOT NULL,
    default_language text DEFAULT ''::text NOT NULL
);


ALTER TABLE projections.instances OWNER TO us;

--
-- Name: keys4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.keys4 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    sequence bigint NOT NULL,
    algorithm text DEFAULT ''::text NOT NULL,
    use smallint DEFAULT 0 NOT NULL
);


ALTER TABLE projections.keys4 OWNER TO us;

--
-- Name: keys4_certificate; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.keys4_certificate (
    id text NOT NULL,
    instance_id text NOT NULL,
    expiry timestamp with time zone NOT NULL,
    certificate bytea NOT NULL
);


ALTER TABLE projections.keys4_certificate OWNER TO us;

--
-- Name: keys4_private; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.keys4_private (
    id text NOT NULL,
    instance_id text NOT NULL,
    expiry timestamp with time zone NOT NULL,
    key jsonb NOT NULL
);


ALTER TABLE projections.keys4_private OWNER TO us;

--
-- Name: keys4_public; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.keys4_public (
    id text NOT NULL,
    instance_id text NOT NULL,
    expiry timestamp with time zone NOT NULL,
    key bytea NOT NULL
);


ALTER TABLE projections.keys4_public OWNER TO us;

--
-- Name: label_policies3; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.label_policies3 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    hide_login_name_suffix boolean DEFAULT false NOT NULL,
    watermark_disabled boolean DEFAULT false NOT NULL,
    should_error_popup boolean DEFAULT false NOT NULL,
    font_url text,
    light_primary_color text,
    light_warn_color text,
    light_background_color text,
    light_font_color text,
    light_logo_url text,
    light_icon_url text,
    dark_primary_color text,
    dark_warn_color text,
    dark_background_color text,
    dark_font_color text,
    dark_logo_url text,
    dark_icon_url text,
    owner_removed boolean DEFAULT false NOT NULL,
    theme_mode smallint DEFAULT 0 NOT NULL
);


ALTER TABLE projections.label_policies3 OWNER TO us;

--
-- Name: limits; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.limits (
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    sequence bigint NOT NULL,
    audit_log_retention interval,
    block boolean
);


ALTER TABLE projections.limits OWNER TO us;

--
-- Name: lockout_policies2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.lockout_policies2 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    max_password_attempts bigint NOT NULL,
    show_failure boolean NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.lockout_policies2 OWNER TO us;

--
-- Name: lockout_policies3; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.lockout_policies3 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    max_password_attempts bigint NOT NULL,
    max_otp_attempts bigint DEFAULT 0 NOT NULL,
    show_failure boolean NOT NULL
);


ALTER TABLE projections.lockout_policies3 OWNER TO us;

--
-- Name: locks; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.locks (
    locker_id text,
    locked_until timestamp(3) with time zone,
    projection_name text NOT NULL,
    instance_id text NOT NULL
);


ALTER TABLE projections.locks OWNER TO us;

--
-- Name: login_names3_domains; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.login_names3_domains (
    name text NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    name_lower text GENERATED ALWAYS AS (lower(name)) STORED
);


ALTER TABLE projections.login_names3_domains OWNER TO us;

--
-- Name: login_names3_policies; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.login_names3_policies (
    must_be_domain boolean NOT NULL,
    is_default boolean NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL
);


ALTER TABLE projections.login_names3_policies OWNER TO us;

--
-- Name: login_names3_users; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.login_names3_users (
    id text NOT NULL,
    user_name text NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    user_name_lower text GENERATED ALWAYS AS (lower(user_name)) STORED
);


ALTER TABLE projections.login_names3_users OWNER TO us;

--
-- Name: login_names3; Type: VIEW; Schema: projections; Owner: us
--

CREATE VIEW projections.login_names3 AS
 SELECT login_names3.user_id,
        CASE
            WHEN login_names3.must_be_domain THEN concat(login_names3.user_name, '@', login_names3.domain)
            ELSE login_names3.user_name
        END AS login_name,
    COALESCE(login_names3.is_primary, true) AS is_primary,
    login_names3.instance_id
   FROM ( SELECT policy_users.user_id,
            policy_users.user_name,
            policy_users.resource_owner,
            policy_users.instance_id,
            policy_users.must_be_domain,
            domains.name AS domain,
            domains.is_primary
           FROM (( SELECT users.id AS user_id,
                    users.user_name,
                    users.instance_id,
                    users.resource_owner,
                    COALESCE(policy_custom.must_be_domain, policy_default.must_be_domain) AS must_be_domain
                   FROM ((projections.login_names3_users users
                     LEFT JOIN projections.login_names3_policies policy_custom ON (((policy_custom.resource_owner = users.resource_owner) AND (policy_custom.instance_id = users.instance_id))))
                     LEFT JOIN projections.login_names3_policies policy_default ON (((policy_default.is_default = true) AND (policy_default.instance_id = users.instance_id))))) policy_users
             LEFT JOIN projections.login_names3_domains domains ON ((policy_users.must_be_domain AND (policy_users.resource_owner = domains.resource_owner) AND (policy_users.instance_id = domains.instance_id))))) login_names3;


ALTER TABLE projections.login_names3 OWNER TO us;

--
-- Name: login_policies5; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.login_policies5 (
    aggregate_id text NOT NULL,
    instance_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    allow_register boolean NOT NULL,
    allow_username_password boolean NOT NULL,
    allow_external_idps boolean NOT NULL,
    force_mfa boolean NOT NULL,
    force_mfa_local_only boolean DEFAULT false NOT NULL,
    second_factors smallint[],
    multi_factors smallint[],
    passwordless_type smallint NOT NULL,
    hide_password_reset boolean NOT NULL,
    ignore_unknown_usernames boolean NOT NULL,
    allow_domain_discovery boolean NOT NULL,
    disable_login_with_email boolean NOT NULL,
    disable_login_with_phone boolean NOT NULL,
    default_redirect_uri text,
    password_check_lifetime bigint NOT NULL,
    external_login_check_lifetime bigint NOT NULL,
    mfa_init_skip_lifetime bigint NOT NULL,
    second_factor_check_lifetime bigint NOT NULL,
    multi_factor_check_lifetime bigint NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.login_policies5 OWNER TO us;

--
-- Name: mail_templates2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.mail_templates2 (
    aggregate_id text NOT NULL,
    instance_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    template bytea NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.mail_templates2 OWNER TO us;

--
-- Name: message_texts2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.message_texts2 (
    aggregate_id text NOT NULL,
    instance_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    type text NOT NULL,
    language text NOT NULL,
    title text,
    pre_header text,
    subject text,
    greeting text,
    text text,
    button_text text,
    footer_text text,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.message_texts2 OWNER TO us;

--
-- Name: milestones; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.milestones (
    instance_id text NOT NULL,
    type smallint NOT NULL,
    reached_date timestamp with time zone,
    last_pushed_date timestamp with time zone,
    primary_domain text,
    ignore_client_ids text[]
);


ALTER TABLE projections.milestones OWNER TO us;

--
-- Name: notification_policies; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.notification_policies (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    is_default boolean NOT NULL,
    password_change boolean NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.notification_policies OWNER TO us;

--
-- Name: notification_providers; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.notification_providers (
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    state smallint NOT NULL,
    provider_type smallint NOT NULL,
    compact boolean NOT NULL
);


ALTER TABLE projections.notification_providers OWNER TO us;

--
-- Name: oidc_settings2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.oidc_settings2 (
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    sequence bigint NOT NULL,
    access_token_lifetime bigint NOT NULL,
    id_token_lifetime bigint NOT NULL,
    refresh_token_idle_expiration bigint NOT NULL,
    refresh_token_expiration bigint NOT NULL
);


ALTER TABLE projections.oidc_settings2 OWNER TO us;

--
-- Name: org_domains2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.org_domains2 (
    org_id text NOT NULL,
    instance_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    domain text NOT NULL,
    is_verified boolean NOT NULL,
    is_primary boolean NOT NULL,
    validation_type smallint NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.org_domains2 OWNER TO us;

--
-- Name: org_members4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.org_members4 (
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    user_id text NOT NULL,
    user_resource_owner text NOT NULL,
    roles text[],
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    org_id text NOT NULL
);


ALTER TABLE projections.org_members4 OWNER TO us;

--
-- Name: org_metadata2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.org_metadata2 (
    org_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    key text NOT NULL,
    value bytea,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.org_metadata2 OWNER TO us;

--
-- Name: orgs1; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.orgs1 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    org_state smallint NOT NULL,
    sequence bigint NOT NULL,
    name text NOT NULL,
    primary_domain text DEFAULT ''::text NOT NULL
);


ALTER TABLE projections.orgs1 OWNER TO us;

--
-- Name: password_age_policies2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.password_age_policies2 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    expire_warn_days bigint NOT NULL,
    max_age_days bigint NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.password_age_policies2 OWNER TO us;

--
-- Name: password_complexity_policies2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.password_complexity_policies2 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    min_length bigint NOT NULL,
    has_lowercase boolean NOT NULL,
    has_uppercase boolean NOT NULL,
    has_symbol boolean NOT NULL,
    has_number boolean NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.password_complexity_policies2 OWNER TO us;

--
-- Name: personal_access_tokens3; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.personal_access_tokens3 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    user_id text NOT NULL,
    expiration timestamp with time zone NOT NULL,
    scopes text[],
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.personal_access_tokens3 OWNER TO us;

--
-- Name: privacy_policies3; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.privacy_policies3 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    privacy_link text NOT NULL,
    tos_link text NOT NULL,
    help_link text NOT NULL,
    support_email text NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.privacy_policies3 OWNER TO us;

--
-- Name: project_grant_members4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.project_grant_members4 (
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    user_id text NOT NULL,
    user_resource_owner text NOT NULL,
    roles text[],
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    project_id text NOT NULL,
    grant_id text NOT NULL,
    granted_org text NOT NULL
);


ALTER TABLE projections.project_grant_members4 OWNER TO us;

--
-- Name: project_grants4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.project_grants4 (
    grant_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    project_id text NOT NULL,
    granted_org_id text NOT NULL,
    granted_role_keys text[]
);


ALTER TABLE projections.project_grants4 OWNER TO us;

--
-- Name: project_members4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.project_members4 (
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    user_id text NOT NULL,
    user_resource_owner text NOT NULL,
    roles text[],
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    project_id text NOT NULL
);


ALTER TABLE projections.project_members4 OWNER TO us;

--
-- Name: project_roles4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.project_roles4 (
    project_id text NOT NULL,
    role_key text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    display_name text NOT NULL,
    group_name text NOT NULL
);


ALTER TABLE projections.project_roles4 OWNER TO us;

--
-- Name: projects4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.projects4 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    name text NOT NULL,
    project_role_assertion boolean NOT NULL,
    project_role_check boolean NOT NULL,
    has_project_check boolean NOT NULL,
    private_labeling_setting smallint NOT NULL
);


ALTER TABLE projections.projects4 OWNER TO us;

--
-- Name: quotas; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.quotas (
    id text NOT NULL,
    instance_id text NOT NULL,
    unit smallint NOT NULL,
    amount bigint,
    from_anchor timestamp with time zone,
    "interval" interval,
    limit_usage boolean
);


ALTER TABLE projections.quotas OWNER TO us;

--
-- Name: quotas_notifications; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.quotas_notifications (
    instance_id text NOT NULL,
    unit smallint NOT NULL,
    id text NOT NULL,
    call_url text NOT NULL,
    percent bigint NOT NULL,
    repeat boolean NOT NULL,
    latest_due_period_start timestamp with time zone,
    next_due_threshold bigint
);


ALTER TABLE projections.quotas_notifications OWNER TO us;

--
-- Name: quotas_periods; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.quotas_periods (
    instance_id text NOT NULL,
    unit smallint NOT NULL,
    start timestamp with time zone NOT NULL,
    usage bigint NOT NULL
);


ALTER TABLE projections.quotas_periods OWNER TO us;

--
-- Name: restrictions2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.restrictions2 (
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    sequence bigint NOT NULL,
    disallow_public_org_registration boolean,
    allowed_languages text[]
);


ALTER TABLE projections.restrictions2 OWNER TO us;

--
-- Name: secret_generators2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.secret_generators2 (
    generator_type smallint NOT NULL,
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    length bigint NOT NULL,
    expiry bigint NOT NULL,
    include_lower_letters boolean NOT NULL,
    include_upper_letters boolean NOT NULL,
    include_digits boolean NOT NULL,
    include_symbols boolean NOT NULL
);


ALTER TABLE projections.secret_generators2 OWNER TO us;

--
-- Name: security_policies2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.security_policies2 (
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    instance_id text NOT NULL,
    sequence bigint NOT NULL,
    enable_iframe_embedding boolean DEFAULT false NOT NULL,
    origins text[],
    enable_impersonation boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.security_policies2 OWNER TO us;

--
-- Name: sessions8; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.sessions8 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    creator text NOT NULL,
    user_id text,
    user_resource_owner text,
    user_checked_at timestamp with time zone,
    password_checked_at timestamp with time zone,
    intent_checked_at timestamp with time zone,
    webauthn_checked_at timestamp with time zone,
    webauthn_user_verified boolean,
    totp_checked_at timestamp with time zone,
    otp_sms_checked_at timestamp with time zone,
    otp_email_checked_at timestamp with time zone,
    metadata jsonb,
    token_id text,
    user_agent_fingerprint_id text,
    user_agent_ip text,
    user_agent_description text,
    user_agent_header jsonb,
    expiration timestamp with time zone
);


ALTER TABLE projections.sessions8 OWNER TO us;

--
-- Name: sms_configs2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.sms_configs2 (
    id text NOT NULL,
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL
);


ALTER TABLE projections.sms_configs2 OWNER TO us;

--
-- Name: sms_configs2_twilio; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.sms_configs2_twilio (
    sms_id text NOT NULL,
    instance_id text NOT NULL,
    sid text NOT NULL,
    sender_number text NOT NULL,
    token jsonb NOT NULL
);


ALTER TABLE projections.sms_configs2_twilio OWNER TO us;

--
-- Name: smtp_configs1; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.smtp_configs1 (
    aggregate_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    tls boolean NOT NULL,
    sender_address text NOT NULL,
    sender_name text NOT NULL,
    reply_to_address text NOT NULL,
    host text NOT NULL,
    username text NOT NULL,
    password jsonb
);


ALTER TABLE projections.smtp_configs1 OWNER TO us;

--
-- Name: smtp_configs2; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.smtp_configs2 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    tls boolean NOT NULL,
    sender_address text NOT NULL,
    sender_name text NOT NULL,
    reply_to_address text NOT NULL,
    host text NOT NULL,
    username text NOT NULL,
    password jsonb,
    state smallint NOT NULL,
    description text NOT NULL
);


ALTER TABLE projections.smtp_configs2 OWNER TO us;

--
-- Name: system_features; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.system_features (
    key text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    value jsonb NOT NULL
);


ALTER TABLE projections.system_features OWNER TO us;

--
-- Name: targets; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.targets (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    target_type smallint NOT NULL,
    sequence bigint NOT NULL,
    name text NOT NULL,
    url text DEFAULT ''::text NOT NULL,
    timeout bigint DEFAULT 0 NOT NULL,
    async boolean DEFAULT false NOT NULL,
    interrupt_on_error boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.targets OWNER TO us;

--
-- Name: user_auth_methods4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.user_auth_methods4 (
    user_id text NOT NULL,
    method_type smallint NOT NULL,
    token_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    name text NOT NULL,
    owner_removed boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.user_auth_methods4 OWNER TO us;

--
-- Name: user_grants4; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.user_grants4 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    user_id text NOT NULL,
    resource_owner_user text NOT NULL,
    project_id text NOT NULL,
    resource_owner_project text NOT NULL,
    grant_id text NOT NULL,
    granted_org text NOT NULL,
    roles text[]
);


ALTER TABLE projections.user_grants4 OWNER TO us;

--
-- Name: user_grants5; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.user_grants5 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    user_id text NOT NULL,
    resource_owner_user text NOT NULL,
    project_id text NOT NULL,
    resource_owner_project text NOT NULL,
    grant_id text NOT NULL,
    granted_org text NOT NULL,
    roles text[]
);


ALTER TABLE projections.user_grants5 OWNER TO us;

--
-- Name: user_metadata5; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.user_metadata5 (
    user_id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    key text NOT NULL,
    value bytea
);


ALTER TABLE projections.user_metadata5 OWNER TO us;

--
-- Name: user_schemas; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.user_schemas (
    id text NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    instance_id text NOT NULL,
    type text NOT NULL,
    revision bigint NOT NULL,
    schema jsonb,
    possible_authenticators smallint[]
);


ALTER TABLE projections.user_schemas OWNER TO us;

--
-- Name: users10; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.users10 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    username text NOT NULL,
    type smallint NOT NULL
);


ALTER TABLE projections.users10 OWNER TO us;

--
-- Name: users10_humans; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.users10_humans (
    user_id text NOT NULL,
    instance_id text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    nick_name text,
    display_name text,
    preferred_language text,
    gender smallint,
    avatar_key text,
    email text NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    phone text,
    is_phone_verified boolean
);


ALTER TABLE projections.users10_humans OWNER TO us;

--
-- Name: users10_machines; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.users10_machines (
    user_id text NOT NULL,
    instance_id text NOT NULL,
    name text NOT NULL,
    description text,
    secret jsonb,
    access_token_type smallint DEFAULT 0 NOT NULL
);


ALTER TABLE projections.users10_machines OWNER TO us;

--
-- Name: users10_notifications; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.users10_notifications (
    user_id text NOT NULL,
    instance_id text NOT NULL,
    last_email text,
    verified_email text,
    last_phone text,
    verified_phone text,
    password_set boolean DEFAULT false NOT NULL
);


ALTER TABLE projections.users10_notifications OWNER TO us;

--
-- Name: users12; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.users12 (
    id text NOT NULL,
    creation_date timestamp with time zone NOT NULL,
    change_date timestamp with time zone NOT NULL,
    sequence bigint NOT NULL,
    state smallint NOT NULL,
    resource_owner text NOT NULL,
    instance_id text NOT NULL,
    username text NOT NULL,
    type smallint NOT NULL
);


ALTER TABLE projections.users12 OWNER TO us;

--
-- Name: users12_humans; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.users12_humans (
    user_id text NOT NULL,
    instance_id text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    nick_name text,
    display_name text,
    preferred_language text,
    gender smallint,
    avatar_key text,
    email text NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    phone text,
    is_phone_verified boolean,
    password_change_required boolean NOT NULL
);


ALTER TABLE projections.users12_humans OWNER TO us;

--
-- Name: users12_machines; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.users12_machines (
    user_id text NOT NULL,
    instance_id text NOT NULL,
    name text NOT NULL,
    description text,
    secret text,
    access_token_type smallint DEFAULT 0 NOT NULL
);


ALTER TABLE projections.users12_machines OWNER TO us;

--
-- Name: users12_notifications; Type: TABLE; Schema: projections; Owner: us
--

CREATE TABLE projections.users12_notifications (
    user_id text NOT NULL,
    instance_id text NOT NULL,
    last_email text,
    verified_email text,
    last_phone text,
    verified_phone text,
    password_set boolean DEFAULT false NOT NULL,
    verified_email_lower text GENERATED ALWAYS AS (lower(verified_email)) STORED
);


ALTER TABLE projections.users12_notifications OWNER TO us;

--
-- Name: assets; Type: TABLE; Schema: system; Owner: us
--

CREATE TABLE system.assets (
    instance_id text NOT NULL,
    asset_type text,
    resource_owner text NOT NULL,
    name text NOT NULL,
    content_type text,
    hash text GENERATED ALWAYS AS (md5(data)) STORED,
    data bytea,
    updated_at timestamp with time zone
);


ALTER TABLE system.assets OWNER TO us;

--
-- Name: encryption_keys; Type: TABLE; Schema: system; Owner: us
--

CREATE TABLE system.encryption_keys (
    id text NOT NULL,
    key text NOT NULL
);


ALTER TABLE system.encryption_keys OWNER TO us;

--
-- Data for Name: current_sequences; Type: TABLE DATA; Schema: adminapi; Owner: us
--

COPY adminapi.current_sequences (view_name, current_sequence, event_date, last_successful_spooler_run, instance_id) FROM stdin;
\.


--
-- Data for Name: failed_events; Type: TABLE DATA; Schema: adminapi; Owner: us
--

COPY adminapi.failed_events (view_name, failed_sequence, failure_count, err_msg, instance_id, last_failed) FROM stdin;
\.


--
-- Data for Name: locks; Type: TABLE DATA; Schema: adminapi; Owner: us
--

COPY adminapi.locks (locker_id, locked_until, view_name, instance_id) FROM stdin;
\.


--
-- Data for Name: styling; Type: TABLE DATA; Schema: adminapi; Owner: us
--

COPY adminapi.styling (aggregate_id, creation_date, change_date, label_policy_state, sequence, primary_color, background_color, warn_color, font_color, primary_color_dark, background_color_dark, warn_color_dark, font_color_dark, logo_url, icon_url, logo_dark_url, icon_dark_url, font_url, err_msg_popup, disable_watermark, hide_login_name_suffix, instance_id) FROM stdin;
\.


--
-- Data for Name: styling2; Type: TABLE DATA; Schema: adminapi; Owner: us
--

COPY adminapi.styling2 (aggregate_id, creation_date, change_date, label_policy_state, sequence, primary_color, background_color, warn_color, font_color, primary_color_dark, background_color_dark, warn_color_dark, font_color_dark, logo_url, icon_url, logo_dark_url, icon_dark_url, font_url, err_msg_popup, disable_watermark, hide_login_name_suffix, instance_id, owner_removed) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	3	22	#5469d4	#fafafa	#cd3d56	#000000	#2073c4	#111827	#ff3b5b	#ffffff						f	f	f	266108224564887557	f
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	1	23	#5469d4	#fafafa	#cd3d56	#000000	#2073c4	#111827	#ff3b5b	#ffffff						f	f	f	266108224564887557	f
\.


--
-- Data for Name: auth_requests; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.auth_requests (id, request, code, request_type, creation_date, change_date, instance_id) FROM stdin;
266220182366584841	{"ID": "266220182366584841", "Code": "", "Prompt": [0], "UserID": "", "AgentID": "266108240469688325", "Request": {"Nonce": "", "Scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "ResponseType": 0, "CodeChallenge": null}, "Audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "AuthTime": "0001-01-01T00:00:00Z", "UserName": "", "AvatarKey": "", "LoginHint": "", "LoginName": "", "UiLocales": null, "UserOrgID": "", "ChangeDate": "0001-01-01T00:00:00Z", "InstanceID": "266108224564887557", "MaxAuthAge": null, "BrowserInfo": {"RemoteIP": "", "UserAgent": "", "AcceptLanguage": ""}, "CallbackURI": "http://localhost:3030/api/auth/callback", "DisplayName": "", "LabelPolicy": null, "LoginPolicy": null, "CreationDate": "2024-05-08T13:39:54.025674965Z", "LinkingUsers": null, "MFAsVerified": null, "PossibleLOAs": null, "ApplicationID": "266108631362109445@datalens", "LockoutPolicy": null, "PrivacyPolicy": null, "SAMLRequestID": "", "TransferState": "pIU547hsJpj77kAZc6xoOUHx", "RequestedOrgID": "", "OrgTranslations": null, "PresignedAvatar": "", "PasswordVerified": false, "RequestedOrgName": "", "RequestedOrgDomain": false, "AllowedExternalIDPs": null, "DefaultTranslations": null, "SelectedIDPConfigID": "", "PrivateLabelingSetting": 0, "RequestedPrimaryDomain": "", "ApplicationResourceOwner": "266108224564953093"}	\N	0	2024-05-08 13:39:54.025674+00	2024-05-08 13:39:54.025674+00	266108224564887557
266222597362941961	{"ID": "266222597362941961", "Code": "", "Prompt": [0], "UserID": "", "AgentID": "266108240469688325", "Request": {"Nonce": "", "Scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "ResponseType": 0, "CodeChallenge": null}, "Audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "AuthTime": "0001-01-01T00:00:00Z", "UserName": "", "AvatarKey": "", "LoginHint": "", "LoginName": "", "UiLocales": null, "UserOrgID": "", "ChangeDate": "0001-01-01T00:00:00Z", "InstanceID": "266108224564887557", "MaxAuthAge": null, "BrowserInfo": {"RemoteIP": "", "UserAgent": "", "AcceptLanguage": ""}, "CallbackURI": "http://localhost:3030/api/auth/callback", "DisplayName": "", "LabelPolicy": null, "LoginPolicy": null, "CreationDate": "2024-05-08T14:03:53.470777507Z", "LinkingUsers": null, "MFAsVerified": null, "PossibleLOAs": null, "ApplicationID": "266108631362109445@datalens", "LockoutPolicy": null, "PrivacyPolicy": null, "SAMLRequestID": "", "TransferState": "Y4+o95NazOQaUk5ukLuiZpaV", "RequestedOrgID": "", "OrgTranslations": null, "PresignedAvatar": "", "PasswordVerified": false, "RequestedOrgName": "", "RequestedOrgDomain": false, "AllowedExternalIDPs": null, "DefaultTranslations": null, "SelectedIDPConfigID": "", "PrivateLabelingSetting": 0, "RequestedPrimaryDomain": "", "ApplicationResourceOwner": "266108224564953093"}	\N	0	2024-05-08 14:03:53.470777+00	2024-05-08 14:03:53.470777+00	266108224564887557
\.


--
-- Data for Name: current_sequences; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.current_sequences (view_name, current_sequence, event_date, last_successful_spooler_run, instance_id) FROM stdin;
\.


--
-- Data for Name: failed_events; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.failed_events (view_name, failed_sequence, failure_count, err_msg, instance_id, last_failed) FROM stdin;
\.


--
-- Data for Name: idp_configs; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.idp_configs (idp_config_id, creation_date, change_date, sequence, aggregate_id, name, idp_state, idp_provider_type, is_oidc, oidc_client_id, oidc_client_secret, oidc_issuer, oidc_scopes, oidc_idp_display_name_mapping, oidc_idp_username_mapping, styling_type, oauth_authorization_endpoint, oauth_token_endpoint, auto_register, jwt_endpoint, jwt_keys_endpoint, jwt_header_name, instance_id) FROM stdin;
\.


--
-- Data for Name: idp_configs2; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.idp_configs2 (idp_config_id, creation_date, change_date, sequence, aggregate_id, name, idp_state, idp_provider_type, is_oidc, oidc_client_id, oidc_client_secret, oidc_issuer, oidc_scopes, oidc_idp_display_name_mapping, oidc_idp_username_mapping, styling_type, oauth_authorization_endpoint, oauth_token_endpoint, auto_register, jwt_endpoint, jwt_keys_endpoint, jwt_header_name, instance_id, owner_removed) FROM stdin;
\.


--
-- Data for Name: idp_providers; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.idp_providers (aggregate_id, idp_config_id, creation_date, change_date, sequence, name, idp_config_type, idp_provider_type, idp_state, styling_type, instance_id) FROM stdin;
\.


--
-- Data for Name: idp_providers2; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.idp_providers2 (aggregate_id, idp_config_id, creation_date, change_date, sequence, name, idp_config_type, idp_provider_type, idp_state, styling_type, instance_id, owner_removed) FROM stdin;
\.


--
-- Data for Name: locks; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.locks (locker_id, locked_until, view_name, instance_id) FROM stdin;
\.


--
-- Data for Name: org_project_mapping; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.org_project_mapping (org_id, project_id, project_grant_id, instance_id) FROM stdin;
\.


--
-- Data for Name: org_project_mapping2; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.org_project_mapping2 (org_id, project_id, project_grant_id, instance_id, owner_removed) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.refresh_tokens (id, creation_date, change_date, resource_owner, token, client_id, user_agent_id, user_id, auth_time, idle_expiration, expiration, sequence, scopes, audience, amr, instance_id, actor) FROM stdin;
266232148246134793	2024-05-08 15:38:46.261742+00	2024-05-08 15:38:46.261742+00	266108224564953093	266232148246134793	266108631362109445@datalens	266108240469688325	266108224565018629	2024-05-08 15:38:45.807798+00	2024-06-07 15:38:46.261742+00	2024-08-06 15:38:46.261742+00	53	{openid,openid,offline_access,urn:zitadel:iam:org:project:id:zitadel:aud}	{266108631362109445@datalens,266108518786924549,266108224565084165}	{password,pwd}	266108224564887557	\N
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.tokens (id, creation_date, change_date, resource_owner, application_id, user_agent_id, user_id, expiration, sequence, scopes, audience, preferred_language, refresh_token_id, is_pat, instance_id, actor) FROM stdin;
266219861720432649	2024-05-08 13:36:42.913339+00	2024-05-08 13:36:42.913339+00	266108224564953093			266219708343123977	2024-05-09 01:36:42.907549+00	4	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266221863510736905	2024-05-08 13:56:36.079416+00	2024-05-08 13:56:36.079416+00	266108224564953093			266219708343123977	2024-05-09 01:56:36.065186+00	6	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266222267304771593	2024-05-08 14:00:36.754565+00	2024-05-08 14:00:36.754565+00	266108224564953093			266219708343123977	2024-05-09 02:00:36.748964+00	9	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266222267304837129	2024-05-08 14:00:36.765638+00	2024-05-08 14:00:36.765638+00	266108224564953093			266219708343123977	2024-05-09 02:00:36.749083+00	10	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266222597111283721	2024-05-08 14:03:53.333837+00	2024-05-08 14:03:53.333837+00	266108224564953093			266219708343123977	2024-05-09 02:03:53.328606+00	14	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266225043078381577	2024-05-08 14:28:11.235802+00	2024-05-08 14:28:11.235802+00	266108224564953093			266219708343123977	2024-05-09 02:28:11.230616+00	16	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266225098124427273	2024-05-08 14:28:44.050896+00	2024-05-08 14:28:44.050896+00	266108224564953093			266219708343123977	2024-05-09 02:28:44.045079+00	18	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266225274654294025	2024-05-08 14:30:29.265984+00	2024-05-08 14:30:29.265984+00	266108224564953093			266219708343123977	2024-05-09 02:30:29.260608+00	20	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266227248258875401	2024-05-08 14:50:05.630545+00	2024-05-08 14:50:05.630545+00	266108224564953093			266219708343123977	2024-05-09 02:50:05.624605+00	22	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266227736492638217	2024-05-08 14:54:56.640322+00	2024-05-08 14:54:56.640322+00	266108224564953093			266219708343123977	2024-05-09 02:54:56.635653+00	24	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266227856449732617	2024-05-08 14:56:08.143016+00	2024-05-08 14:56:08.143016+00	266108224564953093			266219708343123977	2024-05-09 02:56:08.136629+00	26	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266231351194157065	2024-05-08 15:30:51.16886+00	2024-05-08 15:30:51.16886+00	266108224564953093			266219708343123977	2024-05-09 03:30:51.162887+00	28	{openid,profile,urn:zitadel:iam:org:project:id:266108518786924549:aud}	{266108518786924549}	und		f	266108224564887557	\N
266232148262912009	2024-05-08 15:38:46.261742+00	2024-05-08 15:38:46.261742+00	266108224564953093	266108631362109445@datalens	266108240469688325	266108224565018629	2024-05-09 03:38:46.257037+00	52	{openid,openid,offline_access,urn:zitadel:iam:org:project:id:zitadel:aud}	{266108631362109445@datalens,266108518786924549,266108224565084165}	en	266232148246134793	f	266108224564887557	\N
\.


--
-- Data for Name: user_external_idps; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.user_external_idps (external_user_id, idp_config_id, user_id, idp_name, user_display_name, creation_date, change_date, sequence, resource_owner, instance_id) FROM stdin;
\.


--
-- Data for Name: user_external_idps2; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.user_external_idps2 (external_user_id, idp_config_id, user_id, idp_name, user_display_name, creation_date, change_date, sequence, resource_owner, instance_id, owner_removed) FROM stdin;
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.user_sessions (creation_date, change_date, resource_owner, state, user_agent_id, user_id, user_name, password_verification, second_factor_verification, multi_factor_verification, sequence, second_factor_verification_type, multi_factor_verification_type, user_display_name, login_name, external_login_verification, selected_idp_config_id, passwordless_verification, avatar_key, instance_id) FROM stdin;
2024-05-07 19:09:37.544038+00	2024-05-08 15:38:45.807798+00	266108224564953093	0	266108240469688325	266108224565018629	\N	2024-05-08 15:38:45.807798+00	0001-01-01 00:00:00+00	0001-01-01 00:00:00+00	51	0	0	\N	\N	0001-01-01 00:00:00+00		0001-01-01 00:00:00+00	\N	266108224564887557
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.users (id, creation_date, change_date, resource_owner, user_state, password_set, password_change_required, password_change, last_login, user_name, login_names, preferred_login_name, first_name, last_name, nick_name, display_name, preferred_language, gender, email, is_email_verified, phone, is_phone_verified, country, locality, postal_code, region, street_address, otp_state, mfa_max_set_up, mfa_init_skipped, sequence, init_required, username_change_required, machine_name, machine_description, user_type, u2f_tokens, passwordless_tokens, avatar_key, passwordless_init_required, password_init_required, instance_id) FROM stdin;
\.


--
-- Data for Name: users2; Type: TABLE DATA; Schema: auth; Owner: us
--

COPY auth.users2 (id, creation_date, change_date, resource_owner, user_state, password_set, password_change_required, password_change, last_login, user_name, login_names, preferred_login_name, first_name, last_name, nick_name, display_name, preferred_language, gender, email, is_email_verified, phone, is_phone_verified, country, locality, postal_code, region, street_address, otp_state, mfa_max_set_up, mfa_init_skipped, sequence, init_required, username_change_required, machine_name, machine_description, user_type, u2f_tokens, passwordless_tokens, avatar_key, passwordless_init_required, password_init_required, instance_id, owner_removed, otp_sms_added, otp_email_added) FROM stdin;
266219708343123977	2024-05-08 13:35:11.508041+00	2024-05-08 13:35:11.508041+00	266108224564953093	1	f	f	0001-01-01 00:00:00+00	0001-01-01 00:00:00+00	charts	{charts@zitadel.localhost,charts@charts}	charts						0		f		f						0	0	0001-01-01 00:00:00+00	1	f	f	charts	charts	machine	\N	\N		f	f	266108224564887557	f	f	f
266108224565018629	2024-05-07 19:07:43.764022+00	2024-05-08 13:39:50.064303+00	266108224564953093	1	t	f	2024-05-08 13:39:50.064303+00	0001-01-01 00:00:00+00	zitadel-admin@zitadel.localhost	{zitadel-admin@zitadel.localhost@zitadel.localhost,zitadel-admin@zitadel.localhost@zitadel-admin@zitadel.localhost}	zitadel-admin@zitadel.localhost	ZITADEL	Admin		ZITADEL Admin	en	0	zitadel-admin@zitadel.localhost	t		f						0	0	2024-05-07 19:09:39.910044+00	32	f	f			human	\N	\N		f	f	266108224564887557	f	f	f
\.


--
-- Data for Name: events2; Type: TABLE DATA; Schema: eventstore; Owner: us
--

COPY eventstore.events2 (instance_id, aggregate_type, aggregate_id, event_type, sequence, revision, created_at, payload, creator, owner, "position", in_tx_order) FROM stdin;
	system	SYSTEM	system.migration.started	1	1	2024-05-07 19:07:41.667474+00	{"name": "14_events_push"}	system	SYSTEM	1715108861.66749	0
	system	SYSTEM	system.migration.done	2	1	2024-05-07 19:07:41.687523+00	{"name": "14_events_push"}	system	SYSTEM	1715108861.68753	0
	system	SYSTEM	system.migration.started	3	1	2024-05-07 19:07:41.708034+00	{"name": "01_tables"}	system	SYSTEM	1715108861.70805	0
	system	SYSTEM	system.migration.done	4	1	2024-05-07 19:07:41.845097+00	{"name": "01_tables"}	system	SYSTEM	1715108861.84511	0
	system	SYSTEM	system.migration.started	5	1	2024-05-07 19:07:41.864918+00	{"name": "02_assets"}	system	SYSTEM	1715108861.86493	0
	system	SYSTEM	system.migration.done	6	1	2024-05-07 19:07:41.894058+00	{"name": "02_assets"}	system	SYSTEM	1715108861.89407	0
	system	SYSTEM	system.migration.started	7	1	2024-05-07 19:07:41.918914+00	{"name": "03_default_instance"}	system	SYSTEM	1715108861.91893	0
266108224564887557	instance	266108224564887557	instance.added	1	1	2024-05-07 19:07:43.764022+00	{"name": "ZITADEL"}		266108224564887557	1715108863.76405	0
266108224564887557	instance	266108224564887557	instance.default.language.set	2	1	2024-05-07 19:07:43.764022+00	{"language": "en"}		266108224564887557	1715108863.76421	1
266108224564887557	instance	266108224564887557	instance.secret.generator.added	3	1	2024-05-07 19:07:43.764022+00	{"length": 64, "generatorType": 7, "includeDigits": true, "includeLowerLetters": true, "includeUpperLetters": true}		266108224564887557	1715108863.76422	2
266108224564887557	instance	266108224564887557	instance.secret.generator.added	4	1	2024-05-07 19:07:43.764022+00	{"expiry": 259200000000000, "length": 6, "generatorType": 1, "includeDigits": true, "includeUpperLetters": true}		266108224564887557	1715108863.76422	3
266108224564887557	instance	266108224564887557	instance.secret.generator.added	5	1	2024-05-07 19:07:43.764022+00	{"expiry": 3600000000000, "length": 6, "generatorType": 2, "includeDigits": true, "includeUpperLetters": true}		266108224564887557	1715108863.76423	4
266108224564887557	instance	266108224564887557	instance.secret.generator.added	6	1	2024-05-07 19:07:43.764022+00	{"expiry": 3600000000000, "length": 6, "generatorType": 3, "includeDigits": true, "includeUpperLetters": true}		266108224564887557	1715108863.76424	5
266108224564887557	instance	266108224564887557	instance.secret.generator.added	7	1	2024-05-07 19:07:43.764022+00	{"expiry": 3600000000000, "length": 6, "generatorType": 5, "includeDigits": true, "includeUpperLetters": true}		266108224564887557	1715108863.76424	6
266108224564887557	instance	266108224564887557	instance.secret.generator.added	8	1	2024-05-07 19:07:43.764022+00	{"expiry": 3600000000000, "length": 12, "generatorType": 6, "includeDigits": true, "includeLowerLetters": true, "includeUpperLetters": true}		266108224564887557	1715108863.76425	7
266108224564887557	instance	266108224564887557	instance.secret.generator.added	9	1	2024-05-07 19:07:43.764022+00	{"length": 32, "generatorType": 4, "includeDigits": true, "includeLowerLetters": true, "includeUpperLetters": true}		266108224564887557	1715108863.76425	8
266108224564887557	instance	266108224564887557	instance.secret.generator.added	10	1	2024-05-07 19:07:43.764022+00	{"expiry": 300000000000, "length": 8, "generatorType": 8, "includeDigits": true}		266108224564887557	1715108863.76426	9
266108224564887557	instance	266108224564887557	instance.secret.generator.added	11	1	2024-05-07 19:07:43.764022+00	{"expiry": 300000000000, "length": 8, "generatorType": 9, "includeDigits": true}		266108224564887557	1715108863.76426	10
266108224564887557	instance	266108224564887557	instance.policy.password.complexity.added	12	1	2024-05-07 19:07:43.764022+00	{"hasNumber": true, "hasSymbol": true, "minLength": 8, "hasLowercase": true, "hasUppercase": true}		266108224564887557	1715108863.76427	11
266108224564887557	instance	266108224564887557	instance.policy.password.age.added	13	1	2024-05-07 19:07:43.764022+00	{}		266108224564887557	1715108863.76428	12
266108224564887557	instance	266108224564887557	instance.policy.domain.added	14	1	2024-05-07 19:07:43.764022+00	{}		266108224564887557	1715108863.76428	13
266108224564887557	instance	266108224564887557	instance.policy.login.added	15	1	2024-05-07 19:07:43.764022+00	{"allowRegister": true, "allowExternalIdp": true, "passwordlessType": 1, "mfaInitSkipLifetime": 2592000000000000, "allowDomainDiscovery": true, "allowUsernamePassword": true, "passwordCheckLifetime": 864000000000000, "multiFactorCheckLifetime": 43200000000000, "secondFactorCheckLifetime": 64800000000000, "externalLoginCheckLifetime": 864000000000000}		266108224564887557	1715108863.76429	14
266108224564887557	instance	266108224564887557	instance.policy.login.secondfactor.added	16	1	2024-05-07 19:07:43.764022+00	{"mfaType": 1}		266108224564887557	1715108863.76429	15
266108224564887557	instance	266108224564887557	instance.policy.login.secondfactor.added	17	1	2024-05-07 19:07:43.764022+00	{"mfaType": 2}		266108224564887557	1715108863.7643	16
266108224564887557	instance	266108224564887557	instance.policy.login.multifactor.added	18	1	2024-05-07 19:07:43.764022+00	{"mfaType": 1}		266108224564887557	1715108863.7643	17
266108224564887557	instance	266108224564887557	instance.policy.privacy.added	19	1	2024-05-07 19:07:43.764022+00	{"tosLink": "https://zitadel.com/docs/legal/terms-of-service", "privacyLink": "https://zitadel.com/docs/legal/privacy-policy"}		266108224564887557	1715108863.76431	18
266108224564887557	instance	266108224564887557	instance.policy.notification.added	20	1	2024-05-07 19:07:43.764022+00	{"passwordChange": true}		266108224564887557	1715108863.76431	19
266108224564887557	instance	266108224564887557	instance.policy.lockout.added	21	1	2024-05-07 19:07:43.764022+00	{"showLockOutFailures": true}		266108224564887557	1715108863.76432	20
266108224564887557	instance	266108224564887557	instance.policy.label.added	22	1	2024-05-07 19:07:43.764022+00	{"fontColor": "#000000", "warnColor": "#cd3d56", "primaryColor": "#5469d4", "fontColorDark": "#ffffff", "warnColorDark": "#ff3b5b", "backgroundColor": "#fafafa", "primaryColorDark": "#2073c4", "backgroundColorDark": "#111827"}		266108224564887557	1715108863.76432	21
266108224564887557	instance	266108224564887557	instance.policy.label.activated	23	1	2024-05-07 19:07:43.764022+00	{}		266108224564887557	1715108863.76433	22
266108224564887557	instance	266108224564887557	instance.mail.template.added	24	1	2024-05-07 19:07:43.764022+00	{"template": "CjwhZG9jdHlwZSBodG1sPgo8aHRtbCB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94aHRtbCIgeG1sbnM6dj0idXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTp2bWwiIHhtbG5zOm89InVybjpzY2hlbWFzLW1pY3Jvc29mdC1jb206b2ZmaWNlOm9mZmljZSI+CjxoZWFkPgogIDx0aXRsZT4KCiAgPC90aXRsZT4KICA8IS0tW2lmICFtc29dPjwhLS0+CiAgPG1ldGEgaHR0cC1lcXVpdj0iWC1VQS1Db21wYXRpYmxlIiBjb250ZW50PSJJRT1lZGdlIj4KICA8IS0tPCFbZW5kaWZdLS0+CiAgPG1ldGEgaHR0cC1lcXVpdj0iQ29udGVudC1UeXBlIiBjb250ZW50PSJ0ZXh0L2h0bWw7IGNoYXJzZXQ9VVRGLTgiPgogIDxtZXRhIG5hbWU9InZpZXdwb3J0IiBjb250ZW50PSJ3aWR0aD1kZXZpY2Utd2lkdGgsIGluaXRpYWwtc2NhbGU9MSI+CiAgPHN0eWxlIHR5cGU9InRleHQvY3NzIj4KICAgICNvdXRsb29rIGEgeyBwYWRkaW5nOjA7IH0KICAgIGJvZHkgeyBtYXJnaW46MDtwYWRkaW5nOjA7LXdlYmtpdC10ZXh0LXNpemUtYWRqdXN0OjEwMCU7LW1zLXRleHQtc2l6ZS1hZGp1c3Q6MTAwJTsgfQogICAgdGFibGUsIHRkIHsgYm9yZGVyLWNvbGxhcHNlOmNvbGxhcHNlO21zby10YWJsZS1sc3BhY2U6MHB0O21zby10YWJsZS1yc3BhY2U6MHB0OyB9CiAgICBpbWcgeyBib3JkZXI6MDtoZWlnaHQ6YXV0bztsaW5lLWhlaWdodDoxMDAlOyBvdXRsaW5lOm5vbmU7dGV4dC1kZWNvcmF0aW9uOm5vbmU7LW1zLWludGVycG9sYXRpb24tbW9kZTpiaWN1YmljOyB9CiAgICBwIHsgZGlzcGxheTpibG9jazttYXJnaW46MTNweCAwOyB9CiAgPC9zdHlsZT4KICA8IS0tW2lmIG1zb10+CiAgPHhtbD4KICAgIDxvOk9mZmljZURvY3VtZW50U2V0dGluZ3M+CiAgICAgIDxvOkFsbG93UE5HLz4KICAgICAgPG86UGl4ZWxzUGVySW5jaD45NjwvbzpQaXhlbHNQZXJJbmNoPgogICAgPC9vOk9mZmljZURvY3VtZW50U2V0dGluZ3M+CiAgPC94bWw+CiAgPCFbZW5kaWZdLS0+CiAgPCEtLVtpZiBsdGUgbXNvIDExXT4KICA8c3R5bGUgdHlwZT0idGV4dC9jc3MiPgogICAgLm1qLW91dGxvb2stZ3JvdXAtZml4IHsgd2lkdGg6MTAwJSAhaW1wb3J0YW50OyB9CiAgPC9zdHlsZT4KICA8IVtlbmRpZl0tLT4KCgogIDxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+CiAgICBAbWVkaWEgb25seSBzY3JlZW4gYW5kIChtaW4td2lkdGg6NDgwcHgpIHsKICAgICAgLm1qLWNvbHVtbi1wZXItMTAwIHsgd2lkdGg6MTAwJSAhaW1wb3J0YW50OyBtYXgtd2lkdGg6IDEwMCU7IH0KICAgICAgLm1qLWNvbHVtbi1wZXItNjAgeyB3aWR0aDo2MCUgIWltcG9ydGFudDsgbWF4LXdpZHRoOiA2MCU7IH0KICAgIH0KICA8L3N0eWxlPgoKCiAgPHN0eWxlIHR5cGU9InRleHQvY3NzIj4KCgoKICAgIEBtZWRpYSBvbmx5IHNjcmVlbiBhbmQgKG1heC13aWR0aDo0ODBweCkgewogICAgICB0YWJsZS5tai1mdWxsLXdpZHRoLW1vYmlsZSB7IHdpZHRoOiAxMDAlICFpbXBvcnRhbnQ7IH0KICAgICAgdGQubWotZnVsbC13aWR0aC1tb2JpbGUgeyB3aWR0aDogYXV0byAhaW1wb3J0YW50OyB9CiAgICB9CgogIDwvc3R5bGU+CiAgPHN0eWxlIHR5cGU9InRleHQvY3NzIj4uc2hhZG93IGEgewogICAgYm94LXNoYWRvdzogMHB4IDNweCAxcHggLTJweCByZ2JhKDAsIDAsIDAsIDAuMiksIDBweCAycHggMnB4IDBweCByZ2JhKDAsIDAsIDAsIDAuMTQpLCAwcHggMXB4IDVweCAwcHggcmdiYSgwLCAwLCAwLCAwLjEyKTsKICB9PC9zdHlsZT4KCiAge3tpZiAuRm9udFVSTH19CiAgPHN0eWxlPgogICAgQGZvbnQtZmFjZSB7CiAgICAgIGZvbnQtZmFtaWx5OiAne3suRm9udEZhY2VGYW1pbHl9fSc7CiAgICAgIGZvbnQtc3R5bGU6IG5vcm1hbDsKICAgICAgZm9udC1kaXNwbGF5OiBzd2FwOwogICAgICBzcmM6IHVybCh7ey5Gb250VVJMfX0pOwogICAgfQogIDwvc3R5bGU+CiAge3tlbmR9fQoKPC9oZWFkPgo8Ym9keSBzdHlsZT0id29yZC1zcGFjaW5nOm5vcm1hbDsiPgoKCjxkaXYKICAgICAgICBzdHlsZT0iIgo+CgogIDx0YWJsZQogICAgICAgICAgYWxpZ249ImNlbnRlciIgYm9yZGVyPSIwIiBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHJvbGU9InByZXNlbnRhdGlvbiIgc3R5bGU9ImJhY2tncm91bmQ6e3suQmFja2dyb3VuZENvbG9yfX07YmFja2dyb3VuZC1jb2xvcjp7ey5CYWNrZ3JvdW5kQ29sb3J9fTt3aWR0aDoxMDAlO2JvcmRlci1yYWRpdXM6MTZweDsiCiAgPgogICAgPHRib2R5PgogICAgPHRyPgogICAgICA8dGQ+CgoKICAgICAgICA8IS0tW2lmIG1zbyB8IElFXT48dGFibGUgYWxpZ249ImNlbnRlciIgYm9yZGVyPSIwIiBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIGNsYXNzPSIiIHN0eWxlPSJ3aWR0aDo4MDBweDsiIHdpZHRoPSI4MDAiID48dHI+PHRkIHN0eWxlPSJsaW5lLWhlaWdodDowcHg7Zm9udC1zaXplOjBweDttc28tbGluZS1oZWlnaHQtcnVsZTpleGFjdGx5OyI+PCFbZW5kaWZdLS0+CgoKICAgICAgICA8ZGl2ICBzdHlsZT0ibWFyZ2luOjBweCBhdXRvO2JvcmRlci1yYWRpdXM6MTZweDttYXgtd2lkdGg6ODAwcHg7Ij4KCiAgICAgICAgICA8dGFibGUKICAgICAgICAgICAgICAgICAgYWxpZ249ImNlbnRlciIgYm9yZGVyPSIwIiBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHJvbGU9InByZXNlbnRhdGlvbiIgc3R5bGU9IndpZHRoOjEwMCU7Ym9yZGVyLXJhZGl1czoxNnB4OyIKICAgICAgICAgID4KICAgICAgICAgICAgPHRib2R5PgogICAgICAgICAgICA8dHI+CiAgICAgICAgICAgICAgPHRkCiAgICAgICAgICAgICAgICAgICAgICBzdHlsZT0iZGlyZWN0aW9uOmx0cjtmb250LXNpemU6MHB4O3BhZGRpbmc6MjBweCAwO3BhZGRpbmctbGVmdDowO3RleHQtYWxpZ246Y2VudGVyOyIKICAgICAgICAgICAgICA+CiAgICAgICAgICAgICAgICA8IS0tW2lmIG1zbyB8IElFXT48dGFibGUgcm9sZT0icHJlc2VudGF0aW9uIiBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCI+PHRyPjx0ZCBjbGFzcz0iIiB3aWR0aD0iODAwcHgiID48IVtlbmRpZl0tLT4KCiAgICAgICAgICAgICAgICA8dGFibGUKICAgICAgICAgICAgICAgICAgICAgICAgYWxpZ249ImNlbnRlciIgYm9yZGVyPSIwIiBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHJvbGU9InByZXNlbnRhdGlvbiIgc3R5bGU9IndpZHRoOjEwMCU7IgogICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICA8dGJvZHk+CiAgICAgICAgICAgICAgICAgIDx0cj4KICAgICAgICAgICAgICAgICAgICA8dGQ+CgoKICAgICAgICAgICAgICAgICAgICAgIDwhLS1baWYgbXNvIHwgSUVdPjx0YWJsZSBhbGlnbj0iY2VudGVyIiBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgY2xhc3M9IiIgc3R5bGU9IndpZHRoOjgwMHB4OyIgd2lkdGg9IjgwMCIgPjx0cj48dGQgc3R5bGU9ImxpbmUtaGVpZ2h0OjBweDtmb250LXNpemU6MHB4O21zby1saW5lLWhlaWdodC1ydWxlOmV4YWN0bHk7Ij48IVtlbmRpZl0tLT4KCgogICAgICAgICAgICAgICAgICAgICAgPGRpdiAgc3R5bGU9Im1hcmdpbjowcHggYXV0bzttYXgtd2lkdGg6ODAwcHg7Ij4KCiAgICAgICAgICAgICAgICAgICAgICAgIDx0YWJsZQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFsaWduPSJjZW50ZXIiIGJvcmRlcj0iMCIgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiByb2xlPSJwcmVzZW50YXRpb24iIHN0eWxlPSJ3aWR0aDoxMDAlOyIKICAgICAgICAgICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICAgICAgICAgIDx0Ym9keT4KICAgICAgICAgICAgICAgICAgICAgICAgICA8dHI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dGQKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3R5bGU9ImRpcmVjdGlvbjpsdHI7Zm9udC1zaXplOjBweDtwYWRkaW5nOjA7dGV4dC1hbGlnbjpjZW50ZXI7IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8IS0tW2lmIG1zbyB8IElFXT48dGFibGUgcm9sZT0icHJlc2VudGF0aW9uIiBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCI+PHRyPjx0ZCBjbGFzcz0iIiBzdHlsZT0id2lkdGg6ODAwcHg7IiA+PCFbZW5kaWZdLS0+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8ZGl2CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2xhc3M9Im1qLWNvbHVtbi1wZXItMTAwIG1qLW91dGxvb2stZ3JvdXAtZml4IiBzdHlsZT0iZm9udC1zaXplOjA7bGluZS1oZWlnaHQ6MDt0ZXh0LWFsaWduOmxlZnQ7ZGlzcGxheTppbmxpbmUtYmxvY2s7d2lkdGg6MTAwJTtkaXJlY3Rpb246bHRyOyIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwhLS1baWYgbXNvIHwgSUVdPjx0YWJsZSBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgcm9sZT0icHJlc2VudGF0aW9uIiA+PHRyPjx0ZCBzdHlsZT0idmVydGljYWwtYWxpZ246dG9wO3dpZHRoOjgwMHB4OyIgPjwhW2VuZGlmXS0tPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8ZGl2CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjbGFzcz0ibWotY29sdW1uLXBlci0xMDAgbWotb3V0bG9vay1ncm91cC1maXgiIHN0eWxlPSJmb250LXNpemU6MHB4O3RleHQtYWxpZ246bGVmdDtkaXJlY3Rpb246bHRyO2Rpc3BsYXk6aW5saW5lLWJsb2NrO3ZlcnRpY2FsLWFsaWduOnRvcDt3aWR0aDoxMDAlOyIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRhYmxlCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJvcmRlcj0iMCIgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiByb2xlPSJwcmVzZW50YXRpb24iIHdpZHRoPSIxMDAlIgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dGJvZHk+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0cj4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dGQgIHN0eWxlPSJ2ZXJ0aWNhbC1hbGlnbjp0b3A7cGFkZGluZzowOyI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB7e2lmIC5Mb2dvVVJMfX0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0YWJsZQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgcm9sZT0icHJlc2VudGF0aW9uIiBzdHlsZT0iIiB3aWR0aD0iMTAwJSIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRib2R5PgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRyPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0ZAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWxpZ249ImNlbnRlciIgc3R5bGU9ImZvbnQtc2l6ZTowcHg7cGFkZGluZzo1MHB4IDAgMzBweCAwO3dvcmQtYnJlYWs6YnJlYWstd29yZDsiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0YWJsZQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgcm9sZT0icHJlc2VudGF0aW9uIiBzdHlsZT0iYm9yZGVyLWNvbGxhcHNlOmNvbGxhcHNlO2JvcmRlci1zcGFjaW5nOjBweDsiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0Ym9keT4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRyPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0ZCAgc3R5bGU9IndpZHRoOjE4MHB4OyI+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPGltZwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoZWlnaHQ9ImF1dG8iIHNyYz0ie3suTG9nb1VSTH19IiBzdHlsZT0iYm9yZGVyOjA7Ym9yZGVyLXJhZGl1czo4cHg7ZGlzcGxheTpibG9jaztvdXRsaW5lOm5vbmU7dGV4dC1kZWNvcmF0aW9uOm5vbmU7aGVpZ2h0OmF1dG87d2lkdGg6MTAwJTtmb250LXNpemU6MTNweDsiIHdpZHRoPSIxODAiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RkPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RyPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3Rib2R5PgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90YWJsZT4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90ZD4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90cj4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGJvZHk+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RhYmxlPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAge3tlbmR9fQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGQ+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdHI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGJvZHk+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RhYmxlPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L2Rpdj4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPCEtLVtpZiBtc28gfCBJRV0+PC90ZD48L3RyPjwvdGFibGU+PCFbZW5kaWZdLS0+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvZGl2PgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPCEtLVtpZiBtc28gfCBJRV0+PC90ZD48L3RyPjwvdGFibGU+PCFbZW5kaWZdLS0+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RkPgogICAgICAgICAgICAgICAgICAgICAgICAgIDwvdHI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgPC90Ym9keT4KICAgICAgICAgICAgICAgICAgICAgICAgPC90YWJsZT4KCiAgICAgICAgICAgICAgICAgICAgICA8L2Rpdj4KCgogICAgICAgICAgICAgICAgICAgICAgPCEtLVtpZiBtc28gfCBJRV0+PC90ZD48L3RyPjwvdGFibGU+PCFbZW5kaWZdLS0+CgoKICAgICAgICAgICAgICAgICAgICA8L3RkPgogICAgICAgICAgICAgICAgICA8L3RyPgogICAgICAgICAgICAgICAgICA8L3Rib2R5PgogICAgICAgICAgICAgICAgPC90YWJsZT4KCiAgICAgICAgICAgICAgICA8IS0tW2lmIG1zbyB8IElFXT48L3RkPjwvdHI+PHRyPjx0ZCBjbGFzcz0iIiB3aWR0aD0iODAwcHgiID48IVtlbmRpZl0tLT4KCiAgICAgICAgICAgICAgICA8dGFibGUKICAgICAgICAgICAgICAgICAgICAgICAgYWxpZ249ImNlbnRlciIgYm9yZGVyPSIwIiBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHJvbGU9InByZXNlbnRhdGlvbiIgc3R5bGU9IndpZHRoOjEwMCU7IgogICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICA8dGJvZHk+CiAgICAgICAgICAgICAgICAgIDx0cj4KICAgICAgICAgICAgICAgICAgICA8dGQ+CgoKICAgICAgICAgICAgICAgICAgICAgIDwhLS1baWYgbXNvIHwgSUVdPjx0YWJsZSBhbGlnbj0iY2VudGVyIiBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgY2xhc3M9IiIgc3R5bGU9IndpZHRoOjgwMHB4OyIgd2lkdGg9IjgwMCIgPjx0cj48dGQgc3R5bGU9ImxpbmUtaGVpZ2h0OjBweDtmb250LXNpemU6MHB4O21zby1saW5lLWhlaWdodC1ydWxlOmV4YWN0bHk7Ij48IVtlbmRpZl0tLT4KCgogICAgICAgICAgICAgICAgICAgICAgPGRpdiAgc3R5bGU9Im1hcmdpbjowcHggYXV0bzttYXgtd2lkdGg6ODAwcHg7Ij4KCiAgICAgICAgICAgICAgICAgICAgICAgIDx0YWJsZQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFsaWduPSJjZW50ZXIiIGJvcmRlcj0iMCIgY2VsbHBhZGRpbmc9IjAiIGNlbGxzcGFjaW5nPSIwIiByb2xlPSJwcmVzZW50YXRpb24iIHN0eWxlPSJ3aWR0aDoxMDAlOyIKICAgICAgICAgICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICAgICAgICAgIDx0Ym9keT4KICAgICAgICAgICAgICAgICAgICAgICAgICA8dHI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dGQKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3R5bGU9ImRpcmVjdGlvbjpsdHI7Zm9udC1zaXplOjBweDtwYWRkaW5nOjA7dGV4dC1hbGlnbjpjZW50ZXI7IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8IS0tW2lmIG1zbyB8IElFXT48dGFibGUgcm9sZT0icHJlc2VudGF0aW9uIiBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCI+PHRyPjx0ZCBjbGFzcz0iIiBzdHlsZT0idmVydGljYWwtYWxpZ246dG9wO3dpZHRoOjQ4MHB4OyIgPjwhW2VuZGlmXS0tPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPGRpdgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsYXNzPSJtai1jb2x1bW4tcGVyLTYwIG1qLW91dGxvb2stZ3JvdXAtZml4IiBzdHlsZT0iZm9udC1zaXplOjBweDt0ZXh0LWFsaWduOmxlZnQ7ZGlyZWN0aW9uOmx0cjtkaXNwbGF5OmlubGluZS1ibG9jazt2ZXJ0aWNhbC1hbGlnbjp0b3A7d2lkdGg6MTAwJTsiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRhYmxlCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgcm9sZT0icHJlc2VudGF0aW9uIiB3aWR0aD0iMTAwJSIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dGJvZHk+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dHI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0ZCAgc3R5bGU9InZlcnRpY2FsLWFsaWduOnRvcDtwYWRkaW5nOjA7Ij4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRhYmxlCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgcm9sZT0icHJlc2VudGF0aW9uIiBzdHlsZT0iIiB3aWR0aD0iMTAwJSIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dGJvZHk+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRyPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dGQKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhbGlnbj0iY2VudGVyIiBzdHlsZT0iZm9udC1zaXplOjBweDtwYWRkaW5nOjEwcHggMjVweDt3b3JkLWJyZWFrOmJyZWFrLXdvcmQ7IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxkaXYKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0eWxlPSJmb250LWZhbWlseTp7ey5Gb250RmFtaWx5fX07Zm9udC1zaXplOjI0cHg7Zm9udC13ZWlnaHQ6NTAwO2xpbmUtaGVpZ2h0OjE7dGV4dC1hbGlnbjpjZW50ZXI7Y29sb3I6e3suRm9udENvbG9yfX07IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID57ey5HcmVldGluZ319PC9kaXY+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RkPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90cj4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dHI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0ZAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFsaWduPSJjZW50ZXIiIHN0eWxlPSJmb250LXNpemU6MHB4O3BhZGRpbmc6MTBweCAyNXB4O3dvcmQtYnJlYWs6YnJlYWstd29yZDsiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPGRpdgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3R5bGU9ImZvbnQtZmFtaWx5Ont7LkZvbnRGYW1pbHl9fTtmb250LXNpemU6MTZweDtmb250LXdlaWdodDpsaWdodDtsaW5lLWhlaWdodDoxLjU7dGV4dC1hbGlnbjpjZW50ZXI7Y29sb3I6e3suRm9udENvbG9yfX07IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID57ey5UZXh0fX08L2Rpdj4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGQ+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RyPgoKCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8dHI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0ZAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFsaWduPSJjZW50ZXIiIHZlcnRpY2FsLWFsaWduPSJtaWRkbGUiIGNsYXNzPSJzaGFkb3ciIHN0eWxlPSJmb250LXNpemU6MHB4O3BhZGRpbmc6MTBweCAyNXB4O3dvcmQtYnJlYWs6YnJlYWstd29yZDsiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRhYmxlCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib3JkZXI9IjAiIGNlbGxwYWRkaW5nPSIwIiBjZWxsc3BhY2luZz0iMCIgcm9sZT0icHJlc2VudGF0aW9uIiBzdHlsZT0iYm9yZGVyLWNvbGxhcHNlOnNlcGFyYXRlO2xpbmUtaGVpZ2h0OjEwMCU7IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0cj4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRkCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWxpZ249ImNlbnRlciIgYmdjb2xvcj0ie3suUHJpbWFyeUNvbG9yfX0iIHJvbGU9InByZXNlbnRhdGlvbiIgc3R5bGU9ImJvcmRlcjpub25lO2JvcmRlci1yYWRpdXM6NnB4O2N1cnNvcjphdXRvO21zby1wYWRkaW5nLWFsdDoxMHB4IDI1cHg7YmFja2dyb3VuZDp7ey5QcmltYXJ5Q29sb3J9fTsiIHZhbGlnbj0ibWlkZGxlIgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPGEKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhyZWY9Int7LlVSTH19IiByZWw9Im5vb3BlbmVyIG5vcmVmZXJyZXIgbm90cmFjayIgc3R5bGU9ImRpc3BsYXk6aW5saW5lLWJsb2NrO2JhY2tncm91bmQ6e3suUHJpbWFyeUNvbG9yfX07Y29sb3I6I2ZmZmZmZjtmb250LWZhbWlseTp7ey5Gb250RmFtaWx5fX07Zm9udC1zaXplOjE0cHg7Zm9udC13ZWlnaHQ6NTAwO2xpbmUtaGVpZ2h0OjEyMCU7bWFyZ2luOjA7dGV4dC1kZWNvcmF0aW9uOm5vbmU7dGV4dC10cmFuc2Zvcm06bm9uZTtwYWRkaW5nOjEwcHggMjVweDttc28tcGFkZGluZy1hbHQ6MHB4O2JvcmRlci1yYWRpdXM6NnB4OyIgdGFyZ2V0PSJfYmxhbmsiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAge3suQnV0dG9uVGV4dH19CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC9hPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RkPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90cj4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RhYmxlPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90ZD4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdHI+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB7e2lmIC5JbmNsdWRlRm9vdGVyfX0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0cj4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRkCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWxpZ249ImNlbnRlciIgc3R5bGU9ImZvbnQtc2l6ZTowcHg7cGFkZGluZzoxMHB4IDI1cHg7cGFkZGluZy10b3A6MjBweDtwYWRkaW5nLXJpZ2h0OjIwcHg7cGFkZGluZy1ib3R0b206MjBweDtwYWRkaW5nLWxlZnQ6MjBweDt3b3JkLWJyZWFrOmJyZWFrLXdvcmQ7IgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDxwCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHlsZT0iYm9yZGVyLXRvcDpzb2xpZCAycHggI2RiZGJkYjtmb250LXNpemU6MXB4O21hcmdpbjowcHggYXV0bzt3aWR0aDoxMDAlOyIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC9wPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8IS0tW2lmIG1zbyB8IElFXT48dGFibGUgYWxpZ249ImNlbnRlciIgYm9yZGVyPSIwIiBjZWxscGFkZGluZz0iMCIgY2VsbHNwYWNpbmc9IjAiIHN0eWxlPSJib3JkZXItdG9wOnNvbGlkIDJweCAjZGJkYmRiO2ZvbnQtc2l6ZToxcHg7bWFyZ2luOjBweCBhdXRvO3dpZHRoOjQ0MHB4OyIgcm9sZT0icHJlc2VudGF0aW9uIiB3aWR0aD0iNDQwcHgiID48dHI+PHRkIHN0eWxlPSJoZWlnaHQ6MDtsaW5lLWhlaWdodDowOyI+ICZuYnNwOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGQ+PC90cj48L3RhYmxlPjwhW2VuZGlmXS0tPgoKCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGQ+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RyPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDx0cj4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPHRkCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWxpZ249ImNlbnRlciIgc3R5bGU9ImZvbnQtc2l6ZTowcHg7cGFkZGluZzoxNnB4O3dvcmQtYnJlYWs6YnJlYWstd29yZDsiCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPGRpdgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3R5bGU9ImZvbnQtZmFtaWx5Ont7LkZvbnRGYW1pbHl9fTtmb250LXNpemU6MTNweDtsaW5lLWhlaWdodDoxO3RleHQtYWxpZ246Y2VudGVyO2NvbG9yOnt7LkZvbnRDb2xvcn19OyIKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA+e3suRm9vdGVyVGV4dH19PC9kaXY+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RkPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90cj4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHt7ZW5kfX0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGJvZHk+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90YWJsZT4KCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGQ+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RyPgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC90Ym9keT4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8L3RhYmxlPgoKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPC9kaXY+CgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8IS0tW2lmIG1zbyB8IElFXT48L3RkPjwvdHI+PC90YWJsZT48IVtlbmRpZl0tLT4KICAgICAgICAgICAgICAgICAgICAgICAgICAgIDwvdGQ+CiAgICAgICAgICAgICAgICAgICAgICAgICAgPC90cj4KICAgICAgICAgICAgICAgICAgICAgICAgICA8L3Rib2R5PgogICAgICAgICAgICAgICAgICAgICAgICA8L3RhYmxlPgoKICAgICAgICAgICAgICAgICAgICAgIDwvZGl2PgoKCiAgICAgICAgICAgICAgICAgICAgICA8IS0tW2lmIG1zbyB8IElFXT48L3RkPjwvdHI+PC90YWJsZT48IVtlbmRpZl0tLT4KCgogICAgICAgICAgICAgICAgICAgIDwvdGQ+CiAgICAgICAgICAgICAgICAgIDwvdHI+CiAgICAgICAgICAgICAgICAgIDwvdGJvZHk+CiAgICAgICAgICAgICAgICA8L3RhYmxlPgoKICAgICAgICAgICAgICAgIDwhLS1baWYgbXNvIHwgSUVdPjwvdGQ+PC90cj48L3RhYmxlPjwhW2VuZGlmXS0tPgogICAgICAgICAgICAgIDwvdGQ+CiAgICAgICAgICAgIDwvdHI+CiAgICAgICAgICAgIDwvdGJvZHk+CiAgICAgICAgICA8L3RhYmxlPgoKICAgICAgICA8L2Rpdj4KCgogICAgICAgIDwhLS1baWYgbXNvIHwgSUVdPjwvdGQ+PC90cj48L3RhYmxlPjwhW2VuZGlmXS0tPgoKCiAgICAgIDwvdGQ+CiAgICA8L3RyPgogICAgPC90Ym9keT4KICA8L3RhYmxlPgoKPC9kaXY+Cgo8L2JvZHk+CjwvaHRtbD4K"}		266108224564887557	1715108863.76434	23
266108224564887557	instance	266108224564887557	instance.customtext.set	25	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hallo {{.DisplayName}},", "language": "de", "template": "InitCode"}		266108224564887557	1715108863.76559	24
266108224564887557	instance	266108224564887557	instance.customtext.set	26	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "User initialisieren", "language": "de", "template": "InitCode"}		266108224564887557	1715108863.76561	25
266108224564887557	instance	266108224564887557	instance.customtext.set	27	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - User initialisieren", "language": "de", "template": "InitCode"}		266108224564887557	1715108863.76562	26
266108224564887557	instance	266108224564887557	instance.customtext.set	28	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "User initialisieren", "language": "de", "template": "InitCode"}		266108224564887557	1715108863.76641	27
266108224564887557	instance	266108224564887557	instance.customtext.set	29	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "Dieser Benutzer wurde soeben im Zitadel erstellt. Mit dem Benutzernamen &lt;br&gt;&lt;strong&gt;{{.PreferredLoginName}}&lt;/strong&gt;&lt;br&gt; kannst du dich anmelden. Nutze den untenstehenden Button, um die Initialisierung abzuschliessen &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du dieses Mail nicht angefordert hast, kannst du es einfach ignorieren.", "language": "de", "template": "InitCode"}		266108224564887557	1715108863.76642	28
266108224564887557	instance	266108224564887557	instance.customtext.set	30	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Initialisierung abschliessen", "language": "de", "template": "InitCode"}		266108224564887557	1715108863.76643	29
266108224564887557	instance	266108224564887557	instance.customtext.set	31	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hallo {{.DisplayName}},", "language": "de", "template": "PasswordReset"}		266108224564887557	1715108863.76643	30
266108224564887557	instance	266108224564887557	instance.customtext.set	32	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Passwort zurücksetzen", "language": "de", "template": "PasswordReset"}		266108224564887557	1715108863.76644	31
266108224564887557	instance	266108224564887557	instance.customtext.set	33	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Passwort zurücksetzen", "language": "de", "template": "PasswordReset"}		266108224564887557	1715108863.76644	32
266108224564887557	instance	266108224564887557	instance.customtext.set	34	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Passwort zurücksetzen", "language": "de", "template": "PasswordReset"}		266108224564887557	1715108863.76645	33
266108224564887557	instance	266108224564887557	instance.customtext.set	35	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "Wir haben eine Anfrage für das Zurücksetzen deines Passwortes bekommen. Du kannst den untenstehenden Button verwenden, um dein Passwort zurückzusetzen &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du dieses Mail nicht angefordert hast, kannst du es ignorieren.", "language": "de", "template": "PasswordReset"}		266108224564887557	1715108863.76646	34
266108224564887557	instance	266108224564887557	instance.customtext.set	36	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Passwort zurücksetzen", "language": "de", "template": "PasswordReset"}		266108224564887557	1715108863.76646	35
266108224564887557	instance	266108224564887557	instance.customtext.set	37	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hallo {{.DisplayName}},", "language": "de", "template": "VerifyEmail"}		266108224564887557	1715108863.76647	36
266108224564887557	instance	266108224564887557	instance.customtext.set	38	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Email verifizieren", "language": "de", "template": "VerifyEmail"}		266108224564887557	1715108863.76647	37
266108224564887557	instance	266108224564887557	instance.customtext.set	39	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Email verifizieren", "language": "de", "template": "VerifyEmail"}		266108224564887557	1715108863.76648	38
266108224564887557	instance	266108224564887557	instance.customtext.set	40	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Email verifizieren", "language": "de", "template": "VerifyEmail"}		266108224564887557	1715108863.76649	39
266108224564887557	instance	266108224564887557	instance.customtext.set	41	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "Eine neue E-Mail Adresse wurde hinzugefügt. Bitte verwende den untenstehenden Button um diese zu verifizieren &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du deine E-Mail Adresse nicht selber hinzugefügt hast, kannst du dieses E-Mail ignorieren.", "language": "de", "template": "VerifyEmail"}		266108224564887557	1715108863.76649	40
266108224564887557	instance	266108224564887557	instance.customtext.set	42	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Email verifizieren", "language": "de", "template": "VerifyEmail"}		266108224564887557	1715108863.7665	41
266108224564887557	instance	266108224564887557	instance.customtext.set	43	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hallo {{.DisplayName}},", "language": "de", "template": "VerifyPhone"}		266108224564887557	1715108863.76651	42
266108224564887557	instance	266108224564887557	instance.customtext.set	44	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Telefonnummer verifizieren", "language": "de", "template": "VerifyPhone"}		266108224564887557	1715108863.76651	43
266108224564887557	instance	266108224564887557	instance.customtext.set	45	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Telefonnummer verifizieren", "language": "de", "template": "VerifyPhone"}		266108224564887557	1715108863.76652	44
266108224564887557	instance	266108224564887557	instance.customtext.set	46	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Telefonnummer verifizieren", "language": "de", "template": "VerifyPhone"}		266108224564887557	1715108863.76652	45
266108224564887557	instance	266108224564887557	instance.customtext.set	47	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "Eine Telefonnummer wurde hinzugefügt. Bitte verifiziere diese in dem du folgenden Code eingibst (Code {{.Code}})", "language": "de", "template": "VerifyPhone"}		266108224564887557	1715108863.76653	46
266108224564887557	instance	266108224564887557	instance.customtext.set	48	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Telefon verifizieren", "language": "de", "template": "VerifyPhone"}		266108224564887557	1715108863.76654	47
266108224564887557	instance	266108224564887557	instance.customtext.set	49	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hallo {{.DisplayName}},", "language": "de", "template": "DomainClaimed"}		266108224564887557	1715108863.76654	48
266108224564887557	instance	266108224564887557	instance.customtext.set	50	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Domain wurde beansprucht", "language": "de", "template": "DomainClaimed"}		266108224564887557	1715108863.76655	49
266108224564887557	instance	266108224564887557	instance.customtext.set	51	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Domain wurde beansprucht", "language": "de", "template": "DomainClaimed"}		266108224564887557	1715108863.76655	50
266108224564887557	instance	266108224564887557	instance.customtext.set	52	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Email / Username ändern", "language": "de", "template": "DomainClaimed"}		266108224564887557	1715108863.76656	51
	system	SYSTEM	system.migration.started	31	1	2024-05-07 19:07:44.214495+00	{"name": "22_active_instance_events_index"}	system	SYSTEM	1715108864.21451	0
266108224564887557	instance	266108224564887557	instance.customtext.set	53	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "Die Domain {{.Domain}} wurde von einer Organisation beansprucht. Dein derzeitiger User {{.Username}} ist nicht Teil dieser Organisation. Daher musst du beim nächsten Login eine neue Email hinterlegen. Für diesen Login haben wir dir einen temporären Usernamen ({{.TempUsername}}) erstellt.", "language": "de", "template": "DomainClaimed"}		266108224564887557	1715108863.76657	52
266108224564887557	instance	266108224564887557	instance.customtext.set	54	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Login", "language": "de", "template": "DomainClaimed"}		266108224564887557	1715108863.76668	53
266108224564887557	instance	266108224564887557	instance.customtext.set	55	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hallo {{.DisplayName}},", "language": "de", "template": "PasswordChange"}		266108224564887557	1715108863.76669	54
266108224564887557	instance	266108224564887557	instance.customtext.set	56	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Passwort von Benutzer wurde geändert", "language": "de", "template": "PasswordChange"}		266108224564887557	1715108863.76669	55
266108224564887557	instance	266108224564887557	instance.customtext.set	57	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "ZITADEL - Passwort von Benutzer wurde geändert", "language": "de", "template": "PasswordChange"}		266108224564887557	1715108863.7667	56
266108224564887557	instance	266108224564887557	instance.customtext.set	58	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Passwort Änderung", "language": "de", "template": "PasswordChange"}		266108224564887557	1715108863.76671	57
266108224564887557	instance	266108224564887557	instance.customtext.set	59	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "Das Password vom Benutzer wurde geändert. Wenn diese Änderung von jemand anderem gemacht wurde, empfehlen wir die sofortige Zurücksetzung ihres Passworts.", "language": "de", "template": "PasswordChange"}		266108224564887557	1715108863.76671	58
266108224564887557	instance	266108224564887557	instance.customtext.set	60	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Login", "language": "de", "template": "PasswordChange"}		266108224564887557	1715108863.76672	59
266108224564887557	instance	266108224564887557	instance.customtext.set	61	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hello {{.DisplayName}},", "language": "en", "template": "InitCode"}		266108224564887557	1715108863.76672	60
266108224564887557	instance	266108224564887557	instance.customtext.set	62	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Initialize User", "language": "en", "template": "InitCode"}		266108224564887557	1715108863.76673	61
266108224564887557	instance	266108224564887557	instance.customtext.set	63	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Initialize User", "language": "en", "template": "InitCode"}		266108224564887557	1715108863.76674	62
266108224564887557	instance	266108224564887557	instance.customtext.set	64	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Initialize User", "language": "en", "template": "InitCode"}		266108224564887557	1715108863.76674	63
266108224564887557	instance	266108224564887557	instance.customtext.set	65	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "This user was created in Zitadel. Use the username {{.PreferredLoginName}} to login. Please click the button below to finish the initialization process. (Code {{.Code}}) If you didn't ask for this mail, please ignore it.", "language": "en", "template": "InitCode"}		266108224564887557	1715108863.76675	64
266108224564887557	instance	266108224564887557	instance.customtext.set	66	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Finish initialization", "language": "en", "template": "InitCode"}		266108224564887557	1715108863.76675	65
266108224564887557	instance	266108224564887557	instance.customtext.set	67	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hello {{.DisplayName}},", "language": "en", "template": "PasswordReset"}		266108224564887557	1715108863.76676	66
266108224564887557	instance	266108224564887557	instance.customtext.set	68	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Reset password", "language": "en", "template": "PasswordReset"}		266108224564887557	1715108863.76677	67
266108224564887557	instance	266108224564887557	instance.customtext.set	69	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Reset password", "language": "en", "template": "PasswordReset"}		266108224564887557	1715108863.76677	68
266108224564887557	instance	266108224564887557	instance.customtext.set	70	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Reset password", "language": "en", "template": "PasswordReset"}		266108224564887557	1715108863.76678	69
266108224564887557	instance	266108224564887557	instance.customtext.set	71	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "We received a password reset request. Please use the button below to reset your password. (Code {{.Code}}) If you didn't ask for this mail, please ignore it.", "language": "en", "template": "PasswordReset"}		266108224564887557	1715108863.76678	70
266108224564887557	instance	266108224564887557	instance.customtext.set	72	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Reset password", "language": "en", "template": "PasswordReset"}		266108224564887557	1715108863.76679	71
266108224564887557	instance	266108224564887557	instance.customtext.set	73	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hello {{.DisplayName}},", "language": "en", "template": "VerifyEmail"}		266108224564887557	1715108863.76679	72
266108224564887557	instance	266108224564887557	instance.customtext.set	74	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Verify email", "language": "en", "template": "VerifyEmail"}		266108224564887557	1715108863.7668	73
266108224564887557	instance	266108224564887557	instance.customtext.set	75	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Verify email", "language": "en", "template": "VerifyEmail"}		266108224564887557	1715108863.76681	74
266108224564887557	instance	266108224564887557	instance.customtext.set	76	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Verify email", "language": "en", "template": "VerifyEmail"}		266108224564887557	1715108863.76681	75
266108224564887557	instance	266108224564887557	instance.customtext.set	77	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "A new email has been added. Please use the button below to verify your email. (Code {{.Code}}) If you din't add a new email, please ignore this email.", "language": "en", "template": "VerifyEmail"}		266108224564887557	1715108863.76682	76
266108224564887557	instance	266108224564887557	instance.customtext.set	78	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Verify email", "language": "en", "template": "VerifyEmail"}		266108224564887557	1715108863.76682	77
266108224564887557	instance	266108224564887557	instance.customtext.set	79	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hello {{.DisplayName}},", "language": "en", "template": "VerifyPhone"}		266108224564887557	1715108863.76683	78
266108224564887557	instance	266108224564887557	instance.customtext.set	80	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Verify phone", "language": "en", "template": "VerifyPhone"}		266108224564887557	1715108863.76684	79
266108224564887557	instance	266108224564887557	instance.customtext.set	81	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Verify phone", "language": "en", "template": "VerifyPhone"}		266108224564887557	1715108863.76694	80
266108224564887557	instance	266108224564887557	instance.customtext.set	82	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Verify phone", "language": "en", "template": "VerifyPhone"}		266108224564887557	1715108863.76695	81
266108224564887557	instance	266108224564887557	instance.customtext.set	83	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "A new phone number has been added. Please use the following code to verify it {{.Code}}.", "language": "en", "template": "VerifyPhone"}		266108224564887557	1715108863.76696	82
266108224564887557	instance	266108224564887557	instance.customtext.set	84	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Verify phone", "language": "en", "template": "VerifyPhone"}		266108224564887557	1715108863.76696	83
266108224564887557	instance	266108224564887557	instance.customtext.set	85	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hello {{.DisplayName}},", "language": "en", "template": "DomainClaimed"}		266108224564887557	1715108863.76697	84
266108224564887557	instance	266108224564887557	instance.customtext.set	86	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Domain has been claimed", "language": "en", "template": "DomainClaimed"}		266108224564887557	1715108863.76697	85
266108224564887557	instance	266108224564887557	instance.customtext.set	87	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "Zitadel - Domain has been claimed", "language": "en", "template": "DomainClaimed"}		266108224564887557	1715108863.76698	86
266108224564887557	instance	266108224564887557	instance.customtext.set	88	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Change email/username", "language": "en", "template": "DomainClaimed"}		266108224564887557	1715108863.76699	87
266108224564887557	instance	266108224564887557	instance.customtext.set	89	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "The domain {{.Domain}} has been claimed by an organization. Your current user {{.UserName}} is not part of this organization. Therefore you'll have to change your email when you login. We have created a temporary username ({{.TempUsername}}) for this login.", "language": "en", "template": "DomainClaimed"}		266108224564887557	1715108863.76699	88
266108224564887557	instance	266108224564887557	instance.customtext.set	90	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Login", "language": "en", "template": "DomainClaimed"}		266108224564887557	1715108863.767	89
266108224564887557	instance	266108224564887557	instance.customtext.set	91	1	2024-05-07 19:07:43.764022+00	{"key": "Greeting", "text": "Hello {{.DisplayName}},", "language": "en", "template": "PasswordChange"}		266108224564887557	1715108863.76703	90
266108224564887557	instance	266108224564887557	instance.customtext.set	92	1	2024-05-07 19:07:43.764022+00	{"key": "Subject", "text": "Password of user has changed", "language": "en", "template": "PasswordChange"}		266108224564887557	1715108863.76736	91
266108224564887557	instance	266108224564887557	instance.customtext.set	93	1	2024-05-07 19:07:43.764022+00	{"key": "Title", "text": "ZITADEL - Password of user has changed", "language": "en", "template": "PasswordChange"}		266108224564887557	1715108863.76737	92
266108224564887557	instance	266108224564887557	instance.customtext.set	94	1	2024-05-07 19:07:43.764022+00	{"key": "PreHeader", "text": "Change password", "language": "en", "template": "PasswordChange"}		266108224564887557	1715108863.76737	93
266108224564887557	instance	266108224564887557	instance.customtext.set	95	1	2024-05-07 19:07:43.764022+00	{"key": "Text", "text": "The password of your user has changed. If this change was not done by you, please be advised to immediately reset your password.", "language": "en", "template": "PasswordChange"}		266108224564887557	1715108863.76738	94
266108224564887557	instance	266108224564887557	instance.customtext.set	96	1	2024-05-07 19:07:43.764022+00	{"key": "ButtonText", "text": "Login", "language": "en", "template": "PasswordChange"}		266108224564887557	1715108863.76739	95
266108224564887557	org	266108224564953093	org.added	1	1	2024-05-07 19:07:43.764022+00	{"name": "ZITADEL"}		266108224564953093	1715108863.76739	96
266108224564887557	org	266108224564953093	org.domain.added	2	1	2024-05-07 19:07:43.764022+00	{"domain": "zitadel.localhost"}		266108224564953093	1715108863.7674	97
266108224564887557	org	266108224564953093	org.domain.verified	3	1	2024-05-07 19:07:43.764022+00	{"domain": "zitadel.localhost"}		266108224564953093	1715108863.7674	98
266108224564887557	org	266108224564953093	org.domain.primary.set	4	1	2024-05-07 19:07:43.764022+00	{"domain": "zitadel.localhost"}		266108224564953093	1715108863.76741	99
266108224564887557	instance	266108224564887557	instance.default.org.set	97	1	2024-05-07 19:07:43.764022+00	{"orgId": "266108224564953093"}		266108224564887557	1715108863.76742	100
266108224564887557	user	266108224565018629	user.human.added	1	2	2024-05-07 19:07:43.764022+00	{"email": "zitadel-admin@zitadel.localhost", "lastName": "Admin", "userName": "zitadel-admin@zitadel.localhost", "firstName": "ZITADEL", "displayName": "ZITADEL Admin", "encodedHash": "$2a$14$iB3wn6E0poQXEZo7XkFT7.D9xkUnyDEO1DTRDiuvuIvTUv17BFMh2", "changeRequired": true, "preferredLanguage": "en"}		266108224564953093	1715108863.76742	101
266108224564887557	user	266108224565018629	user.human.email.verified	2	2	2024-05-07 19:07:43.764022+00	\N		266108224564953093	1715108863.76743	102
266108224564887557	org	266108224564953093	org.member.added	5	1	2024-05-07 19:07:43.764022+00	{"roles": ["ORG_OWNER"], "userId": "266108224565018629"}		266108224564953093	1715108863.76743	103
266108224564887557	instance	266108224564887557	instance.member.added	98	1	2024-05-07 19:07:43.764022+00	{"roles": ["IAM_OWNER"], "userId": "266108224565018629"}		266108224564887557	1715108863.76744	104
266108224564887557	project	266108224565084165	project.added	1	1	2024-05-07 19:07:43.764022+00	{"name": "ZITADEL"}		266108224564953093	1715108863.76745	105
266108224564887557	project	266108224565084165	project.member.added	2	1	2024-05-07 19:07:43.764022+00	{"roles": ["PROJECT_OWNER"], "userId": "266108224565018629"}		266108224564953093	1715108863.76745	106
266108224564887557	instance	266108224564887557	instance.iam.project.set	99	1	2024-05-07 19:07:43.764022+00	{"iamProjectId": "266108224565084165"}		266108224564887557	1715108863.76746	107
266108224564887557	project	266108224565084165	project.application.added	3	1	2024-05-07 19:07:43.764022+00	{"name": "Management-API", "appId": "266108224565149701"}		266108224564953093	1715108863.76746	108
266108224564887557	project	266108224565084165	project.application.config.api.added	4	1	2024-05-07 19:07:43.764022+00	{"appId": "266108224565149701", "clientId": "266108227433791493@zitadel", "authMethodType": 1}		266108224564953093	1715108863.76747	109
266108224564887557	project	266108224565084165	project.application.added	5	1	2024-05-07 19:07:43.764022+00	{"name": "Admin-API", "appId": "266108224565215237"}		266108224564953093	1715108863.76747	110
266108224564887557	project	266108224565084165	project.application.config.api.added	6	1	2024-05-07 19:07:43.764022+00	{"appId": "266108224565215237", "clientId": "266108227450568709@zitadel", "authMethodType": 1}		266108224564953093	1715108863.76758	111
266108224564887557	project	266108224565084165	project.application.added	7	1	2024-05-07 19:07:43.764022+00	{"name": "Auth-API", "appId": "266108224565280773"}		266108224564953093	1715108863.76759	112
266108224564887557	project	266108224565084165	project.application.config.api.added	8	1	2024-05-07 19:07:43.764022+00	{"appId": "266108224565280773", "clientId": "266108227467345925@zitadel", "authMethodType": 1}		266108224564953093	1715108863.76759	113
266108224564887557	project	266108224565084165	project.application.added	9	1	2024-05-07 19:07:43.764022+00	{"name": "Console", "appId": "266108224565346309"}		266108224564953093	1715108863.7676	114
266108224564887557	project	266108224565084165	project.application.config.oidc.added	10	1	2024-05-07 19:07:43.764022+00	{"appId": "266108224565346309", "devMode": true, "clientId": "266108227467411461@zitadel", "grantTypes": [0], "responseTypes": [0], "authMethodType": 2, "applicationType": 1}		266108224564953093	1715108863.7676	115
266108224564887557	instance	266108224564887557	instance.iam.console.set	100	1	2024-05-07 19:07:43.764022+00	{"appId": "266108224565346309", "clientId": "266108227467411461@zitadel"}		266108224564887557	1715108863.76761	116
266108224564887557	instance	266108224564887557	instance.domain.added	101	1	2024-05-07 19:07:43.764022+00	{"domain": "zitadel-i1rjad.localhost", "generated": true}		266108224564887557	1715108863.76915	117
266108224564887557	project	266108224565084165	project.application.config.oidc.changed	11	1	2024-05-07 19:07:43.764022+00	{"appId": "266108224565346309", "redirectUris": ["http://zitadel-i1rjad.localhost:8085/ui/console/auth/callback"], "postLogoutRedirectUris": ["http://zitadel-i1rjad.localhost:8085/ui/console/signedout"]}		266108224564953093	1715108863.76916	118
266108224564887557	instance	266108224564887557	instance.domain.primary.set	102	1	2024-05-07 19:07:43.764022+00	{"domain": "zitadel-i1rjad.localhost"}		266108224564887557	1715108863.76917	119
266108224564887557	instance	266108224564887557	instance.domain.added	103	1	2024-05-07 19:07:43.764022+00	{"domain": "localhost"}		266108224564887557	1715108863.76934	120
266108224564887557	project	266108224565084165	project.application.config.oidc.changed	12	1	2024-05-07 19:07:43.764022+00	{"appId": "266108224565346309", "redirectUris": ["http://zitadel-i1rjad.localhost:8085/ui/console/auth/callback", "http://localhost:8085/ui/console/auth/callback"], "postLogoutRedirectUris": ["http://zitadel-i1rjad.localhost:8085/ui/console/signedout", "http://localhost:8085/ui/console/signedout"]}		266108224564953093	1715108863.76935	121
266108224564887557	instance	266108224564887557	instance.domain.primary.set	104	1	2024-05-07 19:07:43.764022+00	{"domain": "localhost"}		266108224564887557	1715108863.76935	122
266108224564887557	instance	266108224564887557	instance.oidc.settings.added	105	1	2024-05-07 19:07:43.764022+00	{"idTokenLifetime": 43200000000000, "accessTokenLifetime": 43200000000000, "refreshTokenExpiration": 7776000000000000, "refreshTokenIdleExpiration": 2592000000000000}		266108224564887557	1715108863.76936	123
266108224564887557	feature	266108224564887557	feature.instance.login_default_org.set	1	2	2024-05-07 19:07:43.764022+00	{"Value": true}		266108224564887557	1715108863.76937	124
	system	SYSTEM	system.migration.done	8	1	2024-05-07 19:07:43.780424+00	{"name": "03_default_instance"}	system	SYSTEM	1715108863.78044	0
	system	SYSTEM	system.migration.started	9	1	2024-05-07 19:07:43.792491+00	{"name": "05_last_failed"}	system	SYSTEM	1715108863.7925	0
	system	SYSTEM	system.migration.done	10	1	2024-05-07 19:07:43.81463+00	{"name": "05_last_failed"}	system	SYSTEM	1715108863.81464	0
	system	SYSTEM	system.migration.started	11	1	2024-05-07 19:07:43.827215+00	{"name": "06_resource_owner_columns"}	system	SYSTEM	1715108863.82723	0
	system	SYSTEM	system.migration.done	12	1	2024-05-07 19:07:43.869612+00	{"name": "06_resource_owner_columns"}	system	SYSTEM	1715108863.86962	0
	system	SYSTEM	system.migration.started	13	1	2024-05-07 19:07:43.882139+00	{"name": "07_logstore"}	system	SYSTEM	1715108863.88215	0
	system	SYSTEM	system.migration.done	14	1	2024-05-07 19:07:43.905517+00	{"name": "07_logstore"}	system	SYSTEM	1715108863.90553	0
	system	SYSTEM	system.migration.started	15	1	2024-05-07 19:07:43.91742+00	{"name": "08_auth_token_indexes"}	system	SYSTEM	1715108863.91743	0
	system	SYSTEM	system.migration.done	16	1	2024-05-07 19:07:43.936223+00	{"name": "08_auth_token_indexes"}	system	SYSTEM	1715108863.93623	0
	system	SYSTEM	system.migration.started	17	1	2024-05-07 19:07:43.951177+00	{"name": "12_auth_users_otp_columns"}	system	SYSTEM	1715108863.95119	0
	system	SYSTEM	system.migration.done	18	1	2024-05-07 19:07:43.962454+00	{"name": "12_auth_users_otp_columns"}	system	SYSTEM	1715108863.96246	0
	system	SYSTEM	system.migration.started	19	1	2024-05-07 19:07:43.97842+00	{"name": "13_fix_quota_constraints"}	system	SYSTEM	1715108863.97843	0
	system	SYSTEM	system.migration.done	20	1	2024-05-07 19:07:43.987424+00	{"name": "13_fix_quota_constraints"}	system	SYSTEM	1715108863.98743	0
	system	SYSTEM	system.migration.started	21	1	2024-05-07 19:07:44.000226+00	{"name": "15_current_projection_state"}	system	SYSTEM	1715108864.00024	0
	system	SYSTEM	system.migration.done	22	1	2024-05-07 19:07:44.075043+00	{"name": "15_current_projection_state"}	system	SYSTEM	1715108864.07505	0
	system	SYSTEM	system.migration.started	23	1	2024-05-07 19:07:44.086555+00	{"name": "16_unique_constraint_lower"}	system	SYSTEM	1715108864.08657	0
	system	SYSTEM	system.migration.done	24	1	2024-05-07 19:07:44.095909+00	{"name": "16_unique_constraint_lower"}	system	SYSTEM	1715108864.09592	0
	system	SYSTEM	system.migration.started	25	1	2024-05-07 19:07:44.110817+00	{"name": "17_add_offset_col_to_current_states"}	system	SYSTEM	1715108864.11083	0
	system	SYSTEM	system.migration.done	26	1	2024-05-07 19:07:44.122278+00	{"name": "17_add_offset_col_to_current_states"}	system	SYSTEM	1715108864.12229	0
	system	SYSTEM	system.migration.started	27	1	2024-05-07 19:07:44.136561+00	{"name": "19_add_current_sequences_index"}	system	SYSTEM	1715108864.13657	0
	system	SYSTEM	system.migration.done	28	1	2024-05-07 19:07:44.15596+00	{"name": "19_add_current_sequences_index"}	system	SYSTEM	1715108864.15597	0
	system	SYSTEM	system.migration.started	29	1	2024-05-07 19:07:44.171855+00	{"name": "20_add_by_user_index_on_session"}	system	SYSTEM	1715108864.17187	0
	system	SYSTEM	system.migration.done	30	1	2024-05-07 19:07:44.195072+00	{"name": "20_add_by_user_index_on_session"}	system	SYSTEM	1715108864.19509	0
	system	SYSTEM	system.migration.done	32	1	2024-05-07 19:07:44.234485+00	{"name": "22_active_instance_events_index"}	system	SYSTEM	1715108864.2345	0
	system	SYSTEM	system.migration.started	33	1	2024-05-07 19:07:44.255491+00	{"name": "23_correct_global_unique_constraints"}	system	SYSTEM	1715108864.2555	0
	system	SYSTEM	system.migration.done	34	1	2024-05-07 19:07:44.269473+00	{"name": "23_correct_global_unique_constraints"}	system	SYSTEM	1715108864.26949	0
	system	SYSTEM	system.migration.started	35	1	2024-05-07 19:07:44.285093+00	{"name": "config_change"}	system	SYSTEM	1715108864.2851	0
	system	SYSTEM	system.migration.repeatable.done	36	1	2024-05-07 19:07:44.30823+00	{"name": "config_change", "lastRun": {"externalPort": 8085, "externalDomain": "localhost", "externalSecure": false}}	system	SYSTEM	1715108864.30825	0
	system	SYSTEM	system.migration.started	37	1	2024-05-07 19:07:44.327606+00	{"name": "projection_tables"}	system	SYSTEM	1715108864.32762	0
	system	SYSTEM	system.migration.repeatable.done	38	1	2024-05-07 19:07:45.334964+00	{"name": "projection_tables", "lastRun": {"version": "v2.47.4"}}	system	SYSTEM	1715108865.33498	0
	system	SYSTEM	system.migration.started	39	1	2024-05-07 19:07:45.356472+00	{"name": "18_add_lower_fields_to_login_names"}	system	SYSTEM	1715108865.35648	0
	system	SYSTEM	system.migration.done	40	1	2024-05-07 19:07:45.398312+00	{"name": "18_add_lower_fields_to_login_names"}	system	SYSTEM	1715108865.39832	0
	system	SYSTEM	system.migration.started	41	1	2024-05-07 19:07:45.411462+00	{"name": "21_add_block_field_to_limits"}	system	SYSTEM	1715108865.41147	0
	system	SYSTEM	system.migration.done	42	1	2024-05-07 19:07:45.422222+00	{"name": "21_add_block_field_to_limits"}	system	SYSTEM	1715108865.42224	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	3	2	2024-05-07 19:09:37.544038+00	{"id": "266108240973004805", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715108977.54405	0
266108224564887557	user	266108224565018629	user.human.mfa.init.skipped	4	2	2024-05-07 19:09:39.910044+00	{}	LOGIN	266108224564953093	1715108979.91006	0
266108224564887557	user	266108224565018629	user.human.password.changed	5	2	2024-05-07 19:10:08.214015+00	{"encodedHash": "$2a$14$DK99H.deSQWaASwWoyipwe42jBrV4fjXj6BEz8foaPQS4Ge0fQEUu", "userAgentID": "266108240469688325", "triggerOrigin": "http://localhost:8085", "changeRequired": false}	LOGIN	266108224564953093	1715109008.21403	0
266108224564887557	user	266108224565018629	user.token.added	6	2	2024-05-07 19:10:14.139469+00	{"scopes": ["openid", "profile", "email"], "tokenId": "266108479847006213", "audience": ["266108227433791493@zitadel", "266108227450568709@zitadel", "266108227467345925@zitadel", "266108227467411461@zitadel", "266108224565084165"], "expiration": "2024-05-08T07:10:14.133479084Z", "userAgentId": "266108240469688325", "applicationId": "266108227467411461@zitadel", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715109014.13948	0
266108224564887557	key_pair	266108480518094853	key_pair.added	1	1	2024-05-07 19:10:14.54762+00	{"usage": 0, "algorithm": "RS256", "publicKey": {"key": {"KeyID": "oidcKey", "Crypted": "DRekEXzIuaAGmLg0iTODkdlG+RCGYG3lfK1zf4j/9IqSnLVt2ldeoFlXvvGk5OvLQ7ha868vKcCgN8ZgGjOy9j/gEV07DXRoTZ4n+ve0gbqgZfyXIigH9te+6fjUSgSTAmlWlivRgsUjygIr3SgVyCBibelWNYKykglSlLSajLKa/gEeEMTAnYYiN+bQUl3ZqRDzUHOWxVClW8VPuGPGfHtCPwvP3MeJ2a899VIi+hAelSD4CTddPiVM2gAuS7Z+OKyz+TrJ4WDiEpdHZ3LiITH99aRnPphv0qj7eOhereSf6ht2o3jVJm/ha3hbKzotIPipOZIrbFpVinFZQ/ci/icc2vNyRjjTz7s7s+5G6UYrxf9L7lhtq5QpuurD/WVZR/Dg12aV66VOV92ezswi86b5W9K914LQDVGSDk9IZ1P+kNgctlrxcA6hLcejZ5H2sbT1jozvn20uU4PxAJ1VuVuVLQp9snpIuF3frsh2EktnIJgvrLQZIbF4O1ZtCrSaXXLRnci68qrLhu2zzZTOlcprLpM0tKRqX8tff0HdX6p3ibVqfOA6pKXtWa6QY1areFjYzMmIoGcb3YnaGjX/agv1czHjHqbOYKNdn+ul2R62kHsu8s8OcMYwng==", "Algorithm": "aes", "CryptoType": 0}, "expiry": "2024-05-09T01:10:14.535841834Z"}, "privateKey": {"key": {"KeyID": "oidcKey", "Crypted": "EA8WmqhS/OYVBHtcVUo2D8rBIK7zl7iFGPsvjxXQap5u6SiX3/7awHlwaiTf3ZLms0ZLcGx1A3qC119aiqEv5HByYeI+1fWdrBzs3lLTlsKT4rhA82qr6NzLf0IABEZXuqxKK7QuLijq6LOuwBhgRp+oU6oK4z+0d+wmRcIRmwlfHY7HY0n6GNqLa/jr+QMBPrCE7dvQ2iKWC9DD45Ubq7cZ2oZ5UJYWXZRxhUQMmeqzsS0OMvHt79V2ejE1lgWiTvU59gS9qf3sl4jwbIb78zHRIPlHIgsRp77mnAGFDmIhbCPJZzr2mohHhxwVpV9pmO9iksPq4DGA2zx4syG7UN7hzAGtV+5zONi+UJ8+T9kC8D4nV83TbXB51PAaeiGzyhzhXaH+FzMB3IqDRMkwnMx8PyvBMdS6LeZ2jd3biR7hdcvOSVC/x3gLSpApDz9+OjYzZX3hhRDlnO0zVyTcOJpGMh9XVouMoF8Fkz8k23pOUNNMkAIO0qWS67aU9qXmbOeF0Tq8sIk0UbQ8kRC3gig06+f4czAIFxgMXDihJo+li1leRvNcT1diMJJeVcttK0xNyyD71eTvsra/hiJJ3Y/7j6Zge1w3z7A1b+/vOVpKCFHqnBwTgQlXGcx3WRSxYNge5CBohKsFbR4WwAmP5WNYZH8u/M/8qCaPt5m5q+n2cO5ChZ1Xqpbk6zU15GZQgrw0fBpK5oS5AUk5hgPNU+DmWFMjRiObFOb2rawXHGl3UlPeEI00TfUxxWG6Jy3VLOtNzA6MsqE30XFc+onb8+h77CYkKxC4qNaUbTceMYGNbLSd+X9zD0PhzBI8MIlxiYAfENL+9olLIgFlVeh10ZD1DXPM1BdY3f6b3GgM/9rQ85J0h2HJdxas+q/I60ty01fd5a7+X12WL7mXbF6tIEi40zzGn6BzwSgmjbz+aCEdmLpauHIxO8iVFbZo9aeWGVAQyXGny8xFtx4PRdD3aQmSfPt4VHutNvd2PhzQ6GEWpmc52+/5ZTNHQ4pfyE8sMKnUHug20nWiS8T0G2AHisggEA+pn3DbgxhgzbhuKN9a9FitmxDbGTMDuFYrrBekbL1tqVOXtBzug09MYCNz0WsMOL8d6250EmYOZTj9X3kZlZWWH9cFP6KTmlfhAaBZiafGrKViA+3ykndjwJx1GYL2qa+BIUwaizdppuSLEijxNOCIxGgi31zUMYsJk4QU1eQJZdt/a3xn5KY/Nn1xC/HP6NC4cize1vzLc1M/zXWpBB5no74MIZ1peBd3UAEQ/UOOwUk1Ug8Pjcx/G3g7cClrrOdD97knuDHkdlQBex9KeuP6WeQpi/og+UGZLdl12HRNb/ciIAmZWOY85rgGuyCS9goteTCHq/qg9mVZZqUW6wQdJXtwsSPRvv982DW/Ux4SXXHJQEvEQfhUeN8HmTItMdW3aAEmSFKPQnjrK2tgpeA4XZCjz36Bj/MUgRw+mmtq7Ab5BszFief2I+VOhCd50tK/5ZB6FPnUsVHQ+3n+FZnvXkghP9HN6NBJVT8sPOgoy54+o/UGYQ4g480xU/u4aMpJ8pz3Y41wpft14nVIOjtH0/v6toeDmo5AzDuNxX5PUwrF5GI3Rmoh8KHgzFSG+11+Ganw5t/N6RgoPPAB4HqWHuIHoCeK8WEfhUfChsRKHpg/Y1HcL6bE2DIFDyLnmGMovQYCwPAP4URqJ87YjYlydlNOoIC0IIlPTuZfA3lQcAgDGqISA/9HY4pWtY2zHa9Q3k8dW5NGHNBVq9rMJpx2hg0XVkvZY5P+OLsadfGjz4ufOwlUzYE5zs2o4j/2B81wcCrn/D5+/j95C5tn0yzXQ1spNGzX25GIFbIERKPgr+XbrL5fXLPxyqQY3/ilU1g0B/HMbOb6jeUebo0Cl5H3hDrPu/t365Kfa7jt4ic8qnqoInIpwIkR1EVqewPPOSr4pbLYq8y/0UUtZJ0Yo0kaJUn0phhJB2SLdwS0KtVeZZDGG9ODbVgWi2VmJbJq7jZWGLfrx8QZOpdndWsNLcch8GWvC8IHwDf6aY7NEM9xS2GUYVtB37aBfnwecFfM2bTdX/0bX3FaOW6FyMXrm4AVbpny+O+RTS2f1AUfd5dHi07K1obe9iXzLIO6MMZDWdy2JPJVF4rk246gjLlGHYm/9AphbqT1SS7QgoSvnaJ2kRFGNgRiTWeQfbWuXtt3dtUcjsU76NczAnM8RUjjur/178e8YJbdmCODAcTAKZ4ReoxHJ3X5UN3La7GE", "Algorithm": "aes", "CryptoType": 0}, "expiry": "2024-05-08T01:10:14.535841501Z"}}	OIDC	266108224564887557	1715109014.54763	0
266108224564887557	project	266108518786924549	project.added	1	1	2024-05-07 19:10:37.35547+00	{"name": "DataLens"}	266108224565018629	266108224564953093	1715109037.35548	0
266108224564887557	project	266108518786924549	project.member.added	2	1	2024-05-07 19:10:37.35547+00	{"roles": ["PROJECT_OWNER"], "userId": "266108224565018629"}	266108224565018629	266108224564953093	1715109037.35567	1
266108224564887557	project	266108518786924549	project.application.added	3	1	2024-05-07 19:11:44.550639+00	{"name": "BFF", "appId": "266108631362043909"}	266108224565018629	266108224564953093	1715109104.55065	0
266108224564887557	project	266108518786924549	project.application.config.oidc.added	4	1	2024-05-07 19:11:44.550639+00	{"appId": "266108631362043909", "devMode": true, "clientId": "266108631362109445@datalens", "grantTypes": [0], "clientSecret": {"KeyID": "", "Crypted": "JDJhJDEwJE5mSXZZcXVZV29jckVTSVZOUnBhVHU0bmwybDhBQ25YS2pEaWhOY082TUdWWXBhVUxXOVRl", "Algorithm": "bcrypt", "CryptoType": 1}, "redirectUris": ["http://localhost:8000/api/auth"], "responseTypes": [0], "authMethodType": 1, "postLogoutRedirectUris": ["http://localhost:8000/api/auth"]}	266108224565018629	266108224564953093	1715109104.55087	1
	system	SYSTEM	system.migration.started	43	1	2024-05-08 12:30:46.595713+00	{"name": "24_add_actor_col_to_auth_tokens"}	system	SYSTEM	1715171446.59573	0
	system	SYSTEM	system.migration.done	44	1	2024-05-08 12:30:46.606338+00	{"name": "24_add_actor_col_to_auth_tokens"}	system	SYSTEM	1715171446.60635	0
	system	SYSTEM	system.migration.started	45	1	2024-05-08 12:30:46.620665+00	{"name": "projection_tables"}	system	SYSTEM	1715171446.62068	0
	system	SYSTEM	system.migration.repeatable.done	46	1	2024-05-08 12:30:46.942395+00	{"name": "projection_tables", "lastRun": {"version": "v2.51.3"}}	system	SYSTEM	1715171446.94241	0
	system	SYSTEM	system.migration.started	47	1	2024-05-08 12:30:46.963991+00	{"name": "25_user12_add_lower_fields_to_verified_email"}	system	SYSTEM	1715171446.964	0
	system	SYSTEM	system.migration.done	48	1	2024-05-08 12:30:46.984788+00	{"name": "25_user12_add_lower_fields_to_verified_email"}	system	SYSTEM	1715171446.9848	0
	system	SYSTEM	system.migration.started	49	1	2024-05-08 12:30:47.059711+00	{"name": "projections.orgs1"}	system	SYSTEM	1715171447.05972	0
	system	SYSTEM	system.migration.done	50	1	2024-05-08 12:30:47.190159+00	{"name": "projections.orgs1"}	system	SYSTEM	1715171447.19018	0
	system	SYSTEM	system.migration.started	51	1	2024-05-08 12:30:47.201529+00	{"name": "projections.org_metadata2"}	system	SYSTEM	1715171447.20154	0
	system	SYSTEM	system.migration.done	52	1	2024-05-08 12:30:47.324096+00	{"name": "projections.org_metadata2"}	system	SYSTEM	1715171447.32411	0
	system	SYSTEM	system.migration.started	53	1	2024-05-08 12:30:47.335449+00	{"name": "projections.actions3"}	system	SYSTEM	1715171447.33546	0
	system	SYSTEM	system.migration.done	54	1	2024-05-08 12:30:47.459605+00	{"name": "projections.actions3"}	system	SYSTEM	1715171447.45962	0
	system	SYSTEM	system.migration.started	55	1	2024-05-08 12:30:47.472749+00	{"name": "projections.flow_triggers3"}	system	SYSTEM	1715171447.47276	0
	system	SYSTEM	system.migration.done	56	1	2024-05-08 12:30:47.598511+00	{"name": "projections.flow_triggers3"}	system	SYSTEM	1715171447.59852	0
	system	SYSTEM	system.migration.started	57	1	2024-05-08 12:30:47.610036+00	{"name": "projections.projects4"}	system	SYSTEM	1715171447.61005	0
	system	SYSTEM	system.migration.done	58	1	2024-05-08 12:30:47.734745+00	{"name": "projections.projects4"}	system	SYSTEM	1715171447.73476	0
	system	SYSTEM	system.migration.started	59	1	2024-05-08 12:30:47.744792+00	{"name": "projections.password_complexity_policies2"}	system	SYSTEM	1715171447.7448	0
	system	SYSTEM	system.migration.done	60	1	2024-05-08 12:30:47.867356+00	{"name": "projections.password_complexity_policies2"}	system	SYSTEM	1715171447.86737	0
	system	SYSTEM	system.migration.started	61	1	2024-05-08 12:30:47.877893+00	{"name": "projections.password_age_policies2"}	system	SYSTEM	1715171447.8779	0
	system	SYSTEM	system.migration.done	62	1	2024-05-08 12:30:48.000392+00	{"name": "projections.password_age_policies2"}	system	SYSTEM	1715171448.00041	0
	system	SYSTEM	system.migration.started	63	1	2024-05-08 12:30:48.01188+00	{"name": "projections.lockout_policies3"}	system	SYSTEM	1715171448.01189	0
	system	SYSTEM	system.migration.done	64	1	2024-05-08 12:30:48.135551+00	{"name": "projections.lockout_policies3"}	system	SYSTEM	1715171448.13556	0
	system	SYSTEM	system.migration.started	65	1	2024-05-08 12:30:48.147095+00	{"name": "projections.privacy_policies3"}	system	SYSTEM	1715171448.14711	0
	system	SYSTEM	system.migration.done	66	1	2024-05-08 12:30:48.273044+00	{"name": "projections.privacy_policies3"}	system	SYSTEM	1715171448.27306	0
	system	SYSTEM	system.migration.started	67	1	2024-05-08 12:30:48.288478+00	{"name": "projections.domain_policies2"}	system	SYSTEM	1715171448.28849	0
	system	SYSTEM	system.migration.done	68	1	2024-05-08 12:30:48.413405+00	{"name": "projections.domain_policies2"}	system	SYSTEM	1715171448.41342	0
	system	SYSTEM	system.migration.started	69	1	2024-05-08 12:30:48.4256+00	{"name": "projections.label_policies3"}	system	SYSTEM	1715171448.42561	0
	system	SYSTEM	system.migration.done	70	1	2024-05-08 12:30:48.550231+00	{"name": "projections.label_policies3"}	system	SYSTEM	1715171448.55025	0
	system	SYSTEM	system.migration.started	71	1	2024-05-08 12:30:48.56289+00	{"name": "projections.project_grants4"}	system	SYSTEM	1715171448.56291	0
	system	SYSTEM	system.migration.done	72	1	2024-05-08 12:30:48.687999+00	{"name": "projections.project_grants4"}	system	SYSTEM	1715171448.68801	0
	system	SYSTEM	system.migration.started	73	1	2024-05-08 12:30:48.69934+00	{"name": "projections.project_roles4"}	system	SYSTEM	1715171448.69935	0
	system	SYSTEM	system.migration.done	74	1	2024-05-08 12:30:48.824527+00	{"name": "projections.project_roles4"}	system	SYSTEM	1715171448.82454	0
	system	SYSTEM	system.migration.started	75	1	2024-05-08 12:30:48.83819+00	{"name": "projections.org_domains2"}	system	SYSTEM	1715171448.8382	0
	system	SYSTEM	system.migration.done	76	1	2024-05-08 12:30:48.96255+00	{"name": "projections.org_domains2"}	system	SYSTEM	1715171448.96256	0
	system	SYSTEM	system.migration.started	77	1	2024-05-08 12:30:48.974263+00	{"name": "projections.login_policies5"}	system	SYSTEM	1715171448.97427	0
	system	SYSTEM	system.migration.done	78	1	2024-05-08 12:30:49.098717+00	{"name": "projections.login_policies5"}	system	SYSTEM	1715171449.09873	0
	system	SYSTEM	system.migration.started	79	1	2024-05-08 12:30:49.11111+00	{"name": "projections.idps3"}	system	SYSTEM	1715171449.11112	0
	system	SYSTEM	system.migration.done	80	1	2024-05-08 12:30:49.235121+00	{"name": "projections.idps3"}	system	SYSTEM	1715171449.23513	0
	system	SYSTEM	system.migration.started	81	1	2024-05-08 12:30:49.248306+00	{"name": "projections.idp_templates6"}	system	SYSTEM	1715171449.24832	0
	system	SYSTEM	system.migration.done	82	1	2024-05-08 12:30:49.374221+00	{"name": "projections.idp_templates6"}	system	SYSTEM	1715171449.37424	0
	system	SYSTEM	system.migration.started	83	1	2024-05-08 12:30:49.386514+00	{"name": "projections.apps7"}	system	SYSTEM	1715171449.38653	0
	system	SYSTEM	system.migration.done	84	1	2024-05-08 12:30:49.520182+00	{"name": "projections.apps7"}	system	SYSTEM	1715171449.5202	0
	system	SYSTEM	system.migration.started	85	1	2024-05-08 12:30:49.531849+00	{"name": "projections.idp_user_links3"}	system	SYSTEM	1715171449.53186	0
	system	SYSTEM	system.migration.done	86	1	2024-05-08 12:30:49.656635+00	{"name": "projections.idp_user_links3"}	system	SYSTEM	1715171449.65666	0
	system	SYSTEM	system.migration.started	87	1	2024-05-08 12:30:49.669712+00	{"name": "projections.idp_login_policy_links5"}	system	SYSTEM	1715171449.66973	0
	system	SYSTEM	system.migration.done	88	1	2024-05-08 12:30:49.796942+00	{"name": "projections.idp_login_policy_links5"}	system	SYSTEM	1715171449.79696	0
	system	SYSTEM	system.migration.started	89	1	2024-05-08 12:30:49.810351+00	{"name": "projections.mail_templates2"}	system	SYSTEM	1715171449.81036	0
	system	SYSTEM	system.migration.done	90	1	2024-05-08 12:30:49.932875+00	{"name": "projections.mail_templates2"}	system	SYSTEM	1715171449.93289	0
	system	SYSTEM	system.migration.started	91	1	2024-05-08 12:30:49.945824+00	{"name": "projections.message_texts2"}	system	SYSTEM	1715171449.94584	0
	system	SYSTEM	system.migration.done	92	1	2024-05-08 12:30:50.072272+00	{"name": "projections.message_texts2"}	system	SYSTEM	1715171450.07229	0
	system	SYSTEM	system.migration.started	93	1	2024-05-08 12:30:50.086559+00	{"name": "projections.custom_texts2"}	system	SYSTEM	1715171450.08657	0
	system	SYSTEM	system.migration.done	94	1	2024-05-08 12:30:50.210288+00	{"name": "projections.custom_texts2"}	system	SYSTEM	1715171450.21031	0
	system	SYSTEM	system.migration.started	95	1	2024-05-08 12:30:50.224102+00	{"name": "projections.users12"}	system	SYSTEM	1715171450.22411	0
	system	SYSTEM	system.migration.done	96	1	2024-05-08 12:30:50.357812+00	{"name": "projections.users12"}	system	SYSTEM	1715171450.35783	0
	system	SYSTEM	system.migration.started	97	1	2024-05-08 12:30:50.374372+00	{"name": "projections.login_names3"}	system	SYSTEM	1715171450.37439	0
	system	SYSTEM	system.migration.done	98	1	2024-05-08 12:30:50.500321+00	{"name": "projections.login_names3"}	system	SYSTEM	1715171450.50034	0
	system	SYSTEM	system.migration.started	99	1	2024-05-08 12:30:50.513408+00	{"name": "projections.org_members4"}	system	SYSTEM	1715171450.51342	0
	system	SYSTEM	system.migration.done	100	1	2024-05-08 12:30:50.640391+00	{"name": "projections.org_members4"}	system	SYSTEM	1715171450.64041	0
	system	SYSTEM	system.migration.started	101	1	2024-05-08 12:30:50.655996+00	{"name": "projections.instance_domains"}	system	SYSTEM	1715171450.65601	0
	system	SYSTEM	system.migration.done	102	1	2024-05-08 12:30:50.78216+00	{"name": "projections.instance_domains"}	system	SYSTEM	1715171450.78218	0
	system	SYSTEM	system.migration.started	103	1	2024-05-08 12:30:50.79545+00	{"name": "projections.instance_members4"}	system	SYSTEM	1715171450.79546	0
	system	SYSTEM	system.migration.done	104	1	2024-05-08 12:30:50.920709+00	{"name": "projections.instance_members4"}	system	SYSTEM	1715171450.92073	0
	system	SYSTEM	system.migration.started	105	1	2024-05-08 12:30:50.937343+00	{"name": "projections.project_members4"}	system	SYSTEM	1715171450.93737	0
	system	SYSTEM	system.migration.done	106	1	2024-05-08 12:30:51.063753+00	{"name": "projections.project_members4"}	system	SYSTEM	1715171451.06378	0
	system	SYSTEM	system.migration.started	107	1	2024-05-08 12:30:51.07924+00	{"name": "projections.project_grant_members4"}	system	SYSTEM	1715171451.07927	0
	system	SYSTEM	system.migration.done	108	1	2024-05-08 12:30:51.206754+00	{"name": "projections.project_grant_members4"}	system	SYSTEM	1715171451.20678	0
	system	SYSTEM	system.migration.started	109	1	2024-05-08 12:30:51.220436+00	{"name": "projections.authn_keys2"}	system	SYSTEM	1715171451.22045	0
	system	SYSTEM	system.migration.done	110	1	2024-05-08 12:30:51.345926+00	{"name": "projections.authn_keys2"}	system	SYSTEM	1715171451.34594	0
	system	SYSTEM	system.migration.started	111	1	2024-05-08 12:30:51.361433+00	{"name": "projections.personal_access_tokens3"}	system	SYSTEM	1715171451.36145	0
	system	SYSTEM	system.migration.done	112	1	2024-05-08 12:30:51.487693+00	{"name": "projections.personal_access_tokens3"}	system	SYSTEM	1715171451.48771	0
	system	SYSTEM	system.migration.started	113	1	2024-05-08 12:30:51.503748+00	{"name": "projections.user_grants5"}	system	SYSTEM	1715171451.50376	0
	system	SYSTEM	system.migration.done	114	1	2024-05-08 12:30:51.630874+00	{"name": "projections.user_grants5"}	system	SYSTEM	1715171451.63089	0
	system	SYSTEM	system.migration.started	115	1	2024-05-08 12:30:51.643086+00	{"name": "projections.user_metadata5"}	system	SYSTEM	1715171451.6431	0
	system	SYSTEM	system.migration.done	116	1	2024-05-08 12:30:51.772958+00	{"name": "projections.user_metadata5"}	system	SYSTEM	1715171451.77299	0
	system	SYSTEM	system.migration.started	117	1	2024-05-08 12:30:51.791167+00	{"name": "projections.user_auth_methods4"}	system	SYSTEM	1715171451.79119	0
	system	SYSTEM	system.migration.done	118	1	2024-05-08 12:30:51.920407+00	{"name": "projections.user_auth_methods4"}	system	SYSTEM	1715171451.92043	0
	system	SYSTEM	system.migration.started	119	1	2024-05-08 12:30:51.937198+00	{"name": "projections.instances"}	system	SYSTEM	1715171451.93721	0
	system	SYSTEM	system.migration.done	120	1	2024-05-08 12:30:52.062147+00	{"name": "projections.instances"}	system	SYSTEM	1715171452.06216	0
	system	SYSTEM	system.migration.started	121	1	2024-05-08 12:30:52.075061+00	{"name": "projections.secret_generators2"}	system	SYSTEM	1715171452.07507	0
	system	SYSTEM	system.migration.done	122	1	2024-05-08 12:30:52.20487+00	{"name": "projections.secret_generators2"}	system	SYSTEM	1715171452.20489	0
	system	SYSTEM	system.migration.started	123	1	2024-05-08 12:30:52.223299+00	{"name": "projections.smtp_configs2"}	system	SYSTEM	1715171452.22331	0
	system	SYSTEM	system.migration.done	124	1	2024-05-08 12:30:52.356906+00	{"name": "projections.smtp_configs2"}	system	SYSTEM	1715171452.35693	0
	system	SYSTEM	system.migration.started	125	1	2024-05-08 12:30:52.375334+00	{"name": "projections.sms_configs2"}	system	SYSTEM	1715171452.37535	0
	system	SYSTEM	system.migration.done	126	1	2024-05-08 12:30:52.50857+00	{"name": "projections.sms_configs2"}	system	SYSTEM	1715171452.50859	0
	system	SYSTEM	system.migration.started	127	1	2024-05-08 12:30:52.52646+00	{"name": "projections.oidc_settings2"}	system	SYSTEM	1715171452.52648	0
	system	SYSTEM	system.migration.done	128	1	2024-05-08 12:30:52.658561+00	{"name": "projections.oidc_settings2"}	system	SYSTEM	1715171452.65858	0
	system	SYSTEM	system.migration.started	129	1	2024-05-08 12:30:52.675273+00	{"name": "projections.notification_providers"}	system	SYSTEM	1715171452.67529	0
	system	SYSTEM	system.migration.done	130	1	2024-05-08 12:30:52.814047+00	{"name": "projections.notification_providers"}	system	SYSTEM	1715171452.81408	0
	system	SYSTEM	system.migration.started	131	1	2024-05-08 12:30:52.833179+00	{"name": "projections.keys4"}	system	SYSTEM	1715171452.83319	0
	system	SYSTEM	system.migration.done	132	1	2024-05-08 12:30:52.965374+00	{"name": "projections.keys4"}	system	SYSTEM	1715171452.9654	0
	system	SYSTEM	system.migration.started	133	1	2024-05-08 12:30:52.983786+00	{"name": "projections.security_policies2"}	system	SYSTEM	1715171452.9838	0
	system	SYSTEM	system.migration.done	134	1	2024-05-08 12:30:53.116802+00	{"name": "projections.security_policies2"}	system	SYSTEM	1715171453.11682	0
	system	SYSTEM	system.migration.started	135	1	2024-05-08 12:30:53.135813+00	{"name": "projections.notification_policies"}	system	SYSTEM	1715171453.13584	0
	system	SYSTEM	system.migration.done	136	1	2024-05-08 12:30:53.26902+00	{"name": "projections.notification_policies"}	system	SYSTEM	1715171453.26905	0
	system	SYSTEM	system.migration.started	137	1	2024-05-08 12:30:53.286384+00	{"name": "projections.device_auth_requests2"}	system	SYSTEM	1715171453.2864	0
	system	SYSTEM	system.migration.done	138	1	2024-05-08 12:30:53.416025+00	{"name": "projections.device_auth_requests2"}	system	SYSTEM	1715171453.41605	0
	system	SYSTEM	system.migration.started	139	1	2024-05-08 12:30:53.432715+00	{"name": "projections.sessions8"}	system	SYSTEM	1715171453.43273	0
	system	SYSTEM	system.migration.done	140	1	2024-05-08 12:30:53.580776+00	{"name": "projections.sessions8"}	system	SYSTEM	1715171453.5808	0
	system	SYSTEM	system.migration.started	141	1	2024-05-08 12:30:53.597883+00	{"name": "projections.auth_requests"}	system	SYSTEM	1715171453.5979	0
	system	SYSTEM	system.migration.done	142	1	2024-05-08 12:30:53.726037+00	{"name": "projections.auth_requests"}	system	SYSTEM	1715171453.72606	0
	system	SYSTEM	system.migration.started	143	1	2024-05-08 12:30:53.743765+00	{"name": "projections.milestones"}	system	SYSTEM	1715171453.7438	0
	system	SYSTEM	system.migration.done	144	1	2024-05-08 12:30:53.875446+00	{"name": "projections.milestones"}	system	SYSTEM	1715171453.87547	0
	system	SYSTEM	system.migration.started	145	1	2024-05-08 12:30:53.890585+00	{"name": "projections.quotas"}	system	SYSTEM	1715171453.8906	0
	system	SYSTEM	system.migration.done	146	1	2024-05-08 12:30:54.022951+00	{"name": "projections.quotas"}	system	SYSTEM	1715171454.02297	0
	system	SYSTEM	system.migration.started	147	1	2024-05-08 12:30:54.041377+00	{"name": "projections.limits"}	system	SYSTEM	1715171454.0414	0
	system	SYSTEM	system.migration.done	148	1	2024-05-08 12:30:54.173374+00	{"name": "projections.limits"}	system	SYSTEM	1715171454.17339	0
	system	SYSTEM	system.migration.started	149	1	2024-05-08 12:30:54.190991+00	{"name": "projections.restrictions2"}	system	SYSTEM	1715171454.191	0
	system	SYSTEM	system.migration.done	150	1	2024-05-08 12:30:54.323074+00	{"name": "projections.restrictions2"}	system	SYSTEM	1715171454.32309	0
	system	SYSTEM	system.migration.started	151	1	2024-05-08 12:30:54.341455+00	{"name": "projections.system_features"}	system	SYSTEM	1715171454.34147	0
	system	SYSTEM	system.migration.done	152	1	2024-05-08 12:30:54.470092+00	{"name": "projections.system_features"}	system	SYSTEM	1715171454.47011	0
	system	SYSTEM	system.migration.started	153	1	2024-05-08 12:30:54.490916+00	{"name": "projections.instance_features2"}	system	SYSTEM	1715171454.49093	0
	system	SYSTEM	system.migration.done	154	1	2024-05-08 12:30:54.61691+00	{"name": "projections.instance_features2"}	system	SYSTEM	1715171454.61693	0
	system	SYSTEM	system.migration.started	155	1	2024-05-08 12:30:54.627275+00	{"name": "projections.executions"}	system	SYSTEM	1715171454.62729	0
	system	SYSTEM	system.migration.done	156	1	2024-05-08 12:30:54.751711+00	{"name": "projections.executions"}	system	SYSTEM	1715171454.75173	0
	system	SYSTEM	system.migration.started	157	1	2024-05-08 12:30:54.765464+00	{"name": "projections.targets"}	system	SYSTEM	1715171454.76548	0
	system	SYSTEM	system.migration.done	158	1	2024-05-08 12:30:54.892156+00	{"name": "projections.targets"}	system	SYSTEM	1715171454.89217	0
	system	SYSTEM	system.migration.started	159	1	2024-05-08 12:30:54.904554+00	{"name": "projections.user_schemas"}	system	SYSTEM	1715171454.90457	0
	system	SYSTEM	system.migration.done	160	1	2024-05-08 12:30:55.029705+00	{"name": "projections.user_schemas"}	system	SYSTEM	1715171455.02972	0
	system	SYSTEM	system.migration.started	161	1	2024-05-08 12:30:55.044002+00	{"name": "adminapi.styling2"}	system	SYSTEM	1715171455.04401	0
	system	SYSTEM	system.migration.done	162	1	2024-05-08 12:30:55.064065+00	{"name": "adminapi.styling2"}	system	SYSTEM	1715171455.06407	0
	system	SYSTEM	system.migration.started	163	1	2024-05-08 12:30:55.076548+00	{"name": "auth.users2"}	system	SYSTEM	1715171455.07656	0
	system	SYSTEM	system.migration.done	164	1	2024-05-08 12:30:55.097652+00	{"name": "auth.users2"}	system	SYSTEM	1715171455.09766	0
	system	SYSTEM	system.migration.started	165	1	2024-05-08 12:30:55.108036+00	{"name": "auth.user_sessions"}	system	SYSTEM	1715171455.10805	0
	system	SYSTEM	system.migration.done	166	1	2024-05-08 12:30:55.127018+00	{"name": "auth.user_sessions"}	system	SYSTEM	1715171455.12703	0
	system	SYSTEM	system.migration.started	167	1	2024-05-08 12:30:55.137119+00	{"name": "auth.tokens"}	system	SYSTEM	1715171455.13713	0
	system	SYSTEM	system.migration.done	168	1	2024-05-08 12:30:55.156089+00	{"name": "auth.tokens"}	system	SYSTEM	1715171455.1561	0
	system	SYSTEM	system.migration.started	169	1	2024-05-08 12:30:55.1657+00	{"name": "auth.refresh_tokens"}	system	SYSTEM	1715171455.16571	0
	system	SYSTEM	system.migration.done	170	1	2024-05-08 12:30:55.185156+00	{"name": "auth.refresh_tokens"}	system	SYSTEM	1715171455.18517	0
	system	SYSTEM	system.migration.started	171	1	2024-05-08 12:30:55.196868+00	{"name": "projections.notifications"}	system	SYSTEM	1715171455.19688	0
	system	SYSTEM	system.migration.done	172	1	2024-05-08 12:30:56.230492+00	{"name": "projections.notifications"}	system	SYSTEM	1715171456.23057	0
	system	SYSTEM	system.migration.started	173	1	2024-05-08 12:30:56.25538+00	{"name": "projections.notifications_quota"}	system	SYSTEM	1715171456.2554	0
	system	SYSTEM	system.migration.done	174	1	2024-05-08 12:30:57.294451+00	{"name": "projections.notifications_quota"}	system	SYSTEM	1715171457.29448	0
266108224564887557	user	266108224565018629	user.token.added	7	2	2024-05-08 12:31:00.396532+00	{"reason": "auth_request", "scopes": ["openid", "profile", "email"], "tokenId": "266213247286247433", "audience": ["266108227433791493@zitadel", "266108227450568709@zitadel", "266108227467345925@zitadel", "266108227467411461@zitadel", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T00:31:00.39153501Z", "userAgentId": "266108240469688325", "applicationId": "266108227467411461@zitadel", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715171460.39655	0
266108224564887557	key_pair	266213247571460105	key_pair.added	1	1	2024-05-08 12:31:00.570953+00	{"usage": 0, "algorithm": "RS256", "publicKey": {"key": {"KeyID": "oidcKey", "Crypted": "WvSbHjam0MCb1A5zX3CUxGrBQIgx39gtdq9EPhJ5MEgUHIvzOV1LuthB/BKrYlFkkI17tYxykeweO0V+fMlwVDxMMAEibTj3I6zjKLPiSPVE4TaFcvpfRq/aaTA2jtJeWHV9pBqKznqFQDoQr50TJU5fQRhNL7gP1nrPhqaK7aKHYpu3uBNnnC4ePxNCdDm0qY+Om0KhNknNAxzoonDOIdkUy9MEH9T9UYgC2x2fjr2P4/a9RRysydsDqJ54zeAaAmF9242yTa6IRBK9ETNsupXztqewGckgyMikLJADKAw495Q2SlFRx2Ha6v2WepldjWfxCql/tzoHOOqdnFWN8k+zxkJW+y+Soq+3jr4Lnjka5j7hsOJ4ntvRZYrhzJ1RrV+AJPFUqHvbNdSjGcGGsA+vRrFLy4b6/C73djrXnauiU7poLYFq+3pfHfW7NolTaLbNH6LTxnw/ifphMIr3BhnOsQXA8sOaWL2uDZCMiYIogN45DZcPr2dgJDjsqu268a87Qa1Cm5LJnGAILqWW7sT8L8l/p2Yny19mJ+JK53GR8QZqohGt2dLDwlKLVYFvK9XDi+7LbYuLLIfs9sP4q0eHO2TAapP9TlTi70ilkve57Qdk6RAmF1HLHA==", "Algorithm": "aes", "CryptoType": 0}, "expiry": "2024-05-09T18:31:00.564521052Z"}, "privateKey": {"key": {"KeyID": "oidcKey", "Crypted": "YRpaaksRKMt58gjdyGBmUgLj52+4v61iy/mi8DOG5fchmxgectYuYPUn5T+S6rWkLT1D47GphaB/5w71QySjYxVENQDtGWdPn8hh/IFeWu+TesrX0lv/Fdh8yHMF5niUutwKL/BrgJMptjr3yVnKQrylNmgkea44YsBIZqBmzHlb3vYd+PNuOK6l+ZuRax6Yvn/7P/AvhBDxQrKVfse2cuBzDN1b3ri4nEdCJcZtCWLeHFAyB/aVa0esnVzrke4Siqnf2bn/JdrTLDckzM9SPgFi0Z4rVugExfYaQasEXwNh61xwlcbgg5tCXA/Rt0qyYNW8JF5AMWjl6HuDueJEB2+T0GEwSQZ6pQQGk9cW1evpcK28Y/ED0OPz9AmIOfCDmmD+x6xcUJOl1S7f3eqm2DiskKy9Y7ZQhHLM3lbU8c5Y2mhbykODSr+BXeofWiaZefZpmcNMkMC1N+Fy6vheNvXTG02bFM0s2TWs3BbZZ32oLD0DvxI9e/EtJkTNgPiztzEi9N77bNkHTMIjkICqQ4VEgjkudYehkKMw5Iuigd/BVARQXCL2LC8l5CVENU3R0VsnXv+14y4YxrvHQZTCKqZqqge2kJmD705ywqTKYS2lmszM7/VZaz7yZGKhGsuYvVpow6lnokQ1NgL7ywQo+Pk5l4fXV3XSS4+KJ2os8EBbiddGIFhUMaeN1upHxkfnu3oFOSvwE/ba4V4mPydiwyrd7f4A1+lf11W2iUSCUte1GohDNsaPvdwfwkxcchx1Mpz9J/EdJV3MPR6k5yJxlEga5SwANtop4JnMfHNPKd0JfN/84gpupm04bCA68GECdkhwBJ1+DfSAb/dVQ9sRnAWImgdvkzRGKqGfhG3IP+GQDVQ1XeGo8QWgvObJTX3jOpLh92V4MQZMkjiEmHhcNAS/me5ufuoXwjcNktwEhtvXqoy1d/IzU994TsMZDtDOdw9hv9LxToJ3qcyrP3XF8N0GyrH5AEB7PbKk8YpMipWG5I2WihHrcYI0VJ4uVoDa0ubEt3+MVVcl5rWnAkhrUcR0fLxx+PefMfSeABPrmH8d9xZ0IZ73QHGgu/2PqAlziWn5Scl3GHLBk4tOnBLV9iA7YKXSjSsZUAQT9hj1BnoM8FkwHlUD+5Q6wfziWvcGmNkzkHMCohd/oUzwhzXRjoLBPS66urFVVPciWgEjown892vn7Lh+Gs8Puv6oOkVMGKW3rTaMqXNnPani+rSVG7fnYBSk/AohH7QwnZHnJSPz6s93vf1vx35b0O9ywRzIg7IF8LoxvyzHLn/FMl3VKj2satBmciNBU2EnUcIMcSvQHF3vgmG9amJDN1Z/MxreGdUWqUauRKwfHGxi7zfKbBEp5ukzRlmVD7VkVsg4UOCprOlyLjjCfS3VxWQ49P9QR6bb1LSR8fU6Yfc5SOrxLyclfn3tEjKbKlTMW9pw7cO6qRvOitdhHZ1yvE5nBBpkrDqNw6jb03y0KHscYMrQRpAUgcUDRL1NIjm5l8/w5em0/Gw58lVGLsALBHcMhn8qkPh19wwnh3xAG2Ihc2GOW2ELjG1MG3hybtI51S3l1AAu8LlZtvwARWqNBzbSYEi0HNrdT+jleDvnhoAd8HBAO86PD5z9okjDSWinunWe6KSMHGqaHmfHgTRDWaug0uYWki8X+xUMHn+1P6BzlFtpVKD2qTDBamRtc5eIbzAVo/b4e/5slyk4vNSdFSp/nyBAIZconOjTxWLhPSms+fo6Iyg54oKrRHht1vlNie91cla6SBb0CHBV+bz5KhbnYAJRu8i/qwbuzk6IrWKdJIJ7sPbTQ+zLX6nZfuIWhtIVWkIpRpo71PkvyBl84whb6cXtrfolysKAU0QilGSKBPx6sdj48CdE56XEAgXJwNRU7GrUK7pd/npuPtKHhw+gvqTJAOBpwtB6jrnh7Ea2rLPeySqZ1GxtZyOerL9JkYeOVJqo8Okh6jd4woK5Hl8I/pnnN2g4/RPW7Ht+LAcrTC9P4t94+DXUeQqCwyL2Noqj2U+RhfzMjpN3k76QVO77jSIxcESXnZEzo7Nn+SsdadkE0mYUrGxr2O044mEpo9rM1kf4Fl/he9mvc4oRRXcJh/1+0x71gUBkp75yEHL9InbkUNq9CFmiF9ZP54wNVg5rK2IFyNuRF/IcO5V+RGQAa1XM0u7+TNDQiXErJ7QFT6RCJyanloY1pC+I1tTwkhBceXYDz8FF3agsizHphj3BJLojR+57xe0WQ9l57czF5ZHX", "Algorithm": "aes", "CryptoType": 0}, "expiry": "2024-05-08T18:31:00.564520635Z"}}	OIDC	266108224564887557	1715171460.57097	0
266108224564887557	project	266108518786924549	project.application.changed	5	1	2024-05-08 12:31:42.557376+00	{"name": "Charts", "appId": "266108631362043909"}	266108224565018629	266108224564953093	1715171502.55739	0
266108224564887557	user	266108224565018629	user.token.added	8	2	2024-05-08 12:52:11.847514+00	{"reason": "auth_request", "scopes": ["openid", "profile", "email"], "tokenId": "266215380425375753", "audience": ["266108227433791493@zitadel", "266108227450568709@zitadel", "266108227467345925@zitadel", "266108227467411461@zitadel", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T00:52:11.841681043Z", "userAgentId": "266108240469688325", "applicationId": "266108227467411461@zitadel", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715172731.84754	0
266108224564887557	project	266108518786924549	project.application.config.oidc.secret.changed	6	1	2024-05-08 12:59:22.929721+00	{"appId": "266108631362043909", "hashedSecret": "$2a$04$hj9HToX8AvKmTVtCMBj19.DNOoB46X1C2h/GdxPgo46KhEWRC.pXW"}	266108224565018629	266108224564953093	1715173162.92973	0
266108224564887557	project	266108518786924549	project.application.config.oidc.changed	7	1	2024-05-08 13:01:39.437561+00	{"appId": "266108631362043909", "redirectUris": ["http://localhost:8000/api/auth/callback"]}	266108224565018629	266108224564953093	1715173299.43757	0
266108224564887557	user	266216654839480329	user.machine.added	1	2	2024-05-08 13:04:51.472661+00	{"name": "chards", "userName": "chars", "description": "chars"}	266108224565018629	266108224564953093	1715173491.47267	0
266108224564887557	user	266216654839480329	user.machine.secret.set	2	2	2024-05-08 13:05:02.655436+00	{"hashedSecret": "$2a$04$OENb5nLna6f4H1s.rLbT/.WMpzgq8wviu/D2dIp8ti6rlPEOKgK0O"}	266108224565018629	266108224564953093	1715173502.65545	0
266108224564887557	user	266216654839480329	user.machine.secret.check.succeeded	3	2	2024-05-08 13:05:51.025082+00	{}		266108224564953093	1715173551.0251	0
266108224564887557	user	266216654839480329	user.token.added	4	2	2024-05-08 13:05:51.048311+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266216754814910473", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:05:51.042410422Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715173551.04832	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	8	1	2024-05-08 13:06:07.708302+00	{"appId": "266108631362043909"}		266108224564953093	1715173567.70832	0
266108224564887557	user	266108224565018629	user.token.added	9	2	2024-05-08 13:08:03.073131+00	{"reason": "auth_request", "scopes": ["openid", "profile", "email"], "tokenId": "266216976307716105", "audience": ["266108227433791493@zitadel", "266108227450568709@zitadel", "266108227467345925@zitadel", "266108227467411461@zitadel", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:08:03.066719553Z", "userAgentId": "266108240469688325", "applicationId": "266108227467411461@zitadel", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715173683.07315	0
266108224564887557	project	266108518786924549	project.application.config.oidc.changed	9	1	2024-05-08 13:08:50.827957+00	{"appId": "266108631362043909", "redirectUris": ["http://localhost:3030/api/auth/callback"], "postLogoutRedirectUris": ["http://localhost:3030/api/auth"]}	266108224565018629	266108224564953093	1715173730.82798	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	10	1	2024-05-08 13:09:26.021006+00	{"appId": "266108631362043909"}		266108224564953093	1715173766.02102	0
266108224564887557	user	266108224565018629	user.token.added	10	2	2024-05-08 13:09:26.147+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266217115692826633", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:09:26.141893425Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715173766.14701	0
266108224564887557	user	266216654839480329	user.machine.secret.check.succeeded	5	2	2024-05-08 13:09:26.311487+00	{}		266108224564953093	1715173766.31151	0
266108224564887557	user	266216654839480329	user.token.added	6	2	2024-05-08 13:09:26.332267+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266217115994816521", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:09:26.327197675Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715173766.33228	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	11	1	2024-05-08 13:09:26.363595+00	{"appId": "266108631362043909"}		266108224564953093	1715173766.36361	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	12	1	2024-05-08 13:09:27.179231+00	{"appId": "266108631362043909"}		266108224564953093	1715173767.17925	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	510	1	2024-05-08 14:47:25.750237+00	{"appId": "266108631362043909"}		266108224564953093	1715179645.75025	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	13	1	2024-05-08 13:09:27.188922+00	{"appId": "266108631362043909"}		266108224564953093	1715173767.18893	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	14	1	2024-05-08 13:09:29.273022+00	{"appId": "266108631362043909"}		266108224564953093	1715173769.27304	0
266108224564887557	project	266108518786924549	project.application.config.oidc.changed	15	1	2024-05-08 13:09:57.997448+00	{"appId": "266108631362043909", "grantTypes": [0, 2]}	266108224565018629	266108224564953093	1715173797.99747	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	16	1	2024-05-08 13:10:00.317518+00	{"appId": "266108631362043909"}		266108224564953093	1715173800.31754	0
266108224564887557	project	266108518786924549	project.application.config.oidc.changed	17	1	2024-05-08 13:10:23.956371+00	{"appId": "266108631362043909", "postLogoutRedirectUris": ["http://localhost:3030/auth"]}	266108224565018629	266108224564953093	1715173823.95639	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	18	1	2024-05-08 13:10:29.946381+00	{"appId": "266108631362043909"}		266108224564953093	1715173829.94639	0
266108224564887557	user	266108224565018629	user.token.added	11	2	2024-05-08 13:10:30.068312+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266217222932791305", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:10:30.063230676Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266217222916014089", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715173830.06833	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	12	2	2024-05-08 13:10:30.068312+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266217222916014089", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-07T19:09:37.544038Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715173830.06849	1
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	19	1	2024-05-08 13:10:30.208723+00	{"appId": "266108631362043909"}		266108224564953093	1715173830.20874	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	20	1	2024-05-08 13:10:30.910726+00	{"appId": "266108631362043909"}		266108224564953093	1715173830.91074	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	534	1	2024-05-08 14:49:14.565441+00	{"appId": "266108631362043909"}		266108224564953093	1715179754.56545	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	21	1	2024-05-08 13:10:30.920227+00	{"appId": "266108631362043909"}		266108224564953093	1715173830.92024	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	22	1	2024-05-08 13:10:42.955816+00	{"appId": "266108631362043909"}		266108224564953093	1715173842.95583	0
266108224564887557	user	266108224565018629	user.human.signed.out	13	2	2024-05-08 13:10:56.034705+00	{"userAgentID": "266108240469688325"}		266108224564953093	1715173856.03472	0
266108224564887557	user	266108224565018629	user.human.password.check.failed	14	2	2024-05-08 13:11:01.993706+00	{"id": "266217266603884553", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715173861.99373	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	15	2	2024-05-08 13:11:16.774936+00	{"id": "266217266603884553", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715173876.77495	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	23	1	2024-05-08 13:11:17.10677+00	{"appId": "266108631362043909"}		266108224564953093	1715173877.10678	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	37	1	2024-05-08 13:21:46.670609+00	{"appId": "266108631362043909"}		266108224564953093	1715174506.67062	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	38	1	2024-05-08 13:32:21.933721+00	{"appId": "266108631362043909"}		266108224564953093	1715175141.93374	0
266108224564887557	user	266108224565018629	user.token.added	16	2	2024-05-08 13:11:17.226143+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266217302054141961", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:11:17.221537837Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266217302037364745", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715173877.22616	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	17	2	2024-05-08 13:11:17.226143+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266217302037364745", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-08T13:11:16.774936Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715173877.22645	1
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	24	1	2024-05-08 13:11:17.36092+00	{"appId": "266108631362043909"}		266108224564953093	1715173877.36093	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	25	1	2024-05-08 13:11:17.723722+00	{"appId": "266108631362043909"}		266108224564953093	1715173877.72374	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	511	1	2024-05-08 14:47:39.707657+00	{"appId": "266108631362043909"}		266108224564953093	1715179659.70767	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	26	1	2024-05-08 13:11:17.736167+00	{"appId": "266108631362043909"}		266108224564953093	1715173877.73618	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	27	1	2024-05-08 13:11:40.144504+00	{"appId": "266108631362043909"}		266108224564953093	1715173900.14452	0
266108224564887557	user	266108224565018629	user.human.signed.out	18	2	2024-05-08 13:14:12.94237+00	{"userAgentID": "266108240469688325"}		266108224564953093	1715174052.94238	0
266108224564887557	user	266108224565018629	user.human.password.check.failed	19	2	2024-05-08 13:15:24.182488+00	{"id": "266217596947267593", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715174124.18251	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	20	2	2024-05-08 13:15:54.931105+00	{"id": "266217596947267593", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715174154.93112	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	28	1	2024-05-08 13:15:55.268637+00	{"appId": "266108631362043909"}		266108224564953093	1715174155.26865	0
266108224564887557	user	266108224565018629	user.token.added	21	2	2024-05-08 13:15:55.394158+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266217768729182217", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:15:55.388154383Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266217768712405001", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715174155.39418	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	22	2	2024-05-08 13:15:55.394158+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266217768712405001", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-08T13:15:54.931105Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715174155.39651	1
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	29	1	2024-05-08 13:15:55.533994+00	{"appId": "266108631362043909"}		266108224564953093	1715174155.53401	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	30	1	2024-05-08 13:15:56.206931+00	{"appId": "266108631362043909"}		266108224564953093	1715174156.20694	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	31	1	2024-05-08 13:15:56.210105+00	{"appId": "266108631362043909"}		266108224564953093	1715174156.21011	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	32	1	2024-05-08 13:15:59.743201+00	{"appId": "266108631362043909"}		266108224564953093	1715174159.74322	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	33	1	2024-05-08 13:16:00.334935+00	{"appId": "266108631362043909"}		266108224564953093	1715174160.33496	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	21	2	2024-05-08 14:50:05.607098+00	{}		266108224564953093	1715179805.60712	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	34	1	2024-05-08 13:16:00.345416+00	{"appId": "266108631362043909"}		266108224564953093	1715174160.34543	0
266108224564887557	user	266216654839480329	user.machine.secret.check.succeeded	7	2	2024-05-08 13:21:05.155912+00	{}		266108224564953093	1715174465.15594	0
266108224564887557	user	266216654839480329	user.token.added	8	2	2024-05-08 13:21:05.177409+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266218288470556681", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:21:05.171382137Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715174465.17742	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	35	1	2024-05-08 13:21:05.219263+00	{"appId": "266108631362043909"}		266108224564953093	1715174465.21928	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	36	1	2024-05-08 13:21:46.658462+00	{"appId": "266108631362043909"}		266108224564953093	1715174506.65848	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	553	1	2024-05-08 15:38:47.102271+00	{"appId": "266108631362043909"}		266108224564953093	1715182727.10229	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	39	1	2024-05-08 13:32:21.937821+00	{"appId": "266108631362043909"}		266108224564953093	1715175141.93783	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	512	1	2024-05-08 14:47:39.956726+00	{"appId": "266108631362043909"}		266108224564953093	1715179659.95677	0
266108224564887557	user	266219708343123977	user.token.added	22	2	2024-05-08 14:50:05.630545+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266227248258875401", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:50:05.624605967Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715179805.63056	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	40	1	2024-05-08 13:32:21.952648+00	{"appId": "266108631362043909"}		266108224564953093	1715175141.95266	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	576	1	2024-05-08 15:39:23.4462+00	{"appId": "266108631362043909"}		266108224564953093	1715182763.44621	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	41	1	2024-05-08 13:32:21.960449+00	{"appId": "266108631362043909"}		266108224564953093	1715175141.96046	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	42	1	2024-05-08 13:32:21.968223+00	{"appId": "266108631362043909"}		266108224564953093	1715175141.96823	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	43	1	2024-05-08 13:32:23.90974+00	{"appId": "266108631362043909"}		266108224564953093	1715175143.90976	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	44	1	2024-05-08 13:32:24.186699+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.18672	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	45	1	2024-05-08 13:32:24.242941+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.24296	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	46	1	2024-05-08 13:32:24.249307+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.24933	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	47	1	2024-05-08 13:32:24.258511+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.25852	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	48	1	2024-05-08 13:32:24.264283+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.26429	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	49	1	2024-05-08 13:32:24.269735+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.26974	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	50	1	2024-05-08 13:32:24.280195+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.28021	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	51	1	2024-05-08 13:32:24.962896+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.96291	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	52	1	2024-05-08 13:32:24.974292+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.9743	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	53	1	2024-05-08 13:32:24.984106+00	{"appId": "266108631362043909"}		266108224564953093	1715175144.98412	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	54	1	2024-05-08 13:32:25.004182+00	{"appId": "266108631362043909"}		266108224564953093	1715175145.0042	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	55	1	2024-05-08 13:32:25.223387+00	{"appId": "266108631362043909"}		266108224564953093	1715175145.22341	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	56	1	2024-05-08 13:32:25.329833+00	{"appId": "266108631362043909"}		266108224564953093	1715175145.32986	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	57	1	2024-05-08 13:32:25.347073+00	{"appId": "266108631362043909"}		266108224564953093	1715175145.34709	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	58	1	2024-05-08 13:32:25.403332+00	{"appId": "266108631362043909"}		266108224564953093	1715175145.40335	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	59	1	2024-05-08 13:32:50.067337+00	{"appId": "266108631362043909"}		266108224564953093	1715175170.06735	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	60	1	2024-05-08 13:32:50.07058+00	{"appId": "266108631362043909"}		266108224564953093	1715175170.07059	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	61	1	2024-05-08 13:32:50.081556+00	{"appId": "266108631362043909"}		266108224564953093	1715175170.08157	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	62	1	2024-05-08 13:32:50.093108+00	{"appId": "266108631362043909"}		266108224564953093	1715175170.09312	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	63	1	2024-05-08 13:32:51.303546+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.30356	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	513	1	2024-05-08 14:47:39.960644+00	{"appId": "266108631362043909"}		266108224564953093	1715179659.96066	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	64	1	2024-05-08 13:32:51.314502+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.31451	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	535	1	2024-05-08 14:50:05.665788+00	{"appId": "266108631362043909"}		266108224564953093	1715179805.6658	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	65	1	2024-05-08 13:32:51.317989+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.318	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	554	1	2024-05-08 15:38:47.112162+00	{"appId": "266108631362043909"}		266108224564953093	1715182727.11218	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	66	1	2024-05-08 13:32:51.326235+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.32625	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	67	1	2024-05-08 13:32:51.338792+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.33883	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	68	1	2024-05-08 13:32:51.343561+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.34358	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	69	1	2024-05-08 13:32:51.726272+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.72629	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	70	1	2024-05-08 13:32:51.746359+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.74638	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	71	1	2024-05-08 13:32:51.834887+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.8349	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	72	1	2024-05-08 13:32:51.85235+00	{"appId": "266108631362043909"}		266108224564953093	1715175171.85236	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	73	1	2024-05-08 13:32:52.077704+00	{"appId": "266108631362043909"}		266108224564953093	1715175172.07772	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	74	1	2024-05-08 13:32:52.090953+00	{"appId": "266108631362043909"}		266108224564953093	1715175172.09097	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	75	1	2024-05-08 13:32:52.150374+00	{"appId": "266108631362043909"}		266108224564953093	1715175172.15039	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	76	1	2024-05-08 13:32:52.19108+00	{"appId": "266108631362043909"}		266108224564953093	1715175172.1911	0
266108224564887557	user	266108224565018629	user.token.added	23	2	2024-05-08 13:34:15.851823+00	{"reason": "auth_request", "scopes": ["openid", "profile", "email"], "tokenId": "266219614994694153", "audience": ["266108227433791493@zitadel", "266108227450568709@zitadel", "266108227467345925@zitadel", "266108227467411461@zitadel", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:34:15.846686003Z", "userAgentId": "266108240469688325", "applicationId": "266108227467411461@zitadel", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715175255.85185	0
266108224564887557	user	266216654839480329	user.removed	9	2	2024-05-08 13:35:00.471164+00	\N	266108224565018629	266108224564953093	1715175300.47118	0
266108224564887557	user	266219708343123977	user.machine.added	1	2	2024-05-08 13:35:11.508041+00	{"name": "charts", "userName": "charts", "description": "charts"}	266108224565018629	266108224564953093	1715175311.50805	0
266108224564887557	user	266219708343123977	user.machine.secret.set	2	2	2024-05-08 13:35:16.001532+00	{"hashedSecret": "$2a$04$.YNY0DXBc8L9nDRA0vbJou34AAqsJRz/42/hMzUMFl7OOknVSuHtm"}	266108224565018629	266108224564953093	1715175316.00155	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	3	2	2024-05-08 13:36:42.890272+00	{}		266108224564953093	1715175402.89029	0
266108224564887557	user	266219708343123977	user.token.added	4	2	2024-05-08 13:36:42.913339+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266219861720432649", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:36:42.907549835Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715175402.91336	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	77	1	2024-05-08 13:36:42.953975+00	{"appId": "266108631362043909"}		266108224564953093	1715175402.95399	0
266108224564887557	user	266108224565018629	user.human.signed.out	24	2	2024-05-08 13:36:46.360828+00	{"userAgentID": "266108240469688325"}		266108224564953093	1715175406.36084	0
266108224564887557	user	266108224565018629	user.human.password.check.failed	25	2	2024-05-08 13:36:55.701331+00	{"id": "266219867609235465", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715175415.70134	0
266108224564887557	user	266108224565018629	user.human.password.check.failed	26	2	2024-05-08 13:37:13.716318+00	{"id": "266219867609235465", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715175433.71633	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	89	1	2024-05-08 13:40:23.641812+00	{"appId": "266108631362043909"}		266108224564953093	1715175623.64183	0
266108224564887557	user	266108224565018629	user.human.password.code.added	27	2	2024-05-08 13:38:23.553067+00	{"code": {"KeyID": "userKey", "Crypted": "RzIYSea/3sh/jSwSVQ3PegriBmfAWQ==", "Algorithm": "aes", "CryptoType": 0}, "expiry": 3600000000000, "authRequestID": "266219867609235465", "triggerOrigin": "http://localhost:8085"}	LOGIN	266108224564953093	1715175503.55308	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	28	2	2024-05-08 13:38:40.671626+00	{"id": "266219867609235465", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715175520.67164	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	78	1	2024-05-08 13:38:41.017806+00	{"appId": "266108631362043909"}		266108224564953093	1715175521.01782	0
266108224564887557	user	266108224565018629	user.token.added	29	2	2024-05-08 13:38:41.137702+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266220060077457417", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:38:41.132853251Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266220060060680201", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715175521.13772	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	30	2	2024-05-08 13:38:41.137702+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266220060060680201", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-08T13:38:40.671626Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715175521.1379	1
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	79	1	2024-05-08 13:38:41.276145+00	{"appId": "266108631362043909"}		266108224564953093	1715175521.27616	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	80	1	2024-05-08 13:38:42.005667+00	{"appId": "266108631362043909"}		266108224564953093	1715175522.00568	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	81	1	2024-05-08 13:38:42.010382+00	{"appId": "266108631362043909"}		266108224564953093	1715175522.01039	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	82	1	2024-05-08 13:38:47.581972+00	{"appId": "266108631362043909"}		266108224564953093	1715175527.58199	0
266108224564887557	user	266108224565018629	user.token.added	31	2	2024-05-08 13:39:01.727395+00	{"reason": "auth_request", "scopes": ["openid", "profile", "email"], "tokenId": "266220094621745161", "audience": ["266108227433791493@zitadel", "266108227450568709@zitadel", "266108227467345925@zitadel", "266108227467411461@zitadel", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:39:01.722428802Z", "userAgentId": "266108240469688325", "applicationId": "266108227467411461@zitadel", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715175541.72741	0
266108224564887557	user	266108224565018629	user.human.password.changed	32	2	2024-05-08 13:39:50.064303+00	{"encodedHash": "$2a$14$1GJjFXQR4YGh/uk9JrUWR.du7MNDphloanJw2kjgorFMBsOB3MLYe", "triggerOrigin": "http://localhost:8085", "changeRequired": false}	266108224565018629	266108224564953093	1715175590.06432	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	83	1	2024-05-08 13:39:53.909073+00	{"appId": "266108631362043909"}		266108224564953093	1715175593.90909	0
266108224564887557	user	266108224565018629	user.human.signed.out	33	2	2024-05-08 13:39:53.973961+00	{"userAgentID": "266108240469688325"}		266108224564953093	1715175593.97397	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	34	2	2024-05-08 13:40:16.53273+00	{"id": "266220199831666697", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715175616.53275	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	84	1	2024-05-08 13:40:16.867756+00	{"appId": "266108631362043909"}		266108224564953093	1715175616.86777	0
266108224564887557	user	266108224565018629	user.token.added	35	2	2024-05-08 13:40:16.990771+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266220220887072777", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:40:16.985278045Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266220220870295561", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715175616.99079	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	36	2	2024-05-08 13:40:16.990771+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266220220870295561", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-08T13:40:16.53273Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715175616.99097	1
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	85	1	2024-05-08 13:40:17.141341+00	{"appId": "266108631362043909"}		266108224564953093	1715175617.14135	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	86	1	2024-05-08 13:40:17.862689+00	{"appId": "266108631362043909"}		266108224564953093	1715175617.86271	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	87	1	2024-05-08 13:40:17.872306+00	{"appId": "266108631362043909"}		266108224564953093	1715175617.87232	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	88	1	2024-05-08 13:40:22.997671+00	{"appId": "266108631362043909"}		266108224564953093	1715175622.99769	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	514	1	2024-05-08 14:47:39.964501+00	{"appId": "266108631362043909"}		266108224564953093	1715179659.96451	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	90	1	2024-05-08 13:40:23.650879+00	{"appId": "266108631362043909"}		266108224564953093	1715175623.65089	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	91	1	2024-05-08 13:40:30.999476+00	{"appId": "266108631362043909"}		266108224564953093	1715175630.99949	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	536	1	2024-05-08 14:51:26.840377+00	{"appId": "266108631362043909"}		266108224564953093	1715179886.8404	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	555	1	2024-05-08 15:38:47.185168+00	{"appId": "266108631362043909"}		266108224564953093	1715182727.18518	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	577	1	2024-05-08 15:39:23.456285+00	{"appId": "266108631362043909"}		266108224564953093	1715182763.4563	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	92	1	2024-05-08 13:40:31.016141+00	{"appId": "266108631362043909"}		266108224564953093	1715175631.01615	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	93	1	2024-05-08 13:40:31.020783+00	{"appId": "266108631362043909"}		266108224564953093	1715175631.0208	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	94	1	2024-05-08 13:40:31.023143+00	{"appId": "266108631362043909"}		266108224564953093	1715175631.02315	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	95	1	2024-05-08 13:40:31.0354+00	{"appId": "266108631362043909"}		266108224564953093	1715175631.03554	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	96	1	2024-05-08 13:40:43.374798+00	{"appId": "266108631362043909"}		266108224564953093	1715175643.37481	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	97	1	2024-05-08 13:40:43.650023+00	{"appId": "266108631362043909"}		266108224564953093	1715175643.65004	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	98	1	2024-05-08 13:40:43.708637+00	{"appId": "266108631362043909"}		266108224564953093	1715175643.70865	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	99	1	2024-05-08 13:40:43.711765+00	{"appId": "266108631362043909"}		266108224564953093	1715175643.71178	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	100	1	2024-05-08 13:40:43.71889+00	{"appId": "266108631362043909"}		266108224564953093	1715175643.7189	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	101	1	2024-05-08 13:40:43.726235+00	{"appId": "266108631362043909"}		266108224564953093	1715175643.72625	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	102	1	2024-05-08 13:40:43.730144+00	{"appId": "266108631362043909"}		266108224564953093	1715175643.73016	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	103	1	2024-05-08 13:40:43.742699+00	{"appId": "266108631362043909"}		266108224564953093	1715175643.74271	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	104	1	2024-05-08 13:40:44.089051+00	{"appId": "266108631362043909"}		266108224564953093	1715175644.08907	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	105	1	2024-05-08 13:40:44.137329+00	{"appId": "266108631362043909"}		266108224564953093	1715175644.13738	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	106	1	2024-05-08 13:40:44.151027+00	{"appId": "266108631362043909"}		266108224564953093	1715175644.15104	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	107	1	2024-05-08 13:40:44.477788+00	{"appId": "266108631362043909"}		266108224564953093	1715175644.4778	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	108	1	2024-05-08 13:40:44.500812+00	{"appId": "266108631362043909"}		266108224564953093	1715175644.50082	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	109	1	2024-05-08 13:40:44.506612+00	{"appId": "266108631362043909"}		266108224564953093	1715175644.50663	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	110	1	2024-05-08 13:40:44.56085+00	{"appId": "266108631362043909"}		266108224564953093	1715175644.56086	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	111	1	2024-05-08 13:40:44.59093+00	{"appId": "266108631362043909"}		266108224564953093	1715175644.59095	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	112	1	2024-05-08 13:41:22.874226+00	{"appId": "266108631362043909"}		266108224564953093	1715175682.87424	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	113	1	2024-05-08 13:41:22.877758+00	{"appId": "266108631362043909"}		266108224564953093	1715175682.87777	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	114	1	2024-05-08 13:41:22.885924+00	{"appId": "266108631362043909"}		266108224564953093	1715175682.88597	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	115	1	2024-05-08 13:41:22.890062+00	{"appId": "266108631362043909"}		266108224564953093	1715175682.89007	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	116	1	2024-05-08 13:41:26.255773+00	{"appId": "266108631362043909"}		266108224564953093	1715175686.25579	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	537	1	2024-05-08 14:52:30.457786+00	{"appId": "266108631362043909"}		266108224564953093	1715179950.45781	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	556	1	2024-05-08 15:38:47.188384+00	{"appId": "266108631362043909"}		266108224564953093	1715182727.1884	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	117	1	2024-05-08 13:41:26.271864+00	{"appId": "266108631362043909"}		266108224564953093	1715175686.27188	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	118	1	2024-05-08 13:41:26.275391+00	{"appId": "266108631362043909"}		266108224564953093	1715175686.2754	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	119	1	2024-05-08 13:41:26.287565+00	{"appId": "266108631362043909"}		266108224564953093	1715175686.28758	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	120	1	2024-05-08 13:41:33.303748+00	{"appId": "266108631362043909"}		266108224564953093	1715175693.30377	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	121	1	2024-05-08 13:41:36.424149+00	{"appId": "266108631362043909"}		266108224564953093	1715175696.42417	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	122	1	2024-05-08 13:41:49.448419+00	{"appId": "266108631362043909"}		266108224564953093	1715175709.44843	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	123	1	2024-05-08 13:41:49.45171+00	{"appId": "266108631362043909"}		266108224564953093	1715175709.45172	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	124	1	2024-05-08 13:41:49.457944+00	{"appId": "266108631362043909"}		266108224564953093	1715175709.45795	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	125	1	2024-05-08 13:41:49.461248+00	{"appId": "266108631362043909"}		266108224564953093	1715175709.46126	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	126	1	2024-05-08 13:41:49.464564+00	{"appId": "266108631362043909"}		266108224564953093	1715175709.46457	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	127	1	2024-05-08 13:41:49.475762+00	{"appId": "266108631362043909"}		266108224564953093	1715175709.47577	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	128	1	2024-05-08 13:41:59.592236+00	{"appId": "266108631362043909"}		266108224564953093	1715175719.59225	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	129	1	2024-05-08 13:41:59.598947+00	{"appId": "266108631362043909"}		266108224564953093	1715175719.59896	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	130	1	2024-05-08 13:41:59.60415+00	{"appId": "266108631362043909"}		266108224564953093	1715175719.60416	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	131	1	2024-05-08 13:41:59.617148+00	{"appId": "266108631362043909"}		266108224564953093	1715175719.61716	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	132	1	2024-05-08 13:41:59.621686+00	{"appId": "266108631362043909"}		266108224564953093	1715175719.6217	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	133	1	2024-05-08 13:41:59.629288+00	{"appId": "266108631362043909"}		266108224564953093	1715175719.6293	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	134	1	2024-05-08 13:41:59.705554+00	{"appId": "266108631362043909"}		266108224564953093	1715175719.70557	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	135	1	2024-05-08 13:42:09.701737+00	{"appId": "266108631362043909"}		266108224564953093	1715175729.70175	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	136	1	2024-05-08 13:42:09.712369+00	{"appId": "266108631362043909"}		266108224564953093	1715175729.71238	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	137	1	2024-05-08 13:42:19.767924+00	{"appId": "266108631362043909"}		266108224564953093	1715175739.76794	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	138	1	2024-05-08 13:42:24.703686+00	{"appId": "266108631362043909"}		266108224564953093	1715175744.7037	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	139	1	2024-05-08 13:42:24.715071+00	{"appId": "266108631362043909"}		266108224564953093	1715175744.71508	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	140	1	2024-05-08 13:42:24.763384+00	{"appId": "266108631362043909"}		266108224564953093	1715175744.7634	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	141	1	2024-05-08 13:42:29.831138+00	{"appId": "266108631362043909"}		266108224564953093	1715175749.83115	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	142	1	2024-05-08 13:42:34.785445+00	{"appId": "266108631362043909"}		266108224564953093	1715175754.78546	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	538	1	2024-05-08 14:53:17.349218+00	{"appId": "266108631362043909"}		266108224564953093	1715179997.34923	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	143	1	2024-05-08 13:42:34.7952+00	{"appId": "266108631362043909"}		266108224564953093	1715175754.79521	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	144	1	2024-05-08 13:47:40.343571+00	{"appId": "266108631362043909"}		266108224564953093	1715176060.34358	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	145	1	2024-05-08 13:47:40.919531+00	{"appId": "266108631362043909"}		266108224564953093	1715176060.91955	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	146	1	2024-05-08 13:47:40.925066+00	{"appId": "266108631362043909"}		266108224564953093	1715176060.92508	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	147	1	2024-05-08 13:48:35.35255+00	{"appId": "266108631362043909"}		266108224564953093	1715176115.35257	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	148	1	2024-05-08 13:49:09.74088+00	{"appId": "266108631362043909"}		266108224564953093	1715176149.74091	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	557	1	2024-05-08 15:38:47.190644+00	{"appId": "266108631362043909"}		266108224564953093	1715182727.19065	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	149	1	2024-05-08 13:49:09.750381+00	{"appId": "266108631362043909"}		266108224564953093	1715176149.75039	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	150	1	2024-05-08 13:56:04.015825+00	{"appId": "266108631362043909"}		266108224564953093	1715176564.01585	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	5	2	2024-05-08 13:56:36.024639+00	{}		266108224564953093	1715176596.02466	0
266108224564887557	user	266219708343123977	user.token.added	6	2	2024-05-08 13:56:36.079416+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266221863510736905", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T01:56:36.065186346Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715176596.07943	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	151	1	2024-05-08 13:56:36.136056+00	{"appId": "266108631362043909"}		266108224564953093	1715176596.13607	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	152	1	2024-05-08 13:56:36.890655+00	{"appId": "266108631362043909"}		266108224564953093	1715176596.89067	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	153	1	2024-05-08 13:56:36.89455+00	{"appId": "266108631362043909"}		266108224564953093	1715176596.89456	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	154	1	2024-05-08 13:56:44.320449+00	{"appId": "266108631362043909"}		266108224564953093	1715176604.32046	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	155	1	2024-05-08 13:56:44.810961+00	{"appId": "266108631362043909"}		266108224564953093	1715176604.81098	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	156	1	2024-05-08 13:56:44.815528+00	{"appId": "266108631362043909"}		266108224564953093	1715176604.81554	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	157	1	2024-05-08 13:56:45.95123+00	{"appId": "266108631362043909"}		266108224564953093	1715176605.95125	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	158	1	2024-05-08 13:56:46.924011+00	{"appId": "266108631362043909"}		266108224564953093	1715176606.92403	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	159	1	2024-05-08 13:56:46.926978+00	{"appId": "266108631362043909"}		266108224564953093	1715176606.927	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	160	1	2024-05-08 13:57:01.277235+00	{"appId": "266108631362043909"}		266108224564953093	1715176621.27726	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	161	1	2024-05-08 13:57:01.921198+00	{"appId": "266108631362043909"}		266108224564953093	1715176621.92122	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	162	1	2024-05-08 13:57:01.92402+00	{"appId": "266108631362043909"}		266108224564953093	1715176621.92404	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	163	1	2024-05-08 13:57:21.596644+00	{"appId": "266108631362043909"}		266108224564953093	1715176641.59666	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	164	1	2024-05-08 13:57:21.880228+00	{"appId": "266108631362043909"}		266108224564953093	1715176641.88025	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	165	1	2024-05-08 13:57:21.888271+00	{"appId": "266108631362043909"}		266108224564953093	1715176641.88829	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	166	1	2024-05-08 13:57:44.001602+00	{"appId": "266108631362043909"}		266108224564953093	1715176664.00163	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	167	1	2024-05-08 13:57:44.334653+00	{"appId": "266108631362043909"}		266108224564953093	1715176664.33467	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	515	1	2024-05-08 14:47:39.973797+00	{"appId": "266108631362043909"}		266108224564953093	1715179659.97381	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	168	1	2024-05-08 13:57:44.344626+00	{"appId": "266108631362043909"}		266108224564953093	1715176664.34464	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	169	1	2024-05-08 13:58:45.488152+00	{"appId": "266108631362043909"}		266108224564953093	1715176725.48817	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	7	2	2024-05-08 14:00:36.725606+00	{}		266108224564953093	1715176836.72563	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	23	2	2024-05-08 14:54:56.620278+00	{}		266108224564953093	1715180096.62029	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	8	2	2024-05-08 14:00:36.73969+00	{}		266108224564953093	1715176836.7397	0
266108224564887557	user	266219708343123977	user.token.added	9	2	2024-05-08 14:00:36.754565+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266222267304771593", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:00:36.748964638Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715176836.7546	0
266108224564887557	user	266219708343123977	user.token.added	10	2	2024-05-08 14:00:36.765638+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266222267304837129", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:00:36.749083513Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715176836.76565	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	170	1	2024-05-08 14:00:36.801139+00	{"appId": "266108631362043909"}		266108224564953093	1715176836.80115	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	171	1	2024-05-08 14:00:36.81117+00	{"appId": "266108631362043909"}		266108224564953093	1715176836.81118	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	172	1	2024-05-08 14:01:01.040374+00	{"appId": "266108631362043909"}		266108224564953093	1715176861.04039	0
266108224564887557	user	266108224565018629	user.human.signed.out	37	2	2024-05-08 14:01:01.111362+00	{"userAgentID": "266108240469688325"}		266108224564953093	1715176861.11138	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	38	2	2024-05-08 14:01:05.393217+00	{"id": "266222308274733065", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715176865.39323	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	173	1	2024-05-08 14:01:05.733725+00	{"appId": "266108631362043909"}		266108224564953093	1715176865.73374	0
266108224564887557	user	266108224565018629	user.token.added	39	2	2024-05-08 14:01:05.855315+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266222316143247369", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:01:05.850025596Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266222316126470153", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715176865.85533	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	40	2	2024-05-08 14:01:05.855315+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266222316126470153", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-08T14:01:05.393217Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715176865.85549	1
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	174	1	2024-05-08 14:01:05.988099+00	{"appId": "266108631362043909"}		266108224564953093	1715176865.98811	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	175	1	2024-05-08 14:01:06.390616+00	{"appId": "266108631362043909"}		266108224564953093	1715176866.39063	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	578	1	2024-05-08 15:39:23.460039+00	{"appId": "266108631362043909"}		266108224564953093	1715182763.46005	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	176	1	2024-05-08 14:01:06.40068+00	{"appId": "266108631362043909"}		266108224564953093	1715176866.40069	0
266108224564887557	user	266108224565018629	user.token.added	41	2	2024-05-08 14:01:53.580427+00	{"reason": "auth_request", "scopes": ["openid", "profile", "email"], "tokenId": "266222396204122121", "audience": ["266108227433791493@zitadel", "266108227450568709@zitadel", "266108227467345925@zitadel", "266108227467411461@zitadel", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:01:53.574414632Z", "userAgentId": "266108240469688325", "applicationId": "266108227467411461@zitadel", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715176913.58044	0
266108224564887557	project	266108518786924549	project.application.config.oidc.secret.changed	177	1	2024-05-08 14:02:07.899524+00	{"appId": "266108631362043909", "hashedSecret": "$2a$04$UTt4M56xzZjZu8KUeKnQIOOTBsZjlU057VrRKQ2BzdSfRWBvH9eyy"}	266108224565018629	266108224564953093	1715176927.89954	0
266108224564887557	user	266219708343123977	user.machine.secret.removed	11	2	2024-05-08 14:02:59.186585+00	{}	266108224565018629	266108224564953093	1715176979.1866	0
266108224564887557	user	266219708343123977	user.machine.secret.set	12	2	2024-05-08 14:03:01.434117+00	{"hashedSecret": "$2a$04$36wv2zKlpxtY2oogouuaFumcdWutddDDbfQ4U0fThtgSQMm6zfGsW"}	266108224565018629	266108224564953093	1715176981.43413	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	13	2	2024-05-08 14:03:53.310481+00	{}		266108224564953093	1715177033.3105	0
266108224564887557	user	266219708343123977	user.token.added	14	2	2024-05-08 14:03:53.333837+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266222597111283721", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:03:53.328606465Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715177033.33385	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	178	1	2024-05-08 14:03:53.368422+00	{"appId": "266108631362043909"}		266108224564953093	1715177033.36843	0
266108224564887557	user	266108224565018629	user.human.signed.out	42	2	2024-05-08 14:03:53.424322+00	{"userAgentID": "266108240469688325"}		266108224564953093	1715177033.42434	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	43	2	2024-05-08 14:03:58.754281+00	{"id": "266222599275544585", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715177038.7543	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	179	1	2024-05-08 14:03:59.088026+00	{"appId": "266108631362043909"}		266108224564953093	1715177039.08804	0
266108224564887557	user	266108224565018629	user.token.added	44	2	2024-05-08 14:03:59.217716+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266222606993063945", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:03:59.212389093Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266222606976286729", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715177039.21773	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	45	2	2024-05-08 14:03:59.217716+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266222606976286729", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-08T14:03:58.754281Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715177039.2179	1
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	180	1	2024-05-08 14:03:59.349096+00	{"appId": "266108631362043909"}		266108224564953093	1715177039.34911	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	181	1	2024-05-08 14:04:00.097458+00	{"appId": "266108631362043909"}		266108224564953093	1715177040.09748	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	182	1	2024-05-08 14:04:00.109083+00	{"appId": "266108631362043909"}		266108224564953093	1715177040.1091	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	183	1	2024-05-08 14:04:56.094615+00	{"appId": "266108631362043909"}		266108224564953093	1715177096.09463	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	184	1	2024-05-08 14:05:12.816919+00	{"appId": "266108631362043909"}		266108224564953093	1715177112.81694	0
266108224564887557	user	266219708343123977	user.token.added	24	2	2024-05-08 14:54:56.640322+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266227736492638217", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:54:56.635653505Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715180096.64034	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	185	1	2024-05-08 14:05:12.825598+00	{"appId": "266108631362043909"}		266108224564953093	1715177112.82561	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	186	1	2024-05-08 14:06:17.344614+00	{"appId": "266108631362043909"}		266108224564953093	1715177177.34463	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	187	1	2024-05-08 14:06:17.770429+00	{"appId": "266108631362043909"}		266108224564953093	1715177177.77044	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	558	1	2024-05-08 15:38:47.201355+00	{"appId": "266108631362043909"}		266108224564953093	1715182727.20137	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	188	1	2024-05-08 14:06:17.78012+00	{"appId": "266108631362043909"}		266108224564953093	1715177177.78013	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	189	1	2024-05-08 14:06:24.709567+00	{"appId": "266108631362043909"}		266108224564953093	1715177184.70958	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	190	1	2024-05-08 14:06:25.244181+00	{"appId": "266108631362043909"}		266108224564953093	1715177185.2442	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	579	1	2024-05-08 15:39:23.465262+00	{"appId": "266108631362043909"}		266108224564953093	1715182763.46527	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	191	1	2024-05-08 14:06:25.257348+00	{"appId": "266108631362043909"}		266108224564953093	1715177185.25736	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	192	1	2024-05-08 14:06:42.606729+00	{"appId": "266108631362043909"}		266108224564953093	1715177202.60675	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	193	1	2024-05-08 14:06:47.539279+00	{"appId": "266108631362043909"}		266108224564953093	1715177207.53929	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	194	1	2024-05-08 14:06:47.548353+00	{"appId": "266108631362043909"}		266108224564953093	1715177207.54836	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	195	1	2024-05-08 14:07:00.367192+00	{"appId": "266108631362043909"}		266108224564953093	1715177220.36721	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	196	1	2024-05-08 14:07:00.377215+00	{"appId": "266108631362043909"}		266108224564953093	1715177220.37723	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	197	1	2024-05-08 14:07:00.465348+00	{"appId": "266108631362043909"}		266108224564953093	1715177220.46536	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	198	1	2024-05-08 14:07:00.469779+00	{"appId": "266108631362043909"}		266108224564953093	1715177220.46979	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	539	1	2024-05-08 14:54:56.679297+00	{"appId": "266108631362043909"}		266108224564953093	1715180096.67931	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	199	1	2024-05-08 14:07:00.480855+00	{"appId": "266108631362043909"}		266108224564953093	1715177220.48087	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	200	1	2024-05-08 14:07:00.484713+00	{"appId": "266108631362043909"}		266108224564953093	1715177220.48472	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	201	1	2024-05-08 14:07:01.452526+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.45254	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	559	1	2024-05-08 15:38:48.719368+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.71938	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	202	1	2024-05-08 14:07:01.457343+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.45736	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	203	1	2024-05-08 14:07:01.465084+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.4651	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	204	1	2024-05-08 14:07:01.475275+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.47529	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	205	1	2024-05-08 14:07:01.480218+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.48023	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	206	1	2024-05-08 14:07:01.543283+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.5433	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	207	1	2024-05-08 14:07:01.553457+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.55347	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	208	1	2024-05-08 14:07:01.570986+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.571	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	209	1	2024-05-08 14:07:01.576889+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.5769	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	210	1	2024-05-08 14:07:01.582237+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.58225	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	211	1	2024-05-08 14:07:01.588216+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.58823	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	212	1	2024-05-08 14:07:01.596255+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.59627	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	213	1	2024-05-08 14:07:01.60925+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.60926	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	214	1	2024-05-08 14:07:01.618631+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.61864	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	215	1	2024-05-08 14:07:01.634441+00	{"appId": "266108631362043909"}		266108224564953093	1715177221.63445	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	216	1	2024-05-08 14:07:41.497107+00	{"appId": "266108631362043909"}		266108224564953093	1715177261.49712	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	217	1	2024-05-08 14:07:43.579302+00	{"appId": "266108631362043909"}		266108224564953093	1715177263.57933	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	218	1	2024-05-08 14:07:43.648407+00	{"appId": "266108631362043909"}		266108224564953093	1715177263.64843	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	516	1	2024-05-08 14:47:39.987672+00	{"appId": "266108631362043909"}		266108224564953093	1715179659.98768	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	219	1	2024-05-08 14:07:43.656785+00	{"appId": "266108631362043909"}		266108224564953093	1715177263.6568	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	220	1	2024-05-08 14:07:44.2161+00	{"appId": "266108631362043909"}		266108224564953093	1715177264.21612	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	221	1	2024-05-08 14:07:44.22383+00	{"appId": "266108631362043909"}		266108224564953093	1715177264.22385	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	222	1	2024-05-08 14:07:44.275566+00	{"appId": "266108631362043909"}		266108224564953093	1715177264.27558	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	223	1	2024-05-08 14:07:44.279873+00	{"appId": "266108631362043909"}		266108224564953093	1715177264.28046	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	224	1	2024-05-08 14:07:44.284449+00	{"appId": "266108631362043909"}		266108224564953093	1715177264.28446	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	25	2	2024-05-08 14:56:08.116541+00	{}		266108224564953093	1715180168.11657	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	225	1	2024-05-08 14:07:44.297485+00	{"appId": "266108631362043909"}		266108224564953093	1715177264.2975	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	226	1	2024-05-08 14:07:45.229685+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.2297	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	560	1	2024-05-08 15:38:48.722582+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.72259	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	227	1	2024-05-08 14:07:45.241539+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.24155	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	228	1	2024-05-08 14:07:45.245679+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.24569	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	229	1	2024-05-08 14:07:45.251086+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.2511	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	230	1	2024-05-08 14:07:45.259408+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.25946	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	231	1	2024-05-08 14:07:45.314335+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.31435	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	232	1	2024-05-08 14:07:45.322121+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.32213	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	233	1	2024-05-08 14:07:45.341574+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.34159	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	234	1	2024-05-08 14:07:45.356202+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.35621	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	235	1	2024-05-08 14:07:45.363062+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.36308	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	236	1	2024-05-08 14:07:45.379744+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.37976	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	237	1	2024-05-08 14:07:45.3982+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.39821	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	238	1	2024-05-08 14:07:45.406759+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.40677	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	517	1	2024-05-08 14:47:39.991735+00	{"appId": "266108631362043909"}		266108224564953093	1715179659.99174	0
266108224564887557	user	266219708343123977	user.token.added	26	2	2024-05-08 14:56:08.143016+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266227856449732617", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:56:08.136629385Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715180168.14303	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	239	1	2024-05-08 14:07:45.417153+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.41717	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	561	1	2024-05-08 15:38:48.724562+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.72457	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	240	1	2024-05-08 14:07:45.424414+00	{"appId": "266108631362043909"}		266108224564953093	1715177265.42442	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	241	1	2024-05-08 14:07:46.117488+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.11751	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	242	1	2024-05-08 14:07:46.173824+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.17384	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	243	1	2024-05-08 14:07:46.183223+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.18323	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	244	1	2024-05-08 14:07:46.694177+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.69422	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	245	1	2024-05-08 14:07:46.697385+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.6974	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	246	1	2024-05-08 14:07:46.712915+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.71293	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	247	1	2024-05-08 14:07:46.714555+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.71457	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	248	1	2024-05-08 14:07:46.769916+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.76993	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	249	1	2024-05-08 14:07:46.776241+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.77625	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	250	1	2024-05-08 14:07:46.787337+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.78735	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	251	1	2024-05-08 14:07:46.794813+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.79482	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	252	1	2024-05-08 14:07:46.803268+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.80328	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	253	1	2024-05-08 14:07:46.806175+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.80621	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	254	1	2024-05-08 14:07:46.814335+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.81436	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	255	1	2024-05-08 14:07:46.830753+00	{"appId": "266108631362043909"}		266108224564953093	1715177266.83079	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	256	1	2024-05-08 14:07:52.275789+00	{"appId": "266108631362043909"}		266108224564953093	1715177272.27581	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	257	1	2024-05-08 14:11:34.478892+00	{"appId": "266108631362043909"}		266108224564953093	1715177494.47891	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	258	1	2024-05-08 14:13:19.58132+00	{"appId": "266108631362043909"}		266108224564953093	1715177599.58135	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	259	1	2024-05-08 14:13:27.474449+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.47446	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	260	1	2024-05-08 14:13:27.803198+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.80321	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	261	1	2024-05-08 14:13:27.817914+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.81793	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	518	1	2024-05-08 14:47:40.019092+00	{"appId": "266108631362043909"}		266108224564953093	1715179660.0191	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	262	1	2024-05-08 14:13:27.82197+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.82198	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	263	1	2024-05-08 14:13:27.824536+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.82455	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	540	1	2024-05-08 14:56:08.181983+00	{"appId": "266108631362043909"}		266108224564953093	1715180168.18199	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	264	1	2024-05-08 14:13:27.835779+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.83579	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	265	1	2024-05-08 14:13:27.847803+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.84782	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	266	1	2024-05-08 14:13:27.920265+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.92028	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	267	1	2024-05-08 14:13:27.951571+00	{"appId": "266108631362043909"}		266108224564953093	1715177607.95159	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	268	1	2024-05-08 14:13:28.041897+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.04191	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	269	1	2024-05-08 14:13:28.342202+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.34222	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	270	1	2024-05-08 14:13:28.366926+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.36694	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	271	1	2024-05-08 14:13:28.399134+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.39917	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	272	1	2024-05-08 14:13:28.473026+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.47305	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	273	1	2024-05-08 14:13:28.547069+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.54708	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	274	1	2024-05-08 14:13:28.62383+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.62385	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	275	1	2024-05-08 14:13:28.655267+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.65528	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	276	1	2024-05-08 14:13:28.718559+00	{"appId": "266108631362043909"}		266108224564953093	1715177608.71857	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	277	1	2024-05-08 14:13:44.79214+00	{"appId": "266108631362043909"}		266108224564953093	1715177624.79215	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	278	1	2024-05-08 14:13:44.809646+00	{"appId": "266108631362043909"}		266108224564953093	1715177624.80966	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	279	1	2024-05-08 14:13:44.821982+00	{"appId": "266108631362043909"}		266108224564953093	1715177624.822	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	280	1	2024-05-08 14:13:44.824353+00	{"appId": "266108631362043909"}		266108224564953093	1715177624.82436	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	281	1	2024-05-08 14:13:55.939857+00	{"appId": "266108631362043909"}		266108224564953093	1715177635.93994	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	282	1	2024-05-08 14:13:55.949783+00	{"appId": "266108631362043909"}		266108224564953093	1715177635.9498	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	283	1	2024-05-08 14:14:09.247159+00	{"appId": "266108631362043909"}		266108224564953093	1715177649.24717	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	284	1	2024-05-08 14:14:09.256801+00	{"appId": "266108631362043909"}		266108224564953093	1715177649.25681	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	285	1	2024-05-08 14:14:21.64958+00	{"appId": "266108631362043909"}		266108224564953093	1715177661.6496	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	286	1	2024-05-08 14:14:21.652977+00	{"appId": "266108631362043909"}		266108224564953093	1715177661.65299	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	27	2	2024-05-08 15:30:51.144295+00	{}		266108224564953093	1715182251.14432	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	287	1	2024-05-08 14:14:21.668072+00	{"appId": "266108631362043909"}		266108224564953093	1715177661.66813	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	562	1	2024-05-08 15:38:48.729808+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.72982	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	288	1	2024-05-08 14:14:21.670378+00	{"appId": "266108631362043909"}		266108224564953093	1715177661.67039	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	289	1	2024-05-08 14:14:21.673571+00	{"appId": "266108631362043909"}		266108224564953093	1715177661.67358	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	290	1	2024-05-08 14:14:21.677514+00	{"appId": "266108631362043909"}		266108224564953093	1715177661.67752	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	291	1	2024-05-08 14:14:22.039347+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.03936	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	292	1	2024-05-08 14:14:22.043183+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.0432	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	293	1	2024-05-08 14:14:22.054836+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.05485	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	294	1	2024-05-08 14:14:22.065189+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.0652	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	295	1	2024-05-08 14:14:22.35729+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.3573	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	296	1	2024-05-08 14:14:22.382107+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.38212	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	297	1	2024-05-08 14:14:22.403904+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.40391	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	298	1	2024-05-08 14:14:22.423836+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.42385	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	299	1	2024-05-08 14:14:22.586124+00	{"appId": "266108631362043909"}		266108224564953093	1715177662.58614	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	300	1	2024-05-08 14:14:26.93329+00	{"appId": "266108631362043909"}		266108224564953093	1715177666.93331	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	301	1	2024-05-08 14:14:26.947675+00	{"appId": "266108631362043909"}		266108224564953093	1715177666.94769	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	302	1	2024-05-08 14:14:31.134935+00	{"appId": "266108631362043909"}		266108224564953093	1715177671.13495	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	303	1	2024-05-08 14:14:31.145362+00	{"appId": "266108631362043909"}		266108224564953093	1715177671.14537	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	304	1	2024-05-08 14:14:33.009729+00	{"appId": "266108631362043909"}		266108224564953093	1715177673.00974	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	305	1	2024-05-08 14:14:33.02263+00	{"appId": "266108631362043909"}		266108224564953093	1715177673.02265	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	306	1	2024-05-08 14:14:34.437601+00	{"appId": "266108631362043909"}		266108224564953093	1715177674.43761	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	307	1	2024-05-08 14:14:34.447301+00	{"appId": "266108631362043909"}		266108224564953093	1715177674.44732	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	308	1	2024-05-08 14:14:37.187647+00	{"appId": "266108631362043909"}		266108224564953093	1715177677.18766	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	309	1	2024-05-08 14:14:37.192074+00	{"appId": "266108631362043909"}		266108224564953093	1715177677.19208	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	310	1	2024-05-08 14:14:37.204197+00	{"appId": "266108631362043909"}		266108224564953093	1715177677.20421	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	519	1	2024-05-08 14:47:40.029014+00	{"appId": "266108631362043909"}		266108224564953093	1715179660.02903	0
266108224564887557	user	266219708343123977	user.token.added	28	2	2024-05-08 15:30:51.16886+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266231351194157065", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T03:30:51.162887877Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715182251.16887	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	563	1	2024-05-08 15:38:48.740249+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.74026	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	312	1	2024-05-08 14:14:37.217903+00	{"appId": "266108631362043909"}		266108224564953093	1715177677.21792	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	520	1	2024-05-08 14:48:22.233527+00	{"appId": "266108631362043909"}		266108224564953093	1715179702.23354	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	339	1	2024-05-08 14:15:11.312709+00	{"appId": "266108631362043909"}		266108224564953093	1715177711.31272	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	541	1	2024-05-08 15:30:51.211338+00	{"appId": "266108631362043909"}		266108224564953093	1715182251.21135	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	369	1	2024-05-08 14:16:46.197937+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.19795	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	564	1	2024-05-08 15:38:48.808663+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.80868	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	396	1	2024-05-08 14:20:10.850608+00	{"appId": "266108631362043909"}		266108224564953093	1715178010.85062	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	411	1	2024-05-08 14:20:39.024648+00	{"appId": "266108631362043909"}		266108224564953093	1715178039.02466	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	426	1	2024-05-08 14:22:45.590644+00	{"appId": "266108631362043909"}		266108224564953093	1715178165.59066	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	438	1	2024-05-08 14:22:52.946132+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.94614	0
266108224564887557	user	266219708343123977	user.token.added	18	2	2024-05-08 14:28:44.050896+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266225098124427273", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:28:44.04507996Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715178524.05091	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	462	1	2024-05-08 14:31:37.788502+00	{"appId": "266108631362043909"}		266108224564953093	1715178697.78851	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	475	1	2024-05-08 14:36:21.139989+00	{"appId": "266108631362043909"}		266108224564953093	1715178981.14001	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	313	1	2024-05-08 14:14:39.517725+00	{"appId": "266108631362043909"}		266108224564953093	1715177679.51776	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	326	1	2024-05-08 14:14:46.24695+00	{"appId": "266108631362043909"}		266108224564953093	1715177686.24706	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	340	1	2024-05-08 14:15:11.329013+00	{"appId": "266108631362043909"}		266108224564953093	1715177711.32903	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	354	1	2024-05-08 14:15:38.045692+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.04571	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	370	1	2024-05-08 14:16:46.205166+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.20519	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	397	1	2024-05-08 14:20:11.13703+00	{"appId": "266108631362043909"}		266108224564953093	1715178011.13704	0
266108224564887557	user	266108224565018629	user.human.signed.out	46	2	2024-05-08 15:30:51.27267+00	{"userAgentID": "266108240469688325"}		266108224564953093	1715182251.27268	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	565	1	2024-05-08 15:38:48.81908+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.81909	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	439	1	2024-05-08 14:22:52.962028+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.96204	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	449	1	2024-05-08 14:28:44.092233+00	{"appId": "266108631362043909"}		266108224564953093	1715178524.09225	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	476	1	2024-05-08 14:37:07.144752+00	{"appId": "266108631362043909"}		266108224564953093	1715179027.14477	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	490	1	2024-05-08 14:40:20.42813+00	{"appId": "266108631362043909"}		266108224564953093	1715179220.42815	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	503	1	2024-05-08 14:40:28.741337+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.74135	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	327	1	2024-05-08 14:14:53.773617+00	{"appId": "266108631362043909"}		266108224564953093	1715177693.77363	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	341	1	2024-05-08 14:15:11.380717+00	{"appId": "266108631362043909"}		266108224564953093	1715177711.38073	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	355	1	2024-05-08 14:15:38.048802+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.04881	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	47	2	2024-05-08 15:30:56.192465+00	{"id": "266231351462592521", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715182256.19248	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	384	1	2024-05-08 14:19:01.399323+00	{"appId": "266108631362043909"}		266108224564953093	1715177941.39939	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	398	1	2024-05-08 14:20:11.218108+00	{"appId": "266108631362043909"}		266108224564953093	1715178011.21812	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	412	1	2024-05-08 14:20:39.038935+00	{"appId": "266108631362043909"}		266108224564953093	1715178039.03895	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	427	1	2024-05-08 14:22:45.600311+00	{"appId": "266108631362043909"}		266108224564953093	1715178165.60032	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	19	2	2024-05-08 14:30:29.243476+00	{}		266108224564953093	1715178629.24349	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	477	1	2024-05-08 14:37:12.06559+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.06561	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	491	1	2024-05-08 14:40:22.1171+00	{"appId": "266108631362043909"}		266108224564953093	1715179222.11712	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	314	1	2024-05-08 14:14:39.531546+00	{"appId": "266108631362043909"}		266108224564953093	1715177679.53156	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	521	1	2024-05-08 14:48:22.238131+00	{"appId": "266108631362043909"}		266108224564953093	1715179702.23814	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	342	1	2024-05-08 14:15:13.545207+00	{"appId": "266108631362043909"}		266108224564953093	1715177713.54522	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	356	1	2024-05-08 14:15:38.055349+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.05536	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	371	1	2024-05-08 14:16:46.21075+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.21076	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	385	1	2024-05-08 14:19:01.401452+00	{"appId": "266108631362043909"}		266108224564953093	1715177941.40147	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	399	1	2024-05-08 14:20:11.255712+00	{"appId": "266108631362043909"}		266108224564953093	1715178011.25573	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	413	1	2024-05-08 14:20:39.071332+00	{"appId": "266108631362043909"}		266108224564953093	1715178039.07137	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	428	1	2024-05-08 14:22:45.655593+00	{"appId": "266108631362043909"}		266108224564953093	1715178165.65561	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	440	1	2024-05-08 14:22:52.96897+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.96898	0
266108224564887557	user	266219708343123977	user.token.added	20	2	2024-05-08 14:30:29.265984+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266225274654294025", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:30:29.260608968Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715178629.266	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	463	1	2024-05-08 14:31:37.801637+00	{"appId": "266108631362043909"}		266108224564953093	1715178697.80165	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	478	1	2024-05-08 14:37:12.337425+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.33744	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	492	1	2024-05-08 14:40:22.118839+00	{"appId": "266108631362043909"}		266108224564953093	1715179222.11885	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	504	1	2024-05-08 14:40:28.746637+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.74665	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	542	1	2024-05-08 15:30:56.561079+00	{"appId": "266108631362043909"}		266108224564953093	1715182256.56109	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	566	1	2024-05-08 15:38:48.83607+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.83609	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	315	1	2024-05-08 14:14:41.191313+00	{"appId": "266108631362043909"}		266108224564953093	1715177681.19133	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	328	1	2024-05-08 14:14:53.783539+00	{"appId": "266108631362043909"}		266108224564953093	1715177693.78355	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	343	1	2024-05-08 14:15:18.739929+00	{"appId": "266108631362043909"}		266108224564953093	1715177718.73994	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	357	1	2024-05-08 14:15:38.382365+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.38242	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	522	1	2024-05-08 14:48:22.24376+00	{"appId": "266108631362043909"}		266108224564953093	1715179702.24377	0
266108224564887557	user	266108224565018629	user.token.added	48	2	2024-05-08 15:30:56.694445+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266231360455180297", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T03:30:56.688745255Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266231360438403081", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715182256.69446	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	400	1	2024-05-08 14:20:11.303319+00	{"appId": "266108631362043909"}		266108224564953093	1715178011.30333	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	414	1	2024-05-08 14:20:39.088997+00	{"appId": "266108631362043909"}		266108224564953093	1715178039.08901	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	429	1	2024-05-08 14:22:45.657947+00	{"appId": "266108631362043909"}		266108224564953093	1715178165.65796	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	441	1	2024-05-08 14:22:52.972951+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.97296	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	450	1	2024-05-08 14:30:29.30063+00	{"appId": "266108631362043909"}		266108224564953093	1715178629.30064	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	49	2	2024-05-08 15:30:56.694445+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266231360438403081", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-08T15:30:56.192465Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715182256.69468	1
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	479	1	2024-05-08 14:37:12.349981+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.35	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	493	1	2024-05-08 14:40:22.690159+00	{"appId": "266108631362043909"}		266108224564953093	1715179222.69018	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	567	1	2024-05-08 15:38:48.853497+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.85359	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	523	1	2024-05-08 14:48:22.246407+00	{"appId": "266108631362043909"}		266108224564953093	1715179702.24642	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	329	1	2024-05-08 14:14:56.327087+00	{"appId": "266108631362043909"}		266108224564953093	1715177696.32712	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	344	1	2024-05-08 14:15:18.852294+00	{"appId": "266108631362043909"}		266108224564953093	1715177718.85231	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	358	1	2024-05-08 14:15:38.392043+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.39206	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	543	1	2024-05-08 15:30:56.831769+00	{"appId": "266108631362043909"}		266108224564953093	1715182256.83178	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	386	1	2024-05-08 14:19:01.411615+00	{"appId": "266108631362043909"}		266108224564953093	1715177941.41163	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	401	1	2024-05-08 14:20:11.370361+00	{"appId": "266108631362043909"}		266108224564953093	1715178011.37037	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	415	1	2024-05-08 14:20:42.177652+00	{"appId": "266108631362043909"}		266108224564953093	1715178042.17767	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	451	1	2024-05-08 14:30:35.374266+00	{"appId": "266108631362043909"}		266108224564953093	1715178635.37428	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	464	1	2024-05-08 14:31:37.813731+00	{"appId": "266108631362043909"}		266108224564953093	1715178697.81374	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	316	1	2024-05-08 14:14:41.202281+00	{"appId": "266108631362043909"}		266108224564953093	1715177681.20229	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	330	1	2024-05-08 14:14:56.334475+00	{"appId": "266108631362043909"}		266108224564953093	1715177696.33449	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	345	1	2024-05-08 14:15:18.919403+00	{"appId": "266108631362043909"}		266108224564953093	1715177718.91942	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	359	1	2024-05-08 14:15:38.402173+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.40218	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	372	1	2024-05-08 14:16:46.223245+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.22326	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	387	1	2024-05-08 14:19:55.241843+00	{"appId": "266108631362043909"}		266108224564953093	1715177995.24186	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	402	1	2024-05-08 14:20:11.395154+00	{"appId": "266108631362043909"}		266108224564953093	1715178011.39517	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	416	1	2024-05-08 14:20:42.183169+00	{"appId": "266108631362043909"}		266108224564953093	1715178042.18318	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	524	1	2024-05-08 14:49:00.261503+00	{"appId": "266108631362043909"}		266108224564953093	1715179740.26152	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	544	1	2024-05-08 15:30:57.558652+00	{"appId": "266108631362043909"}		266108224564953093	1715182257.55867	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	452	1	2024-05-08 14:30:35.671983+00	{"appId": "266108631362043909"}		266108224564953093	1715178635.672	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	465	1	2024-05-08 14:31:38.414833+00	{"appId": "266108631362043909"}		266108224564953093	1715178698.41485	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	480	1	2024-05-08 14:37:12.354063+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.35407	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	494	1	2024-05-08 14:40:22.700128+00	{"appId": "266108631362043909"}		266108224564953093	1715179222.70014	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	317	1	2024-05-08 14:14:41.615439+00	{"appId": "266108631362043909"}		266108224564953093	1715177681.61545	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	346	1	2024-05-08 14:15:22.13161+00	{"appId": "266108631362043909"}		266108224564953093	1715177722.13162	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	360	1	2024-05-08 14:15:38.423466+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.42348	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	373	1	2024-05-08 14:16:46.22669+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.2267	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	403	1	2024-05-08 14:20:11.447036+00	{"appId": "266108631362043909"}		266108224564953093	1715178011.44705	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	417	1	2024-05-08 14:20:44.382211+00	{"appId": "266108631362043909"}		266108224564953093	1715178044.38223	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	430	1	2024-05-08 14:22:45.668259+00	{"appId": "266108631362043909"}		266108224564953093	1715178165.66827	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	453	1	2024-05-08 14:30:35.678268+00	{"appId": "266108631362043909"}		266108224564953093	1715178635.67828	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	466	1	2024-05-08 14:31:47.7688+00	{"appId": "266108631362043909"}		266108224564953093	1715178707.76883	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	495	1	2024-05-08 14:40:28.576532+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.57656	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	505	1	2024-05-08 14:40:28.760112+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.76012	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	545	1	2024-05-08 15:30:57.568649+00	{"appId": "266108631362043909"}		266108224564953093	1715182257.56866	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	347	1	2024-05-08 14:15:35.057612+00	{"appId": "266108631362043909"}		266108224564953093	1715177735.05763	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	361	1	2024-05-08 14:15:38.631955+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.63208	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	388	1	2024-05-08 14:19:55.252431+00	{"appId": "266108631362043909"}		266108224564953093	1715177995.25244	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	404	1	2024-05-08 14:20:11.590826+00	{"appId": "266108631362043909"}		266108224564953093	1715178011.59084	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	418	1	2024-05-08 14:22:09.881113+00	{"appId": "266108631362043909"}		266108224564953093	1715178129.88113	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	442	1	2024-05-08 14:22:52.981346+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.98136	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	467	1	2024-05-08 14:31:48.387063+00	{"appId": "266108631362043909"}		266108224564953093	1715178708.38708	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	318	1	2024-05-08 14:14:41.624325+00	{"appId": "266108631362043909"}		266108224564953093	1715177681.62434	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	331	1	2024-05-08 14:14:56.340093+00	{"appId": "266108631362043909"}		266108224564953093	1715177696.3401	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	525	1	2024-05-08 14:49:00.282271+00	{"appId": "266108631362043909"}		266108224564953093	1715179740.28228	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	546	1	2024-05-08 15:30:57.65925+00	{"appId": "266108631362043909"}		266108224564953093	1715182257.65926	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	374	1	2024-05-08 14:16:46.24253+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.24254	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	389	1	2024-05-08 14:20:10.272109+00	{"appId": "266108631362043909"}		266108224564953093	1715178010.27213	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	405	1	2024-05-08 14:20:37.76716+00	{"appId": "266108631362043909"}		266108224564953093	1715178037.76717	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	419	1	2024-05-08 14:22:10.549108+00	{"appId": "266108631362043909"}		266108224564953093	1715178130.54912	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	431	1	2024-05-08 14:22:45.678462+00	{"appId": "266108631362043909"}		266108224564953093	1715178165.67848	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	443	1	2024-05-08 14:22:52.990165+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.99032	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	454	1	2024-05-08 14:30:35.687594+00	{"appId": "266108631362043909"}		266108224564953093	1715178635.6876	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	468	1	2024-05-08 14:35:29.789499+00	{"appId": "266108631362043909"}		266108224564953093	1715178929.78951	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	481	1	2024-05-08 14:37:12.363397+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.36341	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	496	1	2024-05-08 14:40:28.582945+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.58296	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	506	1	2024-05-08 14:40:28.764859+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.76518	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	568	1	2024-05-08 15:38:48.862701+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.86271	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	319	1	2024-05-08 14:14:42.632092+00	{"appId": "266108631362043909"}		266108224564953093	1715177682.63211	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	332	1	2024-05-08 14:14:56.348524+00	{"appId": "266108631362043909"}		266108224564953093	1715177696.34854	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	348	1	2024-05-08 14:15:35.062643+00	{"appId": "266108631362043909"}		266108224564953093	1715177735.06266	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	362	1	2024-05-08 14:15:38.641786+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.6418	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	375	1	2024-05-08 14:16:46.623417+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.62344	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	569	1	2024-05-08 15:38:48.870284+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.8703	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	432	1	2024-05-08 14:22:52.848488+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.84881	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	526	1	2024-05-08 14:49:00.294532+00	{"appId": "266108631362043909"}		266108224564953093	1715179740.29454	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	547	1	2024-05-08 15:30:57.664236+00	{"appId": "266108631362043909"}		266108224564953093	1715182257.66425	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	570	1	2024-05-08 15:38:48.874181+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.87419	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	363	1	2024-05-08 14:15:38.704032+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.70405	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	376	1	2024-05-08 14:16:46.62713+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.62714	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	390	1	2024-05-08 14:20:10.284406+00	{"appId": "266108631362043909"}		266108224564953093	1715178010.28442	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	406	1	2024-05-08 14:20:37.773302+00	{"appId": "266108631362043909"}		266108224564953093	1715178037.77331	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	420	1	2024-05-08 14:22:10.5604+00	{"appId": "266108631362043909"}		266108224564953093	1715178130.56042	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	433	1	2024-05-08 14:22:52.852312+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.85233	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	469	1	2024-05-08 14:35:29.793806+00	{"appId": "266108631362043909"}		266108224564953093	1715178929.79384	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	482	1	2024-05-08 14:37:12.368408+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.36842	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	507	1	2024-05-08 14:40:28.773565+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.77358	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	320	1	2024-05-08 14:14:42.646559+00	{"appId": "266108631362043909"}		266108224564953093	1715177682.64658	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	333	1	2024-05-08 14:14:56.356804+00	{"appId": "266108631362043909"}		266108224564953093	1715177696.35682	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	349	1	2024-05-08 14:15:35.074662+00	{"appId": "266108631362043909"}		266108224564953093	1715177735.07467	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	364	1	2024-05-08 14:15:38.742113+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.74215	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	377	1	2024-05-08 14:16:46.634275+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.63429	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	391	1	2024-05-08 14:20:10.785057+00	{"appId": "266108631362043909"}		266108224564953093	1715178010.78508	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	527	1	2024-05-08 14:49:00.34713+00	{"appId": "266108631362043909"}		266108224564953093	1715179740.34714	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	421	1	2024-05-08 14:22:10.626011+00	{"appId": "266108631362043909"}		266108224564953093	1715178130.62603	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	444	1	2024-05-08 14:22:52.997067+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.99708	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	455	1	2024-05-08 14:30:35.692357+00	{"appId": "266108631362043909"}		266108224564953093	1715178635.69237	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	571	1	2024-05-08 15:38:48.878513+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.87852	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	483	1	2024-05-08 14:37:12.376115+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.37613	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	497	1	2024-05-08 14:40:28.593332+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.59334	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	321	1	2024-05-08 14:14:46.148274+00	{"appId": "266108631362043909"}		266108224564953093	1715177686.14829	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	334	1	2024-05-08 14:14:59.909267+00	{"appId": "266108631362043909"}		266108224564953093	1715177699.90928	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	528	1	2024-05-08 14:49:05.753629+00	{"appId": "266108631362043909"}		266108224564953093	1715179745.75364	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	365	1	2024-05-08 14:15:40.803423+00	{"appId": "266108631362043909"}		266108224564953093	1715177740.80344	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	378	1	2024-05-08 14:16:46.679698+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.67973	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	392	1	2024-05-08 14:20:10.791818+00	{"appId": "266108631362043909"}		266108224564953093	1715178010.79184	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	407	1	2024-05-08 14:20:37.781863+00	{"appId": "266108631362043909"}		266108224564953093	1715178037.78187	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	548	1	2024-05-08 15:30:57.673118+00	{"appId": "266108631362043909"}		266108224564953093	1715182257.67313	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	445	1	2024-05-08 14:22:53.007777+00	{"appId": "266108631362043909"}		266108224564953093	1715178173.00779	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	456	1	2024-05-08 14:30:35.70365+00	{"appId": "266108631362043909"}		266108224564953093	1715178635.70366	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	484	1	2024-05-08 14:37:12.432794+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.43281	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	498	1	2024-05-08 14:40:28.596463+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.59647	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	508	1	2024-05-08 14:40:28.780259+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.78027	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	322	1	2024-05-08 14:14:46.20055+00	{"appId": "266108631362043909"}		266108224564953093	1715177686.20062	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	335	1	2024-05-08 14:14:59.969204+00	{"appId": "266108631362043909"}		266108224564953093	1715177699.96922	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	350	1	2024-05-08 14:15:35.084559+00	{"appId": "266108631362043909"}		266108224564953093	1715177735.08457	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	529	1	2024-05-08 14:49:05.92125+00	{"appId": "266108631362043909"}		266108224564953093	1715179745.92126	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	379	1	2024-05-08 14:16:46.880819+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.88084	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	393	1	2024-05-08 14:20:10.82149+00	{"appId": "266108631362043909"}		266108224564953093	1715178010.8215	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	408	1	2024-05-08 14:20:37.785778+00	{"appId": "266108631362043909"}		266108224564953093	1715178037.78579	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	549	1	2024-05-08 15:30:57.676986+00	{"appId": "266108631362043909"}		266108224564953093	1715182257.677	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	446	1	2024-05-08 14:22:53.011496+00	{"appId": "266108631362043909"}		266108224564953093	1715178173.01151	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	470	1	2024-05-08 14:35:29.805992+00	{"appId": "266108631362043909"}		266108224564953093	1715178929.80601	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	509	1	2024-05-08 14:40:28.785808+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.78582	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	323	1	2024-05-08 14:14:46.211916+00	{"appId": "266108631362043909"}		266108224564953093	1715177686.21193	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	336	1	2024-05-08 14:15:06.451166+00	{"appId": "266108631362043909"}		266108224564953093	1715177706.45118	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	351	1	2024-05-08 14:15:38.028495+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.02851	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	366	1	2024-05-08 14:15:40.80687+00	{"appId": "266108631362043909"}		266108224564953093	1715177740.80688	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	380	1	2024-05-08 14:16:46.903151+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.90317	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	530	1	2024-05-08 14:49:05.925134+00	{"appId": "266108631362043909"}		266108224564953093	1715179745.92514	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	409	1	2024-05-08 14:20:39.005348+00	{"appId": "266108631362043909"}		266108224564953093	1715178039.00536	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	422	1	2024-05-08 14:22:10.630591+00	{"appId": "266108631362043909"}		266108224564953093	1715178130.6306	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	434	1	2024-05-08 14:22:52.8628+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.86281	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	447	1	2024-05-08 14:27:52.864779+00	{"appId": "266108631362043909"}		266108224564953093	1715178472.8648	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	457	1	2024-05-08 14:30:35.714472+00	{"appId": "266108631362043909"}		266108224564953093	1715178635.71449	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	471	1	2024-05-08 14:35:29.810451+00	{"appId": "266108631362043909"}		266108224564953093	1715178929.81046	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	485	1	2024-05-08 14:37:12.443015+00	{"appId": "266108631362043909"}		266108224564953093	1715179032.44303	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	499	1	2024-05-08 14:40:28.608006+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.60805	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	550	1	2024-05-08 15:38:41.26846+00	{"appId": "266108631362043909"}		266108224564953093	1715182721.26848	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	572	1	2024-05-08 15:38:48.892881+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.89289	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	324	1	2024-05-08 14:14:46.217073+00	{"appId": "266108631362043909"}		266108224564953093	1715177686.21709	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	531	1	2024-05-08 14:49:05.952316+00	{"appId": "266108631362043909"}		266108224564953093	1715179745.95233	0
266108224564887557	user	266108224565018629	user.human.signed.out	50	2	2024-05-08 15:38:41.337801+00	{"userAgentID": "266108240469688325"}		266108224564953093	1715182721.33781	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	381	1	2024-05-08 14:16:46.969524+00	{"appId": "266108631362043909"}		266108224564953093	1715177806.96954	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	394	1	2024-05-08 14:20:10.825093+00	{"appId": "266108631362043909"}		266108224564953093	1715178010.8251	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	423	1	2024-05-08 14:22:10.639194+00	{"appId": "266108631362043909"}		266108224564953093	1715178130.6392	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	435	1	2024-05-08 14:22:52.865638+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.86565	0
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	15	2	2024-05-08 14:28:11.214186+00	{}		266108224564953093	1715178491.21421	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	458	1	2024-05-08 14:31:16.091144+00	{"appId": "266108631362043909"}		266108224564953093	1715178676.09116	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	486	1	2024-05-08 14:40:09.813167+00	{"appId": "266108631362043909"}		266108224564953093	1715179209.81318	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	500	1	2024-05-08 14:40:28.711862+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.71187	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	532	1	2024-05-08 14:49:14.550443+00	{"appId": "266108631362043909"}		266108224564953093	1715179754.55046	0
266108224564887557	user	266108224565018629	user.human.password.check.succeeded	51	2	2024-05-08 15:38:45.807798+00	{"id": "266232140109185033", "remoteIP": "192.168.65.1", "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 YaBrowser/24.1.0.0 Safari/537.36", "userAgentID": "266108240469688325", "acceptLanguage": "ru,en;q=0.9"}	LOGIN	266108224564953093	1715182725.80782	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	573	1	2024-05-08 15:38:48.907381+00	{"appId": "266108631362043909"}		266108224564953093	1715182728.90739	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	367	1	2024-05-08 14:15:40.819978+00	{"appId": "266108631362043909"}		266108224564953093	1715177740.81999	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	382	1	2024-05-08 14:16:47.058452+00	{"appId": "266108631362043909"}		266108224564953093	1715177807.05847	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	436	1	2024-05-08 14:22:52.870821+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.87083	0
266108224564887557	user	266219708343123977	user.token.added	16	2	2024-05-08 14:28:11.235802+00	{"reason": "client_credentials", "scopes": ["openid", "profile", "urn:zitadel:iam:org:project:id:266108518786924549:aud"], "tokenId": "266225043078381577", "audience": ["266108518786924549"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T02:28:11.230616167Z", "preferredLanguage": "und"}	SYSTEM	266108224564953093	1715178491.23582	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	459	1	2024-05-08 14:31:20.388855+00	{"appId": "266108631362043909"}		266108224564953093	1715178680.38887	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	472	1	2024-05-08 14:35:29.820249+00	{"appId": "266108631362043909"}		266108224564953093	1715178929.82026	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	487	1	2024-05-08 14:40:17.922018+00	{"appId": "266108631362043909"}		266108224564953093	1715179217.92203	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	337	1	2024-05-08 14:15:06.460881+00	{"appId": "266108631362043909"}		266108224564953093	1715177706.4609	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	352	1	2024-05-08 14:15:38.035883+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.03589	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	551	1	2024-05-08 15:38:46.13794+00	{"appId": "266108631362043909"}		266108224564953093	1715182726.13795	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	383	1	2024-05-08 14:19:01.384087+00	{"appId": "266108631362043909"}		266108224564953093	1715177941.3841	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	395	1	2024-05-08 14:20:10.835362+00	{"appId": "266108631362043909"}		266108224564953093	1715178010.83538	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	574	1	2024-05-08 15:39:23.3707+00	{"appId": "266108631362043909"}		266108224564953093	1715182763.37071	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	424	1	2024-05-08 14:22:10.64917+00	{"appId": "266108631362043909"}		266108224564953093	1715178130.64918	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	437	1	2024-05-08 14:22:52.935856+00	{"appId": "266108631362043909"}		266108224564953093	1715178172.93589	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	448	1	2024-05-08 14:28:11.273436+00	{"appId": "266108631362043909"}		266108224564953093	1715178491.27345	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	460	1	2024-05-08 14:31:37.778361+00	{"appId": "266108631362043909"}		266108224564953093	1715178697.77838	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	473	1	2024-05-08 14:35:39.762734+00	{"appId": "266108631362043909"}		266108224564953093	1715178939.76275	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	488	1	2024-05-08 14:40:18.682967+00	{"appId": "266108631362043909"}		266108224564953093	1715179218.68298	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	501	1	2024-05-08 14:40:28.722375+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.72254	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	325	1	2024-05-08 14:14:46.235101+00	{"appId": "266108631362043909"}		266108224564953093	1715177686.23511	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	338	1	2024-05-08 14:15:06.465553+00	{"appId": "266108631362043909"}		266108224564953093	1715177706.46556	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	353	1	2024-05-08 14:15:38.040425+00	{"appId": "266108631362043909"}		266108224564953093	1715177738.04044	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	368	1	2024-05-08 14:15:40.832872+00	{"appId": "266108631362043909"}		266108224564953093	1715177740.83289	0
266108224564887557	user	266108224565018629	user.token.added	52	2	2024-05-08 15:38:46.261742+00	{"reason": "auth_request", "scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266232148262912009", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "0001-01-01T00:00:00Z", "expiration": "2024-05-09T03:38:46.257037458Z", "userAgentId": "266108240469688325", "applicationId": "266108631362109445@datalens", "refreshTokenID": "266232148246134793", "preferredLanguage": "en"}	SYSTEM	266108224564953093	1715182726.26177	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	410	1	2024-05-08 14:20:39.020016+00	{"appId": "266108631362043909"}		266108224564953093	1715178039.02003	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	425	1	2024-05-08 14:22:45.22873+00	{"appId": "266108631362043909"}		266108224564953093	1715178165.22875	0
266108224564887557	user	266108224565018629	user.human.refresh.token.added	53	2	2024-05-08 15:38:46.261742+00	{"scopes": ["openid", "openid", "offline_access", "urn:zitadel:iam:org:project:id:zitadel:aud"], "tokenId": "266232148246134793", "audience": ["266108631362109445@datalens", "266108518786924549", "266108224565084165"], "authTime": "2024-05-08T15:38:45.807798Z", "clientId": "266108631362109445@datalens", "expiration": 7776000000000000, "userAgentId": "266108240469688325", "idleExpiration": 2592000000000000, "preferredLanguage": "en", "authMethodReferences": ["password", "pwd"]}	SYSTEM	266108224564953093	1715182726.26195	1
266108224564887557	user	266219708343123977	user.machine.secret.check.succeeded	17	2	2024-05-08 14:28:44.025775+00	{}		266108224564953093	1715178524.02579	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	461	1	2024-05-08 14:31:37.785816+00	{"appId": "266108631362043909"}		266108224564953093	1715178697.78583	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	474	1	2024-05-08 14:35:44.060327+00	{"appId": "266108631362043909"}		266108224564953093	1715178944.06034	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	489	1	2024-05-08 14:40:20.415675+00	{"appId": "266108631362043909"}		266108224564953093	1715179220.41569	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	502	1	2024-05-08 14:40:28.731172+00	{"appId": "266108631362043909"}		266108224564953093	1715179228.73118	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	311	1	2024-05-08 14:14:37.208241+00	{"appId": "266108631362043909"}		266108224564953093	1715177677.20825	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	533	1	2024-05-08 14:49:14.56181+00	{"appId": "266108631362043909"}		266108224564953093	1715179754.56182	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	552	1	2024-05-08 15:38:46.404406+00	{"appId": "266108631362043909"}		266108224564953093	1715182726.40442	0
266108224564887557	project	266108518786924549	project.application.oidc.secret.check.succeeded	575	1	2024-05-08 15:39:23.379867+00	{"appId": "266108631362043909"}		266108224564953093	1715182763.37988	0
\.


--
-- Data for Name: unique_constraints; Type: TABLE DATA; Schema: eventstore; Owner: us
--

COPY eventstore.unique_constraints (instance_id, unique_type, unique_field) FROM stdin;
	migration_started	14_events_push
	migration_done	14_events_push
	migration_started	01_tables
	migration_done	01_tables
	migration_started	02_assets
	migration_done	02_assets
	migration_started	03_default_instance
266108224564887557	secret_generator	
266108224564887557	secret_generator	
266108224564887557	secret_generator	
266108224564887557	secret_generator	
266108224564887557	secret_generator	
266108224564887557	secret_generator	
266108224564887557	secret_generator	
266108224564887557	secret_generator	\b
266108224564887557	secret_generator	\t
266108224564887557	org_name	zitadel
266108224564887557	org_domain	zitadel.localhost
266108224564887557	usernames	zitadel-admin@zitadel.localhost
266108224564887557	member	266108224564953093:266108224565018629
266108224564887557	member	266108224564887557:266108224565018629
266108224564887557	project_names	zitadel266108224564953093
266108224564887557	member	266108224565084165:266108224565018629
266108224564887557	appname	management-api:266108224565084165
266108224564887557	appname	admin-api:266108224565084165
266108224564887557	appname	auth-api:266108224565084165
266108224564887557	appname	console:266108224565084165
	migration_done	03_default_instance
	migration_started	05_last_failed
	migration_done	05_last_failed
	migration_started	06_resource_owner_columns
	migration_done	06_resource_owner_columns
	migration_started	07_logstore
	migration_done	07_logstore
	migration_started	08_auth_token_indexes
	migration_done	08_auth_token_indexes
	migration_started	12_auth_users_otp_columns
	migration_done	12_auth_users_otp_columns
	migration_started	13_fix_quota_constraints
	migration_done	13_fix_quota_constraints
	migration_started	15_current_projection_state
	migration_done	15_current_projection_state
	migration_started	16_unique_constraint_lower
	migration_done	16_unique_constraint_lower
	migration_started	17_add_offset_col_to_current_states
	migration_done	17_add_offset_col_to_current_states
	migration_started	19_add_current_sequences_index
	migration_done	19_add_current_sequences_index
	migration_started	20_add_by_user_index_on_session
	migration_done	20_add_by_user_index_on_session
	migration_started	22_active_instance_events_index
	migration_done	22_active_instance_events_index
	migration_started	23_correct_global_unique_constraints
	instance_domain	zitadel-i1rjad.localhost
	instance_domain	localhost
	migration_done	23_correct_global_unique_constraints
	migration_started	18_add_lower_fields_to_login_names
	migration_done	18_add_lower_fields_to_login_names
	migration_started	21_add_block_field_to_limits
	migration_done	21_add_block_field_to_limits
266108224564887557	project_names	datalens266108224564953093
266108224564887557	member	266108518786924549:266108224565018629
	migration_started	24_add_actor_col_to_auth_tokens
	migration_done	24_add_actor_col_to_auth_tokens
	migration_started	25_user12_add_lower_fields_to_verified_email
	migration_done	25_user12_add_lower_fields_to_verified_email
	migration_started	projections.orgs1
	migration_done	projections.orgs1
	migration_started	projections.org_metadata2
	migration_done	projections.org_metadata2
	migration_started	projections.actions3
	migration_done	projections.actions3
	migration_started	projections.flow_triggers3
	migration_done	projections.flow_triggers3
	migration_started	projections.projects4
	migration_done	projections.projects4
	migration_started	projections.password_complexity_policies2
	migration_done	projections.password_complexity_policies2
	migration_started	projections.password_age_policies2
	migration_done	projections.password_age_policies2
	migration_started	projections.lockout_policies3
	migration_done	projections.lockout_policies3
	migration_started	projections.privacy_policies3
	migration_done	projections.privacy_policies3
	migration_started	projections.domain_policies2
	migration_done	projections.domain_policies2
	migration_started	projections.label_policies3
	migration_done	projections.label_policies3
	migration_started	projections.project_grants4
	migration_done	projections.project_grants4
	migration_started	projections.project_roles4
	migration_done	projections.project_roles4
	migration_started	projections.org_domains2
	migration_done	projections.org_domains2
	migration_started	projections.login_policies5
	migration_done	projections.login_policies5
	migration_started	projections.idps3
	migration_done	projections.idps3
	migration_started	projections.idp_templates6
	migration_done	projections.idp_templates6
	migration_started	projections.apps7
	migration_done	projections.apps7
	migration_started	projections.idp_user_links3
	migration_done	projections.idp_user_links3
	migration_started	projections.idp_login_policy_links5
	migration_done	projections.idp_login_policy_links5
	migration_started	projections.mail_templates2
	migration_done	projections.mail_templates2
	migration_started	projections.message_texts2
	migration_done	projections.message_texts2
	migration_started	projections.custom_texts2
	migration_done	projections.custom_texts2
	migration_started	projections.users12
	migration_done	projections.users12
	migration_started	projections.login_names3
	migration_done	projections.login_names3
	migration_started	projections.org_members4
	migration_done	projections.org_members4
	migration_started	projections.instance_domains
	migration_done	projections.instance_domains
	migration_started	projections.instance_members4
	migration_done	projections.instance_members4
	migration_started	projections.project_members4
	migration_done	projections.project_members4
	migration_started	projections.project_grant_members4
	migration_done	projections.project_grant_members4
	migration_started	projections.authn_keys2
	migration_done	projections.authn_keys2
	migration_started	projections.personal_access_tokens3
	migration_done	projections.personal_access_tokens3
	migration_started	projections.user_grants5
	migration_done	projections.user_grants5
	migration_started	projections.user_metadata5
	migration_done	projections.user_metadata5
	migration_started	projections.user_auth_methods4
	migration_done	projections.user_auth_methods4
	migration_started	projections.instances
	migration_done	projections.instances
	migration_started	projections.secret_generators2
	migration_done	projections.secret_generators2
	migration_started	projections.smtp_configs2
	migration_done	projections.smtp_configs2
	migration_started	projections.sms_configs2
	migration_done	projections.sms_configs2
	migration_started	projections.oidc_settings2
	migration_done	projections.oidc_settings2
	migration_started	projections.notification_providers
	migration_done	projections.notification_providers
	migration_started	projections.keys4
	migration_done	projections.keys4
	migration_started	projections.security_policies2
	migration_done	projections.security_policies2
	migration_started	projections.notification_policies
	migration_done	projections.notification_policies
	migration_started	projections.device_auth_requests2
	migration_done	projections.device_auth_requests2
	migration_started	projections.sessions8
	migration_done	projections.sessions8
	migration_started	projections.auth_requests
	migration_done	projections.auth_requests
	migration_started	projections.milestones
	migration_done	projections.milestones
	migration_started	projections.quotas
	migration_done	projections.quotas
	migration_started	projections.limits
	migration_done	projections.limits
	migration_started	projections.restrictions2
	migration_done	projections.restrictions2
	migration_started	projections.system_features
	migration_done	projections.system_features
	migration_started	projections.instance_features2
	migration_done	projections.instance_features2
	migration_started	projections.executions
	migration_done	projections.executions
	migration_started	projections.targets
	migration_done	projections.targets
	migration_started	projections.user_schemas
	migration_done	projections.user_schemas
	migration_started	adminapi.styling2
	migration_done	adminapi.styling2
	migration_started	auth.users2
	migration_done	auth.users2
	migration_started	auth.user_sessions
	migration_done	auth.user_sessions
	migration_started	auth.tokens
	migration_done	auth.tokens
	migration_started	auth.refresh_tokens
	migration_done	auth.refresh_tokens
	migration_started	projections.notifications
	migration_done	projections.notifications
	migration_started	projections.notifications_quota
	migration_done	projections.notifications_quota
266108224564887557	appname	charts:266108518786924549
266108224564887557	usernames	charts
\.


--
-- Data for Name: access; Type: TABLE DATA; Schema: logstore; Owner: us
--

COPY logstore.access (log_date, protocol, request_url, response_status, request_headers, response_headers, instance_id, project_id, requested_domain, requested_host) FROM stdin;
\.


--
-- Data for Name: execution; Type: TABLE DATA; Schema: logstore; Owner: us
--

COPY logstore.execution (log_date, took, message, loglevel, instance_id, action_id, metadata) FROM stdin;
\.


--
-- Data for Name: actions3; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.actions3 (id, creation_date, change_date, resource_owner, instance_id, action_state, sequence, name, script, timeout, allowed_to_fail, owner_removed) FROM stdin;
\.


--
-- Data for Name: apps6; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.apps6 (id, name, project_id, creation_date, change_date, resource_owner, instance_id, state, sequence) FROM stdin;
266108224565149701	Management-API	266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	4
266108224565215237	Admin-API	266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	6
266108224565280773	Auth-API	266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	8
266108224565346309	Console	266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	12
266108631362043909	BFF	266108518786924549	2024-05-07 19:11:44.550639+00	2024-05-07 19:11:44.550639+00	266108224564953093	266108224564887557	1	4
\.


--
-- Data for Name: apps6_api_configs; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.apps6_api_configs (app_id, instance_id, client_id, client_secret, auth_method) FROM stdin;
266108224565149701	266108224564887557	266108227433791493@zitadel	\N	1
266108224565215237	266108224564887557	266108227450568709@zitadel	\N	1
266108224565280773	266108224564887557	266108227467345925@zitadel	\N	1
\.


--
-- Data for Name: apps6_oidc_configs; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.apps6_oidc_configs (app_id, instance_id, version, client_id, client_secret, redirect_uris, response_types, grant_types, application_type, auth_method_type, post_logout_redirect_uris, is_dev_mode, access_token_type, access_token_role_assertion, id_token_role_assertion, id_token_userinfo_assertion, clock_skew, additional_origins, skip_native_app_success_page) FROM stdin;
266108224565346309	266108224564887557	0	266108227467411461@zitadel	\N	{http://zitadel-i1rjad.localhost:8085/ui/console/auth/callback,http://localhost:8085/ui/console/auth/callback}	{0}	{0}	1	2	{http://zitadel-i1rjad.localhost:8085/ui/console/signedout,http://localhost:8085/ui/console/signedout}	t	0	f	f	f	0	\N	f
266108631362043909	266108224564887557	0	266108631362109445@datalens	{"KeyID": "", "Crypted": "JDJhJDEwJE5mSXZZcXVZV29jckVTSVZOUnBhVHU0bmwybDhBQ25YS2pEaWhOY082TUdWWXBhVUxXOVRl", "Algorithm": "bcrypt", "CryptoType": 1}	{http://localhost:8000/api/auth}	{0}	{0}	0	1	{http://localhost:8000/api/auth}	t	0	f	f	f	0	\N	f
\.


--
-- Data for Name: apps6_saml_configs; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.apps6_saml_configs (app_id, instance_id, entity_id, metadata, metadata_url) FROM stdin;
\.


--
-- Data for Name: apps7; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.apps7 (id, name, project_id, creation_date, change_date, resource_owner, instance_id, state, sequence) FROM stdin;
266108224565149701	Management-API	266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	4
266108224565215237	Admin-API	266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	6
266108224565280773	Auth-API	266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	8
266108224565346309	Console	266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	12
266108631362043909	Charts	266108518786924549	2024-05-07 19:11:44.550639+00	2024-05-08 14:02:07.899524+00	266108224564953093	266108224564887557	1	177
\.


--
-- Data for Name: apps7_api_configs; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.apps7_api_configs (app_id, instance_id, client_id, client_secret, auth_method) FROM stdin;
266108224565149701	266108224564887557	266108227433791493@zitadel		1
266108224565215237	266108224564887557	266108227450568709@zitadel		1
266108224565280773	266108224564887557	266108227467345925@zitadel		1
\.


--
-- Data for Name: apps7_oidc_configs; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.apps7_oidc_configs (app_id, instance_id, version, client_id, client_secret, redirect_uris, response_types, grant_types, application_type, auth_method_type, post_logout_redirect_uris, is_dev_mode, access_token_type, access_token_role_assertion, id_token_role_assertion, id_token_userinfo_assertion, clock_skew, additional_origins, skip_native_app_success_page) FROM stdin;
266108224565346309	266108224564887557	0	266108227467411461@zitadel		{http://zitadel-i1rjad.localhost:8085/ui/console/auth/callback,http://localhost:8085/ui/console/auth/callback}	{0}	{0}	1	2	{http://zitadel-i1rjad.localhost:8085/ui/console/signedout,http://localhost:8085/ui/console/signedout}	t	0	f	f	f	0	\N	f
266108631362043909	266108224564887557	0	266108631362109445@datalens	$2a$04$UTt4M56xzZjZu8KUeKnQIOOTBsZjlU057VrRKQ2BzdSfRWBvH9eyy	{http://localhost:3030/api/auth/callback}	{0}	{0,2}	0	1	{http://localhost:3030/auth}	t	0	f	f	f	0	\N	f
\.


--
-- Data for Name: apps7_saml_configs; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.apps7_saml_configs (app_id, instance_id, entity_id, metadata, metadata_url) FROM stdin;
\.


--
-- Data for Name: auth_requests; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.auth_requests (id, creation_date, change_date, sequence, resource_owner, instance_id, login_client, client_id, redirect_uri, scope, prompt, ui_locales, max_age, login_hint, hint_user_id) FROM stdin;
\.


--
-- Data for Name: authn_keys2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.authn_keys2 (id, creation_date, change_date, resource_owner, instance_id, aggregate_id, sequence, object_id, expiration, identifier, public_key, enabled, type) FROM stdin;
\.


--
-- Data for Name: current_sequences; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.current_sequences (projection_name, aggregate_type, current_sequence, instance_id, "timestamp") FROM stdin;
\.


--
-- Data for Name: current_states; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.current_states (projection_name, instance_id, last_updated, aggregate_id, aggregate_type, sequence, event_date, "position", filter_offset) FROM stdin;
projections.device_auth_requests	266108224564887557	2024-05-07 19:24:11.444383+00			0	0001-01-01 00:00:00+00	0	0
projections.apps6	266108224564887557	2024-05-07 19:24:04.662762+00	266108518786924549	project	4	2024-05-07 19:11:44.550639+00	1715109104.55087	1
projections.lockout_policies2	266108224564887557	2024-05-07 19:24:05.257591+00	266108224564887557	instance	21	2024-05-07 19:07:43.764022+00	1715108863.76432	1
projections.user_grants4	266108224564887557	2024-05-07 19:24:06.887484+00			0	0001-01-01 00:00:00+00	0	0
projections.idp_templates5	266108224564887557	2024-05-07 19:24:05.551195+00			0	0001-01-01 00:00:00+00	0	0
projections.smtp_configs1	266108224564887557	2024-05-07 19:24:12.053403+00			0	0001-01-01 00:00:00+00	0	0
projections.org_domains2	266108224564887557	2024-05-08 15:40:05.758134+00	266108224564953093	org	4	2024-05-07 19:07:43.764022+00	1715108863.76741	1
projections.notifications	266108224564887557	2024-05-08 15:40:10.097915+00	266108224565018629	user	32	2024-05-08 13:39:50.064303+00	1715175590.06432	1
projections.instance_features2	266108224564887557	2024-05-08 15:40:08.344405+00	266108224564887557	feature	1	2024-05-07 19:07:43.764022+00	1715108863.76937	1
projections.org_members4	266108224564887557	2024-05-08 15:40:23.32564+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.idps3	266108224564887557	2024-05-08 15:40:08.344423+00			0	0001-01-01 00:00:00+00	0	0
projections.instances	266108224564887557	2024-05-08 15:40:34.674743+00	266108224564887557	instance	100	2024-05-07 19:07:43.764022+00	1715108863.76761	1
projections.user_auth_methods4	266108224564887557	2024-05-08 15:40:17.898372+00			0	0001-01-01 00:00:00+00	0	0
projections.instance_domains	266108224564887557	2024-05-08 15:40:15.759144+00	266108224564887557	instance	104	2024-05-07 19:07:43.764022+00	1715108863.76935	1
projections.idp_login_policy_links5	266108224564887557	2024-05-08 15:40:19.522237+00			0	0001-01-01 00:00:00+00	0	0
projections.auth_requests	266108224564887557	2024-05-08 15:40:29.575252+00			0	0001-01-01 00:00:00+00	0	0
projections.org_metadata2	266108224564887557	2024-05-08 15:40:45.472316+00			0	0001-01-01 00:00:00+00	0	0
projections.authn_keys2	266108224564887557	2024-05-08 15:40:46.800957+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.secret_generators2	266108224564887557	2024-05-08 15:40:57.842812+00	266108224564887557	instance	11	2024-05-07 19:07:43.764022+00	1715108863.76426	2
projections.sms_configs2	266108224564887557	2024-05-08 15:40:59.278521+00			0	0001-01-01 00:00:00+00	0	0
projections.oidc_settings2	266108224564887557	2024-05-08 15:40:02.259554+00	266108224564887557	instance	105	2024-05-07 19:07:43.764022+00	1715108863.76936	1
projections.label_policies3	266108224564887557	2024-05-08 15:40:29.576285+00	266108224564887557	instance	23	2024-05-07 19:07:43.764022+00	1715108863.76433	1
projections.personal_access_tokens3	266108224564887557	2024-05-08 15:40:47.245164+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.security_policies2	266108224564887557	2024-05-08 15:40:48.524752+00			0	0001-01-01 00:00:00+00	0	0
projections.flow_triggers3	266108224564887557	2024-05-08 15:40:39.486671+00			0	0001-01-01 00:00:00+00	0	0
projections.domain_policies2	266108224564887557	2024-05-08 15:40:21.111134+00	266108224564887557	instance	14	2024-05-07 19:07:43.764022+00	1715108863.76428	1
projections.project_roles4	266108224564887557	2024-05-08 15:40:49.198769+00			0	0001-01-01 00:00:00+00	0	0
auth.tokens	266108224564887557	2024-05-08 15:40:30.090312+00	266108224565018629	user	52	2024-05-08 15:38:46.261742+00	1715182726.26177	1
projections.password_age_policies2	266108224564887557	2024-05-08 15:40:53.602284+00	266108224564887557	instance	13	2024-05-07 19:07:43.764022+00	1715108863.76428	1
projections.limits	266108224564887557	2024-05-08 15:40:56.798114+00			0	0001-01-01 00:00:00+00	0	0
projections.notifications_quota	266108224564887557	2024-05-08 15:39:06.395874+00			0	0001-01-01 00:00:00+00	0	0
projections.notification_providers	266108224564887557	2024-05-08 15:40:06.200564+00			0	0001-01-01 00:00:00+00	0	0
projections.sessions8	266108224564887557	2024-05-08 15:40:30.574183+00	266108224565018629	user	32	2024-05-08 13:39:50.064303+00	1715175590.06432	1
projections.quotas	266108224564887557	2024-05-08 15:40:04.096005+00			0	0001-01-01 00:00:00+00	0	0
projections.custom_texts2	266108224564887557	2024-05-08 15:40:05.758077+00	266108224564887557	instance	96	2024-05-07 19:07:43.764022+00	1715108863.76739	1
projections.projects4	266108224564887557	2024-05-08 15:40:31.237919+00	266108518786924549	project	1	2024-05-07 19:10:37.35547+00	1715109037.35548	1
projections.message_texts2	266108224564887557	2024-05-08 15:40:06.76751+00	266108224564887557	instance	96	2024-05-07 19:07:43.764022+00	1715108863.76739	1
projections.project_grants4	266108224564887557	2024-05-08 15:40:16.809231+00			0	0001-01-01 00:00:00+00	0	0
auth.refresh_tokens	266108224564887557	2024-05-08 15:40:43.750083+00	266108224565018629	user	53	2024-05-08 15:38:46.261742+00	1715182726.26195	1
projections.login_policies5	266108224564887557	2024-05-08 15:40:32.292875+00	266108224564887557	instance	18	2024-05-07 19:07:43.764022+00	1715108863.7643	2
projections.system_features	266108224564887557	2024-05-08 15:40:45.472227+00			0	0001-01-01 00:00:00+00	0	0
projections.privacy_policies3	266108224564887557	2024-05-08 15:40:33.518602+00	266108224564887557	instance	19	2024-05-07 19:07:43.764022+00	1715108863.76431	1
projections.restrictions2	266108224564887557	2024-05-08 15:40:08.795597+00			0	0001-01-01 00:00:00+00	0	0
projections.actions3	266108224564887557	2024-05-08 15:40:19.522245+00			0	0001-01-01 00:00:00+00	0	0
projections.login_names3	266108224564887557	2024-05-08 15:40:19.522564+00	266219708343123977	user	1	2024-05-08 13:35:11.508041+00	1715175311.50805	1
projections.password_complexity_policies2	266108224564887557	2024-05-08 15:40:22.322166+00	266108224564887557	instance	12	2024-05-07 19:07:43.764022+00	1715108863.76427	1
adminapi.styling2	266108224564887557	2024-05-08 15:40:22.491033+00	266108224564887557	instance	23	2024-05-07 19:07:43.764022+00	1715108863.76433	1
projections.instance_members4	266108224564887557	2024-05-08 15:40:47.245197+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.users10	266108224564887557	2024-05-07 19:24:12.281536+00	266108224565018629	user	5	2024-05-07 19:10:08.214015+00	1715109008.21403	1
projections.user_schemas	266108224564887557	2024-05-08 15:40:05.162247+00			0	0001-01-01 00:00:00+00	0	0
projections.mail_templates2	266108224564887557	2024-05-08 15:40:05.758078+00	266108224564887557	instance	24	2024-05-07 19:07:43.764022+00	1715108863.76434	1
projections.device_auth_requests2	266108224564887557	2024-05-08 15:40:09.301925+00			0	0001-01-01 00:00:00+00	0	0
auth.user_sessions	266108224564887557	2024-05-08 15:40:21.648544+00	266108224565018629	user	51	2024-05-08 15:38:45.807798+00	1715182725.80782	1
projections.project_grant_members4	266108224564887557	2024-05-08 15:40:26.333074+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.milestones	266108224564887557	2024-05-08 15:40:26.916411+00	266108224565018629	user	52	2024-05-08 15:38:46.261742+00	1715182726.26177	1
projections.smtp_configs2	266108224564887557	2024-05-08 15:40:29.574595+00			0	0001-01-01 00:00:00+00	0	0
projections.notification_policies	266108224564887557	2024-05-08 15:40:29.575991+00	266108224564887557	instance	20	2024-05-07 19:07:43.764022+00	1715108863.76431	1
auth.users2	266108224564887557	2024-05-08 15:40:32.62336+00	266108224565018629	user	32	2024-05-08 13:39:50.064303+00	1715175590.06432	1
projections.lockout_policies3	266108224564887557	2024-05-08 15:40:33.613346+00	266108224564887557	instance	21	2024-05-07 19:07:43.764022+00	1715108863.76432	1
projections.project_members4	266108224564887557	2024-05-08 15:40:35.181468+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.users12	266108224564887557	2024-05-08 15:40:38.757486+00	266219708343123977	user	12	2024-05-08 14:03:01.434117+00	1715176981.43413	1
projections.executions	266108224564887557	2024-05-08 15:40:39.486474+00			0	0001-01-01 00:00:00+00	0	0
projections.user_grants5	266108224564887557	2024-05-08 15:40:43.93325+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.idp_templates6	266108224564887557	2024-05-08 15:40:43.933365+00			0	0001-01-01 00:00:00+00	0	0
projections.apps7	266108224564887557	2024-05-08 15:40:00.334539+00	266108518786924549	project	177	2024-05-08 14:02:07.899524+00	1715176927.89954	1
projections.idp_user_links3	266108224564887557	2024-05-08 15:40:44.702685+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.user_metadata5	266108224564887557	2024-05-08 15:40:57.256063+00	266216654839480329	user	9	2024-05-08 13:35:00.471164+00	1715175300.47118	1
projections.keys4	266108224564887557	2024-05-08 15:40:02.259583+00	266213247571460105	key_pair	1	2024-05-08 12:31:00.570953+00	1715171460.57097	1
projections.orgs1	266108224564887557	2024-05-08 15:40:04.095906+00	266108224564953093	org	4	2024-05-07 19:07:43.764022+00	1715108863.76741	1
projections.targets	266108224564887557	2024-05-08 15:40:05.156119+00			0	0001-01-01 00:00:00+00	0	0
\.


--
-- Data for Name: custom_texts2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.custom_texts2 (aggregate_id, instance_id, creation_date, change_date, sequence, is_default, template, language, key, text, owner_removed) FROM stdin;
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	25	t	InitCode	de	Greeting	Hallo {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	26	t	InitCode	de	Subject	User initialisieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	27	t	InitCode	de	Title	Zitadel - User initialisieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	28	t	InitCode	de	PreHeader	User initialisieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	29	t	InitCode	de	Text	Dieser Benutzer wurde soeben im Zitadel erstellt. Mit dem Benutzernamen &lt;br&gt;&lt;strong&gt;{{.PreferredLoginName}}&lt;/strong&gt;&lt;br&gt; kannst du dich anmelden. Nutze den untenstehenden Button, um die Initialisierung abzuschliessen &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du dieses Mail nicht angefordert hast, kannst du es einfach ignorieren.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	30	t	InitCode	de	ButtonText	Initialisierung abschliessen	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	31	t	PasswordReset	de	Greeting	Hallo {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	32	t	PasswordReset	de	Subject	Passwort zurücksetzen	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	33	t	PasswordReset	de	Title	Zitadel - Passwort zurücksetzen	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	34	t	PasswordReset	de	PreHeader	Passwort zurücksetzen	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	35	t	PasswordReset	de	Text	Wir haben eine Anfrage für das Zurücksetzen deines Passwortes bekommen. Du kannst den untenstehenden Button verwenden, um dein Passwort zurückzusetzen &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du dieses Mail nicht angefordert hast, kannst du es ignorieren.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	36	t	PasswordReset	de	ButtonText	Passwort zurücksetzen	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	37	t	VerifyEmail	de	Greeting	Hallo {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	38	t	VerifyEmail	de	Subject	Email verifizieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	39	t	VerifyEmail	de	Title	Zitadel - Email verifizieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	40	t	VerifyEmail	de	PreHeader	Email verifizieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	41	t	VerifyEmail	de	Text	Eine neue E-Mail Adresse wurde hinzugefügt. Bitte verwende den untenstehenden Button um diese zu verifizieren &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du deine E-Mail Adresse nicht selber hinzugefügt hast, kannst du dieses E-Mail ignorieren.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	42	t	VerifyEmail	de	ButtonText	Email verifizieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	43	t	VerifyPhone	de	Greeting	Hallo {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	44	t	VerifyPhone	de	Subject	Telefonnummer verifizieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	45	t	VerifyPhone	de	Title	Zitadel - Telefonnummer verifizieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	46	t	VerifyPhone	de	PreHeader	Telefonnummer verifizieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	47	t	VerifyPhone	de	Text	Eine Telefonnummer wurde hinzugefügt. Bitte verifiziere diese in dem du folgenden Code eingibst (Code {{.Code}})	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	48	t	VerifyPhone	de	ButtonText	Telefon verifizieren	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	49	t	DomainClaimed	de	Greeting	Hallo {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	50	t	DomainClaimed	de	Subject	Domain wurde beansprucht	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	51	t	DomainClaimed	de	Title	Zitadel - Domain wurde beansprucht	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	52	t	DomainClaimed	de	PreHeader	Email / Username ändern	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	53	t	DomainClaimed	de	Text	Die Domain {{.Domain}} wurde von einer Organisation beansprucht. Dein derzeitiger User {{.Username}} ist nicht Teil dieser Organisation. Daher musst du beim nächsten Login eine neue Email hinterlegen. Für diesen Login haben wir dir einen temporären Usernamen ({{.TempUsername}}) erstellt.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	54	t	DomainClaimed	de	ButtonText	Login	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	55	t	PasswordChange	de	Greeting	Hallo {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	56	t	PasswordChange	de	Subject	Passwort von Benutzer wurde geändert	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	57	t	PasswordChange	de	Title	ZITADEL - Passwort von Benutzer wurde geändert	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	58	t	PasswordChange	de	PreHeader	Passwort Änderung	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	59	t	PasswordChange	de	Text	Das Password vom Benutzer wurde geändert. Wenn diese Änderung von jemand anderem gemacht wurde, empfehlen wir die sofortige Zurücksetzung ihres Passworts.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	60	t	PasswordChange	de	ButtonText	Login	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	61	t	InitCode	en	Greeting	Hello {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	62	t	InitCode	en	Subject	Initialize User	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	63	t	InitCode	en	Title	Zitadel - Initialize User	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	64	t	InitCode	en	PreHeader	Initialize User	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	65	t	InitCode	en	Text	This user was created in Zitadel. Use the username {{.PreferredLoginName}} to login. Please click the button below to finish the initialization process. (Code {{.Code}}) If you didn't ask for this mail, please ignore it.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	66	t	InitCode	en	ButtonText	Finish initialization	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	67	t	PasswordReset	en	Greeting	Hello {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	68	t	PasswordReset	en	Subject	Reset password	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	69	t	PasswordReset	en	Title	Zitadel - Reset password	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	70	t	PasswordReset	en	PreHeader	Reset password	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	71	t	PasswordReset	en	Text	We received a password reset request. Please use the button below to reset your password. (Code {{.Code}}) If you didn't ask for this mail, please ignore it.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	72	t	PasswordReset	en	ButtonText	Reset password	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	73	t	VerifyEmail	en	Greeting	Hello {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	74	t	VerifyEmail	en	Subject	Verify email	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	75	t	VerifyEmail	en	Title	Zitadel - Verify email	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	76	t	VerifyEmail	en	PreHeader	Verify email	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	77	t	VerifyEmail	en	Text	A new email has been added. Please use the button below to verify your email. (Code {{.Code}}) If you din't add a new email, please ignore this email.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	78	t	VerifyEmail	en	ButtonText	Verify email	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	79	t	VerifyPhone	en	Greeting	Hello {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	80	t	VerifyPhone	en	Subject	Verify phone	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	81	t	VerifyPhone	en	Title	Zitadel - Verify phone	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	82	t	VerifyPhone	en	PreHeader	Verify phone	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	83	t	VerifyPhone	en	Text	A new phone number has been added. Please use the following code to verify it {{.Code}}.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	84	t	VerifyPhone	en	ButtonText	Verify phone	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	85	t	DomainClaimed	en	Greeting	Hello {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	86	t	DomainClaimed	en	Subject	Domain has been claimed	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	87	t	DomainClaimed	en	Title	Zitadel - Domain has been claimed	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	88	t	DomainClaimed	en	PreHeader	Change email/username	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	89	t	DomainClaimed	en	Text	The domain {{.Domain}} has been claimed by an organization. Your current user {{.UserName}} is not part of this organization. Therefore you'll have to change your email when you login. We have created a temporary username ({{.TempUsername}}) for this login.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	90	t	DomainClaimed	en	ButtonText	Login	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	91	t	PasswordChange	en	Greeting	Hello {{.DisplayName}},	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	92	t	PasswordChange	en	Subject	Password of user has changed	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	93	t	PasswordChange	en	Title	ZITADEL - Password of user has changed	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	94	t	PasswordChange	en	PreHeader	Change password	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	95	t	PasswordChange	en	Text	The password of your user has changed. If this change was not done by you, please be advised to immediately reset your password.	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	96	t	PasswordChange	en	ButtonText	Login	f
\.


--
-- Data for Name: device_auth_requests; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.device_auth_requests (client_id, device_code, user_code, scopes, creation_date, change_date, sequence, instance_id) FROM stdin;
\.


--
-- Data for Name: device_auth_requests2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.device_auth_requests2 (client_id, device_code, user_code, scopes, audience, creation_date, change_date, sequence, instance_id) FROM stdin;
\.


--
-- Data for Name: domain_policies2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.domain_policies2 (id, creation_date, change_date, sequence, state, user_login_must_be_domain, validate_org_domains, smtp_sender_address_matches_instance_domain, is_default, resource_owner, instance_id, owner_removed) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	14	1	f	f	f	t	266108224564887557	266108224564887557	f
\.


--
-- Data for Name: executions; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.executions (id, creation_date, change_date, resource_owner, instance_id, sequence, targets, includes) FROM stdin;
\.


--
-- Data for Name: failed_events; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.failed_events (projection_name, failed_sequence, failure_count, error, instance_id, last_failed) FROM stdin;
\.


--
-- Data for Name: failed_events2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.failed_events2 (projection_name, instance_id, aggregate_type, aggregate_id, event_creation_date, failed_sequence, failure_count, error, last_failed) FROM stdin;
projections.notifications	266108224564887557	user	266108224565018629	2024-05-07 19:10:08.214015+00	5	10	ID=QUERY-fwofw Message=Errors.SMTPConfig.NotFound Parent=(sql: no rows in result set)	2024-05-07 19:10:59.268386+00
projections.notifications	266108224564887557	user	266108224565018629	2024-05-08 13:38:23.553067+00	27	10	ID=QUERY-fwofw Message=Errors.SMTPConfig.NotFound Parent=(sql: no rows in result set)	2024-05-08 13:38:55.647446+00
projections.notifications	266108224564887557	user	266108224565018629	2024-05-08 13:39:50.064303+00	32	10	ID=QUERY-fwofw Message=Errors.SMTPConfig.NotFound Parent=(sql: no rows in result set)	2024-05-08 13:40:01.250171+00
\.


--
-- Data for Name: flow_triggers3; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.flow_triggers3 (flow_type, change_date, sequence, trigger_type, resource_owner, instance_id, trigger_sequence, action_id) FROM stdin;
\.


--
-- Data for Name: idp_login_policy_links5; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_login_policy_links5 (idp_id, aggregate_id, creation_date, change_date, sequence, resource_owner, instance_id, provider_type, owner_removed) FROM stdin;
\.


--
-- Data for Name: idp_templates5; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5 (id, creation_date, change_date, sequence, resource_owner, instance_id, state, name, owner_type, type, owner_removed, is_creation_allowed, is_linking_allowed, is_auto_creation, is_auto_update) FROM stdin;
\.


--
-- Data for Name: idp_templates5_apple; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_apple (idp_id, instance_id, client_id, team_id, key_id, private_key, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates5_azure; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_azure (idp_id, instance_id, client_id, client_secret, scopes, tenant, is_email_verified) FROM stdin;
\.


--
-- Data for Name: idp_templates5_github; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_github (idp_id, instance_id, client_id, client_secret, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates5_github_enterprise; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_github_enterprise (idp_id, instance_id, client_id, client_secret, authorization_endpoint, token_endpoint, user_endpoint, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates5_gitlab; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_gitlab (idp_id, instance_id, client_id, client_secret, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates5_gitlab_self_hosted; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_gitlab_self_hosted (idp_id, instance_id, issuer, client_id, client_secret, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates5_google; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_google (idp_id, instance_id, client_id, client_secret, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates5_jwt; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_jwt (idp_id, instance_id, issuer, jwt_endpoint, keys_endpoint, header_name) FROM stdin;
\.


--
-- Data for Name: idp_templates5_ldap2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_ldap2 (idp_id, instance_id, servers, start_tls, base_dn, bind_dn, bind_password, user_base, user_object_classes, user_filters, timeout, id_attribute, first_name_attribute, last_name_attribute, display_name_attribute, nick_name_attribute, preferred_username_attribute, email_attribute, email_verified, phone_attribute, phone_verified_attribute, preferred_language_attribute, avatar_url_attribute, profile_attribute) FROM stdin;
\.


--
-- Data for Name: idp_templates5_oauth2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_oauth2 (idp_id, instance_id, client_id, client_secret, authorization_endpoint, token_endpoint, user_endpoint, scopes, id_attribute) FROM stdin;
\.


--
-- Data for Name: idp_templates5_oidc; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_oidc (idp_id, instance_id, issuer, client_id, client_secret, scopes, id_token_mapping) FROM stdin;
\.


--
-- Data for Name: idp_templates5_saml; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates5_saml (idp_id, instance_id, metadata, key, certificate, binding, with_signed_request) FROM stdin;
\.


--
-- Data for Name: idp_templates6; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6 (id, creation_date, change_date, sequence, resource_owner, instance_id, state, name, owner_type, type, owner_removed, is_creation_allowed, is_linking_allowed, is_auto_creation, is_auto_update, auto_linking) FROM stdin;
\.


--
-- Data for Name: idp_templates6_apple; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_apple (idp_id, instance_id, client_id, team_id, key_id, private_key, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates6_azure; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_azure (idp_id, instance_id, client_id, client_secret, scopes, tenant, is_email_verified) FROM stdin;
\.


--
-- Data for Name: idp_templates6_github; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_github (idp_id, instance_id, client_id, client_secret, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates6_github_enterprise; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_github_enterprise (idp_id, instance_id, client_id, client_secret, authorization_endpoint, token_endpoint, user_endpoint, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates6_gitlab; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_gitlab (idp_id, instance_id, client_id, client_secret, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates6_gitlab_self_hosted; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_gitlab_self_hosted (idp_id, instance_id, issuer, client_id, client_secret, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates6_google; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_google (idp_id, instance_id, client_id, client_secret, scopes) FROM stdin;
\.


--
-- Data for Name: idp_templates6_jwt; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_jwt (idp_id, instance_id, issuer, jwt_endpoint, keys_endpoint, header_name) FROM stdin;
\.


--
-- Data for Name: idp_templates6_ldap2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_ldap2 (idp_id, instance_id, servers, start_tls, base_dn, bind_dn, bind_password, user_base, user_object_classes, user_filters, timeout, id_attribute, first_name_attribute, last_name_attribute, display_name_attribute, nick_name_attribute, preferred_username_attribute, email_attribute, email_verified, phone_attribute, phone_verified_attribute, preferred_language_attribute, avatar_url_attribute, profile_attribute) FROM stdin;
\.


--
-- Data for Name: idp_templates6_oauth2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_oauth2 (idp_id, instance_id, client_id, client_secret, authorization_endpoint, token_endpoint, user_endpoint, scopes, id_attribute) FROM stdin;
\.


--
-- Data for Name: idp_templates6_oidc; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_oidc (idp_id, instance_id, issuer, client_id, client_secret, scopes, id_token_mapping) FROM stdin;
\.


--
-- Data for Name: idp_templates6_saml; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_templates6_saml (idp_id, instance_id, metadata, key, certificate, binding, with_signed_request) FROM stdin;
\.


--
-- Data for Name: idp_user_links3; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idp_user_links3 (idp_id, user_id, external_user_id, creation_date, change_date, sequence, resource_owner, instance_id, display_name, owner_removed) FROM stdin;
\.


--
-- Data for Name: idps3; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idps3 (id, creation_date, change_date, sequence, resource_owner, instance_id, state, name, styling_type, owner_type, auto_register, type, owner_removed) FROM stdin;
\.


--
-- Data for Name: idps3_jwt_config; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idps3_jwt_config (idp_id, instance_id, issuer, keys_endpoint, header_name, endpoint) FROM stdin;
\.


--
-- Data for Name: idps3_oidc_config; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.idps3_oidc_config (idp_id, instance_id, client_id, client_secret, issuer, scopes, display_name_mapping, username_mapping, authorization_endpoint, token_endpoint) FROM stdin;
\.


--
-- Data for Name: instance_domains; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.instance_domains (instance_id, creation_date, change_date, sequence, domain, is_generated, is_primary) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	104	zitadel-i1rjad.localhost	t	f
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	104	localhost	f	t
\.


--
-- Data for Name: instance_features2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.instance_features2 (instance_id, key, creation_date, change_date, sequence, value) FROM stdin;
266108224564887557	login_default_org	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	1	true
\.


--
-- Data for Name: instance_members4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.instance_members4 (creation_date, change_date, user_id, user_resource_owner, roles, sequence, resource_owner, instance_id, id) FROM stdin;
2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224565018629	266108224564953093	{IAM_OWNER}	98	266108224564887557	266108224564887557	266108224564887557
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.instances (id, name, change_date, creation_date, default_org_id, iam_project_id, console_client_id, console_app_id, sequence, default_language) FROM stdin;
266108224564887557	ZITADEL	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224565084165	266108227467411461@zitadel	266108224565346309	100	en
\.


--
-- Data for Name: keys4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.keys4 (id, creation_date, change_date, resource_owner, instance_id, sequence, algorithm, use) FROM stdin;
266108480518094853	2024-05-07 19:10:14.54762+00	2024-05-07 19:10:14.54762+00	266108224564887557	266108224564887557	1	RS256	0
266213247571460105	2024-05-08 12:31:00.570953+00	2024-05-08 12:31:00.570953+00	266108224564887557	266108224564887557	1	RS256	0
\.


--
-- Data for Name: keys4_certificate; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.keys4_certificate (id, instance_id, expiry, certificate) FROM stdin;
\.


--
-- Data for Name: keys4_private; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.keys4_private (id, instance_id, expiry, key) FROM stdin;
266108480518094853	266108224564887557	2024-05-08 01:10:14.535841+00	{"KeyID": "oidcKey", "Crypted": "EA8WmqhS/OYVBHtcVUo2D8rBIK7zl7iFGPsvjxXQap5u6SiX3/7awHlwaiTf3ZLms0ZLcGx1A3qC119aiqEv5HByYeI+1fWdrBzs3lLTlsKT4rhA82qr6NzLf0IABEZXuqxKK7QuLijq6LOuwBhgRp+oU6oK4z+0d+wmRcIRmwlfHY7HY0n6GNqLa/jr+QMBPrCE7dvQ2iKWC9DD45Ubq7cZ2oZ5UJYWXZRxhUQMmeqzsS0OMvHt79V2ejE1lgWiTvU59gS9qf3sl4jwbIb78zHRIPlHIgsRp77mnAGFDmIhbCPJZzr2mohHhxwVpV9pmO9iksPq4DGA2zx4syG7UN7hzAGtV+5zONi+UJ8+T9kC8D4nV83TbXB51PAaeiGzyhzhXaH+FzMB3IqDRMkwnMx8PyvBMdS6LeZ2jd3biR7hdcvOSVC/x3gLSpApDz9+OjYzZX3hhRDlnO0zVyTcOJpGMh9XVouMoF8Fkz8k23pOUNNMkAIO0qWS67aU9qXmbOeF0Tq8sIk0UbQ8kRC3gig06+f4czAIFxgMXDihJo+li1leRvNcT1diMJJeVcttK0xNyyD71eTvsra/hiJJ3Y/7j6Zge1w3z7A1b+/vOVpKCFHqnBwTgQlXGcx3WRSxYNge5CBohKsFbR4WwAmP5WNYZH8u/M/8qCaPt5m5q+n2cO5ChZ1Xqpbk6zU15GZQgrw0fBpK5oS5AUk5hgPNU+DmWFMjRiObFOb2rawXHGl3UlPeEI00TfUxxWG6Jy3VLOtNzA6MsqE30XFc+onb8+h77CYkKxC4qNaUbTceMYGNbLSd+X9zD0PhzBI8MIlxiYAfENL+9olLIgFlVeh10ZD1DXPM1BdY3f6b3GgM/9rQ85J0h2HJdxas+q/I60ty01fd5a7+X12WL7mXbF6tIEi40zzGn6BzwSgmjbz+aCEdmLpauHIxO8iVFbZo9aeWGVAQyXGny8xFtx4PRdD3aQmSfPt4VHutNvd2PhzQ6GEWpmc52+/5ZTNHQ4pfyE8sMKnUHug20nWiS8T0G2AHisggEA+pn3DbgxhgzbhuKN9a9FitmxDbGTMDuFYrrBekbL1tqVOXtBzug09MYCNz0WsMOL8d6250EmYOZTj9X3kZlZWWH9cFP6KTmlfhAaBZiafGrKViA+3ykndjwJx1GYL2qa+BIUwaizdppuSLEijxNOCIxGgi31zUMYsJk4QU1eQJZdt/a3xn5KY/Nn1xC/HP6NC4cize1vzLc1M/zXWpBB5no74MIZ1peBd3UAEQ/UOOwUk1Ug8Pjcx/G3g7cClrrOdD97knuDHkdlQBex9KeuP6WeQpi/og+UGZLdl12HRNb/ciIAmZWOY85rgGuyCS9goteTCHq/qg9mVZZqUW6wQdJXtwsSPRvv982DW/Ux4SXXHJQEvEQfhUeN8HmTItMdW3aAEmSFKPQnjrK2tgpeA4XZCjz36Bj/MUgRw+mmtq7Ab5BszFief2I+VOhCd50tK/5ZB6FPnUsVHQ+3n+FZnvXkghP9HN6NBJVT8sPOgoy54+o/UGYQ4g480xU/u4aMpJ8pz3Y41wpft14nVIOjtH0/v6toeDmo5AzDuNxX5PUwrF5GI3Rmoh8KHgzFSG+11+Ganw5t/N6RgoPPAB4HqWHuIHoCeK8WEfhUfChsRKHpg/Y1HcL6bE2DIFDyLnmGMovQYCwPAP4URqJ87YjYlydlNOoIC0IIlPTuZfA3lQcAgDGqISA/9HY4pWtY2zHa9Q3k8dW5NGHNBVq9rMJpx2hg0XVkvZY5P+OLsadfGjz4ufOwlUzYE5zs2o4j/2B81wcCrn/D5+/j95C5tn0yzXQ1spNGzX25GIFbIERKPgr+XbrL5fXLPxyqQY3/ilU1g0B/HMbOb6jeUebo0Cl5H3hDrPu/t365Kfa7jt4ic8qnqoInIpwIkR1EVqewPPOSr4pbLYq8y/0UUtZJ0Yo0kaJUn0phhJB2SLdwS0KtVeZZDGG9ODbVgWi2VmJbJq7jZWGLfrx8QZOpdndWsNLcch8GWvC8IHwDf6aY7NEM9xS2GUYVtB37aBfnwecFfM2bTdX/0bX3FaOW6FyMXrm4AVbpny+O+RTS2f1AUfd5dHi07K1obe9iXzLIO6MMZDWdy2JPJVF4rk246gjLlGHYm/9AphbqT1SS7QgoSvnaJ2kRFGNgRiTWeQfbWuXtt3dtUcjsU76NczAnM8RUjjur/178e8YJbdmCODAcTAKZ4ReoxHJ3X5UN3La7GE", "Algorithm": "aes", "CryptoType": 0}
266213247571460105	266108224564887557	2024-05-08 18:31:00.56452+00	{"KeyID": "oidcKey", "Crypted": "YRpaaksRKMt58gjdyGBmUgLj52+4v61iy/mi8DOG5fchmxgectYuYPUn5T+S6rWkLT1D47GphaB/5w71QySjYxVENQDtGWdPn8hh/IFeWu+TesrX0lv/Fdh8yHMF5niUutwKL/BrgJMptjr3yVnKQrylNmgkea44YsBIZqBmzHlb3vYd+PNuOK6l+ZuRax6Yvn/7P/AvhBDxQrKVfse2cuBzDN1b3ri4nEdCJcZtCWLeHFAyB/aVa0esnVzrke4Siqnf2bn/JdrTLDckzM9SPgFi0Z4rVugExfYaQasEXwNh61xwlcbgg5tCXA/Rt0qyYNW8JF5AMWjl6HuDueJEB2+T0GEwSQZ6pQQGk9cW1evpcK28Y/ED0OPz9AmIOfCDmmD+x6xcUJOl1S7f3eqm2DiskKy9Y7ZQhHLM3lbU8c5Y2mhbykODSr+BXeofWiaZefZpmcNMkMC1N+Fy6vheNvXTG02bFM0s2TWs3BbZZ32oLD0DvxI9e/EtJkTNgPiztzEi9N77bNkHTMIjkICqQ4VEgjkudYehkKMw5Iuigd/BVARQXCL2LC8l5CVENU3R0VsnXv+14y4YxrvHQZTCKqZqqge2kJmD705ywqTKYS2lmszM7/VZaz7yZGKhGsuYvVpow6lnokQ1NgL7ywQo+Pk5l4fXV3XSS4+KJ2os8EBbiddGIFhUMaeN1upHxkfnu3oFOSvwE/ba4V4mPydiwyrd7f4A1+lf11W2iUSCUte1GohDNsaPvdwfwkxcchx1Mpz9J/EdJV3MPR6k5yJxlEga5SwANtop4JnMfHNPKd0JfN/84gpupm04bCA68GECdkhwBJ1+DfSAb/dVQ9sRnAWImgdvkzRGKqGfhG3IP+GQDVQ1XeGo8QWgvObJTX3jOpLh92V4MQZMkjiEmHhcNAS/me5ufuoXwjcNktwEhtvXqoy1d/IzU994TsMZDtDOdw9hv9LxToJ3qcyrP3XF8N0GyrH5AEB7PbKk8YpMipWG5I2WihHrcYI0VJ4uVoDa0ubEt3+MVVcl5rWnAkhrUcR0fLxx+PefMfSeABPrmH8d9xZ0IZ73QHGgu/2PqAlziWn5Scl3GHLBk4tOnBLV9iA7YKXSjSsZUAQT9hj1BnoM8FkwHlUD+5Q6wfziWvcGmNkzkHMCohd/oUzwhzXRjoLBPS66urFVVPciWgEjown892vn7Lh+Gs8Puv6oOkVMGKW3rTaMqXNnPani+rSVG7fnYBSk/AohH7QwnZHnJSPz6s93vf1vx35b0O9ywRzIg7IF8LoxvyzHLn/FMl3VKj2satBmciNBU2EnUcIMcSvQHF3vgmG9amJDN1Z/MxreGdUWqUauRKwfHGxi7zfKbBEp5ukzRlmVD7VkVsg4UOCprOlyLjjCfS3VxWQ49P9QR6bb1LSR8fU6Yfc5SOrxLyclfn3tEjKbKlTMW9pw7cO6qRvOitdhHZ1yvE5nBBpkrDqNw6jb03y0KHscYMrQRpAUgcUDRL1NIjm5l8/w5em0/Gw58lVGLsALBHcMhn8qkPh19wwnh3xAG2Ihc2GOW2ELjG1MG3hybtI51S3l1AAu8LlZtvwARWqNBzbSYEi0HNrdT+jleDvnhoAd8HBAO86PD5z9okjDSWinunWe6KSMHGqaHmfHgTRDWaug0uYWki8X+xUMHn+1P6BzlFtpVKD2qTDBamRtc5eIbzAVo/b4e/5slyk4vNSdFSp/nyBAIZconOjTxWLhPSms+fo6Iyg54oKrRHht1vlNie91cla6SBb0CHBV+bz5KhbnYAJRu8i/qwbuzk6IrWKdJIJ7sPbTQ+zLX6nZfuIWhtIVWkIpRpo71PkvyBl84whb6cXtrfolysKAU0QilGSKBPx6sdj48CdE56XEAgXJwNRU7GrUK7pd/npuPtKHhw+gvqTJAOBpwtB6jrnh7Ea2rLPeySqZ1GxtZyOerL9JkYeOVJqo8Okh6jd4woK5Hl8I/pnnN2g4/RPW7Ht+LAcrTC9P4t94+DXUeQqCwyL2Noqj2U+RhfzMjpN3k76QVO77jSIxcESXnZEzo7Nn+SsdadkE0mYUrGxr2O044mEpo9rM1kf4Fl/he9mvc4oRRXcJh/1+0x71gUBkp75yEHL9InbkUNq9CFmiF9ZP54wNVg5rK2IFyNuRF/IcO5V+RGQAa1XM0u7+TNDQiXErJ7QFT6RCJyanloY1pC+I1tTwkhBceXYDz8FF3agsizHphj3BJLojR+57xe0WQ9l57czF5ZHX", "Algorithm": "aes", "CryptoType": 0}
\.


--
-- Data for Name: keys4_public; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.keys4_public (id, instance_id, expiry, key) FROM stdin;
266108480518094853	266108224564887557	2024-05-09 01:10:14.535841+00	\\x2d2d2d2d2d424547494e20525341205055424c4943204b45592d2d2d2d2d0a4d494942496a414e42676b71686b6947397730424151454641414f43415138414d49494243674b43415145413637353157552f377073514d30534476475242670a4d7947377064556a78684c324b46434d6b705734587a55796d3543645a76644171555a4f7050364d5348434e55366e306e635a333862486d716958464c66596e0a46786444567a6e57792f3377676b503157446d34434277596a795956392f6171356b3043586c6e6234646959386a784f7439365279774b5563325944337965570a4a4a793741366c6950576c52736c6e5347567652694f2b4d65556c4d415572374a34475479676c334f3132314459755833634f446235714d414236764755504c0a42786d542f6754784d6277534d6e546f517135395a66374f754f6664465063795452574d394b6d32492b2f694956744a77462f78436b65744b416c62564344340a78487366614670463863395031675a324e3832477442673430434d624d436165722b59474c683374596a643351457439486650304c54376d702b345169556b700a68514944415141420a2d2d2d2d2d454e4420525341205055424c4943204b45592d2d2d2d2d0a
266213247571460105	266108224564887557	2024-05-09 18:31:00.564521+00	\\x2d2d2d2d2d424547494e20525341205055424c4943204b45592d2d2d2d2d0a4d494942496a414e42676b71686b6947397730424151454641414f43415138414d49494243674b434151454130305668384231676f6d662f79466b5a764a4f370a4b64346e514e77672f78455a454a67316f4a39414755714f6c65314a3735567a6d442b456f334d484b674b394b3553686c744b556c57512f57376b4142574d740a4e713738343458335365675976314261302b3458486a50752f45675165314470646b7236626131354d433068597263527975456439593033584641584631674c0a674d636a31793574396d7633525254796b5237633232754a47644976345558345473546f4d786b566e326f50755032786b716e34423271633272747a7358554c0a734b6f49707365326646534a4d7a5778305a3854774c38635368564136564a6b387a362f4d7749416e7a504a674d4856646379585933324c3366564c30654d5a0a4f6b74486e345155454a44496a4b4f57386852416845655a5668716c6b536e38794179345042306b4d5a7257716f544f75754a413663743278444e6275746b490a7a514944415141420a2d2d2d2d2d454e4420525341205055424c4943204b45592d2d2d2d2d0a
\.


--
-- Data for Name: label_policies3; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.label_policies3 (id, creation_date, change_date, sequence, state, is_default, resource_owner, instance_id, hide_login_name_suffix, watermark_disabled, should_error_popup, font_url, light_primary_color, light_warn_color, light_background_color, light_font_color, light_logo_url, light_icon_url, dark_primary_color, dark_warn_color, dark_background_color, dark_font_color, dark_logo_url, dark_icon_url, owner_removed, theme_mode) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	22	3	t	266108224564887557	266108224564887557	f	f	f	\N	#5469d4	#cd3d56	#fafafa	#000000	\N	\N	#2073c4	#ff3b5b	#111827	#ffffff	\N	\N	f	0
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	23	1	t	266108224564887557	266108224564887557	f	f	f	\N	#5469d4	#cd3d56	#fafafa	#000000	\N	\N	#2073c4	#ff3b5b	#111827	#ffffff	\N	\N	f	0
\.


--
-- Data for Name: limits; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.limits (aggregate_id, creation_date, change_date, resource_owner, instance_id, sequence, audit_log_retention, block) FROM stdin;
\.


--
-- Data for Name: lockout_policies2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.lockout_policies2 (id, creation_date, change_date, sequence, state, is_default, resource_owner, instance_id, max_password_attempts, show_failure, owner_removed) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	21	1	t	266108224564887557	266108224564887557	0	t	f
\.


--
-- Data for Name: lockout_policies3; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.lockout_policies3 (id, creation_date, change_date, sequence, state, is_default, resource_owner, instance_id, max_password_attempts, max_otp_attempts, show_failure) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	21	1	t	266108224564887557	266108224564887557	0	0	t
\.


--
-- Data for Name: locks; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.locks (locker_id, locked_until, projection_name, instance_id) FROM stdin;
266213242538295305	2024-05-08 12:31:07.92+00	signing_key	266108224564887557
\.


--
-- Data for Name: login_names3_domains; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.login_names3_domains (name, is_primary, resource_owner, instance_id) FROM stdin;
zitadel.localhost	t	266108224564953093	266108224564887557
\.


--
-- Data for Name: login_names3_policies; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.login_names3_policies (must_be_domain, is_default, resource_owner, instance_id) FROM stdin;
f	t	266108224564887557	266108224564887557
\.


--
-- Data for Name: login_names3_users; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.login_names3_users (id, user_name, resource_owner, instance_id) FROM stdin;
266108224565018629	zitadel-admin@zitadel.localhost	266108224564953093	266108224564887557
266219708343123977	charts	266108224564953093	266108224564887557
\.


--
-- Data for Name: login_policies5; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.login_policies5 (aggregate_id, instance_id, creation_date, change_date, sequence, is_default, allow_register, allow_username_password, allow_external_idps, force_mfa, force_mfa_local_only, second_factors, multi_factors, passwordless_type, hide_password_reset, ignore_unknown_usernames, allow_domain_discovery, disable_login_with_email, disable_login_with_phone, default_redirect_uri, password_check_lifetime, external_login_check_lifetime, mfa_init_skip_lifetime, second_factor_check_lifetime, multi_factor_check_lifetime, owner_removed) FROM stdin;
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	18	t	t	t	t	f	f	{1,2}	{1}	1	f	f	t	f	f		864000000000000	864000000000000	2592000000000000	64800000000000	43200000000000	f
\.


--
-- Data for Name: mail_templates2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.mail_templates2 (aggregate_id, instance_id, creation_date, change_date, sequence, state, is_default, template, owner_removed) FROM stdin;
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	24	1	t	\\x0a3c21646f63747970652068746d6c3e0a3c68746d6c20786d6c6e733d22687474703a2f2f7777772e77332e6f72672f313939392f7868746d6c2220786d6c6e733a763d2275726e3a736368656d61732d6d6963726f736f66742d636f6d3a766d6c2220786d6c6e733a6f3d2275726e3a736368656d61732d6d6963726f736f66742d636f6d3a6f66666963653a6f6666696365223e0a3c686561643e0a20203c7469746c653e0a0a20203c2f7469746c653e0a20203c212d2d5b696620216d736f5d3e3c212d2d3e0a20203c6d65746120687474702d65717569763d22582d55412d436f6d70617469626c652220636f6e74656e743d2249453d65646765223e0a20203c212d2d3c215b656e6469665d2d2d3e0a20203c6d65746120687474702d65717569763d22436f6e74656e742d547970652220636f6e74656e743d22746578742f68746d6c3b20636861727365743d5554462d38223e0a20203c6d657461206e616d653d2276696577706f72742220636f6e74656e743d2277696474683d6465766963652d77696474682c20696e697469616c2d7363616c653d31223e0a20203c7374796c6520747970653d22746578742f637373223e0a20202020236f75746c6f6f6b2061207b2070616464696e673a303b207d0a20202020626f6479207b206d617267696e3a303b70616464696e673a303b2d7765626b69742d746578742d73697a652d61646a7573743a313030253b2d6d732d746578742d73697a652d61646a7573743a313030253b207d0a202020207461626c652c207464207b20626f726465722d636f6c6c617073653a636f6c6c617073653b6d736f2d7461626c652d6c73706163653a3070743b6d736f2d7461626c652d7273706163653a3070743b207d0a20202020696d67207b20626f726465723a303b6865696768743a6175746f3b6c696e652d6865696768743a313030253b206f75746c696e653a6e6f6e653b746578742d6465636f726174696f6e3a6e6f6e653b2d6d732d696e746572706f6c6174696f6e2d6d6f64653a626963756269633b207d0a2020202070207b20646973706c61793a626c6f636b3b6d617267696e3a3133707820303b207d0a20203c2f7374796c653e0a20203c212d2d5b6966206d736f5d3e0a20203c786d6c3e0a202020203c6f3a4f6666696365446f63756d656e7453657474696e67733e0a2020202020203c6f3a416c6c6f77504e472f3e0a2020202020203c6f3a506978656c73506572496e63683e39363c2f6f3a506978656c73506572496e63683e0a202020203c2f6f3a4f6666696365446f63756d656e7453657474696e67733e0a20203c2f786d6c3e0a20203c215b656e6469665d2d2d3e0a20203c212d2d5b6966206c7465206d736f2031315d3e0a20203c7374796c6520747970653d22746578742f637373223e0a202020202e6d6a2d6f75746c6f6f6b2d67726f75702d666978207b2077696474683a313030252021696d706f7274616e743b207d0a20203c2f7374796c653e0a20203c215b656e6469665d2d2d3e0a0a0a20203c7374796c6520747970653d22746578742f637373223e0a20202020406d65646961206f6e6c792073637265656e20616e6420286d696e2d77696474683a343830707829207b0a2020202020202e6d6a2d636f6c756d6e2d7065722d313030207b2077696474683a313030252021696d706f7274616e743b206d61782d77696474683a20313030253b207d0a2020202020202e6d6a2d636f6c756d6e2d7065722d3630207b2077696474683a3630252021696d706f7274616e743b206d61782d77696474683a203630253b207d0a202020207d0a20203c2f7374796c653e0a0a0a20203c7374796c6520747970653d22746578742f637373223e0a0a0a0a20202020406d65646961206f6e6c792073637265656e20616e6420286d61782d77696474683a343830707829207b0a2020202020207461626c652e6d6a2d66756c6c2d77696474682d6d6f62696c65207b2077696474683a20313030252021696d706f7274616e743b207d0a20202020202074642e6d6a2d66756c6c2d77696474682d6d6f62696c65207b2077696474683a206175746f2021696d706f7274616e743b207d0a202020207d0a0a20203c2f7374796c653e0a20203c7374796c6520747970653d22746578742f637373223e2e736861646f772061207b0a20202020626f782d736861646f773a203070782033707820317078202d327078207267626128302c20302c20302c20302e32292c20307078203270782032707820307078207267626128302c20302c20302c20302e3134292c20307078203170782035707820307078207267626128302c20302c20302c20302e3132293b0a20207d3c2f7374796c653e0a0a20207b7b6966202e466f6e7455524c7d7d0a20203c7374796c653e0a2020202040666f6e742d66616365207b0a202020202020666f6e742d66616d696c793a20277b7b2e466f6e744661636546616d696c797d7d273b0a202020202020666f6e742d7374796c653a206e6f726d616c3b0a202020202020666f6e742d646973706c61793a20737761703b0a2020202020207372633a2075726c287b7b2e466f6e7455524c7d7d293b0a202020207d0a20203c2f7374796c653e0a20207b7b656e647d7d0a0a3c2f686561643e0a3c626f6479207374796c653d22776f72642d73706163696e673a6e6f726d616c3b223e0a0a0a3c6469760a20202020202020207374796c653d22220a3e0a0a20203c7461626c650a20202020202020202020616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d226261636b67726f756e643a7b7b2e4261636b67726f756e64436f6c6f727d7d3b6261636b67726f756e642d636f6c6f723a7b7b2e4261636b67726f756e64436f6c6f727d7d3b77696474683a313030253b626f726465722d7261646975733a313670783b220a20203e0a202020203c74626f64793e0a202020203c74723e0a2020202020203c74643e0a0a0a20202020202020203c212d2d5b6966206d736f207c2049455d3e3c7461626c6520616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220636c6173733d2222207374796c653d2277696474683a38303070783b222077696474683d2238303022203e3c74723e3c7464207374796c653d226c696e652d6865696768743a3070783b666f6e742d73697a653a3070783b6d736f2d6c696e652d6865696768742d72756c653a65786163746c793b223e3c215b656e6469665d2d2d3e0a0a0a20202020202020203c64697620207374796c653d226d617267696e3a307078206175746f3b626f726465722d7261646975733a313670783b6d61782d77696474683a38303070783b223e0a0a202020202020202020203c7461626c650a202020202020202020202020202020202020616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d2277696474683a313030253b626f726465722d7261646975733a313670783b220a202020202020202020203e0a2020202020202020202020203c74626f64793e0a2020202020202020202020203c74723e0a20202020202020202020202020203c74640a202020202020202020202020202020202020202020207374796c653d22646972656374696f6e3a6c74723b666f6e742d73697a653a3070783b70616464696e673a3230707820303b70616464696e672d6c6566743a303b746578742d616c69676e3a63656e7465723b220a20202020202020202020202020203e0a202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c7461626c6520726f6c653d2270726573656e746174696f6e2220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d2230223e3c74723e3c746420636c6173733d22222077696474683d22383030707822203e3c215b656e6469665d2d2d3e0a0a202020202020202020202020202020203c7461626c650a202020202020202020202020202020202020202020202020616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d2277696474683a313030253b220a202020202020202020202020202020203e0a2020202020202020202020202020202020203c74626f64793e0a2020202020202020202020202020202020203c74723e0a20202020202020202020202020202020202020203c74643e0a0a0a202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c7461626c6520616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220636c6173733d2222207374796c653d2277696474683a38303070783b222077696474683d2238303022203e3c74723e3c7464207374796c653d226c696e652d6865696768743a3070783b666f6e742d73697a653a3070783b6d736f2d6c696e652d6865696768742d72756c653a65786163746c793b223e3c215b656e6469665d2d2d3e0a0a0a202020202020202020202020202020202020202020203c64697620207374796c653d226d617267696e3a307078206175746f3b6d61782d77696474683a38303070783b223e0a0a2020202020202020202020202020202020202020202020203c7461626c650a2020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d2277696474683a313030253b220a2020202020202020202020202020202020202020202020203e0a20202020202020202020202020202020202020202020202020203c74626f64793e0a20202020202020202020202020202020202020202020202020203c74723e0a202020202020202020202020202020202020202020202020202020203c74640a2020202020202020202020202020202020202020202020202020202020202020202020207374796c653d22646972656374696f6e3a6c74723b666f6e742d73697a653a3070783b70616464696e673a303b746578742d616c69676e3a63656e7465723b220a202020202020202020202020202020202020202020202020202020203e0a2020202020202020202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c7461626c6520726f6c653d2270726573656e746174696f6e2220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d2230223e3c74723e3c746420636c6173733d2222207374796c653d2277696474683a38303070783b22203e3c215b656e6469665d2d2d3e0a0a2020202020202020202020202020202020202020202020202020202020203c6469760a2020202020202020202020202020202020202020202020202020202020202020202020202020636c6173733d226d6a2d636f6c756d6e2d7065722d313030206d6a2d6f75746c6f6f6b2d67726f75702d66697822207374796c653d22666f6e742d73697a653a303b6c696e652d6865696768743a303b746578742d616c69676e3a6c6566743b646973706c61793a696e6c696e652d626c6f636b3b77696474683a313030253b646972656374696f6e3a6c74723b220a2020202020202020202020202020202020202020202020202020202020203e0a20202020202020202020202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c7461626c6520626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22203e3c74723e3c7464207374796c653d22766572746963616c2d616c69676e3a746f703b77696474683a38303070783b22203e3c215b656e6469665d2d2d3e0a0a20202020202020202020202020202020202020202020202020202020202020203c6469760a20202020202020202020202020202020202020202020202020202020202020202020202020202020636c6173733d226d6a2d636f6c756d6e2d7065722d313030206d6a2d6f75746c6f6f6b2d67726f75702d66697822207374796c653d22666f6e742d73697a653a3070783b746578742d616c69676e3a6c6566743b646972656374696f6e3a6c74723b646973706c61793a696e6c696e652d626c6f636b3b766572746963616c2d616c69676e3a746f703b77696474683a313030253b220a20202020202020202020202020202020202020202020202020202020202020203e0a0a202020202020202020202020202020202020202020202020202020202020202020203c7461626c650a202020202020202020202020202020202020202020202020202020202020202020202020202020202020626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e222077696474683d2231303025220a202020202020202020202020202020202020202020202020202020202020202020203e0a2020202020202020202020202020202020202020202020202020202020202020202020203c74626f64793e0a2020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a20202020202020202020202020202020202020202020202020202020202020202020202020203c746420207374796c653d22766572746963616c2d616c69676e3a746f703b70616464696e673a303b223e0a202020202020202020202020202020202020202020202020202020202020202020202020202020207b7b6966202e4c6f676f55524c7d7d0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c7461626c650a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d22222077696474683d2231303025220a202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74626f64793e0a0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74640a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e74657222207374796c653d22666f6e742d73697a653a3070783b70616464696e673a353070782030203330707820303b776f72642d627265616b3a627265616b2d776f72643b220a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c7461626c650a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d22626f726465722d636f6c6c617073653a636f6c6c617073653b626f726465722d73706163696e673a3070783b220a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74626f64793e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c746420207374796c653d2277696474683a31383070783b223e0a0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c696d670a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020206865696768743d226175746f22207372633d227b7b2e4c6f676f55524c7d7d22207374796c653d22626f726465723a303b626f726465722d7261646975733a3870783b646973706c61793a626c6f636b3b6f75746c696e653a6e6f6e653b746578742d6465636f726174696f6e3a6e6f6e653b6865696768743a6175746f3b77696474683a313030253b666f6e742d73697a653a313370783b222077696474683d22313830220a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202f3e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74626f64793e0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f7461626c653e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74626f64793e0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f7461626c653e0a202020202020202020202020202020202020202020202020202020202020202020202020202020207b7b656e647d7d0a20202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a2020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a2020202020202020202020202020202020202020202020202020202020202020202020203c2f74626f64793e0a202020202020202020202020202020202020202020202020202020202020202020203c2f7461626c653e0a0a20202020202020202020202020202020202020202020202020202020202020203c2f6469763e0a0a20202020202020202020202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c2f74643e3c2f74723e3c2f7461626c653e3c215b656e6469665d2d2d3e0a2020202020202020202020202020202020202020202020202020202020203c2f6469763e0a0a2020202020202020202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c2f74643e3c2f74723e3c2f7461626c653e3c215b656e6469665d2d2d3e0a202020202020202020202020202020202020202020202020202020203c2f74643e0a20202020202020202020202020202020202020202020202020203c2f74723e0a20202020202020202020202020202020202020202020202020203c2f74626f64793e0a2020202020202020202020202020202020202020202020203c2f7461626c653e0a0a202020202020202020202020202020202020202020203c2f6469763e0a0a0a202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c2f74643e3c2f74723e3c2f7461626c653e3c215b656e6469665d2d2d3e0a0a0a20202020202020202020202020202020202020203c2f74643e0a2020202020202020202020202020202020203c2f74723e0a2020202020202020202020202020202020203c2f74626f64793e0a202020202020202020202020202020203c2f7461626c653e0a0a202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c2f74643e3c2f74723e3c74723e3c746420636c6173733d22222077696474683d22383030707822203e3c215b656e6469665d2d2d3e0a0a202020202020202020202020202020203c7461626c650a202020202020202020202020202020202020202020202020616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d2277696474683a313030253b220a202020202020202020202020202020203e0a2020202020202020202020202020202020203c74626f64793e0a2020202020202020202020202020202020203c74723e0a20202020202020202020202020202020202020203c74643e0a0a0a202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c7461626c6520616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220636c6173733d2222207374796c653d2277696474683a38303070783b222077696474683d2238303022203e3c74723e3c7464207374796c653d226c696e652d6865696768743a3070783b666f6e742d73697a653a3070783b6d736f2d6c696e652d6865696768742d72756c653a65786163746c793b223e3c215b656e6469665d2d2d3e0a0a0a202020202020202020202020202020202020202020203c64697620207374796c653d226d617267696e3a307078206175746f3b6d61782d77696474683a38303070783b223e0a0a2020202020202020202020202020202020202020202020203c7461626c650a2020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d2277696474683a313030253b220a2020202020202020202020202020202020202020202020203e0a20202020202020202020202020202020202020202020202020203c74626f64793e0a20202020202020202020202020202020202020202020202020203c74723e0a202020202020202020202020202020202020202020202020202020203c74640a2020202020202020202020202020202020202020202020202020202020202020202020207374796c653d22646972656374696f6e3a6c74723b666f6e742d73697a653a3070783b70616464696e673a303b746578742d616c69676e3a63656e7465723b220a202020202020202020202020202020202020202020202020202020203e0a2020202020202020202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c7461626c6520726f6c653d2270726573656e746174696f6e2220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d2230223e3c74723e3c746420636c6173733d2222207374796c653d22766572746963616c2d616c69676e3a746f703b77696474683a34383070783b22203e3c215b656e6469665d2d2d3e0a0a2020202020202020202020202020202020202020202020202020202020203c6469760a2020202020202020202020202020202020202020202020202020202020202020202020202020636c6173733d226d6a2d636f6c756d6e2d7065722d3630206d6a2d6f75746c6f6f6b2d67726f75702d66697822207374796c653d22666f6e742d73697a653a3070783b746578742d616c69676e3a6c6566743b646972656374696f6e3a6c74723b646973706c61793a696e6c696e652d626c6f636b3b766572746963616c2d616c69676e3a746f703b77696474683a313030253b220a2020202020202020202020202020202020202020202020202020202020203e0a0a20202020202020202020202020202020202020202020202020202020202020203c7461626c650a20202020202020202020202020202020202020202020202020202020202020202020202020202020626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e222077696474683d2231303025220a20202020202020202020202020202020202020202020202020202020202020203e0a202020202020202020202020202020202020202020202020202020202020202020203c74626f64793e0a202020202020202020202020202020202020202020202020202020202020202020203c74723e0a2020202020202020202020202020202020202020202020202020202020202020202020203c746420207374796c653d22766572746963616c2d616c69676e3a746f703b70616464696e673a303b223e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020203c7461626c650a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d22222077696474683d2231303025220a20202020202020202020202020202020202020202020202020202020202020202020202020203e0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c74626f64793e0a0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74640a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e74657222207374796c653d22666f6e742d73697a653a3070783b70616464696e673a3130707820323570783b776f72642d627265616b3a627265616b2d776f72643b220a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c6469760a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207374796c653d22666f6e742d66616d696c793a7b7b2e466f6e7446616d696c797d7d3b666f6e742d73697a653a323470783b666f6e742d7765696768743a3530303b6c696e652d6865696768743a313b746578742d616c69676e3a63656e7465723b636f6c6f723a7b7b2e466f6e74436f6c6f727d7d3b220a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e7b7b2e4772656574696e677d7d3c2f6469763e0a0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74640a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e74657222207374796c653d22666f6e742d73697a653a3070783b70616464696e673a3130707820323570783b776f72642d627265616b3a627265616b2d776f72643b220a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c6469760a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207374796c653d22666f6e742d66616d696c793a7b7b2e466f6e7446616d696c797d7d3b666f6e742d73697a653a313670783b666f6e742d7765696768743a6c696768743b6c696e652d6865696768743a312e353b746578742d616c69676e3a63656e7465723b636f6c6f723a7b7b2e466f6e74436f6c6f727d7d3b220a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e7b7b2e546578747d7d3c2f6469763e0a0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a0a0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74640a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e7465722220766572746963616c2d616c69676e3d226d6964646c652220636c6173733d22736861646f7722207374796c653d22666f6e742d73697a653a3070783b70616464696e673a3130707820323570783b776f72642d627265616b3a627265616b2d776f72643b220a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c7461626c650a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d22302220726f6c653d2270726573656e746174696f6e22207374796c653d22626f726465722d636f6c6c617073653a73657061726174653b6c696e652d6865696768743a313030253b220a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74640a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e74657222206267636f6c6f723d227b7b2e5072696d617279436f6c6f727d7d2220726f6c653d2270726573656e746174696f6e22207374796c653d22626f726465723a6e6f6e653b626f726465722d7261646975733a3670783b637572736f723a6175746f3b6d736f2d70616464696e672d616c743a3130707820323570783b6261636b67726f756e643a7b7b2e5072696d617279436f6c6f727d7d3b222076616c69676e3d226d6964646c65220a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c610a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020687265663d227b7b2e55524c7d7d222072656c3d226e6f6f70656e6572206e6f7265666572726572206e6f747261636b22207374796c653d22646973706c61793a696e6c696e652d626c6f636b3b6261636b67726f756e643a7b7b2e5072696d617279436f6c6f727d7d3b636f6c6f723a236666666666663b666f6e742d66616d696c793a7b7b2e466f6e7446616d696c797d7d3b666f6e742d73697a653a313470783b666f6e742d7765696768743a3530303b6c696e652d6865696768743a313230253b6d617267696e3a303b746578742d6465636f726174696f6e3a6e6f6e653b746578742d7472616e73666f726d3a6e6f6e653b70616464696e673a3130707820323570783b6d736f2d70616464696e672d616c743a3070783b626f726465722d7261646975733a3670783b22207461726765743d225f626c616e6b220a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207b7b2e427574746f6e546578747d7d0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f613e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f7461626c653e0a0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a202020202020202020202020202020202020202020202020202020202020202020202020202020207b7b6966202e496e636c756465466f6f7465727d7d0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74640a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e74657222207374796c653d22666f6e742d73697a653a3070783b70616464696e673a3130707820323570783b70616464696e672d746f703a323070783b70616464696e672d72696768743a323070783b70616464696e672d626f74746f6d3a323070783b70616464696e672d6c6566743a323070783b776f72642d627265616b3a627265616b2d776f72643b220a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c700a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207374796c653d22626f726465722d746f703a736f6c69642032707820236462646264623b666f6e742d73697a653a3170783b6d617267696e3a307078206175746f3b77696474683a313030253b220a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f703e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c7461626c6520616c69676e3d2263656e7465722220626f726465723d2230222063656c6c70616464696e673d2230222063656c6c73706163696e673d223022207374796c653d22626f726465722d746f703a736f6c69642032707820236462646264623b666f6e742d73697a653a3170783b6d617267696e3a307078206175746f3b77696474683a34343070783b2220726f6c653d2270726573656e746174696f6e222077696474683d22343430707822203e3c74723e3c7464207374796c653d226865696768743a303b6c696e652d6865696768743a303b223e20266e6273703b0a20202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e3c2f74723e3c2f7461626c653e3c215b656e6469665d2d2d3e0a0a0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c74723e0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c74640a2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020616c69676e3d2263656e74657222207374796c653d22666f6e742d73697a653a3070783b70616464696e673a313670783b776f72642d627265616b3a627265616b2d776f72643b220a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203e0a0a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203c6469760a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207374796c653d22666f6e742d66616d696c793a7b7b2e466f6e7446616d696c797d7d3b666f6e742d73697a653a313370783b6c696e652d6865696768743a313b746578742d616c69676e3a63656e7465723b636f6c6f723a7b7b2e466f6e74436f6c6f727d7d3b220a20202020202020202020202020202020202020202020202020202020202020202020202020202020202020203e7b7b2e466f6f746572546578747d7d3c2f6469763e0a0a2020202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a202020202020202020202020202020202020202020202020202020202020202020202020202020207b7b656e647d7d0a202020202020202020202020202020202020202020202020202020202020202020202020202020203c2f74626f64793e0a20202020202020202020202020202020202020202020202020202020202020202020202020203c2f7461626c653e0a0a2020202020202020202020202020202020202020202020202020202020202020202020203c2f74643e0a202020202020202020202020202020202020202020202020202020202020202020203c2f74723e0a202020202020202020202020202020202020202020202020202020202020202020203c2f74626f64793e0a20202020202020202020202020202020202020202020202020202020202020203c2f7461626c653e0a0a2020202020202020202020202020202020202020202020202020202020203c2f6469763e0a0a2020202020202020202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c2f74643e3c2f74723e3c2f7461626c653e3c215b656e6469665d2d2d3e0a202020202020202020202020202020202020202020202020202020203c2f74643e0a20202020202020202020202020202020202020202020202020203c2f74723e0a20202020202020202020202020202020202020202020202020203c2f74626f64793e0a2020202020202020202020202020202020202020202020203c2f7461626c653e0a0a202020202020202020202020202020202020202020203c2f6469763e0a0a0a202020202020202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c2f74643e3c2f74723e3c2f7461626c653e3c215b656e6469665d2d2d3e0a0a0a20202020202020202020202020202020202020203c2f74643e0a2020202020202020202020202020202020203c2f74723e0a2020202020202020202020202020202020203c2f74626f64793e0a202020202020202020202020202020203c2f7461626c653e0a0a202020202020202020202020202020203c212d2d5b6966206d736f207c2049455d3e3c2f74643e3c2f74723e3c2f7461626c653e3c215b656e6469665d2d2d3e0a20202020202020202020202020203c2f74643e0a2020202020202020202020203c2f74723e0a2020202020202020202020203c2f74626f64793e0a202020202020202020203c2f7461626c653e0a0a20202020202020203c2f6469763e0a0a0a20202020202020203c212d2d5b6966206d736f207c2049455d3e3c2f74643e3c2f74723e3c2f7461626c653e3c215b656e6469665d2d2d3e0a0a0a2020202020203c2f74643e0a202020203c2f74723e0a202020203c2f74626f64793e0a20203c2f7461626c653e0a0a3c2f6469763e0a0a3c2f626f64793e0a3c2f68746d6c3e0a	f
\.


--
-- Data for Name: message_texts2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.message_texts2 (aggregate_id, instance_id, creation_date, change_date, sequence, state, type, language, title, pre_header, subject, greeting, text, button_text, footer_text, owner_removed) FROM stdin;
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	30	1	InitCode	de	Zitadel - User initialisieren	User initialisieren	User initialisieren	Hallo {{.DisplayName}},	Dieser Benutzer wurde soeben im Zitadel erstellt. Mit dem Benutzernamen &lt;br&gt;&lt;strong&gt;{{.PreferredLoginName}}&lt;/strong&gt;&lt;br&gt; kannst du dich anmelden. Nutze den untenstehenden Button, um die Initialisierung abzuschliessen &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du dieses Mail nicht angefordert hast, kannst du es einfach ignorieren.	Initialisierung abschliessen	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	36	1	PasswordReset	de	Zitadel - Passwort zurücksetzen	Passwort zurücksetzen	Passwort zurücksetzen	Hallo {{.DisplayName}},	Wir haben eine Anfrage für das Zurücksetzen deines Passwortes bekommen. Du kannst den untenstehenden Button verwenden, um dein Passwort zurückzusetzen &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du dieses Mail nicht angefordert hast, kannst du es ignorieren.	Passwort zurücksetzen	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	42	1	VerifyEmail	de	Zitadel - Email verifizieren	Email verifizieren	Email verifizieren	Hallo {{.DisplayName}},	Eine neue E-Mail Adresse wurde hinzugefügt. Bitte verwende den untenstehenden Button um diese zu verifizieren &lt;br&gt;(Code &lt;strong&gt;{{.Code}}&lt;/strong&gt;).&lt;br&gt; Falls du deine E-Mail Adresse nicht selber hinzugefügt hast, kannst du dieses E-Mail ignorieren.	Email verifizieren	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	48	1	VerifyPhone	de	Zitadel - Telefonnummer verifizieren	Telefonnummer verifizieren	Telefonnummer verifizieren	Hallo {{.DisplayName}},	Eine Telefonnummer wurde hinzugefügt. Bitte verifiziere diese in dem du folgenden Code eingibst (Code {{.Code}})	Telefon verifizieren	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	84	1	VerifyPhone	en	Zitadel - Verify phone	Verify phone	Verify phone	Hello {{.DisplayName}},	A new phone number has been added. Please use the following code to verify it {{.Code}}.	Verify phone	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	54	1	DomainClaimed	de	Zitadel - Domain wurde beansprucht	Email / Username ändern	Domain wurde beansprucht	Hallo {{.DisplayName}},	Die Domain {{.Domain}} wurde von einer Organisation beansprucht. Dein derzeitiger User {{.Username}} ist nicht Teil dieser Organisation. Daher musst du beim nächsten Login eine neue Email hinterlegen. Für diesen Login haben wir dir einen temporären Usernamen ({{.TempUsername}}) erstellt.	Login	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	60	1	PasswordChange	de	ZITADEL - Passwort von Benutzer wurde geändert	Passwort Änderung	Passwort von Benutzer wurde geändert	Hallo {{.DisplayName}},	Das Password vom Benutzer wurde geändert. Wenn diese Änderung von jemand anderem gemacht wurde, empfehlen wir die sofortige Zurücksetzung ihres Passworts.	Login	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	66	1	InitCode	en	Zitadel - Initialize User	Initialize User	Initialize User	Hello {{.DisplayName}},	This user was created in Zitadel. Use the username {{.PreferredLoginName}} to login. Please click the button below to finish the initialization process. (Code {{.Code}}) If you didn't ask for this mail, please ignore it.	Finish initialization	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	72	1	PasswordReset	en	Zitadel - Reset password	Reset password	Reset password	Hello {{.DisplayName}},	We received a password reset request. Please use the button below to reset your password. (Code {{.Code}}) If you didn't ask for this mail, please ignore it.	Reset password	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	78	1	VerifyEmail	en	Zitadel - Verify email	Verify email	Verify email	Hello {{.DisplayName}},	A new email has been added. Please use the button below to verify your email. (Code {{.Code}}) If you din't add a new email, please ignore this email.	Verify email	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	90	1	DomainClaimed	en	Zitadel - Domain has been claimed	Change email/username	Domain has been claimed	Hello {{.DisplayName}},	The domain {{.Domain}} has been claimed by an organization. Your current user {{.UserName}} is not part of this organization. Therefore you'll have to change your email when you login. We have created a temporary username ({{.TempUsername}}) for this login.	Login	\N	f
266108224564887557	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	96	1	PasswordChange	en	ZITADEL - Password of user has changed	Change password	Password of user has changed	Hello {{.DisplayName}},	The password of your user has changed. If this change was not done by you, please be advised to immediately reset your password.	Login	\N	f
\.


--
-- Data for Name: milestones; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.milestones (instance_id, type, reached_date, last_pushed_date, primary_domain, ignore_client_ids) FROM stdin;
266108224564887557	1	2024-05-07 19:07:43.764022+00	\N	localhost	\N
266108224564887557	6	\N	\N	localhost	\N
266108224564887557	2	2024-05-07 19:10:14.139469+00	\N	localhost	\N
266108224564887557	3	2024-05-07 19:10:37.35547+00	\N	localhost	\N
266108224564887557	4	2024-05-07 19:11:44.550639+00	\N	localhost	\N
266108224564887557	5	2024-05-08 13:09:26.147+00	\N	localhost	{266108227433791493@zitadel,266108227450568709@zitadel,266108227467345925@zitadel,266108227467411461@zitadel}
\.


--
-- Data for Name: notification_policies; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.notification_policies (id, creation_date, change_date, resource_owner, instance_id, sequence, state, is_default, password_change, owner_removed) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564887557	266108224564887557	20	1	t	t	f
\.


--
-- Data for Name: notification_providers; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.notification_providers (aggregate_id, creation_date, change_date, sequence, resource_owner, instance_id, state, provider_type, compact) FROM stdin;
\.


--
-- Data for Name: oidc_settings2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.oidc_settings2 (aggregate_id, creation_date, change_date, resource_owner, instance_id, sequence, access_token_lifetime, id_token_lifetime, refresh_token_idle_expiration, refresh_token_expiration) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564887557	266108224564887557	105	43200000000000	43200000000000	2592000000000000	7776000000000000
\.


--
-- Data for Name: org_domains2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.org_domains2 (org_id, instance_id, creation_date, change_date, sequence, domain, is_verified, is_primary, validation_type, owner_removed) FROM stdin;
266108224564953093	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	4	zitadel.localhost	t	t	0	f
\.


--
-- Data for Name: org_members4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.org_members4 (creation_date, change_date, user_id, user_resource_owner, roles, sequence, resource_owner, instance_id, org_id) FROM stdin;
2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224565018629	266108224564953093	{ORG_OWNER}	5	266108224564953093	266108224564887557	266108224564953093
\.


--
-- Data for Name: org_metadata2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.org_metadata2 (org_id, creation_date, change_date, sequence, resource_owner, instance_id, key, value, owner_removed) FROM stdin;
\.


--
-- Data for Name: orgs1; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.orgs1 (id, creation_date, change_date, resource_owner, instance_id, org_state, sequence, name, primary_domain) FROM stdin;
266108224564953093	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224564953093	266108224564887557	1	4	ZITADEL	zitadel.localhost
\.


--
-- Data for Name: password_age_policies2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.password_age_policies2 (id, creation_date, change_date, sequence, state, is_default, resource_owner, instance_id, expire_warn_days, max_age_days, owner_removed) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	13	1	t	266108224564887557	266108224564887557	0	0	f
\.


--
-- Data for Name: password_complexity_policies2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.password_complexity_policies2 (id, creation_date, change_date, sequence, state, is_default, resource_owner, instance_id, min_length, has_lowercase, has_uppercase, has_symbol, has_number, owner_removed) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	12	1	t	266108224564887557	266108224564887557	8	t	t	t	t	f
\.


--
-- Data for Name: personal_access_tokens3; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.personal_access_tokens3 (id, creation_date, change_date, sequence, resource_owner, instance_id, user_id, expiration, scopes, owner_removed) FROM stdin;
\.


--
-- Data for Name: privacy_policies3; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.privacy_policies3 (id, creation_date, change_date, sequence, state, is_default, resource_owner, instance_id, privacy_link, tos_link, help_link, support_email, owner_removed) FROM stdin;
266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	19	1	t	266108224564887557	266108224564887557	https://zitadel.com/docs/legal/privacy-policy	https://zitadel.com/docs/legal/terms-of-service			f
\.


--
-- Data for Name: project_grant_members4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.project_grant_members4 (creation_date, change_date, user_id, user_resource_owner, roles, sequence, resource_owner, instance_id, project_id, grant_id, granted_org) FROM stdin;
\.


--
-- Data for Name: project_grants4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.project_grants4 (grant_id, creation_date, change_date, sequence, state, resource_owner, instance_id, project_id, granted_org_id, granted_role_keys) FROM stdin;
\.


--
-- Data for Name: project_members4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.project_members4 (creation_date, change_date, user_id, user_resource_owner, roles, sequence, resource_owner, instance_id, project_id) FROM stdin;
2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	266108224565018629	266108224564953093	{PROJECT_OWNER}	2	266108224564953093	266108224564887557	266108224565084165
2024-05-07 19:10:37.35547+00	2024-05-07 19:10:37.35547+00	266108224565018629	266108224564953093	{PROJECT_OWNER}	2	266108224564953093	266108224564887557	266108518786924549
\.


--
-- Data for Name: project_roles4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.project_roles4 (project_id, role_key, creation_date, change_date, sequence, resource_owner, instance_id, display_name, group_name) FROM stdin;
\.


--
-- Data for Name: projects4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.projects4 (id, creation_date, change_date, sequence, state, resource_owner, instance_id, name, project_role_assertion, project_role_check, has_project_check, private_labeling_setting) FROM stdin;
266108224565084165	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	1	1	266108224564953093	266108224564887557	ZITADEL	f	f	f	0
266108518786924549	2024-05-07 19:10:37.35547+00	2024-05-07 19:10:37.35547+00	1	1	266108224564953093	266108224564887557	DataLens	f	f	f	0
\.


--
-- Data for Name: quotas; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.quotas (id, instance_id, unit, amount, from_anchor, "interval", limit_usage) FROM stdin;
\.


--
-- Data for Name: quotas_notifications; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.quotas_notifications (instance_id, unit, id, call_url, percent, repeat, latest_due_period_start, next_due_threshold) FROM stdin;
\.


--
-- Data for Name: quotas_periods; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.quotas_periods (instance_id, unit, start, usage) FROM stdin;
\.


--
-- Data for Name: restrictions2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.restrictions2 (aggregate_id, creation_date, change_date, resource_owner, instance_id, sequence, disallow_public_org_registration, allowed_languages) FROM stdin;
\.


--
-- Data for Name: secret_generators2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.secret_generators2 (generator_type, aggregate_id, creation_date, change_date, sequence, resource_owner, instance_id, length, expiry, include_lower_letters, include_upper_letters, include_digits, include_symbols) FROM stdin;
7	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	3	266108224564887557	266108224564887557	64	0	t	t	t	f
1	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	4	266108224564887557	266108224564887557	6	259200000000000	f	t	t	f
2	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	5	266108224564887557	266108224564887557	6	3600000000000	f	t	t	f
3	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	6	266108224564887557	266108224564887557	6	3600000000000	f	t	t	f
5	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	7	266108224564887557	266108224564887557	6	3600000000000	f	t	t	f
6	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	8	266108224564887557	266108224564887557	12	3600000000000	t	t	t	f
4	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	9	266108224564887557	266108224564887557	32	0	t	t	t	f
8	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	10	266108224564887557	266108224564887557	8	300000000000	f	f	t	f
9	266108224564887557	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	11	266108224564887557	266108224564887557	8	300000000000	f	f	t	f
\.


--
-- Data for Name: security_policies2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.security_policies2 (creation_date, change_date, instance_id, sequence, enable_iframe_embedding, origins, enable_impersonation) FROM stdin;
\.


--
-- Data for Name: sessions8; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.sessions8 (id, creation_date, change_date, sequence, state, resource_owner, instance_id, creator, user_id, user_resource_owner, user_checked_at, password_checked_at, intent_checked_at, webauthn_checked_at, webauthn_user_verified, totp_checked_at, otp_sms_checked_at, otp_email_checked_at, metadata, token_id, user_agent_fingerprint_id, user_agent_ip, user_agent_description, user_agent_header, expiration) FROM stdin;
\.


--
-- Data for Name: sms_configs2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.sms_configs2 (id, aggregate_id, creation_date, change_date, sequence, state, resource_owner, instance_id) FROM stdin;
\.


--
-- Data for Name: sms_configs2_twilio; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.sms_configs2_twilio (sms_id, instance_id, sid, sender_number, token) FROM stdin;
\.


--
-- Data for Name: smtp_configs1; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.smtp_configs1 (aggregate_id, creation_date, change_date, sequence, resource_owner, instance_id, tls, sender_address, sender_name, reply_to_address, host, username, password) FROM stdin;
\.


--
-- Data for Name: smtp_configs2; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.smtp_configs2 (id, creation_date, change_date, sequence, resource_owner, instance_id, tls, sender_address, sender_name, reply_to_address, host, username, password, state, description) FROM stdin;
\.


--
-- Data for Name: system_features; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.system_features (key, creation_date, change_date, sequence, value) FROM stdin;
\.


--
-- Data for Name: targets; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.targets (id, creation_date, change_date, resource_owner, instance_id, target_type, sequence, name, url, timeout, async, interrupt_on_error) FROM stdin;
\.


--
-- Data for Name: user_auth_methods4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.user_auth_methods4 (user_id, method_type, token_id, creation_date, change_date, sequence, state, resource_owner, instance_id, name, owner_removed) FROM stdin;
\.


--
-- Data for Name: user_grants4; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.user_grants4 (id, creation_date, change_date, sequence, state, resource_owner, instance_id, user_id, resource_owner_user, project_id, resource_owner_project, grant_id, granted_org, roles) FROM stdin;
\.


--
-- Data for Name: user_grants5; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.user_grants5 (id, creation_date, change_date, sequence, state, resource_owner, instance_id, user_id, resource_owner_user, project_id, resource_owner_project, grant_id, granted_org, roles) FROM stdin;
\.


--
-- Data for Name: user_metadata5; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.user_metadata5 (user_id, creation_date, change_date, sequence, resource_owner, instance_id, key, value) FROM stdin;
\.


--
-- Data for Name: user_schemas; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.user_schemas (id, change_date, sequence, state, instance_id, type, revision, schema, possible_authenticators) FROM stdin;
\.


--
-- Data for Name: users10; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.users10 (id, creation_date, change_date, sequence, state, resource_owner, instance_id, username, type) FROM stdin;
266108224565018629	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	2	1	266108224564953093	266108224564887557	zitadel-admin@zitadel.localhost	1
\.


--
-- Data for Name: users10_humans; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.users10_humans (user_id, instance_id, first_name, last_name, nick_name, display_name, preferred_language, gender, avatar_key, email, is_email_verified, phone, is_phone_verified) FROM stdin;
266108224565018629	266108224564887557	ZITADEL	Admin	\N	ZITADEL Admin	en	\N	\N	zitadel-admin@zitadel.localhost	t	\N	\N
\.


--
-- Data for Name: users10_machines; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.users10_machines (user_id, instance_id, name, description, secret, access_token_type) FROM stdin;
\.


--
-- Data for Name: users10_notifications; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.users10_notifications (user_id, instance_id, last_email, verified_email, last_phone, verified_phone, password_set) FROM stdin;
266108224565018629	266108224564887557	zitadel-admin@zitadel.localhost	zitadel-admin@zitadel.localhost	\N	\N	t
\.


--
-- Data for Name: users12; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.users12 (id, creation_date, change_date, sequence, state, resource_owner, instance_id, username, type) FROM stdin;
266108224565018629	2024-05-07 19:07:43.764022+00	2024-05-07 19:07:43.764022+00	2	1	266108224564953093	266108224564887557	zitadel-admin@zitadel.localhost	1
266219708343123977	2024-05-08 13:35:11.508041+00	2024-05-08 14:03:01.434117+00	12	1	266108224564953093	266108224564887557	charts	2
\.


--
-- Data for Name: users12_humans; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.users12_humans (user_id, instance_id, first_name, last_name, nick_name, display_name, preferred_language, gender, avatar_key, email, is_email_verified, phone, is_phone_verified, password_change_required) FROM stdin;
266108224565018629	266108224564887557	ZITADEL	Admin	\N	ZITADEL Admin	en	\N	\N	zitadel-admin@zitadel.localhost	t	\N	\N	f
\.


--
-- Data for Name: users12_machines; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.users12_machines (user_id, instance_id, name, description, secret, access_token_type) FROM stdin;
266219708343123977	266108224564887557	charts	charts	$2a$04$36wv2zKlpxtY2oogouuaFumcdWutddDDbfQ4U0fThtgSQMm6zfGsW	0
\.


--
-- Data for Name: users12_notifications; Type: TABLE DATA; Schema: projections; Owner: us
--

COPY projections.users12_notifications (user_id, instance_id, last_email, verified_email, last_phone, verified_phone, password_set) FROM stdin;
266108224565018629	266108224564887557	zitadel-admin@zitadel.localhost	zitadel-admin@zitadel.localhost	\N	\N	t
\.


--
-- Data for Name: assets; Type: TABLE DATA; Schema: system; Owner: us
--

COPY system.assets (instance_id, asset_type, resource_owner, name, content_type, data, updated_at) FROM stdin;
266108224564887557	1	266108224564887557	policy/label/css/variables.css	text/css	\\x3a726f6f74207b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3530303a207267622838342c203130352c20323132293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3630303a207267622837352c2039382c20323034293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3930303a207267622834352c2037382c20313830293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d636f6e74726173743a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3230303a20726762283132322c203133362c20323438293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3130303a20726762283133372c203135302c20323535293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3330303a20726762283130322c203131392c20323238293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3430303a207267622839332c203131322c20323230293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3730303a207267622836362c2039312c20313936293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3830303a207267622835362c2038342c20313838293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d35303a20726762283135382c203136392c20323535293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d35303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3130303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3330303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3630303a20726762283233332c203233332c20323333293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d636f6e74726173743a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3930303a20726762283138342c203138342c20313834293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3230303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3430303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3530303a20726762283235302c203235302c20323530293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3730303a20726762283231362c203231362c20323136293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3830303a20726762283230302c203230302c20323030293b2d2d7a69746164656c2d636f6c6f722d7761726e2d35303a20726762283235352c203133322c20313439293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3130303a20726762283235352c203131322c20313330293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3230303a20726762283234342c2039372c20313137293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3530303a20726762283230352c2036312c203836293b2d2d7a69746164656c2d636f6c6f722d7761726e2d636f6e74726173743a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3330303a20726762283232332c2037382c20313030293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3430303a20726762283231342c2037302c203933293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3630303a20726762283139362c2035322c203739293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3730303a20726762283138372c2034332c203732293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3830303a20726762283137382c2033332c203636293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3930303a20726762283137302c2032312c203539293b2d2d7a69746164656c2d636f6c6f722d6c6162656c3a20233030303030303b2d2d7a69746164656c2d636f6c6f722d746578742d3230303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d3330303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d3430303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d3830303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d636f6e74726173743a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d746578742d35303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d3130303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d3530303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d3630303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d3730303a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d3930303a2072676228302c20302c2030293b7d2e6c676e2d6461726b2d7468656d65207b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3230303a207267622838312c203134362c20323331293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3430303a207267622834362c203132322c20323034293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3530303a207267622833322c203131352c20313936293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3730303a2072676228302c203130312c20313830293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3930303a2072676228302c2038372c20313635293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d636f6e74726173743a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d35303a20726762283132302c203137392c20323535293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3130303a207267622839382c203136302c20323436293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3330303a207267622835372c203132392c20323132293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3630303a207267622831312c203130382c20313838293b2d2d7a69746164656c2d636f6c6f722d7072696d6172792d3830303a2072676228302c2039342c20313732293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d636f6e74726173743a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3230303a207267622832312c2032382c203434293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3430303a207267622831382c2032352c203430293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3630303a207267622831362c2032332c203338293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3730303a207267622831352c2032322c203337293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3830303a207267622831342c2032312c203336293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3930303a207267622831332c2032302c203335293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d35303a207267622832362c2033332c203438293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3130303a207267622832332c2033302c203436293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3330303a207267622831392c2032362c203431293b2d2d7a69746164656c2d636f6c6f722d6261636b67726f756e642d3530303a207267622831372c2032342c203339293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3430303a20726762283235352c2037312c203939293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3530303a20726762283235352c2035392c203931293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3630303a20726762283234342c2034362c203833293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3730303a20726762283233332c2033302c203735293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3830303a20726762283232322c20342c203637293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3930303a20726762283231312c20302c203539293b2d2d7a69746164656c2d636f6c6f722d7761726e2d636f6e74726173743a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3230303a20726762283235352c203130372c20313238293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3130303a20726762283235352c203132362c20313434293b2d2d7a69746164656c2d636f6c6f722d7761726e2d3330303a20726762283235352c2038322c20313038293b2d2d7a69746164656c2d636f6c6f722d7761726e2d35303a20726762283235352c203135322c20313637293b2d2d7a69746164656c2d636f6c6f722d6c6162656c3a20236666666666663b2d2d7a69746164656c2d636f6c6f722d746578742d636f6e74726173743a2072676228302c20302c2030293b2d2d7a69746164656c2d636f6c6f722d746578742d35303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d746578742d3430303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d746578742d3330303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d746578742d3530303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d746578742d3630303a20726762283233382c203233382c20323338293b2d2d7a69746164656c2d636f6c6f722d746578742d3730303a20726762283232312c203232312c20323231293b2d2d7a69746164656c2d636f6c6f722d746578742d3830303a20726762283230342c203230342c20323034293b2d2d7a69746164656c2d636f6c6f722d746578742d3930303a20726762283138372c203138372c20313837293b2d2d7a69746164656c2d636f6c6f722d746578742d3130303a20726762283235352c203235352c20323535293b2d2d7a69746164656c2d636f6c6f722d746578742d3230303a20726762283235352c203235352c20323535293b7d	2024-05-07 19:07:46.429031+00
\.


--
-- Data for Name: encryption_keys; Type: TABLE DATA; Schema: system; Owner: us
--

COPY system.encryption_keys (id, key) FROM stdin;
userKey	Lw_svbz1MlGoSf-VGQKmdBGYzouxh4QmZguqOAr96Fq__dWglkg-PG6KvOCW4L5p
smtpKey	JWIp2BZKHlIb_j8BQw1HzGA73Cugs3agD2_5y52CP34hE-GwXBaEUDe14WHnKOTt
oidcKey	jb9rLX83ZvefaIultdYF78fXXXhrsYtQwAxKLHBQvhkBA5JHVTlNzGO8x5Kcjkmg
domainVerificationKey	3U39KHH56snZqqZ9ybroo-OpEXfe_BBw6tErvYsqZ495ZSkSDU-nBq3IskM4kym4
idpConfigKey	V7IxUBh1U9tR-Z0nOS484xUxBkGS4EkpOt-EWvcpV9l_gWrYSbSPuEWd9nGozDbf
samlKey	Zie31BZ_xhA6IiCmRTnp_263yKB2jdlPymDHll-fSi2AuRL4otG_6_fyKL4XUdNG
otpKey	rmiXKetWDRVhW4IKtQGUim7mtC3L7wZYuPwS7roYe0hDZmmPKEkeeXpXrykGc6_u
smsKey	Vq15VTD53uvs7qowpHeE-TeVXFhk3z1EO_JeSaLcPjnkyOgJQdoE7Blu84eUDcZn
csrfCookieKey	9oAnu-zZrnqwKs2Rorb6LoZRwaAcwVAMCvD2uQdaq4BAeXFG7N2qv4DulQILjdDP
userAgentCookieKey	QyJkiSI8Q3H7MKRVHkF4Z1to0tNmPpx3jbrn1w6R9f9C4bB_Krts1H1IK5E4hbjn
\.


--
-- Name: system_seq; Type: SEQUENCE SET; Schema: eventstore; Owner: us
--

SELECT pg_catalog.setval('eventstore.system_seq', 1, false);


--
-- Name: current_sequences current_sequences_pkey; Type: CONSTRAINT; Schema: adminapi; Owner: us
--

ALTER TABLE ONLY adminapi.current_sequences
    ADD CONSTRAINT current_sequences_pkey PRIMARY KEY (view_name, instance_id);


--
-- Name: failed_events failed_events_pkey; Type: CONSTRAINT; Schema: adminapi; Owner: us
--

ALTER TABLE ONLY adminapi.failed_events
    ADD CONSTRAINT failed_events_pkey PRIMARY KEY (view_name, failed_sequence, instance_id);


--
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: adminapi; Owner: us
--

ALTER TABLE ONLY adminapi.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (view_name, instance_id);


--
-- Name: styling2 styling2_pkey; Type: CONSTRAINT; Schema: adminapi; Owner: us
--

ALTER TABLE ONLY adminapi.styling2
    ADD CONSTRAINT styling2_pkey PRIMARY KEY (instance_id, aggregate_id, label_policy_state);


--
-- Name: styling styling_pkey; Type: CONSTRAINT; Schema: adminapi; Owner: us
--

ALTER TABLE ONLY adminapi.styling
    ADD CONSTRAINT styling_pkey PRIMARY KEY (aggregate_id, label_policy_state, instance_id);


--
-- Name: auth_requests auth_requests_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.auth_requests
    ADD CONSTRAINT auth_requests_pkey PRIMARY KEY (id, instance_id);


--
-- Name: current_sequences current_sequences_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.current_sequences
    ADD CONSTRAINT current_sequences_pkey PRIMARY KEY (view_name, instance_id);


--
-- Name: failed_events failed_events_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.failed_events
    ADD CONSTRAINT failed_events_pkey PRIMARY KEY (view_name, failed_sequence, instance_id);


--
-- Name: idp_configs2 idp_configs2_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.idp_configs2
    ADD CONSTRAINT idp_configs2_pkey PRIMARY KEY (instance_id, idp_config_id);


--
-- Name: idp_configs idp_configs_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.idp_configs
    ADD CONSTRAINT idp_configs_pkey PRIMARY KEY (idp_config_id, instance_id);


--
-- Name: idp_providers2 idp_providers2_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.idp_providers2
    ADD CONSTRAINT idp_providers2_pkey PRIMARY KEY (instance_id, aggregate_id, idp_config_id);


--
-- Name: idp_providers idp_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.idp_providers
    ADD CONSTRAINT idp_providers_pkey PRIMARY KEY (aggregate_id, idp_config_id, instance_id);


--
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (view_name, instance_id);


--
-- Name: org_project_mapping2 org_project_mapping2_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.org_project_mapping2
    ADD CONSTRAINT org_project_mapping2_pkey PRIMARY KEY (instance_id, org_id, project_id);


--
-- Name: org_project_mapping org_project_mapping_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.org_project_mapping
    ADD CONSTRAINT org_project_mapping_pkey PRIMARY KEY (org_id, project_id, instance_id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id, instance_id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id, instance_id);


--
-- Name: user_external_idps2 user_external_idps2_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.user_external_idps2
    ADD CONSTRAINT user_external_idps2_pkey PRIMARY KEY (instance_id, external_user_id, idp_config_id);


--
-- Name: user_external_idps user_external_idps_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.user_external_idps
    ADD CONSTRAINT user_external_idps_pkey PRIMARY KEY (external_user_id, idp_config_id, instance_id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (user_agent_id, user_id, instance_id);


--
-- Name: users2 users2_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.users2
    ADD CONSTRAINT users2_pkey PRIMARY KEY (instance_id, id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: us
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id, instance_id);


--
-- Name: events2 events2_pkey; Type: CONSTRAINT; Schema: eventstore; Owner: us
--

ALTER TABLE ONLY eventstore.events2
    ADD CONSTRAINT events2_pkey PRIMARY KEY (instance_id, aggregate_type, aggregate_id, sequence);


--
-- Name: unique_constraints unique_constraints_pkey; Type: CONSTRAINT; Schema: eventstore; Owner: us
--

ALTER TABLE ONLY eventstore.unique_constraints
    ADD CONSTRAINT unique_constraints_pkey PRIMARY KEY (instance_id, unique_type, unique_field);


--
-- Name: actions3 actions3_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.actions3
    ADD CONSTRAINT actions3_pkey PRIMARY KEY (instance_id, id);


--
-- Name: apps6_api_configs apps6_api_configs_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps6_api_configs
    ADD CONSTRAINT apps6_api_configs_pkey PRIMARY KEY (instance_id, app_id);


--
-- Name: apps6_oidc_configs apps6_oidc_configs_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps6_oidc_configs
    ADD CONSTRAINT apps6_oidc_configs_pkey PRIMARY KEY (instance_id, app_id);


--
-- Name: apps6 apps6_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps6
    ADD CONSTRAINT apps6_pkey PRIMARY KEY (instance_id, id);


--
-- Name: apps6_saml_configs apps6_saml_configs_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps6_saml_configs
    ADD CONSTRAINT apps6_saml_configs_pkey PRIMARY KEY (instance_id, app_id);


--
-- Name: apps7_api_configs apps7_api_configs_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps7_api_configs
    ADD CONSTRAINT apps7_api_configs_pkey PRIMARY KEY (instance_id, app_id);


--
-- Name: apps7_oidc_configs apps7_oidc_configs_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps7_oidc_configs
    ADD CONSTRAINT apps7_oidc_configs_pkey PRIMARY KEY (instance_id, app_id);


--
-- Name: apps7 apps7_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps7
    ADD CONSTRAINT apps7_pkey PRIMARY KEY (instance_id, id);


--
-- Name: apps7_saml_configs apps7_saml_configs_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps7_saml_configs
    ADD CONSTRAINT apps7_saml_configs_pkey PRIMARY KEY (instance_id, app_id);


--
-- Name: auth_requests auth_requests_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.auth_requests
    ADD CONSTRAINT auth_requests_pkey PRIMARY KEY (instance_id, id);


--
-- Name: authn_keys2 authn_keys2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.authn_keys2
    ADD CONSTRAINT authn_keys2_pkey PRIMARY KEY (instance_id, id);


--
-- Name: current_sequences current_sequences_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.current_sequences
    ADD CONSTRAINT current_sequences_pkey PRIMARY KEY (projection_name, aggregate_type, instance_id);


--
-- Name: current_states current_states_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.current_states
    ADD CONSTRAINT current_states_pkey PRIMARY KEY (projection_name, instance_id);


--
-- Name: custom_texts2 custom_texts2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.custom_texts2
    ADD CONSTRAINT custom_texts2_pkey PRIMARY KEY (instance_id, aggregate_id, template, key, language);


--
-- Name: device_auth_requests2 device_auth_requests2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.device_auth_requests2
    ADD CONSTRAINT device_auth_requests2_pkey PRIMARY KEY (instance_id, device_code);


--
-- Name: device_auth_requests device_auth_requests_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.device_auth_requests
    ADD CONSTRAINT device_auth_requests_pkey PRIMARY KEY (instance_id, device_code);


--
-- Name: domain_policies2 domain_policies2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.domain_policies2
    ADD CONSTRAINT domain_policies2_pkey PRIMARY KEY (instance_id, id);


--
-- Name: executions executions_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.executions
    ADD CONSTRAINT executions_pkey PRIMARY KEY (instance_id, id);


--
-- Name: failed_events2 failed_events2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.failed_events2
    ADD CONSTRAINT failed_events2_pkey PRIMARY KEY (projection_name, instance_id, aggregate_type, aggregate_id, failed_sequence);


--
-- Name: failed_events failed_events_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.failed_events
    ADD CONSTRAINT failed_events_pkey PRIMARY KEY (projection_name, failed_sequence, instance_id);


--
-- Name: flow_triggers3 flow_triggers3_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.flow_triggers3
    ADD CONSTRAINT flow_triggers3_pkey PRIMARY KEY (instance_id, flow_type, trigger_type, resource_owner, action_id);


--
-- Name: idp_login_policy_links5 idp_login_policy_links5_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_login_policy_links5
    ADD CONSTRAINT idp_login_policy_links5_pkey PRIMARY KEY (instance_id, aggregate_id, idp_id);


--
-- Name: idp_templates5_apple idp_templates5_apple_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_apple
    ADD CONSTRAINT idp_templates5_apple_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_azure idp_templates5_azure_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_azure
    ADD CONSTRAINT idp_templates5_azure_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_github_enterprise idp_templates5_github_enterprise_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_github_enterprise
    ADD CONSTRAINT idp_templates5_github_enterprise_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_github idp_templates5_github_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_github
    ADD CONSTRAINT idp_templates5_github_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_gitlab idp_templates5_gitlab_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_gitlab
    ADD CONSTRAINT idp_templates5_gitlab_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_gitlab_self_hosted idp_templates5_gitlab_self_hosted_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_gitlab_self_hosted
    ADD CONSTRAINT idp_templates5_gitlab_self_hosted_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_google idp_templates5_google_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_google
    ADD CONSTRAINT idp_templates5_google_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_jwt idp_templates5_jwt_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_jwt
    ADD CONSTRAINT idp_templates5_jwt_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_ldap2 idp_templates5_ldap2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_ldap2
    ADD CONSTRAINT idp_templates5_ldap2_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_oauth2 idp_templates5_oauth2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_oauth2
    ADD CONSTRAINT idp_templates5_oauth2_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5_oidc idp_templates5_oidc_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_oidc
    ADD CONSTRAINT idp_templates5_oidc_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates5 idp_templates5_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5
    ADD CONSTRAINT idp_templates5_pkey PRIMARY KEY (instance_id, id);


--
-- Name: idp_templates5_saml idp_templates5_saml_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_saml
    ADD CONSTRAINT idp_templates5_saml_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_apple idp_templates6_apple_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_apple
    ADD CONSTRAINT idp_templates6_apple_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_azure idp_templates6_azure_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_azure
    ADD CONSTRAINT idp_templates6_azure_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_github_enterprise idp_templates6_github_enterprise_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_github_enterprise
    ADD CONSTRAINT idp_templates6_github_enterprise_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_github idp_templates6_github_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_github
    ADD CONSTRAINT idp_templates6_github_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_gitlab idp_templates6_gitlab_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_gitlab
    ADD CONSTRAINT idp_templates6_gitlab_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_gitlab_self_hosted idp_templates6_gitlab_self_hosted_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_gitlab_self_hosted
    ADD CONSTRAINT idp_templates6_gitlab_self_hosted_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_google idp_templates6_google_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_google
    ADD CONSTRAINT idp_templates6_google_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_jwt idp_templates6_jwt_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_jwt
    ADD CONSTRAINT idp_templates6_jwt_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_ldap2 idp_templates6_ldap2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_ldap2
    ADD CONSTRAINT idp_templates6_ldap2_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_oauth2 idp_templates6_oauth2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_oauth2
    ADD CONSTRAINT idp_templates6_oauth2_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6_oidc idp_templates6_oidc_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_oidc
    ADD CONSTRAINT idp_templates6_oidc_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_templates6 idp_templates6_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6
    ADD CONSTRAINT idp_templates6_pkey PRIMARY KEY (instance_id, id);


--
-- Name: idp_templates6_saml idp_templates6_saml_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_saml
    ADD CONSTRAINT idp_templates6_saml_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idp_user_links3 idp_user_links3_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_user_links3
    ADD CONSTRAINT idp_user_links3_pkey PRIMARY KEY (instance_id, idp_id, external_user_id);


--
-- Name: idps3_jwt_config idps3_jwt_config_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idps3_jwt_config
    ADD CONSTRAINT idps3_jwt_config_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idps3_oidc_config idps3_oidc_config_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idps3_oidc_config
    ADD CONSTRAINT idps3_oidc_config_pkey PRIMARY KEY (instance_id, idp_id);


--
-- Name: idps3 idps3_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idps3
    ADD CONSTRAINT idps3_pkey PRIMARY KEY (instance_id, id);


--
-- Name: instance_domains instance_domains_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.instance_domains
    ADD CONSTRAINT instance_domains_pkey PRIMARY KEY (instance_id, domain);


--
-- Name: instance_features2 instance_features2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.instance_features2
    ADD CONSTRAINT instance_features2_pkey PRIMARY KEY (instance_id, key);


--
-- Name: instance_members4 instance_members4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.instance_members4
    ADD CONSTRAINT instance_members4_pkey PRIMARY KEY (instance_id, id, user_id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: keys4_certificate keys4_certificate_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.keys4_certificate
    ADD CONSTRAINT keys4_certificate_pkey PRIMARY KEY (instance_id, id);


--
-- Name: keys4 keys4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.keys4
    ADD CONSTRAINT keys4_pkey PRIMARY KEY (instance_id, id);


--
-- Name: keys4_private keys4_private_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.keys4_private
    ADD CONSTRAINT keys4_private_pkey PRIMARY KEY (instance_id, id);


--
-- Name: keys4_public keys4_public_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.keys4_public
    ADD CONSTRAINT keys4_public_pkey PRIMARY KEY (instance_id, id);


--
-- Name: label_policies3 label_policies3_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.label_policies3
    ADD CONSTRAINT label_policies3_pkey PRIMARY KEY (instance_id, id, state);


--
-- Name: limits limits_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.limits
    ADD CONSTRAINT limits_pkey PRIMARY KEY (instance_id, resource_owner);


--
-- Name: lockout_policies2 lockout_policies2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.lockout_policies2
    ADD CONSTRAINT lockout_policies2_pkey PRIMARY KEY (instance_id, id);


--
-- Name: lockout_policies3 lockout_policies3_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.lockout_policies3
    ADD CONSTRAINT lockout_policies3_pkey PRIMARY KEY (instance_id, id);


--
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (projection_name, instance_id);


--
-- Name: login_names3_domains login_names3_domains_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.login_names3_domains
    ADD CONSTRAINT login_names3_domains_pkey PRIMARY KEY (instance_id, resource_owner, name);


--
-- Name: login_names3_policies login_names3_policies_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.login_names3_policies
    ADD CONSTRAINT login_names3_policies_pkey PRIMARY KEY (instance_id, resource_owner);


--
-- Name: login_names3_users login_names3_users_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.login_names3_users
    ADD CONSTRAINT login_names3_users_pkey PRIMARY KEY (instance_id, id);


--
-- Name: login_policies5 login_policies5_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.login_policies5
    ADD CONSTRAINT login_policies5_pkey PRIMARY KEY (instance_id, aggregate_id);


--
-- Name: mail_templates2 mail_templates2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.mail_templates2
    ADD CONSTRAINT mail_templates2_pkey PRIMARY KEY (instance_id, aggregate_id);


--
-- Name: message_texts2 message_texts2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.message_texts2
    ADD CONSTRAINT message_texts2_pkey PRIMARY KEY (instance_id, aggregate_id, type, language);


--
-- Name: milestones milestones_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.milestones
    ADD CONSTRAINT milestones_pkey PRIMARY KEY (instance_id, type);


--
-- Name: notification_policies notification_policies_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.notification_policies
    ADD CONSTRAINT notification_policies_pkey PRIMARY KEY (instance_id, id);


--
-- Name: notification_providers notification_providers_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.notification_providers
    ADD CONSTRAINT notification_providers_pkey PRIMARY KEY (instance_id, aggregate_id, provider_type);


--
-- Name: oidc_settings2 oidc_settings2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.oidc_settings2
    ADD CONSTRAINT oidc_settings2_pkey PRIMARY KEY (instance_id, aggregate_id);


--
-- Name: org_domains2 org_domains2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.org_domains2
    ADD CONSTRAINT org_domains2_pkey PRIMARY KEY (org_id, domain, instance_id);


--
-- Name: org_members4 org_members4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.org_members4
    ADD CONSTRAINT org_members4_pkey PRIMARY KEY (instance_id, org_id, user_id);


--
-- Name: org_metadata2 org_metadata2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.org_metadata2
    ADD CONSTRAINT org_metadata2_pkey PRIMARY KEY (instance_id, org_id, key);


--
-- Name: orgs1 orgs1_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.orgs1
    ADD CONSTRAINT orgs1_pkey PRIMARY KEY (instance_id, id);


--
-- Name: password_age_policies2 password_age_policies2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.password_age_policies2
    ADD CONSTRAINT password_age_policies2_pkey PRIMARY KEY (instance_id, id);


--
-- Name: password_complexity_policies2 password_complexity_policies2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.password_complexity_policies2
    ADD CONSTRAINT password_complexity_policies2_pkey PRIMARY KEY (instance_id, id);


--
-- Name: personal_access_tokens3 personal_access_tokens3_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.personal_access_tokens3
    ADD CONSTRAINT personal_access_tokens3_pkey PRIMARY KEY (instance_id, id);


--
-- Name: privacy_policies3 privacy_policies3_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.privacy_policies3
    ADD CONSTRAINT privacy_policies3_pkey PRIMARY KEY (instance_id, id);


--
-- Name: project_grant_members4 project_grant_members4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.project_grant_members4
    ADD CONSTRAINT project_grant_members4_pkey PRIMARY KEY (instance_id, project_id, grant_id, user_id);


--
-- Name: project_grants4 project_grants4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.project_grants4
    ADD CONSTRAINT project_grants4_pkey PRIMARY KEY (instance_id, grant_id);


--
-- Name: project_members4 project_members4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.project_members4
    ADD CONSTRAINT project_members4_pkey PRIMARY KEY (instance_id, project_id, user_id);


--
-- Name: project_roles4 project_roles4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.project_roles4
    ADD CONSTRAINT project_roles4_pkey PRIMARY KEY (instance_id, project_id, role_key);


--
-- Name: projects4 projects4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.projects4
    ADD CONSTRAINT projects4_pkey PRIMARY KEY (instance_id, id);


--
-- Name: quotas_notifications quotas_notifications_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.quotas_notifications
    ADD CONSTRAINT quotas_notifications_pkey PRIMARY KEY (instance_id, unit, id);


--
-- Name: quotas_periods quotas_periods_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.quotas_periods
    ADD CONSTRAINT quotas_periods_pkey PRIMARY KEY (instance_id, unit, start);


--
-- Name: quotas quotas_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.quotas
    ADD CONSTRAINT quotas_pkey PRIMARY KEY (instance_id, unit);


--
-- Name: restrictions2 restrictions2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.restrictions2
    ADD CONSTRAINT restrictions2_pkey PRIMARY KEY (instance_id, resource_owner);


--
-- Name: secret_generators2 secret_generators2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.secret_generators2
    ADD CONSTRAINT secret_generators2_pkey PRIMARY KEY (instance_id, generator_type, aggregate_id);


--
-- Name: security_policies2 security_policies2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.security_policies2
    ADD CONSTRAINT security_policies2_pkey PRIMARY KEY (instance_id);


--
-- Name: sessions8 sessions8_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.sessions8
    ADD CONSTRAINT sessions8_pkey PRIMARY KEY (instance_id, id);


--
-- Name: sms_configs2 sms_configs2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.sms_configs2
    ADD CONSTRAINT sms_configs2_pkey PRIMARY KEY (instance_id, id);


--
-- Name: sms_configs2_twilio sms_configs2_twilio_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.sms_configs2_twilio
    ADD CONSTRAINT sms_configs2_twilio_pkey PRIMARY KEY (instance_id, sms_id);


--
-- Name: smtp_configs1 smtp_configs1_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.smtp_configs1
    ADD CONSTRAINT smtp_configs1_pkey PRIMARY KEY (instance_id, aggregate_id);


--
-- Name: smtp_configs2 smtp_configs2_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.smtp_configs2
    ADD CONSTRAINT smtp_configs2_pkey PRIMARY KEY (instance_id, resource_owner, id);


--
-- Name: system_features system_features_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.system_features
    ADD CONSTRAINT system_features_pkey PRIMARY KEY (key);


--
-- Name: targets targets_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.targets
    ADD CONSTRAINT targets_pkey PRIMARY KEY (instance_id, id);


--
-- Name: user_auth_methods4 user_auth_methods4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.user_auth_methods4
    ADD CONSTRAINT user_auth_methods4_pkey PRIMARY KEY (instance_id, user_id, method_type, token_id);


--
-- Name: user_grants4 user_grants4_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.user_grants4
    ADD CONSTRAINT user_grants4_pkey PRIMARY KEY (instance_id, id);


--
-- Name: user_grants5 user_grants5_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.user_grants5
    ADD CONSTRAINT user_grants5_pkey PRIMARY KEY (instance_id, id);


--
-- Name: user_metadata5 user_metadata5_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.user_metadata5
    ADD CONSTRAINT user_metadata5_pkey PRIMARY KEY (instance_id, user_id, key);


--
-- Name: user_schemas user_schemas_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.user_schemas
    ADD CONSTRAINT user_schemas_pkey PRIMARY KEY (instance_id, id);


--
-- Name: users10_humans users10_humans_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users10_humans
    ADD CONSTRAINT users10_humans_pkey PRIMARY KEY (instance_id, user_id);


--
-- Name: users10_machines users10_machines_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users10_machines
    ADD CONSTRAINT users10_machines_pkey PRIMARY KEY (instance_id, user_id);


--
-- Name: users10_notifications users10_notifications_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users10_notifications
    ADD CONSTRAINT users10_notifications_pkey PRIMARY KEY (instance_id, user_id);


--
-- Name: users10 users10_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users10
    ADD CONSTRAINT users10_pkey PRIMARY KEY (instance_id, id);


--
-- Name: users12_humans users12_humans_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users12_humans
    ADD CONSTRAINT users12_humans_pkey PRIMARY KEY (instance_id, user_id);


--
-- Name: users12_machines users12_machines_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users12_machines
    ADD CONSTRAINT users12_machines_pkey PRIMARY KEY (instance_id, user_id);


--
-- Name: users12_notifications users12_notifications_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users12_notifications
    ADD CONSTRAINT users12_notifications_pkey PRIMARY KEY (instance_id, user_id);


--
-- Name: users12 users12_pkey; Type: CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users12
    ADD CONSTRAINT users12_pkey PRIMARY KEY (instance_id, id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: system; Owner: us
--

ALTER TABLE ONLY system.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (instance_id, resource_owner, name);


--
-- Name: encryption_keys encryption_keys_pkey; Type: CONSTRAINT; Schema: system; Owner: us
--

ALTER TABLE ONLY system.encryption_keys
    ADD CONSTRAINT encryption_keys_pkey PRIMARY KEY (id);


--
-- Name: current_sequences_instance_id_idx; Type: INDEX; Schema: adminapi; Owner: us
--

CREATE INDEX current_sequences_instance_id_idx ON adminapi.current_sequences USING btree (instance_id);


--
-- Name: failed_events_instance_id_idx; Type: INDEX; Schema: adminapi; Owner: us
--

CREATE INDEX failed_events_instance_id_idx ON adminapi.failed_events USING btree (instance_id);


--
-- Name: st2_owner_removed_idx; Type: INDEX; Schema: adminapi; Owner: us
--

CREATE INDEX st2_owner_removed_idx ON adminapi.styling2 USING btree (owner_removed);


--
-- Name: auth_code_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX auth_code_idx ON auth.auth_requests USING btree (code);


--
-- Name: current_sequences_instance_id_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX current_sequences_instance_id_idx ON auth.current_sequences USING btree (instance_id);


--
-- Name: ext_idps2_owner_removed_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX ext_idps2_owner_removed_idx ON auth.user_external_idps2 USING btree (owner_removed);


--
-- Name: failed_events_instance_id_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX failed_events_instance_id_idx ON auth.failed_events USING btree (instance_id);


--
-- Name: idp_conf2_owner_removed_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX idp_conf2_owner_removed_idx ON auth.idp_configs2 USING btree (owner_removed);


--
-- Name: idp_prov2_owner_removed_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX idp_prov2_owner_removed_idx ON auth.idp_providers2 USING btree (owner_removed);


--
-- Name: inst_app_tkn_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX inst_app_tkn_idx ON auth.tokens USING btree (instance_id, application_id);


--
-- Name: inst_refresh_tkn_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX inst_refresh_tkn_idx ON auth.tokens USING btree (instance_id, refresh_token_id);


--
-- Name: inst_ro_tkn_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX inst_ro_tkn_idx ON auth.tokens USING btree (instance_id, resource_owner);


--
-- Name: inst_usr_agnt_tkn_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX inst_usr_agnt_tkn_idx ON auth.tokens USING btree (instance_id, user_id, user_agent_id);


--
-- Name: org_proj_m2_owner_removed_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX org_proj_m2_owner_removed_idx ON auth.org_project_mapping2 USING btree (owner_removed);


--
-- Name: u2_owner_removed_idx; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX u2_owner_removed_idx ON auth.users2 USING btree (owner_removed);


--
-- Name: unique_client_user_index; Type: INDEX; Schema: auth; Owner: us
--

CREATE UNIQUE INDEX unique_client_user_index ON auth.refresh_tokens USING btree (client_id, user_agent_id, user_id);


--
-- Name: user_sessions_by_user; Type: INDEX; Schema: auth; Owner: us
--

CREATE INDEX user_sessions_by_user ON auth.user_sessions USING btree (instance_id, user_id);


--
-- Name: active_instances_events; Type: INDEX; Schema: eventstore; Owner: us
--

CREATE INDEX active_instances_events ON eventstore.events2 USING btree (aggregate_type, event_type) WHERE ((aggregate_type = 'instance'::text) AND (event_type = ANY (ARRAY['instance.added'::text, 'instance.removed'::text])));


--
-- Name: es_active_instances; Type: INDEX; Schema: eventstore; Owner: us
--

CREATE INDEX es_active_instances ON eventstore.events2 USING btree (created_at DESC, instance_id);


--
-- Name: es_projection; Type: INDEX; Schema: eventstore; Owner: us
--

CREATE INDEX es_projection ON eventstore.events2 USING btree (instance_id, aggregate_type, event_type, "position");


--
-- Name: es_wm; Type: INDEX; Schema: eventstore; Owner: us
--

CREATE INDEX es_wm ON eventstore.events2 USING btree (aggregate_id, instance_id, aggregate_type, event_type);


--
-- Name: events2_current_sequence; Type: INDEX; Schema: eventstore; Owner: us
--

CREATE INDEX events2_current_sequence ON eventstore.events2 USING btree (sequence DESC, aggregate_id, aggregate_type, instance_id);


--
-- Name: log_date_desc; Type: INDEX; Schema: logstore; Owner: us
--

CREATE INDEX log_date_desc ON logstore.execution USING btree (instance_id, log_date DESC) INCLUDE (took);


--
-- Name: protocol_date_desc; Type: INDEX; Schema: logstore; Owner: us
--

CREATE INDEX protocol_date_desc ON logstore.access USING btree (instance_id, protocol, log_date DESC) INCLUDE (request_url, response_status, request_headers);


--
-- Name: actions3_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX actions3_owner_removed_idx ON projections.actions3 USING btree (owner_removed);


--
-- Name: actions3_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX actions3_resource_owner_idx ON projections.actions3 USING btree (resource_owner);


--
-- Name: apps6_api_configs_client_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX apps6_api_configs_client_id_idx ON projections.apps6_api_configs USING btree (client_id);


--
-- Name: apps6_oidc_configs_client_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX apps6_oidc_configs_client_id_idx ON projections.apps6_oidc_configs USING btree (client_id);


--
-- Name: apps6_project_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX apps6_project_id_idx ON projections.apps6 USING btree (project_id);


--
-- Name: apps6_saml_configs_entity_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX apps6_saml_configs_entity_id_idx ON projections.apps6_saml_configs USING btree (entity_id);


--
-- Name: apps7_api_configs_client_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX apps7_api_configs_client_id_idx ON projections.apps7_api_configs USING btree (client_id);


--
-- Name: apps7_oidc_configs_client_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX apps7_oidc_configs_client_id_idx ON projections.apps7_oidc_configs USING btree (client_id);


--
-- Name: apps7_project_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX apps7_project_id_idx ON projections.apps7 USING btree (project_id);


--
-- Name: apps7_saml_configs_entity_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX apps7_saml_configs_entity_id_idx ON projections.apps7_saml_configs USING btree (entity_id);


--
-- Name: authn_keys2_enabled_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX authn_keys2_enabled_idx ON projections.authn_keys2 USING btree (enabled);


--
-- Name: authn_keys2_identifier_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX authn_keys2_identifier_idx ON projections.authn_keys2 USING btree (identifier);


--
-- Name: cs_instance_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX cs_instance_id_idx ON projections.current_states USING btree (instance_id);


--
-- Name: current_sequences_instance_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX current_sequences_instance_id_idx ON projections.current_sequences USING btree (instance_id);


--
-- Name: custom_texts2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX custom_texts2_owner_removed_idx ON projections.custom_texts2 USING btree (owner_removed);


--
-- Name: device_auth_requests2_user_code_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX device_auth_requests2_user_code_idx ON projections.device_auth_requests2 USING btree (instance_id, user_code);


--
-- Name: device_auth_requests_user_code_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX device_auth_requests_user_code_idx ON projections.device_auth_requests USING btree (instance_id, user_code);


--
-- Name: domain_policies2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX domain_policies2_owner_removed_idx ON projections.domain_policies2 USING btree (owner_removed);


--
-- Name: failed_events_instance_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX failed_events_instance_id_idx ON projections.failed_events USING btree (instance_id);


--
-- Name: fe2_instance_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX fe2_instance_id_idx ON projections.failed_events2 USING btree (instance_id);


--
-- Name: idp_login_policy_links5_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idp_login_policy_links5_owner_removed_idx ON projections.idp_login_policy_links5 USING btree (owner_removed);


--
-- Name: idp_login_policy_links5_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idp_login_policy_links5_resource_owner_idx ON projections.idp_login_policy_links5 USING btree (resource_owner);


--
-- Name: idp_templates5_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idp_templates5_owner_removed_idx ON projections.idp_templates5 USING btree (owner_removed);


--
-- Name: idp_templates5_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idp_templates5_resource_owner_idx ON projections.idp_templates5 USING btree (resource_owner);


--
-- Name: idp_templates6_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idp_templates6_owner_removed_idx ON projections.idp_templates6 USING btree (owner_removed);


--
-- Name: idp_templates6_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idp_templates6_resource_owner_idx ON projections.idp_templates6 USING btree (resource_owner);


--
-- Name: idp_user_links3_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idp_user_links3_owner_removed_idx ON projections.idp_user_links3 USING btree (owner_removed);


--
-- Name: idp_user_links3_user_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idp_user_links3_user_id_idx ON projections.idp_user_links3 USING btree (user_id);


--
-- Name: idps3_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idps3_owner_removed_idx ON projections.idps3 USING btree (owner_removed);


--
-- Name: idps3_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX idps3_resource_owner_idx ON projections.idps3 USING btree (resource_owner);


--
-- Name: instance_domains_instance_domain_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX instance_domains_instance_domain_idx ON projections.instance_domains USING btree (domain) INCLUDE (creation_date, change_date, sequence, is_generated, is_primary);


--
-- Name: instance_members4_im_instance_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX instance_members4_im_instance_idx ON projections.instance_members4 USING btree (instance_id) INCLUDE (creation_date, change_date, roles, sequence, resource_owner);


--
-- Name: instance_members4_user_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX instance_members4_user_id_idx ON projections.instance_members4 USING btree (user_id);


--
-- Name: label_policies3_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX label_policies3_owner_removed_idx ON projections.label_policies3 USING btree (owner_removed);


--
-- Name: lockout_policies2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX lockout_policies2_owner_removed_idx ON projections.lockout_policies2 USING btree (owner_removed);


--
-- Name: login_names3_domain_search; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX login_names3_domain_search ON projections.login_names3_domains USING btree (instance_id, resource_owner, name_lower);


--
-- Name: login_names3_domain_search_result; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX login_names3_domain_search_result ON projections.login_names3_domains USING btree (instance_id, resource_owner) INCLUDE (is_primary);


--
-- Name: login_names3_policies_is_default_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX login_names3_policies_is_default_idx ON projections.login_names3_policies USING btree (resource_owner, is_default);


--
-- Name: login_names3_users_instance_user_name_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX login_names3_users_instance_user_name_idx ON projections.login_names3_users USING btree (instance_id, user_name) INCLUDE (resource_owner);


--
-- Name: login_names3_users_lnu_instance_ro_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX login_names3_users_lnu_instance_ro_id_idx ON projections.login_names3_users USING btree (instance_id, resource_owner, id) INCLUDE (user_name);


--
-- Name: login_names3_users_search; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX login_names3_users_search ON projections.login_names3_users USING btree (instance_id, user_name_lower) INCLUDE (resource_owner);


--
-- Name: login_policies5_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX login_policies5_owner_removed_idx ON projections.login_policies5 USING btree (owner_removed);


--
-- Name: mail_templates2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX mail_templates2_owner_removed_idx ON projections.mail_templates2 USING btree (owner_removed);


--
-- Name: message_texts2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX message_texts2_owner_removed_idx ON projections.message_texts2 USING btree (owner_removed);


--
-- Name: org_domains2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX org_domains2_owner_removed_idx ON projections.org_domains2 USING btree (owner_removed);


--
-- Name: org_members4_om_instance_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX org_members4_om_instance_idx ON projections.org_members4 USING btree (instance_id) INCLUDE (creation_date, change_date, roles, sequence, resource_owner);


--
-- Name: org_members4_user_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX org_members4_user_id_idx ON projections.org_members4 USING btree (user_id);


--
-- Name: org_metadata2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX org_metadata2_owner_removed_idx ON projections.org_metadata2 USING btree (owner_removed);


--
-- Name: orgs1_domain_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX orgs1_domain_idx ON projections.orgs1 USING btree (primary_domain);


--
-- Name: orgs1_name_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX orgs1_name_idx ON projections.orgs1 USING btree (name);


--
-- Name: password_age_policies2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX password_age_policies2_owner_removed_idx ON projections.password_age_policies2 USING btree (owner_removed);


--
-- Name: password_complexity_policies2_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX password_complexity_policies2_owner_removed_idx ON projections.password_complexity_policies2 USING btree (owner_removed);


--
-- Name: personal_access_tokens3_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX personal_access_tokens3_owner_removed_idx ON projections.personal_access_tokens3 USING btree (owner_removed);


--
-- Name: personal_access_tokens3_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX personal_access_tokens3_resource_owner_idx ON projections.personal_access_tokens3 USING btree (resource_owner);


--
-- Name: personal_access_tokens3_user_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX personal_access_tokens3_user_id_idx ON projections.personal_access_tokens3 USING btree (user_id);


--
-- Name: privacy_policies3_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX privacy_policies3_owner_removed_idx ON projections.privacy_policies3 USING btree (owner_removed);


--
-- Name: project_grant_members4_pgm_instance_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX project_grant_members4_pgm_instance_idx ON projections.project_grant_members4 USING btree (instance_id) INCLUDE (creation_date, change_date, roles, sequence, resource_owner);


--
-- Name: project_grant_members4_user_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX project_grant_members4_user_id_idx ON projections.project_grant_members4 USING btree (user_id);


--
-- Name: project_grants4_granted_org_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX project_grants4_granted_org_idx ON projections.project_grants4 USING btree (granted_org_id);


--
-- Name: project_grants4_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX project_grants4_resource_owner_idx ON projections.project_grants4 USING btree (resource_owner);


--
-- Name: project_members4_pm_instance_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX project_members4_pm_instance_idx ON projections.project_members4 USING btree (instance_id) INCLUDE (creation_date, change_date, roles, sequence, resource_owner);


--
-- Name: project_members4_user_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX project_members4_user_id_idx ON projections.project_members4 USING btree (user_id);


--
-- Name: projects4_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX projects4_resource_owner_idx ON projections.projects4 USING btree (resource_owner);


--
-- Name: sessions8_user_agent_fingerprint_id_idx_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX sessions8_user_agent_fingerprint_id_idx_idx ON projections.sessions8 USING btree (user_agent_fingerprint_id);


--
-- Name: user_auth_methods4_owner_removed_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX user_auth_methods4_owner_removed_idx ON projections.user_auth_methods4 USING btree (owner_removed);


--
-- Name: user_auth_methods4_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX user_auth_methods4_resource_owner_idx ON projections.user_auth_methods4 USING btree (resource_owner);


--
-- Name: user_grants4_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX user_grants4_resource_owner_idx ON projections.user_grants4 USING btree (resource_owner);


--
-- Name: user_grants4_user_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX user_grants4_user_id_idx ON projections.user_grants4 USING btree (user_id);


--
-- Name: user_grants5_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX user_grants5_resource_owner_idx ON projections.user_grants5 USING btree (resource_owner);


--
-- Name: user_grants5_user_id_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX user_grants5_user_id_idx ON projections.user_grants5 USING btree (user_id);


--
-- Name: user_metadata5_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX user_metadata5_resource_owner_idx ON projections.user_metadata5 USING btree (resource_owner);


--
-- Name: users10_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX users10_resource_owner_idx ON projections.users10 USING btree (resource_owner);


--
-- Name: users10_username_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX users10_username_idx ON projections.users10 USING btree (username);


--
-- Name: users12_notifications_email_search; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX users12_notifications_email_search ON projections.users12_notifications USING btree (instance_id, verified_email_lower);


--
-- Name: users12_resource_owner_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX users12_resource_owner_idx ON projections.users12 USING btree (resource_owner);


--
-- Name: users12_username_idx; Type: INDEX; Schema: projections; Owner: us
--

CREATE INDEX users12_username_idx ON projections.users12 USING btree (username);


--
-- Name: apps6_api_configs fk_api_configs_ref_apps6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps6_api_configs
    ADD CONSTRAINT fk_api_configs_ref_apps6 FOREIGN KEY (instance_id, app_id) REFERENCES projections.apps6(instance_id, id) ON DELETE CASCADE;


--
-- Name: apps7_api_configs fk_api_configs_ref_apps7; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps7_api_configs
    ADD CONSTRAINT fk_api_configs_ref_apps7 FOREIGN KEY (instance_id, app_id) REFERENCES projections.apps7(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_apple fk_apple_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_apple
    ADD CONSTRAINT fk_apple_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_apple fk_apple_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_apple
    ADD CONSTRAINT fk_apple_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_azure fk_azure_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_azure
    ADD CONSTRAINT fk_azure_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_azure fk_azure_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_azure
    ADD CONSTRAINT fk_azure_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: keys4_certificate fk_certificate_ref_keys4; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.keys4_certificate
    ADD CONSTRAINT fk_certificate_ref_keys4 FOREIGN KEY (instance_id, id) REFERENCES projections.keys4(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_github_enterprise fk_github_enterprise_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_github_enterprise
    ADD CONSTRAINT fk_github_enterprise_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_github_enterprise fk_github_enterprise_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_github_enterprise
    ADD CONSTRAINT fk_github_enterprise_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_github fk_github_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_github
    ADD CONSTRAINT fk_github_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_github fk_github_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_github
    ADD CONSTRAINT fk_github_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_gitlab fk_gitlab_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_gitlab
    ADD CONSTRAINT fk_gitlab_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_gitlab fk_gitlab_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_gitlab
    ADD CONSTRAINT fk_gitlab_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_gitlab_self_hosted fk_gitlab_self_hosted_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_gitlab_self_hosted
    ADD CONSTRAINT fk_gitlab_self_hosted_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_gitlab_self_hosted fk_gitlab_self_hosted_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_gitlab_self_hosted
    ADD CONSTRAINT fk_gitlab_self_hosted_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_google fk_google_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_google
    ADD CONSTRAINT fk_google_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_google fk_google_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_google
    ADD CONSTRAINT fk_google_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: users10_humans fk_humans_ref_users10; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users10_humans
    ADD CONSTRAINT fk_humans_ref_users10 FOREIGN KEY (instance_id, user_id) REFERENCES projections.users10(instance_id, id) ON DELETE CASCADE;


--
-- Name: users12_humans fk_humans_ref_users12; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users12_humans
    ADD CONSTRAINT fk_humans_ref_users12 FOREIGN KEY (instance_id, user_id) REFERENCES projections.users12(instance_id, id) ON DELETE CASCADE;


--
-- Name: idps3_jwt_config fk_jwt_config_ref_idps3; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idps3_jwt_config
    ADD CONSTRAINT fk_jwt_config_ref_idps3 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idps3(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_jwt fk_jwt_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_jwt
    ADD CONSTRAINT fk_jwt_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_jwt fk_jwt_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_jwt
    ADD CONSTRAINT fk_jwt_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_ldap2 fk_ldap2_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_ldap2
    ADD CONSTRAINT fk_ldap2_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_ldap2 fk_ldap2_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_ldap2
    ADD CONSTRAINT fk_ldap2_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: users10_machines fk_machines_ref_users10; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users10_machines
    ADD CONSTRAINT fk_machines_ref_users10 FOREIGN KEY (instance_id, user_id) REFERENCES projections.users10(instance_id, id) ON DELETE CASCADE;


--
-- Name: users12_machines fk_machines_ref_users12; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users12_machines
    ADD CONSTRAINT fk_machines_ref_users12 FOREIGN KEY (instance_id, user_id) REFERENCES projections.users12(instance_id, id) ON DELETE CASCADE;


--
-- Name: users10_notifications fk_notifications_ref_users10; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users10_notifications
    ADD CONSTRAINT fk_notifications_ref_users10 FOREIGN KEY (instance_id, user_id) REFERENCES projections.users10(instance_id, id) ON DELETE CASCADE;


--
-- Name: users12_notifications fk_notifications_ref_users12; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.users12_notifications
    ADD CONSTRAINT fk_notifications_ref_users12 FOREIGN KEY (instance_id, user_id) REFERENCES projections.users12(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_oauth2 fk_oauth2_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_oauth2
    ADD CONSTRAINT fk_oauth2_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_oauth2 fk_oauth2_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_oauth2
    ADD CONSTRAINT fk_oauth2_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: idps3_oidc_config fk_oidc_config_ref_idps3; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idps3_oidc_config
    ADD CONSTRAINT fk_oidc_config_ref_idps3 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idps3(instance_id, id) ON DELETE CASCADE;


--
-- Name: apps6_oidc_configs fk_oidc_configs_ref_apps6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps6_oidc_configs
    ADD CONSTRAINT fk_oidc_configs_ref_apps6 FOREIGN KEY (instance_id, app_id) REFERENCES projections.apps6(instance_id, id) ON DELETE CASCADE;


--
-- Name: apps7_oidc_configs fk_oidc_configs_ref_apps7; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps7_oidc_configs
    ADD CONSTRAINT fk_oidc_configs_ref_apps7 FOREIGN KEY (instance_id, app_id) REFERENCES projections.apps7(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_oidc fk_oidc_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_oidc
    ADD CONSTRAINT fk_oidc_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_oidc fk_oidc_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_oidc
    ADD CONSTRAINT fk_oidc_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: keys4_private fk_private_ref_keys4; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.keys4_private
    ADD CONSTRAINT fk_private_ref_keys4 FOREIGN KEY (instance_id, id) REFERENCES projections.keys4(instance_id, id) ON DELETE CASCADE;


--
-- Name: keys4_public fk_public_ref_keys4; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.keys4_public
    ADD CONSTRAINT fk_public_ref_keys4 FOREIGN KEY (instance_id, id) REFERENCES projections.keys4(instance_id, id) ON DELETE CASCADE;


--
-- Name: apps6_saml_configs fk_saml_configs_ref_apps6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps6_saml_configs
    ADD CONSTRAINT fk_saml_configs_ref_apps6 FOREIGN KEY (instance_id, app_id) REFERENCES projections.apps6(instance_id, id) ON DELETE CASCADE;


--
-- Name: apps7_saml_configs fk_saml_configs_ref_apps7; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.apps7_saml_configs
    ADD CONSTRAINT fk_saml_configs_ref_apps7 FOREIGN KEY (instance_id, app_id) REFERENCES projections.apps7(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates5_saml fk_saml_ref_idp_templates5; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates5_saml
    ADD CONSTRAINT fk_saml_ref_idp_templates5 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates5(instance_id, id) ON DELETE CASCADE;


--
-- Name: idp_templates6_saml fk_saml_ref_idp_templates6; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.idp_templates6_saml
    ADD CONSTRAINT fk_saml_ref_idp_templates6 FOREIGN KEY (instance_id, idp_id) REFERENCES projections.idp_templates6(instance_id, id) ON DELETE CASCADE;


--
-- Name: sms_configs2_twilio fk_twilio_ref_sms_configs2; Type: FK CONSTRAINT; Schema: projections; Owner: us
--

ALTER TABLE ONLY projections.sms_configs2_twilio
    ADD CONSTRAINT fk_twilio_ref_sms_configs2 FOREIGN KEY (instance_id, sms_id) REFERENCES projections.sms_configs2(instance_id, id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

