#!/usr/bin/env bash

#clean up local mysql database
rm -rf scripts/docker-compose-mysql/compose/mysql/data

set -o errexit -o nounset -o pipefail
# import in shellcheck / CI / IntelliJ compatible ways
# shellcheck source=/dev/null
source "${BASH_SOURCE%/*}/test.inc.sh" || source test.inc.sh

cromwell::build::setup_common_environment

if [[ "${CROMWELL_BUILD_PROVIDER}" == "${CROMWELL_BUILD_PROVIDER_TRAVIS}" ]]; then
  # Upgrade docker-compose so that we get the correct exit codes
  docker-compose -version
  sudo rm /usr/local/bin/docker-compose
  curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" > docker-compose
  chmod +x docker-compose
  sudo mv docker-compose /usr/local/bin
  docker-compose -version
fi

export TEST_CROMWELL_TAG=test-only-do-not-push

docker image ls -q broadinstitute/cromwell:"${TEST_CROMWELL_TAG}" | grep . || \
CROMWELL_SBT_DOCKER_TAGS="${TEST_CROMWELL_TAG}" sbt server/docker

# Turn off exit-on-error temporarily, as we expect an error
set +o errexit
CROMWELL_TAG="${TEST_CROMWELL_TAG}" \
docker-compose \
  -f scripts/docker-compose-mysql/docker-compose-deadlock.yml \
  up \
  --scale cromwell_norefresh=2 \
  --exit-code-from deadlocker

exit_code=$?
set -o errexit

echo "docker-compose exit code was ${exit_code}"

# Tear everything down, but dump out the logs first
CROMWELL_TAG="${TEST_CROMWELL_TAG}" \
docker-compose \
  -f scripts/docker-compose-mysql/docker-compose-deadlock.yml \
  logs --no-color > deadlock.logs \

docker-compose \
  -f scripts/docker-compose-mysql/docker-compose-deadlock.yml \
  down \
  -v

# Note: leaving behind these directories that may be manually cleaned
# - scripts/docker-compose-mysql/compose/mysql/data
# - scripts/docker-compose-mysql/cromwell-executions

exit ${exit_code}