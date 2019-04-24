#!/usr/bin/env bash
set -euo pipefail

echo "HELLO WORLD"
pwd
echo "HELLO"
cd /bundle_update/bendigo
bundle update --jobs="$(nproc)"
