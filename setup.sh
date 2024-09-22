#!/bin/bash

# Check OS



# Red HAT

if [[ -d "/etc/dnf" ]] && [[ -f "/usr/bin/dnf" ]]; then
        USER_DISTRO="RED_HAT"
fi

cat /etc/os-release | grep -i "redhat" > /dev/null;

if [[ "$?" -eq 0 ]];then
	USER_DISTRO="RED_HAT";
fi

# Debian

if [[ -d "/etc/apt" ]] && [[ -f "/usr/bin/apt" ]]; then
        USER_DISTRO="Debian"
fi

cat /etc/os-release | grep -i "debian" > /dev/null;

if [[ "$?" -eq 0 ]];then
	USER_DISTRO="Debian";
fi

# Arch

if [[ -f "/usr/bin/pacman" ]]; then
        USER_DISTRO="Arch"
fi

cat /etc/os-release | grep -i "arch" > /dev/null;

if [[ "$?" -eq 0 ]];then
        USER_DISTRO="Arch";
fi

case "$USER_DISTRO" in

RED_HAT)
	echo "Distro Based on RED_HAT";

        #Verif git
        rpm --query git > /dev/null;

        if [[ "$?" -eq 0 ]]
        then
                echo "Git installed"
        else
                echo "Git not installed"
                sudo dnf install git -y
        fi

        #Verif ZSH
        rpm --query zsh > /dev/null;

        if [[ "$?" -eq 0 ]]
        then
                echo "Zsh installed"
        else
                echo "Zsh not installed"
                sudo dnf install zsh -y
        fi

        #Verif Curl
        rpm --query curl > /dev/null ;

        if [[ "$?" -eq 0 ]]
        then
                echo "Curl installed"
        else
                echo "Curl not installed"
                sudo dnf install curl -y
        fi

        #Verif neofetch
        rpm --query fastfetch > /dev/null ;

        if [[ "$?" -eq 0 ]]
        then
                echo "Fastfetch installed"
        else
                echo "Fastfetch not installed"
                sudo dnf install fastfetch -y
        fi
;;
Debian)
	echo "Distro Based on Debian";

        #Verif git
        apt show git 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Git installed"
        else
                echo "Git not installed"
                sudo apt install git -y
        fi

        #Verif ZSH
        apt show zsh 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null
        if [[ "$?" -eq 0 ]]
        then
                echo "Zsh installed"
        else
                echo "Zsh not installed"
                sudo apt install zsh -y
        fi

        #Verif Curl
        apt show curl 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null
        if [[ "$?" -eq 0 ]]
        then
                echo "Curl installed"
        else
                echo "Curl not installed"
                sudo apt install curl -y
        fi

        #Verif wget
        apt show wget 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null
        if [[ "$?" -eq 0 ]]
        then
                echo "Wget installed"
        else
                echo "Wget not installed"
                sudo apt install wget -y
        fi


        #Verif neofetch
        apt show fastfetch 2> /dev/null | grep -i "APT-Manual-Installed: yes" > /dev/null
        if [[ "$?" -eq 0 ]]
        then
                echo "Fastfetch installed"
        else
                echo "Fastfetch not installed"
                wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.25.0/fastfetch-linux-amd64.deb
                dpkg -i fastfetch-linux-amd64.deb
                rm fastfetch-linux-amd64.deb
        fi



;;
Arch)
	echo "Distro Based on Arch";
        # Verif git
        pacman -Q git > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Git installed"
        else
                echo "Git not installed"
                sudo pacman -Syu git ;
        fi

        # Verif ZSH
        pacman -Q zsh > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Zsh installed"
        else
                echo "Zsh not installed"
                sudo pacman -Syu zsh;
        fi

        #Verif Curl
        pacman -Q curl > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Curl installed"
        else
                echo "Curl not installed"
                sudo pacman -Syu zsh;
        fi

        # Verif Fastfetch
        pacman -Q fastfetch > /dev/null

        if [[ "$?" -eq 0 ]]
        then
                echo "Fastfetch installed"
        else
                echo "Fastfetch not installed"
                sudo pacman -Syu fastfetch;
        fi


esac


# Change shell
echo "Changing default shell"
chsh -s /usr/bin/zsh ;

# Install OhMyZsh
cd  ~;
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install.sh && chmod +x install.sh
sh install.sh --unattended

# Install Plug-in
git clone https://github.com/zsh-users/zsh-syntax-highlighting ;
git clone https://github.com/zsh-users/zsh-completions ;
git clone https://github.com/zsh-users/zsh-autosuggestions ;

# Moove plug-in into zsh dir
mv zsh* ~/.oh-my-zsh/plugins

# Copy personnal theme into dir
mv ~/auto_zsh/chibraax.zsh-theme ~/.oh-my-zsh/themes/;

# Write plug-in into .zshrc and change theme
sed -i "s/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/g" .zshrc ;
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="chibraax"/g' .zshrc ;

# Config .zshrc
echo "fastfetch" >> .zshrc
rm install.sh

exec zsh -l && source .zshrc
exit 0;
