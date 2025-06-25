#!/bin/bash

# exit setup
set -eo pipefail
# [-e] - immediately exit if any command has a non-zero exit status
# [-x] - all executed commands are printed to the terminal [not secure]
# [-o pipefail] - if any command in a pipeline fails, that return code will be used as the return code of the whole pipeline

IS_CLEANUP="false"
IS_PLAN="false"
IS_PLAN_MD="false"
IS_APPLY="false"
IS_APPROVE="false"
IS_INIT="false"
IS_TOFURC="false"
IS_LOCK="false"
IS_SILENT="false"
IS_LINT="false"
IS_LINT_FIX="false"
IS_DOCKER_LOGIN="false"
IS_HELM_LOGIN="false"

# parse args
for _ in "$@"; do
  case ${1} in
  --sa-file)
    SA_FILE="${2}"
    shift # past argument
    shift # past value
    ;;
  --yc-cli-path)
    YC_CLI_PATH="${2}"
    shift # past argument
    shift # past value
    ;;
  --rm)
    RM_FROM_STATE="${2}"
    shift # past argument
    shift # past value
    ;;
  --import)
    IMPORT_TO_STATE_ADDRESS="${2}"
    IMPORT_TO_STATE_ID="${3}"
    shift # past argument
    shift # past value-address
    shift # past value-id
    ;;
  --apply)
    IS_APPLY="true"
    shift # past argument with no value
    ;;
  --silent)
    IS_SILENT="true"
    shift # past argument with no value
    ;;
  --plan)
    IS_PLAN="true"
    shift # past argument with no value
    ;;
  --plan-input)
    PLAN_INPUT="${2}"
    shift # past argument
    shift # past value
    ;;
  --plan-out)
    PLAN_OUT="${2}"
    shift # past argument
    shift # past value
    ;;
  --plan-md)
    IS_PLAN_MD="true"
    shift # past argument with no value
    ;;
  --approve)
    IS_APPROVE="true"
    shift # past argument with no value
    ;;
  --cleanup)
    IS_CLEANUP="true"
    shift # past argument with no value
    ;;
  --docker-login)
    IS_DOCKER_LOGIN="true"
    shift # past argument with no value
    ;;
  --init)
    IS_INIT="true"
    shift # past argument with no value
    ;;
  --target)
    TARGET="${2}"
    shift # past argument
    shift # past value
    ;;
  --tofurc)
    IS_TOFURC="true"
    shift # past argument with no value
    ;;
  --lock)
    IS_LOCK="true"
    shift # past argument with no value
    ;;
  --lint)
    IS_LINT="true"
    shift # past argument with no value
    ;;
  --lint-fix)
    IS_LINT_FIX="true"
    shift # past argument with no value
    ;;
  -*)
    echo "unknown arg: ${1}"
    exit 1
    ;;
  *) ;;
  esac
done

if [ "${IS_LINT}" == "true" ]; then
  echo "🛡️ lint terraform files.."
  tofu fmt -recursive -check -diff || exit 1
  echo "✅ terraform files is valid"
  exit 0
fi

if [ "${IS_LINT_FIX}" == "true" ]; then
  echo "🛠️ fix terraform files style.."
  tofu fmt -recursive -diff
  echo "✅ terraform files is valid"
  exit 0
fi

if [ -f ./.env ]; then
  # shellcheck disable=SC1091
  source ./.env
fi

if [ -z "${API_ENDPOINT}" ]; then
  API_ENDPOINT="api.cloud.yandex.net"
fi

if [ -z "${STORAGE_ENDPOINT}" ]; then
  STORAGE_ENDPOINT="storage.yandexcloud.net"
fi

if [ -z "${CLOUD_ID}" ]; then
  echo "❌ env 'CLOUD_ID' is empty, please fill it..."
  exit 1
fi

if [ -z "${FOLDER_ID}" ]; then
  echo "❌ env 'FOLDER_ID' is empty, please fill it..."
  exit 1
fi

SERVICE="datalens"
SUFFIX="opensource-sandbox"

LOCKBOX_NAME="${SERVICE}-${SUFFIX}-terraform"

CR_ENDPOINT=$(echo "${API_ENDPOINT}" | sed -E 's|^api.|cr.|')

PROFILE_NAME="${SERVICE}-${SUFFIX}"

if [ "$CI" == "true" ]; then
  PROFILE_NAME="${SERVICE}-${SUFFIX}-$(date +%s)"
fi

if [ -z "${SA_FILE}" ] && [ "$CI" != "true" ]; then
  SA_FILE="$(pwd)/sa_key.json"
fi

# shellcheck disable=SC2236
if [ ! -z "${YC_CLI_PATH}" ]; then
  yc() {
    ${YC_CLI_PATH} "$@"
  }
fi

YC_PROFILE_EXISTS=$(yc config profile list 2>/dev/null | sed 's| ACTIVE||' | { grep -x "${PROFILE_NAME}" || true; } | head -n1 | sed "s|${PROFILE_NAME}|true|")

