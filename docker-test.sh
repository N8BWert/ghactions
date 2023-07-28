#!/usr/bin/env bash

currentDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"

docker compose -f "${currentDir}/vault-compose.yml" up -d >> /dev/null 2>&1

export TEST_SUCCESS
if docker compose -f "${currentDir}/runner-compose.yml" up --exit-code-from random_alpine; then
    TEST_SUCCESS=true
else
    TEST_SUCCESS=false
fi

docker compose -f "${currentDir}/vault-compose.yml" down
docker compose -f "${currentDir}/runner-compose.yml" down

if [[ $TEST_SUCCESS == true ]]; then
    exit 0
else
    exit 1
fi