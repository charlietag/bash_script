#!/bin/bash
# --- Define var---

# --- Start to stress test ---
URL="${1}"
if [[ -z "${URL}" ]]; then
  echo "URL is not specified..."
  echo
  exit
fi

URI_BASE="$(echo "${URL}" | awk -F'/' '{print $3}')"
host $URI_BASE
