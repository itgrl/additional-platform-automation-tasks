#!/usr/bin/env bash
# code_snippet get-guid-script start bash

cat /var/version && echo ""
set -eux

if [ ! -d deployment-guids ]; then 
  mkdir deployment-guids
fi

om --env env/"${ENV_FILE}" curl -p /api/v0/deployed/products/ | \
jq -c '.[] | select(.type == "${PRODUCT_SLUG}")' | jq '.guid' >x deployment-guids/"${PRODUCT_SLUG}"

# code_snippet get-guid-script end