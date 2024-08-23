#!/usr/bin/env bash
# code_snippet credhub-get-script start bash

cat /var/version && echo ""
set -euo pipefail

if [ -n "${OPSMAN_SSH_PRIVATE_KEY}" ];
then
  env | grep CREDHUB > credhub-env-vars.sh
  cat "${OPSMAN_SSH_PRIVATE_KEY}" > OPSMAN_SSH_PRIVATE_KEY.key
  eval $(om --env env/"${ENV_FILE}" bosh-env -i "OPSMAN_SSH_PRIVATE_KEY.key")
fi

# NOTE: The credhub cli does not ignore empty/null environment variables.
# https://github.com/cloudfoundry-incubator/credhub-cli/issues/68
if [ -z "${CREDHUB_CA_CERT}" ]; then
  unset CREDHUB_CA_CERT
fi

credhub --version

# shellcheck disable=SC2086

flags=("")
mkdir templates
echo -e "${TEMPLATE}" > "templates/${FILENAME}"
mkdir -p interpolated-files/credhub-get

# ${flags[@] needs to be globbed to pass through properly
# shellcheck disable=SC2068

credhub interpolate \
  --file templates/"${FILENAME}" ${flags[@]} \
  > interpolated-files/credhub-get/"${FILENAME}"

if [ -n "${OPSMAN_SSH_PRIVATE_KEY}" ];
then
  unset BOSH_ENVIRONMENT
  unset BOSH_CA_CERT
  unset CREDHUB_CLIENT
  unset CREDHUB_SERVER
  unset BOSH_ALL_PROXY
  unset CREDHUB_PROXY
  unset BOSH_CLIENT_SECRET
  unset CREDHUB_SECRET
  unset CREDHUB_CA_CERT
  unset BOSH_CLIENT
  export "$(cat credhub-env-vars.sh | xargs)"
fi

# code_snippet credhub-get-script end