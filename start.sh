#!/bin/bash

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq .token --raw-output)

curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token

echo "Using token $ACCESS_TOKEN"
echo "Using token $REG_TOKEN"

./config.sh --url https://github.com/${REPOSITORY} --token $REG_TOKEN --ephemeral --unattended

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token $REG_TOKEN
    rm -rf ./_work/*
    echo "Exiting..."
    exit 1
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM
trap 'cleanup' EXIT

unset ACCESS_TOKEN
unset REPOSITORY

./run.sh & wait $!
