#!/bin/bash

# Get name of current environment.
WP_ENV=$(grep WP_ENV .env | cut -d '=' -f 2-)

# Create the environment file.
[[ -e .env ]] || cp .env.example .env

# Create the `wp-config.php` based on modified sample with environment variables.
[[ -e web/wp/wp-config.php ]] || cp web/wp-config-sample.php web/wp/wp-config.php

# Remove `wp-config-sample.php` file provided with clean installation of WordPress.
[[ -e web/wp/wp-config-sample.php ]] && rm web/wp/wp-config-sample.php || true
