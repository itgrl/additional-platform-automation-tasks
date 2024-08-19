#!/usr/bin/env bash
# code_snippet get-guid-script start bash

cat /var/version && echo ""
set -eux

om --env env/"${ENV_FILE}" curl -p /api/v0/deployed/products/ | jq -c '.[] | select(.type == "${PRODUCT_SLUG}")' | jq '.guid' | tee /tmp/"${PRODUCT_SLUG}"-guid.tmp

# code_snippet get-guid-script end