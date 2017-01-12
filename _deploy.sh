#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "abj@abjur.org.br"
git config --global user.name "ABJ"

git clone -b content https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git out
cd out
cp -r ../content/* ./
git add --all *
git commit -m "Update the PU" || true
git push origin content

