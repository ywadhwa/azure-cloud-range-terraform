#!/usr/bin/env bash
set -euo pipefail

ENV_DIR=${ENV_DIR:-infra/envs/baseline}

cd "$ENV_DIR"
terraform destroy -auto-approve
