#!/bin/bash

set -e

cp Dockerfile-alpine.template tmp

# Change basic image.
sed -i '/FROM alpine/i\ARG BASE_IMAGE_TAG\n' tmp
sed -i 's/FROM alpine.*/FROM wodby\/alpine:${BASE_IMAGE_TAG}/' tmp

mv tmp Dockerfile-alpine.wodby.template
cp update.sh tmp

sed -i 's/Dockerfile-${template}.template/Dockerfile-${template}.wodby.template/' tmp
sed -i 's/\/Dockerfile"/\/Dockerfile.wodby"/' tmp
# Only alpine 3.7
sed -i 's/alpine{3.6,3.7}/alpine3.7/' tmp
sed -i '/jessie,stretch/d' tmp
# Change .travis.yml modifications.
sed -i -E 's/^(echo "\$travis.*)/#\1/' tmp
# Update travis.yml
sed -i '/$fullVersion;/a\    sed -i -E "s/(RUBY${version//.})=.*/\\1=$fullVersion/" .travis.yml' tmp
# Update README.
sed -i '/$fullVersion;/a\\n    sed -i -E "s/\\`${version}\.[0-9]+\\`/\\`$fullVersion\\`/" README.md' tmp

mv tmp update.wodby.sh

./update.wodby.sh

rm Dockerfile-alpine.wodby.template
rm update.wodby.sh