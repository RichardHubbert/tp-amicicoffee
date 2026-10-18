#!/bin/bash

# Update this client site from the core tp-woodman repository
# This script safely merges updates while preserving client-specific configuration

set -e

CORE_REMOTE="core"
CORE_BRANCH="main"
UPDATE_BRANCH="update-from-core-$(date +%Y%m%d-%H%M%S)"

echo "🔄 Updating from core repository..."
echo ""

# Check if core remote exists
if ! git remote | grep -q "^${CORE_REMOTE}$"; then
  echo "❌ Error: Core remote '${CORE_REMOTE}' not found"
  echo "Run ./scripts/link-to-core.sh first to set up the core remote"
  exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo "❌ Error: You have uncommitted changes"
  echo "Please commit or stash your changes before updating from core"
  git status --short
  exit 1
fi

# Fetch latest from core
echo "📥 Fetching latest changes from core/${CORE_BRANCH}..."
git fetch ${CORE_REMOTE} ${CORE_BRANCH}

# Show what's changed
echo ""
echo "📋 Changes available from core:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
git log HEAD..${CORE_REMOTE}/${CORE_BRANCH} --oneline --decorate --graph | head -n 20
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if there are actually updates
if git merge-base --is-ancestor ${CORE_REMOTE}/${CORE_BRANCH} HEAD; then
  echo ""
  echo "✅ Your repository is already up to date with core!"
  exit 0
fi

echo ""
read -p "Do you want to merge these updates? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "❌ Update cancelled"
  exit 0
fi

# Create update branch
echo ""
echo "🌿 Creating update branch: ${UPDATE_BRANCH}"
git checkout -b ${UPDATE_BRANCH}

# Merge from core
echo ""
echo "🔀 Merging updates from core/${CORE_BRANCH}..."
echo ""
echo "Note: Your client-specific files are protected:"
echo "  - src/config/site.ts"
echo "  - public/brand/**"
echo "  - .env"
echo ""

if git merge ${CORE_REMOTE}/${CORE_BRANCH} --no-ff -m "Merge updates from core repository ($(date +%Y-%m-%d))"; then
  echo ""
  echo "✅ Merge completed successfully!"
  
  # Show what changed
  echo ""
  echo "📊 Files changed in this update:"
  git diff --name-status HEAD~1
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ Update branch created: ${UPDATE_BRANCH}"
  echo ""
  echo "Next steps:"
  echo "  1. Test your site:"
  echo "     npm install"
  echo "     npm run dev"
  echo ""
  echo "  2. If everything works:"
  echo "     git checkout main"
  echo "     git merge ${UPDATE_BRANCH}"
  echo "     git push origin main"
  echo ""
  echo "  3. If there are issues:"
  echo "     git checkout main"
  echo "     git branch -D ${UPDATE_BRANCH}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
  echo ""
  echo "⚠️  Merge conflicts detected!"
  echo ""
  echo "Conflicted files:"
  git status --short | grep "^UU\|^AA\|^DD"
  echo ""
  echo "Please resolve conflicts manually:"
  echo "  1. Edit conflicted files"
  echo "  2. git add <resolved-file>"
  echo "  3. git merge --continue"
  echo ""
  echo "Or abort the merge:"
  echo "  git merge --abort"
  echo "  git checkout main"
  echo "  git branch -D ${UPDATE_BRANCH}"
  exit 1
fi
