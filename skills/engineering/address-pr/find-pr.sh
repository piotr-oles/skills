#!/usr/bin/env bash
# Prints PR number for current branch/HEAD, exits non-zero if not found.
set -euo pipefail

pr=$(gh pr list --head "$(git rev-parse --abbrev-ref HEAD)" --json number -q '.[0].number' 2>/dev/null || true)

if [ -z "$pr" ]; then
  commit_sha=$(git rev-parse HEAD)
  repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
  pr=$(gh api "repos/${repo}/commits/${commit_sha}/pulls" --jq '.[0].number')
fi

if [ -z "$pr" ]; then
  echo "error: no PR found for current branch or HEAD" >&2
  exit 1
fi

echo "$pr"