yc-cleanup() {
  if [ "${IS_CLEANUP}" != "true" ] || [ "${CI}" == "true" ]; then
    return 0
  fi

  yc config profile create temp || yc config profile activate temp

  yc config profile delete "${PROFILE_NAME}" &>/dev/null
}
trap 'yc-cleanup' EXIT

if [ ! "${YC_PROFILE_EXISTS}" == "true" ]; then
  echo "💡 yc profile [${PROFILE_NAME}] does not exists, creating..."
  if [ -f "${SA_FILE}" ] || [ "$CI" == "true" ]; then
    yc config profile create "${PROFILE_NAME}" &>/dev/null || exit 1

    yc --profile "${PROFILE_NAME}" config set cloud-id "${CLOUD_ID}" &>/dev/null || exit 1
    yc --profile "${PROFILE_NAME}" config set folder-id "${FOLDER_ID}" &>/dev/null || exit 1
    yc --profile "${PROFILE_NAME}" config set endpoint "${API_ENDPOINT}:443" &>/dev/null || exit 1
    yc config set service-account-key "${SA_FILE}" &>/dev/null || exit 1
  else
    echo "❌ service account file '${SA_FILE}' does not exists, configure profile '${PROFILE_NAME}' manually at 'yc' cli or provider sa account file, exit..."
  fi
fi

SERVICE_ACCOUNT_ID=$(yc --profile "${PROFILE_NAME}" --folder-id "${FOLDER_ID}" lockbox payload get --name "${LOCKBOX_NAME}" --key service-account-id)

# shellcheck disable=SC2155
export AWS_ACCESS_KEY_ID=$(yc --profile "${PROFILE_NAME}" --folder-id "${FOLDER_ID}" lockbox payload get --name "${LOCKBOX_NAME}" --key access-key)
# shellcheck disable=SC2155
export AWS_SECRET_ACCESS_KEY=$(yc --profile "${PROFILE_NAME}" --folder-id "${FOLDER_ID}" lockbox payload get --name "${LOCKBOX_NAME}" --key secret-key)
export AWS_ENDPOINT_URL_S3="${STORAGE_ENDPOINT}"
export YC_STORAGE_ACCESS_KEY="${AWS_ACCESS_KEY_ID}"
export YC_STORAGE_SECRET_KEY="${AWS_SECRET_ACCESS_KEY}"

if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
  echo "❌ error load lockbox payload from name '${LOCKBOX_NAME}', check profile settings, exit..."
  exit 1
fi

# shellcheck disable=SC2155
export BACKEND_STATE_BUCKET=$(yc --profile "${PROFILE_NAME}" --folder-id "${FOLDER_ID}" lockbox payload get --name "${LOCKBOX_NAME}" --key backend-state-bucket)
# shellcheck disable=SC2155
export BACKEND_STATE_KEY=$(yc --profile "${PROFILE_NAME}" --folder-id "${FOLDER_ID}" lockbox payload get --name "${LOCKBOX_NAME}" --key backend-state-key)
# shellcheck disable=SC2155
export BACKEND_STATE_REGION=$(yc --profile "${PROFILE_NAME}" --folder-id "${FOLDER_ID}" lockbox payload get --name "${LOCKBOX_NAME}" --key backend-state-region)

export TF_VAR_PROFILE="${PROFILE_NAME}"

export TF_VAR_CLOUD_ID="${CLOUD_ID}"
export TF_VAR_FOLDER_ID="${FOLDER_ID}"

export TF_VAR_API_ENDPOINT="${API_ENDPOINT}"
export TF_VAR_STORAGE_ENDPOINT="${STORAGE_ENDPOINT}"
export TF_VAR_CR_ENDPOINT="${CR_ENDPOINT}"

export TF_VAR_BACKEND_STATE_BUCKET="${BACKEND_STATE_BUCKET}"
export TF_VAR_BACKEND_STATE_KEY="${BACKEND_STATE_KEY}"
export TF_VAR_BACKEND_STATE_REGION="${BACKEND_STATE_REGION}"

export TF_VAR_DOMAIN="${DOMAIN}"

# shellcheck disable=SC2236
if [ ! -z "${YC_IAM_TOKEN}" ]; then
  export TF_VAR_YC_TOKEN="${YC_IAM_TOKEN}"
else
  # shellcheck disable=SC2155
  export TF_VAR_YC_TOKEN=$(yc --profile "${PROFILE_NAME}" iam create-token --impersonate-service-account-id "${SERVICE_ACCOUNT_ID}")
fi

if [ -z "${TF_VAR_YC_TOKEN}" ]; then
  echo "❌ error obtain iam token for sa '${SERVICE_ACCOUNT_ID}', check profile settings, exit..."
  exit 1
fi

if [ "${IS_DOCKER_LOGIN}" == "true" ]; then
  echo "🐋 docker login to registry with iam token..."
  echo "${TF_VAR_YC_TOKEN}" | docker login --username iam --password-stdin "${CR_ENDPOINT}" || exit 1
  exit 0
fi

if [ "${IS_HELM_LOGIN}" == "true" ]; then
  echo "🚢 helm login to registry with iam token..."
  echo "${TF_VAR_YC_TOKEN}" | helm registry login --username iam --password-stdin "${CR_ENDPOINT}" || exit 1
  exit 0
