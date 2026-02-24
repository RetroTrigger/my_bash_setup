# my_bash_setup

A script to quickly bootstrap a modern Bash environment with a custom prompt, improved CLI tools, and smart navigation.

## What gets installed

| Tool | Purpose |
|------|---------|
| [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts) | Font with icon support required for the prompt and eza icons |
| [Starship](https://starship.rs) | Fast, customisable cross-shell prompt |
| [eza](https://github.com/eza-community/eza) | Modern replacement for `ls` with icons and git integration |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` that learns your most-used directories |

## Supported distros

- Arch Linux
- Debian / Ubuntu (and derivatives e.g. Linux Mint, Pop!_OS)
- Fedora

## Usage

```bash
bash <(curl -s https://raw.githubusercontent.com/RetroTrigger/my_bash_setup/main/install.sh)
```

Or clone and run locally:

```bash
git clone https://github.com/RetroTrigger/my_bash_setup.git
cd my_bash_setup
bash install.sh
```

After the script completes, reload your shell:

```bash
source ~/.bashrc
```

## eza aliases

The following aliases are added to `~/.bashrc`:

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | Basic listing with icons |
| `la` | `eza -a --icons` | All files including hidden |
| `l` | `eza -lh --icons --git` | Long format with git status |
| `ll` | `eza -lah --icons --git --group-directories-first` | Long all, directories first |
| `lt` | `eza --tree --level=2 --icons` | Tree view, 2 levels deep |
| `lsize` | `eza -lah --sort=size --reverse --icons` | Sorted by size |
| `ltime` | `eza -lah --sort=modified --reverse --icons` | Sorted by modification time |
| `ld` | `eza --only-dirs --icons` | Directories only |

## Notes

- The script is idempotent — safe to run multiple times, existing installs are skipped
- `sudo` is required for font and package installation
- The Starship config is fetched from this repo and saved to `~/.config/starship.toml` on every run
