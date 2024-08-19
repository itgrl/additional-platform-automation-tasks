#!/usr/bin/env bash
# code_snippet credhub-get-script start bash

cat /var/version && echo ""
set -euo pipefail

# NOTE: The credhub cli does not ignore empty/null environment variables.
# https://github.com/cloudfoundry-incubator/credhub-cli/issues/68
if [ -z "${CREDHUB_CA_CERT}" ]; then
  unset CREDHUB_CA_CERT
fi

credhub --version

# shellcheck disable=SC2086

flags=("")
mkdir templates
cat "${TEMPLATE}" > "templates/${FILENAME}"
mkdir -p interpolated-files/credhub-get

# ${flags[@] needs to be globbed to pass through properly
# shellcheck disable=SC2068

credhub interpolate \
  --file templates/"${FILENAME}" ${flags[@]} \
  >interpolated-files/"${FILENAME}"

# code_snippet credhub-get-script end