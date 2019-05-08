#!/usr/bin/env bash

set -xeuo pipefail

for i in $(seq 20); do
    echo "Running with docker number ${i}"
    docker run --rm openjdk:8u212 \
        curl -sO https://repo1.maven.org/maven2/org/broadinstitute/gatk/4.1.2.0/gatk-4.1.2.0.pom.md5
    echo
    echo "Sleeping 5 seconds..."
    sleep 5
done

for i in $(seq 20); do
    echo "Running without docker number ${i}"
    curl -s https://repo1.maven.org/maven2/org/broadinstitute/gatk/4.1.2.0/gatk-4.1.2.0.pom.md5 > /dev/null
    curl -s https://git.drupalcode.org/project/drupal/raw/8.7.0/sites/default/default.services.yml > /dev/null
    curl -s https://git.drupalcode.org/project/drupal/raw/8.7.0/update.php > /dev/null
    curl -s https://raw.githubusercontent.com/drupal/drupal/8.7.0/index.php > /dev/null
    curl -s https://raw.githubusercontent.com/drupal/drupal/8.7.0/sites/example.sites.php > /dev/null
    echo
    echo "Sleeping 5 seconds..."
    sleep 5
done
