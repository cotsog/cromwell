#!/usr/bin/env bash

set -xeuo pipefail

for i in $(seq 20); do
    echo "Running without docker number ${i}"
    curl -iv https://repo1.maven.org/maven2/org/broadinstitute/gatk/4.1.2.0/gatk-4.1.2.0.pom.md5
    curl -iv https://git.drupalcode.org/project/drupal/raw/8.7.0/sites/default/default.services.yml  
    curl -iv https://git.drupalcode.org/project/drupal/raw/8.7.0/update.php
    curl -iv https://raw.githubusercontent.com/drupal/drupal/8.7.0/index.php
    curl -iv https://raw.githubusercontent.com/drupal/drupal/8.7.0/sites/example.sites.php
    echo
    echo "Sleeping 5 seconds..."
    sleep 5
done

for i in $(seq 20); do
    echo "Running with docker number ${i}"
    docker run --rm openjdk:8u212 \
        "curl -iv https://repo1.maven.org/maven2/org/broadinstitute/gatk/4.1.2.0/gatk-4.1.2.0.pom.md5;" \
        "curl -iv https://git.drupalcode.org/project/drupal/raw/8.7.0/sites/default/default.services.yml;" \
        "curl -iv https://git.drupalcode.org/project/drupal/raw/8.7.0/update.php;" \
        "curl -iv https://raw.githubusercontent.com/drupal/drupal/8.7.0/index.php;" \
        "curl -iv https://raw.githubusercontent.com/drupal/drupal/8.7.0/sites/example.sites.php"
    echo
    echo "Sleeping 5 seconds..."
    sleep 5
done
