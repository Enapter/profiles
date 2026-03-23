#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
OUTPUT="${1:-profiles.zip}"

# Use a temp dir for staging
STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT

find "$REPO_ROOT" -name "*.yml" -not -path '*/.github/*' | while read -r file; do
  # Get path relative to repo root
  rel="${file#"$REPO_ROOT"/}"
  # Convert path to folder name: replace / with . and strip .yml
  folder="${rel%.yml}"
  folder="${folder//\//.}"
  # Copy file as manifest.yml inside the folder
  mkdir -p "$STAGING/$folder"
  cp "$file" "$STAGING/$folder/manifest.yml"
done

# Create the zip from the staging dir
(cd "$STAGING" && zip -r - .) > "$OUTPUT"

echo "Created $OUTPUT"
