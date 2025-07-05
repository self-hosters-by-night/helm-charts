#!/bin/bash

set -euo pipefail

VERSION=${1:-}

if [[ -z "$VERSION" ]]; then
    echo "Usage: $0 <version>" >&2
    echo "Example: $0 1.21.0" >&2
    exit 1
fi

# Validate version format (basic check)
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y.Z (e.g., 1.21.0)" >&2
    exit 1
fi

echo "Updating CRDs to version $VERSION..."

rm -rf crds
mkdir crds

if ! kustomize build "github.com/fission/fission/crds/v1?ref=v${VERSION}" -o crds; then
    echo "Error: Failed to build CRDs for version $VERSION" >&2
    exit 1
fi

sed -i "s/^version: .*/version: $VERSION/" Chart.yaml

git add crds Chart.yaml
git commit -m "Update CRDs to version $VERSION"

echo "Successfully updated CRDs to version $VERSION"
