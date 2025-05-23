#!/usr/bin/env bash
# Usage: ./bump_version.sh [--dry-run] [--commit] [--tag]

DRY_RUN=false
DO_COMMIT=false
DO_TAG=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --dry-run)
      DRY_RUN=true
      ;;
    --commit)
      DO_COMMIT=true
      ;;
    --tag)
      DO_TAG=true
      ;;
  esac
done

# Directory paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUMPVERSION_CFG="$SCRIPT_DIR/.bumpversion.cfg"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Read the current version from .bumpversion.cfg
current_version=$(grep "^current_version" "$BUMPVERSION_CFG" | cut -d'=' -f2 | tr -d ' ')
IFS='.' read -r major minor patch <<< "$current_version"
new_patch=$((patch + 1))
new_version="${major}.${minor}.${new_patch}"

commit_msg="Bump version to ${new_version}"
tag="${new_version}"

# Start a YAML document and output only YAML content
echo "---"
if [ "$DRY_RUN" = true ]; then
  echo "dry_run: true"
  echo "current_version: ${current_version}"
  echo "new_version: ${new_version}"
  if [ "$DO_COMMIT" = true ]; then
    echo "commit: ${commit_msg}"
  fi
  if [ "$DO_TAG" = true ]; then
    echo "tag: ${tag}"
  fi
  exit 0
fi

# Execute changes if not a dry run
echo "dry_run: false"
echo "current_version: ${current_version}"
echo "new_version: ${new_version}"

# Update .bumpversion.cfg
sed -i '' "s/^current_version *= *.*/current_version = ${new_version}/" "$BUMPVERSION_CFG"
echo "Updated .bumpversion.cfg to version ${new_version}"

if [ "$DO_COMMIT" = true ]; then
  # Change to project root directory
  cd "$PROJECT_ROOT"
  
  git add "$BUMPVERSION_CFG"
  
  git commit -m "${commit_msg}"
  echo "commit: ${commit_msg}"
fi

if [ "$DO_TAG" = true ]; then
  # Ensure we're in the project root
  cd "$PROJECT_ROOT" 
  
  git tag "${tag}"
  echo "tag: ${tag}"
fi
