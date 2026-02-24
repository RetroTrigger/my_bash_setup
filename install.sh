#!/bin/bash
set -eo pipefail
trap 'rm -f /tmp/FiraCode.zip' EXIT

install_eza_apt() {
    sudo apt update
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
}

##Install firacode nerdfont
if ! fc-list | grep -qi "FiraCode"; then
    if ! command -v unzip &> /dev/null; then
        if [ ! -f /etc/os-release ]; then
            echo "Cannot detect distro: /etc/os-release not found. Please install unzip manually."
            exit 1
        fi
        . /etc/os-release
        case "${ID}" in
            arch) sudo pacman -S --noconfirm unzip ;;
            debian|ubuntu) sudo apt update && sudo apt install -y unzip ;;
            fedora) sudo dnf install -y unzip ;;
            *) echo "unzip not found. Please install it manually."; exit 1 ;;
        esac
    fi
    wget -O /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
    sudo unzip /tmp/FiraCode.zip -d /usr/share/fonts/
    sudo fc-cache -fv
else
    echo "FiraCode Nerd Font already installed, skipping."
fi

## Install Starship
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    echo "Starship already installed, skipping."
fi
if ! grep -q 'starship init bash' ~/.bashrc; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

## Deploy starship config
mkdir -p ~/.config
wget -O ~/.config/starship.toml https://raw.githubusercontent.com/RetroTrigger/my_bash_setup/main/starship.toml

##Install eza
if ! command -v eza &> /dev/null; then
    if [ ! -f /etc/os-release ]; then
        echo "Cannot detect distro: /etc/os-release not found. Please install eza manually."
        exit 1
    fi
    . /etc/os-release
    DISTRO_ID="${ID}"
    DISTRO_ID_LIKE="${ID_LIKE:-}"
    case "$DISTRO_ID" in
        arch)
            sudo pacman -S --noconfirm eza
            ;;
        debian|ubuntu)
            install_eza_apt
            ;;
        fedora)
            sudo dnf install -y eza
            ;;
        *)
            if echo "$DISTRO_ID_LIKE" | grep -qE "debian|ubuntu"; then
                install_eza_apt
            else
                echo "Unsupported distro: $DISTRO_ID. Please install eza manually."
            fi
            ;;
    esac
else
    echo "eza already installed, skipping."
fi

#Add eza aliases to .bashrc
if ! grep -q "alias ls='eza" ~/.bashrc; then
cat <<EOF >> ~/.bashrc
alias ls='eza --icons'
alias la='eza -a --icons'
alias l='eza -lh --icons --git'
alias ll='eza -lah --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias lsize='eza -lah --sort=size --reverse --icons'
alias ltime='eza -lah --sort=modified --reverse --icons'
alias ld='eza --only-dirs --icons'
EOF
else
    echo "eza aliases already in ~/.bashrc, skipping."
fi

##Install zoxide
if ! command -v zoxide &> /dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo "zoxide already installed, skipping."
fi
if ! grep -q 'zoxide init bash' ~/.bashrc; then
    echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
fi

echo "Done! Run 'source ~/.bashrc' or open a new terminal to apply changes."
