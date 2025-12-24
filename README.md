# 🚀 BunVM - Bun Version Manager

[![GitHub](https://img.shields.io/badge/GitHub-privjaac%2Fbunvm-blue?logo=github)](https://github.com/privjaac/bunvm)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh-orange.svg)](https://github.com/privjaac/bunvm)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg)](https://github.com/privjaac/bunvm)

> The fast, simple, and powerful version manager for [Bun](https://bun.sh)

BunVM lets you quickly install and switch between multiple versions of Bun on your system. Built with pure shell scripts, zero dependencies, and inspired by the best version managers out there.

```bash
# One command to rule them all
curl -fsSL https://install.bunvm.com | bash
```

## 📑 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Commands](#-commands)
- [Real-World Examples](#-real-world-examples)
- [Advanced Features](#-advanced-features)
- [Configuration](#-configuration)
- [Uninstallation](#️-uninstallation)
- [Why BunVM?](#-why-bunvm)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## ✨ Features

- 🎯 **Zero Dependencies** - Pure shell script, no Node.js or Python required
- ⚡ **Lightning Fast** - Minimal overhead, instant version switching
- 🔄 **Auto Version Switching** - Detects `.bun-version` files automatically
- 📦 **Multiple Versions** - Install and manage unlimited Bun versions
- 🎨 **Tab Completion** - Smart autocompletion for Bash and Zsh
- 🔗 **Version Aliases** - Create memorable names for your versions
- 🌍 **Cross-Platform** - Works on macOS (Intel & Apple Silicon) and Linux (x64 & ARM64)
- 🔒 **Safe Updates** - Self-updating without breaking your setup

## 📦 Installation

Install BunVM with a single command:

```bash
curl -fsSL https://install.bunvm.com | bash
```

The installer will:
1. Download BunVM to `~/.bunvm`
2. Add initialization to your shell profile (`~/.zshrc` or `~/.bashrc`)
3. Set up autocompletion
4. Reload your shell automatically

**After installation**, restart your terminal or run:

```bash
source ~/.zshrc  # or ~/.bashrc for bash
```

## 🚀 Quick Start

```bash
# Install the latest version of Bun
bunvm install latest

# Install a specific version
bunvm install 1.0.0

# List all available versions
bunvm list

# List only installed versions
bunvm list --local

# Switch to a version
bunvm use 1.0.0

# Check current version
bunvm current

# Verify Bun is working
bun --version
```

## 📚 Commands

### `bunvm install <version>`

Install a specific version of Bun.

```bash
# Install latest version
bunvm install latest

# Install specific version
bunvm install 1.0.0
bunvm install 1.0.25
```

After installation, the version is automatically activated if it's your first install.

### `bunvm use <version>`

Activate a specific version of Bun.

```bash
bunvm use 1.0.0
bunvm use latest

# Also works with aliases (see below)
bunvm use stable
```

This command:
- Switches to the specified version in your current shell
- **Persists the version** as default for future shells
- Updates your `PATH` automatically

### `bunvm list [--local]`

List available Bun versions.

```bash
# List all versions (remote + local)
bunvm list

# List only installed versions
bunvm list --local
```

Output example:
```
 Version    | Status       | Use | Install Path
--------------------------------------------------------------------------------
 1.0.25     | installed*   | *   | ~/.bunvm/versions/bun-1.0.25
 1.0.24     | installed    |     | ~/.bunvm/versions/bun-1.0.24
 1.0.23     | available    |     | -
 1.0.22     | available    |     | -
--------------------------------------------------------------------------------
* indicates the version currently in use.
```

### `bunvm current`

Show the currently active version.

```bash
bunvm current
# Output: ✔ Current version: 1.0.25
```

### `bunvm alias <name> <version>`

Create a memorable alias for a version.

```bash
# Create aliases
bunvm alias stable 1.0.25
bunvm alias lts 1.0.20
bunvm alias dev 1.1.0

# Use aliases
bunvm use stable
bunvm use lts
```

### `bunvm uninstall <version>`

Remove an installed version.

```bash
bunvm uninstall 1.0.0
```

This also removes any aliases pointing to that version.

### `bunvm selfupdate`

Update BunVM to the latest version.

```bash
bunvm selfupdate
```

This updates:
- Core bunvm scripts
- All commands
- Libraries
- Autocompletion scripts

## 💡 Real-World Examples

### Scenario 1: Working on Multiple Projects

```bash
# Project A requires Bun 1.0.25
cd ~/projects/project-a
echo "1.0.25" > .bun-version
bunvm install 1.0.25
# BunVM auto-switches to 1.0.25 when you enter this directory

# Project B requires Bun 1.0.20
cd ~/projects/project-b
echo "1.0.20" > .bun-version
bunvm install 1.0.20
# BunVM auto-switches to 1.0.20 when you enter this directory

# No manual switching needed! 🎉
```

### Scenario 2: Testing Beta Features

```bash
# Install stable version
bunvm install 1.0.25
bunvm alias stable 1.0.25

# Install beta version
bunvm install 1.1.0
bunvm alias beta 1.1.0

# Easy switching for testing
bunvm use stable   # Use stable for work
bunvm use beta     # Test new features
bunvm use stable   # Back to stable
```

### Scenario 3: Team Collaboration

```bash
# Add .bun-version to your project
echo "1.0.25" > .bun-version
git add .bun-version
git commit -m "Pin Bun version for consistency"

# Team members just need to:
git clone <your-project>
cd <your-project>
bunvm install $(cat .bun-version)
# Everyone uses the same Bun version! 🤝
```

### Scenario 4: CI/CD Integration

```yaml
# .github/workflows/test.yml
steps:
  - name: Install BunVM
    run: curl -fsSL https://install.bunvm.com | bash

  - name: Install Bun
    run: |
      source ~/.bashrc
      bunvm install $(cat .bun-version)

  - name: Run tests
    run: bun test
```

## 🎯 Advanced Features

### Auto Version Switching

BunVM automatically switches to the correct Bun version when you enter a directory with a `.bun-version` file.

```bash
# Create a .bun-version file
echo "1.0.25" > .bun-version

# Enter the directory - BunVM auto-switches!
cd my-project
# Automatically using Bun 1.0.25
```

This works in:
- **Bash**: On every prompt
- **Zsh**: On directory changes

### Tab Completion

BunVM includes smart autocompletion for both Bash and Zsh.

```bash
# Press TAB after typing:
bunvm <TAB>
# Shows: install uninstall use list current alias selfupdate help

bunvm use <TAB>
# Shows: 1.0.25 1.0.24 stable lts (installed versions + aliases)

bunvm list <TAB>
# Shows: --local
```

### Version Aliases

Create meaningful names for versions:

```bash
# Set up your workflow
bunvm alias production 1.0.25
bunvm alias staging 1.0.24
bunvm alias experimental 1.1.0

# Switch easily
bunvm use production
bunvm use staging
```

## 🔧 Configuration

BunVM stores everything in `~/.bunvm/`:

```
~/.bunvm/
├── bunvm.sh              # Core script
├── commands/             # Command implementations
├── lib/                  # Shared libraries
├── autoload/            # Autocompletion & autoenv
├── versions/            # Installed Bun versions
│   ├── bun-1.0.25/
│   └── bun-1.0.24/
└── etc/                 # Configuration
    ├── current          # Active version
    └── aliases          # Version aliases
```

## 🗑️ Uninstallation

To completely remove BunVM from your system:

```bash
curl -fsSL https://uninstall.bunvm.com | bash
```

This will:
1. Remove `~/.bunvm` directory
2. Clean up your shell profile
3. Remove all installed Bun versions

## 🆚 Why BunVM?

| Feature | BunVM | Others |
|---------|-------|--------|
| **Zero Dependencies** | ✅ | ❌ (most require Node/Python) |
| **Auto Version Switching** | ✅ | ⚠️ (limited) |
| **Tab Completion** | ✅ | ⚠️ (varies) |
| **Installation Speed** | ⚡ Instant | 🐌 Slow |
| **Self-Updating** | ✅ | ❌ |
| **Cross-Platform** | ✅ | ⚠️ (varies) |
| **Learning Curve** | 📈 Minimal | 📈 Steep |

## 🐛 Troubleshooting

### Bun command not found after installation

Make sure you've reloaded your shell:

```bash
source ~/.zshrc  # or ~/.bashrc
```

Or open a new terminal window.

### bunvm command not found

Check if BunVM is in your shell profile:

```bash
grep bunvm ~/.zshrc  # or ~/.bashrc
```

You should see:
```bash
export BUNVM_DIR="$HOME/.bunvm"
source "$BUNVM_DIR/bunvm.sh"
```

### Version doesn't persist after restarting terminal

This is now fixed! `bunvm use` automatically persists the version. If you're still experiencing this:

1. Update BunVM: `bunvm selfupdate`
2. Restart your terminal
3. Try again: `bunvm use <version>`

### Tab completion not working

1. Make sure you've updated: `bunvm selfupdate`
2. Reload your shell: `source ~/.zshrc` (or `~/.bashrc`)
3. Check if completion is loaded:
   ```bash
   # Bash
   type _bunvm_completion

   # Zsh
   type _bunvm
   ```

## 🤝 Contributing

Found a bug or have a feature request?

- **Issues**: https://github.com/privjaac/bunvm/issues
- **Pull Requests**: https://github.com/privjaac/bunvm/pulls

## 📄 License

MIT License - feel free to use BunVM in your projects!

## 🙏 Acknowledgments

Inspired by:
- [nvm](https://github.com/nvm-sh/nvm) - Node Version Manager
- [rbenv](https://github.com/rbenv/rbenv) - Ruby Version Manager
- [sdkman](https://sdkman.io/) - Software Development Kit Manager

---

**Made with ❤️ for the Bun community**

[Report Bug](https://github.com/privjaac/bunvm/issues) · [Request Feature](https://github.com/privjaac/bunvm/issues) · [Documentation](https://github.com/privjaac/bunvm)