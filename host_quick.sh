#!/bin/bash
# --- Define var---

# --- Start to stress test ---
URL="${1}"
if [[ -z "${URL}" ]]; then
  echo "URL is not specified..."
  echo
  exit
fi

IF_PROTO="$(echo "${URL}" | grep '/')"

if [[ -n $IF_PROTO ]]; then
  URI_BASE="$(echo "${URL}" | awk -F'/' '{print $3}')"
else
  URI_BASE="$URL"
fi

host $URI_BASE
