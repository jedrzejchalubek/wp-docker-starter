#!/bin/sh
set -e

if [ "$WORDPRESS_ENV" = "development" ] ; then
  # Install project's Composer dependencies
  composer install --no-interaction
  # Install theme's dependencies and build a custom `<theme-name>` theme
  cd wp-content/themes/<theme-name>
  npm install && npm run development
  rm -rf node_modules/
else
  # Install project's Composer dependencies
  composer install -o --no-dev --no-interaction
  # Install theme's dependencies and build a custom `<theme-name>` theme
  cd wp-content/themes/<theme-name>
  npm install && npm run production
  rm -rf node_modules/
fi
