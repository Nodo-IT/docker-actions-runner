#!/bin/bash
set -e

# Required environment variables
if [[ -z "$GITHUB_URL" || -z "$RUNNER_TOKEN" || -z "$RUNNER_NAME" ]]; then
  echo "Missing one of: GITHUB_URL, RUNNER_TOKEN, RUNNER_NAME"
  exit 1
fi

cd /home/dockeruser/actions-runner

# Cleanup from previous session (if any)
./config.sh remove --unattended || true

# Configure the runner
./config.sh --unattended \
  --url "$GITHUB_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$RUNNER_NAME" \
  --work "_work" \
  --replace

# Trap SIGINT/SIGTERM to cleanup properly (on shutdown)
cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended || true
  exit 0
}
trap cleanup SIGINT SIGTERM

# Start the runner
exec ./run.sh
