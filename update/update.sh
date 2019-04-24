#!/usr/bin/env bash
set -euo pipefail

echo "HELLO WORLD"

cd /bundle_update/bendigo
bundle update --jobs="$(nproc)"
