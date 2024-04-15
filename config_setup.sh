#!/bin/bash

echo "Making sure packages are up to date"
sudo apt update; sudo apt upgrade -y

config_dir="$HOME/.config"

echo "checking if $HOME/.config exists..."
if [ -d "$config_dir" ]; then
  echo "$config_dir does exist."
fi

if [ ! -d "$config_dir" ]; then
  echo "$config_dir does not exist."
  mkdir $config_dir
fi

echo -e "\n- Installing i3"
echo "##Installing required packages##"
if ! dpkg -s i3 >/dev/null 2>&1; then
    sudo apt install i3 -y
else
    echo "i3 is already installed."
fi

echo -e "\n- Installing polybar"
if ! dpkg -s polybar >/dev/null 2>&1; then
    sudo apt install polybar -y
else
    echo "polybar is already installed."
fi

echo -e "\n- Installing rofi"
if ! dpkg -s rofi >/dev/null 2>&1; then
    sudo apt install rofi -y
else
    echo "rofi is already installed."
fi

echo -e "\n- Installing feh"
if ! dpkg -s feh >/dev/null 2>&1; then
    sudo apt install feh -y
else
    echo "feh is already installed."
fi

echo -e "\n- Installing zsh"
if ! dpkg -s zsh >/dev/null 2>&1; then
    sudo apt install zsh -y
else
    echo "zsh is already installed."
fi

echo -e "\n- Installing Oh-My-ZSH"
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed."
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo -e "\n- Installing zsh-autosuggestions"
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo zsh-autosuggestions is already installed
else
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

echo -e "\n- Installing zsh-syntax-highlighting"
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo zsh-syntax-highlighting is already installed
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo -e "\nAdding config files"
# Specific configuration directories for various applications
config_dirs=(
    "$config_dir/i3"
    "$config_dir/picom"
    "$config_dir/rofi"
    "$config_dir/polybar"
)

# Checking and creating configuration directories if they don't exist
for dir in "${config_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist. Creating..."
        mkdir -p "$dir"
        if [ $? -eq 0 ]; then
            echo "Directory $dir created successfully."
        else
            echo "Failed to create directory $dir."
        fi
    else
        echo "Directory $dir already exists."
    fi
done
cp ./config $config_dir/i3/
cp ./picom.conf $config_dir/picom/
cp ./config.rasi $config_dir/rofi/
cp ./config.ini $config_dir/polybar/
cp ./startup.sh $config_dir/
cp ./.zshrc $HOME

echo -e "\nCreating xsession desktop"
sudo cp ./i3.desktop /usr/share/xsessions/
