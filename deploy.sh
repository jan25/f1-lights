#!/usr/bin/env sh

# Build and deploy to jan25.github.io/f1-lights

set -e

npm run build
cd dist

git init
git add -A
git commit -m 'deploy'

git push -f https://github.com/jan25/f1-lights master:gh-pages

cd -