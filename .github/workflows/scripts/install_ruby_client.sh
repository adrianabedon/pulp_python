#!/bin/bash

# WARNING: DO NOT EDIT!
#
# This file was generated by plugin_template, and is managed by it. Please use
# './plugin-template --github pulp_python' to update this file.
#
# For more info visit https://github.com/pulp/plugin_template

set -mveuo pipefail

# make sure this script runs at the repo root
cd "$(dirname "$(realpath -e "$0")")"/../../..

source .github/workflows/scripts/utils.sh

export PULP_URL="${PULP_URL:-https://pulp}"


REPORTED_STATUS="$(pulp status)"
REPORTED_VERSION="$(echo "$REPORTED_STATUS" | jq --arg plugin "python" -r '.versions[] | select(.component == $plugin) | .version')"
VERSION="$(echo "$REPORTED_VERSION" | python -c 'from packaging.version import Version; print(Version(input()))')"

pushd ../pulp-openapi-generator
rm -rf pulp_python-client
./generate.sh pulp_python ruby "$VERSION"
pushd pulp_python-client
gem build pulp_python_client
gem install --both "./pulp_python_client-$VERSION.gem"
tar cvf ../../pulp_python/python-ruby-client.tar "./pulp_python_client-$VERSION.gem"
popd
popd
