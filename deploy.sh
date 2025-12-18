#!/bin/bash
set -e
REPO_URL="$1"
git init;git branch -M main;git add .;git commit -m "ULTRA Release"
git remote add origin "$REPO_URL"
git push -u origin main
