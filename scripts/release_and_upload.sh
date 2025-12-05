#!/usr/bin/env bash
set -euo pipefail

# Скрипт архивирует три папки (atmosphere, config, switch) в один файл
# с именем Ryazhenkabestcfw_Tuner_<DATE>.zip (по префиксу - можно добавить)
# затем создаёт или обновляет GitHub release и загружает архив как asset.

REPO_DEFAULT="Dimasick-git/Ryazhenkabestcfw-Tuner"
TARGET_DIRS=("atmosphere" "config" "switch")

usage() {
  cat <<EOF
Usage: $0 -t <tag> [-n <release-name>] [-b <body>] [-r <repo>] [-p <prefix>]

Options:
  -t <tag>         Git tag for the release (required)
  -n <release-name> Release title (default: tag)
  -b <body>        Release notes/body
  -r <repo>        GitHub repo (owner/name), default: ${REPO_DEFAULT}
  -p <prefix>      Prefix for created zip files (default: none)
  -h               Show this help

Example:
  $0 -t v1.2.3 -n "My Release" -b "Notes" -r Dimasick-git/Ryazhenkabestcfw-Tuner
EOF
}

  echo " - Creating zip: $zipname"
  zip -r "$TMPDIR/$zipname" "${EXISTING[@]}" >/dev/null 2>&1 || { echo "zip failed" >&2; rm -rf "$TMPDIR"; exit 1; }
  ARTIFACTS+=("$TMPDIR/$zipname")
else
  echo " - 'zip' not found, creating tar.gz: $tarname"
  tar -C . -czf "$TMPDIR/$tarname" "${EXISTING[@]}" || { echo "tar failed" >&2; rm -rf "$TMPDIR"; exit 1; }
  #!/usr/bin/env bash
  set -euo pipefail

  # Скрипт архивирует три папки (atmosphere, config, switch) в один архив
  # с именем Ryazhenkabestcfw_Tuner_<DATE>.(zip|tar.gz), затем создаёт или
  # обновляет GitHub release и загружает архив как asset.

  REPO_DEFAULT="Dimasick-git/Ryazhenkabestcfw-Tuner"
  TARGET_DIRS=("atmosphere" "config" "switch")

  usage() {
    cat <<EOF
  Usage: $0 -t <tag> [-n <release-name>] [-b <body>] [-r <repo>] [-p <prefix>]

  Options:
    -t <tag>         Git tag for the release (required)
    -n <release-name> Release title (default: tag)
    -b <body>        Release notes/body
    -r <repo>        GitHub repo (owner/name), default: ${REPO_DEFAULT}
    -p <prefix>      Prefix for created archive file (default: none)
    -h               Show this help

  Example:
    $0 -t v1.2.3 -n "My Release" -b "Notes" -r Dimasick-git/Ryazhenkabestcfw-Tuner
  EOF
  }

  TAG=""
  NAME=""
  BODY=""
  REPO="${REPO_DEFAULT}"
  PREFIX=""

  while getopts ":t:n:b:r:p:h" opt; do
    case ${opt} in
      t) TAG="$OPTARG" ;;
      n) NAME="$OPTARG" ;;
      b) BODY="$OPTARG" ;;
      r) REPO="$OPTARG" ;;
      p) PREFIX="$OPTARG" ;;
      h) usage; exit 0 ;;
      \?) echo "Invalid option: -$OPTARG" >&2; usage; exit 1 ;;
      :) echo "Option -$OPTARG requires an argument." >&2; usage; exit 1 ;;
    esac
  done

  if [ -z "$TAG" ]; then
    echo "Error: tag is required." >&2
    usage
    exit 1
  fi

  if ! command -v gh >/dev/null 2>&1; then
    echo "Error: 'gh' (GitHub CLI) is required. Install and authenticate first." >&2
    exit 1
  fi

  if ! command -v zip >/dev/null 2>&1 && ! command -v tar >/dev/null 2>&1; then
    echo "Error: 'zip' or 'tar' required to create archives." >&2
    exit 1
  fi

  NAME=${NAME:-$TAG}

  DATE=$(date +%Y%m%d_%H%M%S)
  TMPDIR="$(mktemp -d)"
  ARTIFACTS=()

  echo "Creating single archive from: ${TARGET_DIRS[*]}"
  # collect existing dirs
  EXISTING=()
  for d in "${TARGET_DIRS[@]}"; do
    if [ -d "$d" ]; then
      EXISTING+=("$d")
    else
      echo " - Warning: directory '$d' not found, skipping." >&2
    fi
  done

  if [ ${#EXISTING[@]} -eq 0 ]; then
    echo "No source directories found to archive. Exiting." >&2
    rm -rf "$TMPDIR"
    exit 1
  fi

  base="${PREFIX}Ryazhenkabestcfw_Tuner"
  zipname="${base}_${DATE}.zip"
  tarname="${base}_${DATE}.tar.gz"

  if command -v zip >/dev/null 2>&1; then
    echo " - Creating zip: $zipname"
    zip -r "$TMPDIR/$zipname" "${EXISTING[@]}" >/dev/null 2>&1 || { echo "zip failed" >&2; rm -rf "$TMPDIR"; exit 1; }
    ARTIFACTS+=("$TMPDIR/$zipname")
  else
    echo " - 'zip' not found, creating tar.gz: $tarname"
    tar -C . -czf "$TMPDIR/$tarname" "${EXISTING[@]}" || { echo "tar failed" >&2; rm -rf "$TMPDIR"; exit 1; }
    ARTIFACTS+=("$TMPDIR/$tarname")
  fi

  if [ ${#ARTIFACTS[@]} -eq 0 ]; then
    echo "No archives created. Exiting." >&2
    rm -rf "$TMPDIR"
    exit 1
  fi

  echo "Checking if release '${TAG}' exists in repo ${REPO}..."
  if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
    echo "Release exists -> uploading assets (will overwrite if present)"
    for a in "${ARTIFACTS[@]}"; do
      echo "Uploading asset: $a"
      gh release upload "$TAG" "$a" --clobber --repo "$REPO"
    done
    echo "Updating release notes..."
    if [ -n "$BODY" ]; then
      gh release edit "$TAG" --notes "$BODY" --repo "$REPO"
    fi
  else
    echo "Creating release '$TAG' and uploading assets"
    gh release create "$TAG" "${ARTIFACTS[@]}" --title "$NAME" --notes "$BODY" --repo "$REPO"
  fi

  echo "Done. Uploaded ${#ARTIFACTS[@]} artifact(s) to release $TAG in $REPO"
  echo "Temporary files are in: $TMPDIR (removed)"
  rm -rf "$TMPDIR"

  exit 0
