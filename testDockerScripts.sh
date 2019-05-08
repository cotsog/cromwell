#!/usr/bin/env bash

set -xeuo pipefail

for i in $(seq 100); do
    echo "Running with docker number ${i}"
    docker run --rm openjdk:8u212 \
        bash -c "curl -fO https://repo1.maven.org/maven2/org/broadinstitute/gatk/4.1.2.0/gatk-4.1.2.0.pom.md5;curl -fO https://git.drupalcode.org/project/drupal/raw/8.7.0/sites/default/default.services.yml;curl -fO https://git.drupalcode.org/project/drupal/raw/8.7.0/update.php;curl -fO https://raw.githubusercontent.com/drupal/drupal/8.7.0/index.php;curl -fO https://raw.githubusercontent.com/drupal/drupal/8.7.0/sites/example.sites.php"
    echo
    echo "Sleeping 2 seconds..."
    sleep 2
done

for i in $(seq 100); do
    echo "Running without docker number ${i}"
    curl -f https://repo1.maven.org/maven2/org/broadinstitute/gatk/4.1.2.0/gatk-4.1.2.0.pom.md5 > /dev/null
    curl -f https://git.drupalcode.org/project/drupal/raw/8.7.0/sites/default/default.services.yml > /dev/null
    curl -f https://git.drupalcode.org/project/drupal/raw/8.7.0/update.php > /dev/null
    curl -f https://raw.githubusercontent.com/drupal/drupal/8.7.0/index.php > /dev/null
    curl -f https://raw.githubusercontent.com/drupal/drupal/8.7.0/sites/example.sites.php > /dev/null
    echo
    echo "Sleeping 2 seconds..."
    sleep 2
done
