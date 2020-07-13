#!/bin/bash

set -e
set -u
set -o errexit

declare -a versions=('0.35.0' 'latest')

echo "steps:"

for v in ${versions[@]}; do
  # Specs
  echo " - label: Run Specs (${v})"
  echo "   command: crystal spec"
  echo "   plugins:"
  echo '     - docker-compose#v3.2.0:'
  echo "         run: ci-${v}"

  # Formatting
  echo " - label: Code Formatting (${v})"
  echo "   command: bin/ameba"
  echo "   plugins:"
  echo '     - docker-compose#v3.2.0:'
  echo "         run: ci-${v}"

  # Mutation testing
  echo " - label: Mutation Testing (${v})"
  echo "   command: bin/crytic -m 68"
  echo "   plugins:"
  echo '     - docker-compose#v3.2.0:'
  echo "         run: ci-${v}"
done
