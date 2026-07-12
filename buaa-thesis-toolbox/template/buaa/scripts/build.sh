#!/usr/bin/env bash
set -euo pipefail

# Thesis root = parent of buaa/
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

output_file="${1:-Artifact.pdf}"

# Class file lives at buaa/buaa.cls
export TEXINPUTS="${ROOT}/buaa//:${TEXINPUTS:-}"

files=()
while IFS= read -r file; do
  files+=("$file")
done < <(find chapters -maxdepth 1 -type f -name '*.md' | sort)

if [ "${#files[@]}" -eq 0 ]; then
  echo "No Markdown files found under chapters/." >&2
  exit 1
fi

pandoc "${files[@]}" --defaults "./buaa/pandoc.yaml" -o "$output_file"
