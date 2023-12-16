#!/bin/bash
set -eux

# CHART="http-headers"
# MESSAGE="chore(deps): patch update quay.io/k8start/http-headers docker tag to v0.1.3"
if [[ -z "${CHART+x}" ]]; then >&2 echo "CHART must be set"; exit 1; fi
if [[ -z "${BUMP+x}" ]]; then
  if [[ -z "${MESSAGE+x}" ]]; then >&2 echo "MESSAGE or BUMP must be set!"; exit 1; fi
  BUMP=$(echo "$MESSAGE" | grep -Po '(?<=^chore\(deps\): )(patch|major|minor)')
fi

VERSION=$(./scripts/semver.sh bump "${BUMP}" "$(yq -e ".version" < ./charts/"${CHART}"/Chart.yaml)")
yq -e -i ".version = \"${VERSION}\"" ./charts/"${CHART}"/Chart.yaml

# File sourced from https://github.com/bukowa/charts/blob/174776759718e124770c698534823068a62ab498/scripts/bumpversion-helmchart.sh