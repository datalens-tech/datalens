#!/bin/bash

IS_OPEN="false"
IS_CLOSE="false"
PROXY_PORT="1080"

# parse args
for i in "$@"; do
  case ${1} in
  --port)
    PROXY_PORT="${2}"
    shift # past argument
    shift # past value
    ;;
  --open)
    IS_OPEN="true"
    shift # past argument with no value
    ;;
  --close)
    IS_CLOSE="true"
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

PROXY_CONTROL_SOCKET="${PROFILE_NAME}-proxy"

SSH_KEY_PATH=$(yc compute ssh certificate export --cloud-id "${CLOUD_ID}" --profile "${PROFILE_NAME}" | grep 'Identity: ' | sed 's|Identity: ||' | tr -d ' ')
SSH_LOGIN=$(echo "${SSH_KEY_PATH}" | grep -o "yc-sa-.*")

BASTION_IP=$(yc compute instance get --name "${PROFILE_NAME}-bastion" --profile "${PROFILE_NAME}" --folder-id "${FOLDER_ID}" --format json | jq -r '.network_interfaces[0].primary_v4_address.one_to_one_nat.address')

open() {
  if ssh -S "${PROXY_CONTROL_SOCKET}" -o "StrictHostKeyChecking no" -O check -N -q "${SSH_LOGIN}@${BASTION_IP}" -i "${SSH_KEY_PATH}" >/dev/null 2>&1; then
    echo "  - close old k8s bastion proxy, before open new..." >&2
    ssh -S "${PROXY_CONTROL_SOCKET}" -o "StrictHostKeyChecking no" -O exit -N -q "${SSH_LOGIN}@${BASTION_IP}" -i "${SSH_KEY_PATH}"
  fi
  echo "  - open k8s bastion proxy..." >&2

  # -M place the ssh client into master mode for connection sharing with control socket
  # -S specifies the location of a control socket
  # -f specifies an alternative configuration file
  # -n prevents reading from stdin
  # -N do not execute a remote command
  # -T disable pseudo-terminal allocation
  ssh -M -fnNT -S "${PROXY_CONTROL_SOCKET}" -o "StrictHostKeyChecking no" -q -D "${PROXY_PORT}" "${SSH_LOGIN}@${BASTION_IP}" -i "${SSH_KEY_PATH}"
}

close() {
  if ssh -S "${PROXY_CONTROL_SOCKET}" -o "StrictHostKeyChecking no" -O check -q "${SSH_LOGIN}@${BASTION_IP}" -i "${SSH_KEY_PATH}" >/dev/null 2>&1; then
    echo "  - close k8s bastion proxy..." >&2
    ssh -S "${PROXY_CONTROL_SOCKET}" -o "StrictHostKeyChecking no" -O exit -N -q "${SSH_LOGIN}@${BASTION_IP}" -i "${SSH_KEY_PATH}"
  else
    echo "  - active k8s bastion proxy does not exist..." >&2
  fi
}

if [ "${IS_OPEN}" == "true" ]; then
  open
fi

if [ "${IS_CLOSE}" == "true" ]; then
  close
fi