fi

if [ "${IS_TOFURC}" == "true" ]; then
  echo "🔧 update .tofurc file with mirrors..."

  echo 'provider_installation {
  network_mirror {
    url = "https://'"${TOFU_MIRROR}"'/"
    include = ["registry.terraform.io/*/*", "registry.opentofu.org/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*", "registry.opentofu.org/*/*"]
  }
}' >~/.tofurc
fi

if [ "${IS_SILENT}" == "true" ]; then
  export TF_LOG="error"
fi

if [ "${IS_INIT}" == "true" ]; then
  echo ""
  echo "🧰 init backend..."
  if [ "${IS_SILENT}" == "true" ]; then
    tofu init -reconfigure -upgrade >/dev/null || exit 1
  else
    tofu init -reconfigure -upgrade || exit 1
  fi
fi

if [ "${IS_LOCK}" == "true" ]; then
  echo ""
  echo "🔐 update lock file..."
  echo ""

  # remove old lock file
  rm -f .terraform.lock.hcl

  tofu providers lock \
    -net-mirror="https://${TOFU_MIRROR}" \
    -platform=linux_amd64 \
    -platform=linux_arm64 \
    -platform=darwin_arm64 \
    -platform=darwin_amd64 \
    hashicorp/dns \
    hashicorp/helm \
    hashicorp/http \
    hashicorp/local \
    hashicorp/random \
    hashicorp/time \
    hashicorp/tls \
    hashicorp/kubernetes \
    registry.terraform.io/yandex-cloud/yandex
fi

echo ""
echo "🔍 validate config..."
echo ""

if [ "${IS_SILENT}" == "true" ]; then
  tofu validate >/dev/null || exit 1
else
  tofu validate || exit 1
fi

# shellcheck disable=SC2236
if [ ! -z "${RM_FROM_STATE}" ]; then
  tofu state rm "${RM_FROM_STATE}" || exit 1
  exit 0
fi

# shellcheck disable=SC2236
if [ ! -z "${IMPORT_TO_STATE_ADDRESS}" ] && [ ! -z "${IMPORT_TO_STATE_ID}" ]; then
  tofu import "${IMPORT_TO_STATE_ADDRESS}" "${IMPORT_TO_STATE_ID}" || exit 1
  exit 0
fi

# shellcheck disable=SC2236
if [ ! -z "${TARGET}" ]; then
  TARGET_ARG=""
  # shellcheck disable=SC2001
  TARGET=$(echo "${TARGET}" | sed 's|\n| |')
  for TRG in $TARGET; do
    TARGET_ARG="${TARGET_ARG} -target ${TRG}"
  done
  TARGET="${TARGET_ARG}"
fi

if [ "${IS_APPLY}" == "true" ]; then
  if [ "${IS_APPROVE}" == "true" ]; then
    echo ""
    echo "🤖 apply with auto-approve..."
    echo ""
    # shellcheck disable=SC2086
    tofu apply -auto-approve -input=false ${TARGET} ${PLAN_INPUT}
  else
    echo ""
    echo "🚀 apply..."
    echo ""
    # shellcheck disable=SC2086
    tofu apply -input=false ${TARGET} ${PLAN_INPUT}
  fi
elif [ "${IS_PLAN}" == "true" ]; then
  echo ""
  echo "📝 plan..."
  echo ""

  # shellcheck disable=SC2236
  if [ ! -z "${PLAN_OUT}" ]; then
    if [ "${IS_SILENT}" == "true" ]; then
      # shellcheck disable=SC2086
      tofu plan -input=false -out="${PLAN_OUT}" ${TARGET} >/dev/null
    else
      # shellcheck disable=SC2086
      tofu plan -input=false -out="${PLAN_OUT}" ${TARGET}
    fi

    tofu show -no-color "${PLAN_OUT}" >"${PLAN_OUT}.txt"

    if [ "${IS_PLAN_MD}" == "true" ]; then
      tofu show -no-color -json "${PLAN_OUT}" >"${PLAN_OUT}.json"

      # shellcheck disable=SC2002
      MD_TABLE=$(cat "${PLAN_OUT}.json" | jq -r '.resource_changes[] | select(.change.actions[0] != "no-op") as $res | .change.actions[] | {action: ., resource: $res.address}')
      MD_TABLE=$(echo "${MD_TABLE}" | jq -r '. | "| " + .action + " | `" + .resource + "` |"')
      MD_TABLE=$(echo "${MD_TABLE}" | sed 's| create | 🟢 create |' | sed 's| update | 🟡 update |' | sed 's| delete | 🔴 delete |')
      echo "| ACTION | RESOURCE |" >"${PLAN_OUT}.md"
      echo "|---|---|" >>"${PLAN_OUT}.md"
      echo "${MD_TABLE}" >>"${PLAN_OUT}.md"

      rm -rf "${PLAN_OUT}.json"
    fi
  else
    # shellcheck disable=SC2086
    tofu plan -input=false ${TARGET}
  fi
fi
