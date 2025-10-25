# Ruby Language Setup for Devenv

## Detection

Detect a Ruby project by checking for:
- `.ruby-version` file in the project root, OR
- `Gemfile` in the project root

## Required Files

Ruby projects require a `.ruby-version` file to specify the Ruby version.

**If `.ruby-version` doesn't exist:**
- Ask the user which Ruby version to use
- Create the `.ruby-version` file with the specified version

## Configuration Additions

### devenv.nix

Two modifications needed:

1. **Add packages** - Replace the existing `packages = with pkgs; [...]` section to include Ruby-specific packages:

```nix
  packages = with pkgs; [
    git
    libyaml
    sqlite-interactive
    bashInteractive
    openssl
    curl
    libxml2
    libxslt
    libffi
    docker
  ];
```

2. **Add Ruby language configuration** - Add before the closing brace:

```nix
  languages.ruby.enable = true;
  languages.ruby.versionFile = ./.ruby-version;
```

The additions are available in `assets/languages/ruby/devenv.nix.additions`.

### devenv.yaml

Add the following to the `inputs:` section of `devenv.yaml`:

```yaml
  nixpkgs-ruby:
    url: github:bobvanderlinden/nixpkgs-ruby
```

The additions are available in `assets/languages/ruby/devenv.yaml.additions`.

## Implementation Steps

1. Check for `.ruby-version` file
2. Copy base templates from `assets/base/`
3. Read `assets/languages/ruby/devenv.nix.additions` and append to `devenv.nix` before the closing brace
4. Read `assets/languages/ruby/devenv.yaml.additions` and append to the `inputs:` section of `devenv.yaml`
5. Continue with standard ignore file updates and git commit
