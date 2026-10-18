#!/bin/bash

# Link this client repository to the core tp-woodman repository
# This script adds the core repository as a git remote for receiving updates

set -e

CORE_REPO="https://github.com/RichardHubbert/tp-woodman.git"
REMOTE_NAME="core"

echo "🔗 Linking to core repository..."
echo ""

# Check if core remote already exists
if git remote | grep -q "^${REMOTE_NAME}$"; then
  echo "✅ Remote '${REMOTE_NAME}' already exists"
  echo "   URL: $(git remote get-url ${REMOTE_NAME})"
  echo ""
  echo "To update the URL, run:"
  echo "  git remote set-url ${REMOTE_NAME} ${CORE_REPO}"
else
  echo "📥 Adding core repository as remote '${REMOTE_NAME}'..."
  git remote add ${REMOTE_NAME} ${CORE_REPO}
  echo "✅ Remote '${REMOTE_NAME}' added successfully!"
fi

echo ""
echo "🔍 Fetching latest changes from core..."
git fetch ${REMOTE_NAME} main

echo ""
echo "✅ Setup complete!"
echo ""
echo "Your repository is now linked to the core repository."
echo "To pull updates, run: ./scripts/update-from-core.sh"
echo ""
echo "Current remotes:"
git remote -v
