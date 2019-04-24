#!/usr/bin/env bash
set -euo pipefail

cd /bundle_update/bendigo
bundle update --jobs="$(nproc)"
