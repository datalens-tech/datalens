#!/bin/bash

IS_CLEANUP="false"
IS_APPLY="false"
IS_APPROVE="false"
IS_INIT="false"
IS_TOFURC="false"
IS_DOCKER_LOGIN="false"

# parse args
for i in "$@"; do
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
  --out)
    PLAN_OUT="${2}"
    shift # past argument
    shift # past value
    ;;
  --apply)
    IS_APPLY="true"
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
  -* | --*)
    echo "unknown arg: $i"
    exit 1
    ;;
  *) ;;
  esac
done

if [ -f ./.env ]; then
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

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")

SERVICE="datalens"
SUFFIX="opensource-sandbox"

LOCKBOX_NAME="${SERVICE}-${SUFFIX}-terraform"

# api endpoints
CR_ENDPOINT=$(echo "${API_ENDPOINT}" | sed -E 's|^api.|cr.|')

PROFILE_NAME="${SERVICE}-${SUFFIX}"

if [ "$CI" == "true" ]; then
  PROFILE_NAME="${SERVICE}-${SUFFIX}-$(date +%s)"
fi

if [ -z "${SA_FILE}" ] && [ "$CI" != "true" ]; then
  SA_FILE="$(pwd)/sa_key.json"
fi

if [ ! -z "${YC_CLI_PATH}" ]; then
  yc() {
    ${YC_CLI_PATH} "$@"
  }
fi

YC_PROFILE_EXISTS=$(yc config profile list 2>/dev/null | grep -q "${PROFILE_NAME}" && echo "true")

yc-cleanup() {
  if [ "${IS_CLEANUP}" != "true" ] && [ "${CI}" != "true" ]; then
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

    yc config set cloud-id ${CLOUD_ID} &>/dev/null || exit 1
    yc config set folder-id ${FOLDER_ID} &>/dev/null || exit 1
    yc config set endpoint "${API_ENDPOINT}:443" &>/dev/null || exit 1
    if [ ! -z "${SA_FILE}" ]; then
      yc config set service-account-key "${SA_FILE}" &>/dev/null || exit 1
    fi
  else
    echo "❌ service account file '${SA_FILE}' does not exists, configure profile '${PROFILE_NAME}' manually at 'yc' cli or provider sa account file, exit..."
  fi
fi

SERVICE_ACCOUNT_ID=$(yc --profile=${PROFILE_NAME} --folder-id=${FOLDER_ID} lockbox payload get --name "${LOCKBOX_NAME}" --key service-account-id)

export AWS_ACCESS_KEY_ID=$(yc --profile=${PROFILE_NAME} --folder-id=${FOLDER_ID} lockbox payload get --name "${LOCKBOX_NAME}" --key access-key)
export AWS_SECRET_ACCESS_KEY=$(yc --profile=${PROFILE_NAME} --folder-id=${FOLDER_ID} lockbox payload get --name "${LOCKBOX_NAME}" --key secret-key)
export AWS_ENDPOINT_URL_S3="${STORAGE_ENDPOINT}"
export YC_STORAGE_ACCESS_KEY="${AWS_ACCESS_KEY_ID}"
export YC_STORAGE_SECRET_KEY="${AWS_SECRET_ACCESS_KEY}"

if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
  echo "❌ error load lockbox payload from name '${LOCKBOX_NAME}', check profile settings, exit..."
  exit 1
fi

export BACKEND_STATE_BUCKET=$(yc --profile=${PROFILE_NAME} --folder-id=${FOLDER_ID} lockbox payload get --name "${LOCKBOX_NAME}" --key backend-state-bucket)
export BACKEND_STATE_KEY=$(yc --profile=${PROFILE_NAME} --folder-id=${FOLDER_ID} lockbox payload get --name "${LOCKBOX_NAME}" --key backend-state-key)
export BACKEND_STATE_REGION=$(yc --profile=${PROFILE_NAME} --folder-id=${FOLDER_ID} lockbox payload get --name "${LOCKBOX_NAME}" --key backend-state-region)

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

export TF_VAR_YC_TOKEN=$(yc --profile=${PROFILE_NAME} --folder-id=${FOLDER_ID} iam create-token --impersonate-service-account-id "${SERVICE_ACCOUNT_ID}")

if [ -z "${TF_VAR_YC_TOKEN}" ]; then
  echo "❌ error obtain iam token for sa '${SERVICE_ACCOUNT_ID}', check profile settings, exit..."
  exit 1
fi

if [ "${IS_DOCKER_LOGIN}" == "true" ]; then
  echo "🐋 docker login to registry with iam token..."
  echo "${TF_VAR_YC_TOKEN}" | docker login --username iam --password-stdin "${CR_ENDPOINT}" || exit 1
  exit 0
fi

if [ "${IS_TOFURC}" == "true" ]; then
  echo "🔧 update .tofurc file with mirrors..."

  echo 'provider_installation {
  network_mirror {
    url = "https://'"${TOFU_MIRROR}"'/"
    include = ["registry.opentofu.org/*/*"]
  }
  direct {
    exclude = ["registry.opentofu.org/*/*"]
  }
}' >~/.tofurc
fi

if [ "${IS_INIT}" == "true" ]; then
  echo "🧰 init backend..."
  tofu init -reconfigure -upgrade || exit 1
fi

echo ""
echo "🔍 validate config..."
echo ""

tofu validate || exit 1

if [ ! -z "${RM_FROM_STATE}" ]; then
  tofu state rm "${RM_FROM_STATE}" || exit 1
  exit 0
fi

if [ ! -z "${IMPORT_TO_STATE_ADDRESS}" ]; then
  if [ ! -z "${IMPORT_TO_STATE_ID}" ]; then
    tofu import "${IMPORT_TO_STATE_ADDRESS}" "${IMPORT_TO_STATE_ID}" || exit 1
    exit 0
  fi
fi

if [ ! -z "${TARGET}" ]; then
  TARGET="-target ${TARGET}"
fi

if [ "${IS_APPLY}" == "true" ]; then
  if [ "${IS_APPROVE}" == "true" ]; then
    echo ""
    echo "🤖 apply with auto-approve..."
    echo ""
    tofu apply -auto-approve -input=false ${TARGET}
  else
    echo ""
    echo "🚀 apply..."
    echo ""
    tofu apply -input=false ${TARGET}
  fi
else
  echo ""
  echo "📝 plan..."
  echo ""

  if [ ! -z "${PLAN_OUT}" ]; then
    tofu plan -input=false -out="${PLAN_OUT}.temp" ${TARGET}
    tofu show -no-color "${PLAN_OUT}.temp" | sed -E 's|(^ +\+)|🟢\1|' | sed -E 's|(^ +\-)|🔴\1|' | sed -E 's|(^ +\~)|🔄\1|' >"${PLAN_OUT}.tfplan"
    rm -rf "${PLAN_OUT}.temp"
  else
    tofu plan -input=false ${TARGET}
  fi
fi
