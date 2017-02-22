#!/bin/bash

DIR=$(dirname "$0")

cd $DIR

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf _site
mkdir _site
git worktree prune
rm -rf .git/worktrees/_site

echo "Checking out gh-pages branch into _site"
git worktree add -B gh-pages _site origin/gh-pages

echo "Removing existing files"
rm -rf _site/*

echo "Generating site"
jekyll build

echo "Updating gh-pages branch"
cd _site && git add --all && git commit -m "Publishing _site to gh-pages" && git push

