#! /bin/sh -l

REMOTE="${1}"

if [ -z "${REMOTE}" ]; then
  echo Please specify an origin
  exit 1
fi

git config --global --add safe.directory /github/workspace
git clone --bare "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" . || exit 1
git remote add --mirror=fetch mirror "${REMOTE}" || exit 1
git fetch mirror +refs/heads/*:refs/remotes/origin/* || exit 1

if [ -n "${TARGET_REFSPACE}" ]; then
  git push --force --mirror --prune origin "${TARGET_REFSPACE}" || exit 1
else
  git push --force --mirror --prune origin || exit 1
fi