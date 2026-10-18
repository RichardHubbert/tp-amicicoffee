# 🔄 Updating from Core Repository

This document explains how to receive feature updates and bug fixes from the core Table Pilot repository while preserving your client-specific configuration.

## Overview

This client site (`tp-amicicoffee`) is based on the core repository `tp-woodman`. The core repo contains shared functionality and features that benefit all client sites. This guide shows you how to pull those updates into your client site safely.

## Prerequisites

- Git installed and configured
- Your client site repository cloned locally
- Permission to push to your client repository

---

## Initial Setup (One-Time)

If this is your first time updating from core, you need to link your repository to the core:

### 1. Add Core as a Remote

```bash
# Navigate to your client repository
cd /path/to/tp-amicicoffee

# Add the core repository as a remote named 'core'
git remote add core https://github.com/RichardHubbert/tp-woodman.git

# Verify the remote was added
git remote -v
```

You should see output like:
```
core    https://github.com/RichardHubbert/tp-woodman.git (fetch)
core    https://github.com/RichardHubbert/tp-woodman.git (push)
origin  https://github.com/yourusername/tp-amicicoffee.git (fetch)
origin  https://github.com/yourusername/tp-amicicoffee.git (push)
```

### 2. Configure Merge Strategy

The `.gitattributes` file in this repository is already configured to protect client-specific files during merges. When you merge from core:

- `src/config/site.ts` will **always** keep your version (merge=ours)
- `public/brand/**` assets will **always** keep your version (merge=ours)
- `.env` will **always** keep your version (merge=ours)

This means updates from core won't overwrite your business-specific configuration or branding.

---

## Pulling Updates from Core

### Step 1: Fetch Latest Changes from Core

```bash
# Fetch the latest changes from the core repository
git fetch core main
```

### Step 2: Check What's Changed

Before merging, review what updates are available:

```bash
# See a summary of changes
git log HEAD..core/main --oneline

# See detailed changes (optional)
git log HEAD..core/main
```

### Step 3: Merge Core Updates

Create a new branch for the update:

```bash
# Create a branch for the core update
git checkout -b update-from-core-$(date +%Y%m%d)

# Merge changes from core/main
git merge core/main --no-ff -m "Merge updates from core repository"
```

The merge will:
- ✅ Apply all shared code updates
- ✅ Preserve your `src/config/site.ts`
- ✅ Preserve your `public/brand/` assets
- ✅ Preserve your `.env` file

### Step 4: Review and Test

After merging, review the changes:

```bash
# See what files were changed
git diff HEAD~1

# See the merge commit
git show
```

**Important**: Test your site locally before deploying:

```bash
# Install any new dependencies
npm install

# Run the development server
npm run dev

# Build the production bundle
npm run build
```

**Test checklist**:
- [ ] Site loads without errors
- [ ] Your business name and branding still appear correctly
- [ ] Booking flow works end-to-end
- [ ] Colors and styling match your brand
- [ ] Contact information is correct

### Step 5: Push Updates

If everything looks good:

```bash
# Push the update branch
git push origin update-from-core-$(date +%Y%m%d)

# Create a pull request or merge directly to main
# (depending on your team's workflow)
```

---

## Handling Merge Conflicts

If you encounter merge conflicts during the update:

### 1. Identify Conflicted Files

```bash
# List files with conflicts
git status
```

### 2. Resolve Conflicts

For each conflicted file (excluding those in `.gitattributes`):

```bash
# Edit the file to resolve conflicts
# Look for conflict markers: <<<<<<<, =======, >>>>>>>
nano path/to/conflicted-file.ts

# After resolving, mark as resolved
git add path/to/conflicted-file.ts
```

### 3. Complete the Merge

```bash
# After resolving all conflicts
git merge --continue
```

---

## What Gets Updated

When you merge from core, you'll receive updates to:

### ✅ Shared Components
- Booking system improvements
- UI component updates
- Bug fixes in shared functionality

### ✅ Shared Services
- Database query optimizations
- Email service improvements
- Authentication enhancements

### ✅ Shared Utilities
- Helper functions
- Type definitions
- API clients

### ✅ Dependencies
- Package updates (via `package.json`)
- Security patches

### ❌ What Stays Yours

These files are protected and won't be overwritten:

- `src/config/site.ts` (your business configuration)
- `public/brand/**` (your brand assets)
- `.env` (your environment variables)

---

## Update Frequency

**Recommended schedule**:

- **Security updates**: Immediately when notified
- **Feature updates**: Monthly or as needed
- **Routine updates**: Quarterly

Sign up for notifications from the core repository to stay informed about important updates.

---

## Rollback Procedure

If an update causes issues, you can roll back:

```bash
# Find the commit before the merge
git log --oneline

# Reset to the commit before the merge
git reset --hard <commit-hash-before-merge>

# Force push (⚠️ use with caution)
git push origin main --force
```

**Better approach**: Create a revert commit instead:

```bash
# Revert the merge commit
git revert -m 1 <merge-commit-hash>

# Push the revert
git push origin main
```

---

## Reporting Issues

If you encounter problems after updating from core:

1. **Check the core repository issues**: https://github.com/RichardHubbert/tp-woodman/issues
2. **Document the problem**: Include error messages, browser console logs, and steps to reproduce
3. **Open an issue** in the core repository if it's not client-specific
4. **Contact support** if it's specific to your client site

---

## Advanced: Selective Updates

If you only want specific updates from core:

```bash
# Fetch core changes
git fetch core main

# Cherry-pick specific commits
git cherry-pick <commit-hash>

# Or merge specific files
git checkout core/main -- path/to/specific-file.ts
git commit -m "Update specific file from core"
```

---

## Questions?

- **Core repository**: https://github.com/RichardHubbert/tp-woodman
- **Documentation**: See `README.md` and `CLONING.md`
- **Support**: Contact your development team

---

**Last Updated**: October 2026
