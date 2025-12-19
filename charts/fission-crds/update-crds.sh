#!/bin/bash

set -euo pipefail

echo "Fetching latest Fission version..."
VERSION=$(curl -s https://api.github.com/repos/fission/fission/releases/latest | jq -r '.tag_name' | sed 's/^v//')

if [[ -z "$VERSION" || "$VERSION" == "null" ]]; then
    echo "Error: Failed to fetch latest version" >&2
    exit 1
fi

# Validate version format (basic check)
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y.Z (got: $VERSION)" >&2
    exit 1
fi

echo "Latest version: $VERSION"
echo "Updating CRDs to version $VERSION..."

rm -rf crds
mkdir crds

if ! kubectl kustomize "github.com/fission/fission/crds/v1?ref=v${VERSION}" -o crds; then
    echo "Error: Failed to build CRDs for version $VERSION" >&2
    exit 1
fi

sed -i "s/^version: .*/version: $VERSION/" Chart.yaml

git add crds Chart.yaml
git commit -m "Update Fission CRDs to version $VERSION"

echo "Successfully updated CRDs to version $VERSION"
