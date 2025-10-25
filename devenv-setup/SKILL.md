---
name: devenv-setup
description: Set up devenv development environments in projects. Use when the user requests to set up devenv, initialize a development environment, or configure devenv for a new or existing project. Detects project language and applies appropriate configuration.
---

# Devenv Setup

## Overview

Automate the setup of devenv development environments for projects. Detect project type, copy appropriate configuration files, update ignore files, and commit the configuration.

## Setup Workflow

### 1. Determine Project Language

**If the user specifies a language:**
- Use the language specified by the user
- Read the corresponding `references/languages/<language>.md` file for setup instructions

**If the user doesn't specify a language:**
- Infer the language by checking for common indicator files:
  - Ruby: `.ruby-version` or `Gemfile`
  - Python: `.python-version`, `requirements.txt`, or `pyproject.toml`
  - Node.js: `package.json`
  - (Add more as languages are supported)
- If a language is inferred, use the AskUserQuestion tool to confirm with the user
- Once confirmed, read the corresponding `references/languages/<language>.md` file for setup instructions

**If no language is determined or user confirms no language:**
- Proceed with base setup only

### 2. Copy Base Configuration Files

Copy all files from `assets/base/` to the project root:

- `devenv.nix` - Main configuration
- `devenv.yaml` - Inputs configuration
- `devenv.local.nix` - Local customizations (empty by default)

### 3. Apply Language-Specific Configuration

If a language was detected in step 1, follow the instructions in the corresponding `references/languages/<language>.md` file to apply language-specific additions to the base configuration files.

### 4. Update or Create Ignore Files

Add devenv-specific entries to `.gitignore` and `.dockerignore`:

```
# Devenv
/.direnv
/.envrc
.devenv*
devenv.local.nix
```

**For existing files:**
- Read the file
- Check if devenv section already exists
- If not, append the devenv section

**For new files:**
- Create the file with just the devenv entries

Process both `.gitignore` and `.dockerignore`.

### 5. Test Devenv Configuration

Run a simple command with devenv to generate lock files and validate the configuration:

```bash
devenv shell "echo 'Devenv setup successful'"
```

This will:
- Generate `.devenv.flake.nix` and other generated files
- Create `devenv.lock`
- Validate that the devenv configuration is correct
- Catch any errors in the devenv files before committing

If the command fails, review the error messages and fix any configuration issues before proceeding.

### 6. Initialize Git Repository (if needed)

Check if the project is a git repository:

```bash
git status
```

If not a repository (command fails), initialize one:

```bash
git init
```

### 7. Commit the Changes

Add all devenv-related files (including generated ones) and commit:

```bash
git add devenv.nix devenv.yaml devenv.local.nix devenv.lock .devenv.flake.nix .gitignore .dockerignore
git commit -m "Set up devenv development environment"
```

## Resources

### assets/base/

Base template files copied to all projects:
- `devenv.nix` - Base configuration with common packages
- `devenv.yaml` - Base inputs (nixpkgs-unstable)
- `devenv.local.nix` - Empty template for local customizations

### assets/languages/<language>/

Language-specific configuration additions that get merged into base files.

### references/languages/<language>.md

Detailed setup instructions for each supported language, including:
- How to detect the language
- Required files and prerequisites
- Configuration additions needed
- Implementation steps
