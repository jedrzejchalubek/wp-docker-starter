#!/bin/sh
set -e

app_name=$1
registry=$2
image_id=$(docker inspect $registry --format={{.Id}})

curl -n -X PATCH https://api.heroku.com/apps/$app_name/formation \
  -d '{"updates":[{"type":"web","docker_image":"'"$image_id"'"}]}' \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3.docker-releases" \
  -H "Authorization: Bearer $HEROKU_API_KEY"
