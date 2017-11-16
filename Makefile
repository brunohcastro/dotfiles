# Configuration
#
# Variables used in m4 templates
user-email = brunohcastro@gmail.com
user-name = Bruno Castro
user-nick = $(USER)
colorscheme = gruvbox-dark-hard

# Userspace
#
user/home:
	- xdg-user-dirs-update

user/desktop: wm/i3 \
              applications
	- pacaur -S --noconfirm --needed xorg-xsetroot

user/environments/golang: ~/.env-golang
	- sudo pacman -S --noconfirm --needed \
	    go \
	    go-tools
	- go get -u github.com/rogpeppe/godef
	- go get -u github.com/nsf/gocode
	- curl https://glide.sh/get | sh

user/environments/rust: ~/.env-rust
	- curl https://sh.rustup.rs -sSf \
	    | sh -s -- --no-modify-path

user/environments/asdf:
	- git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.0
	- source ~/.zshrc

user/environments/node: user/environments/asdf
	- asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
	- bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
	- asdf install nodejs 8.7.0
	- asdf global nodejs 8.7.0

user/environments/sdkman:
	- curl -s "https://get.sdkman.io" | bash

user/environments/jvm: user/environments/sdkman
	- sdkman install java
	- sdkman install kotlin
	- sdkman install gradle
	- sdkman install ant
	- sdkman install maven

user/git-identity:
	- git config --global user.name $(user-name)
	- git config --global user.email $(user-email)

# Window Manager
#

wm/i3: stow/dotfile/i3 wm/locker wm/support
	- sudo -v
	- pacaur -S --noconfirm --noedit --needed \
	    i3-gaps \
	    i3blocks

wm/locker:
	- pacaur -S --noconfirm --noedit --needed \
	    i3lock \
	    python-cairo \
	    python-gobject \
	    python-dbus

wm/support: applications/scrot applications/dunst
	- pacaur -S --noconfirm --noedit --needed \
	    compton \
	    rofi \
	    volumeicon \
	    unclutter-xfixes-git \
	    hsetroot \
	    volumeicon \
	    playerctl \
	    network-manager-applet \
	    gpointing-device-settings \
	    pavucontrol \
	    xautolock \
	    imagemagick \
	    python2-i3-py \
	    feh

# Applications
#

# Groups

applications: applications/appearance \
              applications/productivity \
              applications/browsers \
              applications/graphics \
              applications/filesystem \
              applications/social \
              applications/development \
              applications/utils

applications/appearance: stow/dotfile/qt
	- pacaur -S --noconfirm --noedit --needed \
	    arc-gtk-theme \
	    qt5-styleplugins \
	    qt5ct \
	    lxappearance \
	    papirus-icon-theme-git \
	    gnome-themes-standard

applications/productivity: applications/taskwarrior
	- pacaur -S --noconfirm --noedit --needed \
	    libreoffice \
	    zathura \
	    zathura-pdf-mupdf \
	    texlive-most \
	    xpdf \
	    ghostscript \
	    evince-no-gnome \
	    rednotebook

applications/browsers:
	- pacaur -S --noconfirm --noedit --needed \
	    chromium \
	    firefox \
	    google-chrome

applications/graphics:
	- pacaur -S --noconfirm --needed --noedit \
	    inkscape \
	    gimp \
	    pencil

applications/filesystem: stow/dotfile/ranger
	- pacaur -S --noconfirm --noedit --needed \
	    pcmanfm \
	    simple-mtpfs \
	    xarchiver \
	    dropbox \
	    gvfs \
	    ranger

applications/development: applications/emacs applications/docker
	- pacaur -S --noconfirm --noedit --needed \
	    android-studio \
	    webstorm-jre \
	    visual-studio-code \
	    aws-cli \
	    chef-dk \
	    the_silver_searcher \
	    staruml \
	    argouml \
	    kubectl-bin \
	    robo3t-bin \
	    kube-aws

applications/social: applications/weechat
	- pacaur -S --noconfirm --noedit --needed \
	    telegram-desktop-bin \
	    slack-desktop

applications/multimedia:
	- pacaur -S --noconfirm --noedit --needed \
	    mellowplayer \
	    youtube-dl \
	    vokoscreen \
	    mpv

applications/utils: applications/password-store applications/redshift
	- pacaur -S --noconfirm --noedit --needed \
	    qbittorrent \
	    copyq \
	    variety \
	    screenfetch

# Specific

applications/dunst: stow/dotfile/dunst
	- sudo pacman -S --noconfirm --needed dunst

applications/redshift: stow/dotfile/redshift
	- sudo pacman -S --noconfirm --needed redshift

applications/emacs: git/emacs.d
	- sudo pacman -S --noconfirm --needed \
	    emacs \
	    mu \
	    offlineimap \
	    w3m

applications/mpd: ~/.config/mpd/mpd.conf ~/.config/systemd/user/mpd.service
	- sudo pacman -S --noconfirm --needed mpd mpc
	- mkdir -p ~/.mpd/playlists
	- systemctl --user daemon-reload
	- systemctl --user enable mpd.service
	- systemctl --user start mpd.service

applications/ncmpcpp: ~/.ncmpcpp/bindings ~/.ncmpcpp/config
	- sudo pacman -S --noconfirm --needed ncmpcpp

applications/weechat:
	- sudo pacman -S --noconfirm --needed \
	    python2 \
	    python2-pip \
	    weechat
	- sudo pip2 install websocket-client
	- mkdir -p ~/.weechat/python/autoload
	- curl -o ~/.weechat/python/autoload/wee_slack.py "https://raw.githubusercontent.com/rawdigits/wee-slack/master/wee_slack.py"

applications/taskwarrior: stow/dotfile/taskwarrior
	- sudo pacman -S --noconfirm --needed \
	    task

applications/terminal: stow/dotfile/xresources
	- pacaur -S --noconfirm --noedit --needed \
	    rxvt-unicode-patched \
	    oh-my-zsh-git
	- sudo pacman -S --noconfirm --needed \
	    urxvt-perls \
	    tmux

applications/scrot:
	- sudo pacman -S --noconfirm --needed scrot
	- mkdir -p ~/Pictures/screenshots

applications/docker:
	- sudo pacman -S --noconfirm --needed \
	    docker \
	    docker-compose \
	    lxc
	- sudo gpasswd -a $(USER) docker
	- sudo systemctl enable docker

applications/password-store: git/password-store
	- gpg --recv-keys 011FDC52DA839335
	- pacaur -S --noconfirm --needed --noedit \
	    pass \
	    browserpass

# Core
#

core: core/utils \
      core/aur-helper \
      core/xorg \
      core/fonts

core/utils:
	sudo pacman -S --noconfirm \
	  zsh \
	  ctags \
	  git \
	  openssh \
	  unzip \
	  unrar \
	  xdg-user-dirs \
	  stow \
	  exfat-utils \
	  cpio \
	  xsel

core/fonts:
	pacaur -S --noconfirm --noedit --needed \
	  libxft \
	  ttf-dejavu \
	  ttf-font-awesome \
	  noto-fonts \
	  ttf-ms-fonts \
	  ttf-roboto \
	  ttf-ubuntu-font-family \
	  nerd-fonts-complete

core/aur-helper: core/aur-helper/cower
	cd tmp \
		&& curl -L -O "https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz" \
		&& tar -xvf pacaur.tar.gz \
		&& cd pacaur \
		&& makepkg -sri --noconfirm

core/aur-helper/cower: clean/tmp
	- gpg --recv-keys 487EACC08557AD082088DABA1EB2638FF56C0C53 # Dave Reisner, cower maintainer
	- mkdir -p tmp \
			&& cd tmp \
			&& curl -L -O "https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz" \
			&& tar -xvf cower.tar.gz \
			&& cd cower \
			&& makepkg -sri --noconfirm

core/xorg: # /etc/X11/xorg.conf.d/20-intel.conf /etc/X11/xorg.conf.d/00-keyboard.conf ~/.drirc
	sudo pacman -S --noconfirm --needed \
	  xorg-server \
	  xorg-xinit \
	  xorg-xinput \
	  xorg-xrandr \
	  xorg-xrdb \
	  xorg-xdm \
	  xorg-xev \
	  xorg-setxkbmap \
	  xterm \
	  xclip \
	  xf86-input-libinput \
	  xf86-input-synaptics
	- sudo systemctl enable xdm.service

# System
#

system/common: system/network \
               system/sound

system/notebook: # /etc/modprobe.d/i915.conf /etc/thinkfan.conf
	- pacaur -S --noconfirm --noedit --needed \
	    acpi \
	    ethtool \
	    powertop \
	    rfkill \
	    tlp \
	    x86_energy_perf_policy \
	    xorg-xbacklight \
	    xfce4-power-manager \
	    acpi_call
	- sudo systemctl enable tlp.service tlp-sleep.service
	- sudo systemctl start tlp.service tlp-sleep.service

system/sound: stow/etc/modprobe.d
	- pacaur -S --noconfirm --noedit --needed \
	    pamixer \
	    pulseaudio \
	    pulseaudio-alsa \
	    alsa-utils \
	    pulseaudio-bluetooth
	- pulseaudio -D

system/bluetooth:
	- sudo pacman -S --noconfirm --needed \
	    bluez \
	    bluez-utils
	- sudo systemctl enable bluetooth.service
	- sudo systemctl start bluetooth.service

system/network:
	- sudo pacman -S --noconfirm --needed networkmanager
	- sudo systemctl enable NetworkManager.service
	- sudo systemctl start NetworkManager.service

system/intel:
	- sudo pacman -S --noconfirm --needed \
	    xf86-video-intel \
	    libva-intel-driver \
	    lib32-libva-intel-driver \
	    libvdpau-va-gl \
	    libvdpau \
	    lib32-libvdpau

system/razer:
	- gpg --recv-keys 5FB027474203454C
	- pacaur -S --noconfirm --noedit --needed \
	    razercfg

system/nvidia:
	- sudo pacman -S --noconfirm --needed \
	    nvidia \
	    nvidia-utils \
	    nvidia-settings \
	    libxnvctrl \
	    lib32-nvidia-utils

system/hybrid-graphics: # system/intel system/nvidia
	- sudo pacman -S --noconfirm --needed \
	    bumblebee \
	    primus \
	    lib32-primus \
	    bbswitch
	- sudo systemctl enable bumblebeed.service
	- sudo systemctl start bumblebeed.service
	- sudo gpasswd -a $(USER) bumblebee

# Device setups
#
device/common: core \
               system/common

device/common/notebook: device/common \
                        system/notebook \
	- sudo pacman -S --noconfirm --needed \


device/desktop: device/common
	- pacaur -S --noconfirm --noedit --needed \


device/imac: device/common
	- echo "TODO"

device/asus-k555: core \
                  system/common \
                  system/notebook \
                  system/hybrid-graphics \
                  user/desktop \
                  user/environments/nodejs
	- pacaur -S --noconfirm --noedit --needed \
	    aic94xx-firmware \
	    wd719x-firmware

device/acer-vx5: device/common/notebook
	- echo "TODO"

device/macbook-air: device/common/notebook
	- echo "TODO"

device/surface: device/common/notebook
	- echo "TODO"

# Task utils
#
olkb/install:
	- pacaur -S --noconfirm --noedit --needed \
	    avr-gcc \
	    avr-binutils \
	    avr-libc \
	    dfu-util \
	    arm-none-eabi-gcc \
	    arm-none-eabi-binutils \
	    arm-none-eabi-newlib \
	    dfu-programmer

olkb/remove:
	- sudo pacman -Rns \
	    avr-gcc \
	    avr-binutils \
	    avr-libc \
	    dfu-util \
	    arm-none-eabi-gcc \
	    arm-none-eabi-binutils \
	    arm-none-eabi-newlib \
	    dfu-programmer

/etc/vconsole.conf: templates/etc/vconsole.conf
	- sudo pacman -S --noconfirm terminus-font
	- sudo cp ./templates/vconsole.conf /etc/vconsole.conf

/etc/modprobe.d/%: templates/etc/modprobe.d/*
	- sudo cp templates/etc/modprobe.d/$* $@

/etc/%: templates/etc/*
	- sudo cp templates/etc/$* $@

/etc/X11/xorg.conf.d/%.conf: templates/etc/X11/xorg.conf.d/*
	- sudo cp templates/etc/X11/xorg.conf.d/$*.conf $@

/etc/systemd/system/%: templates/etc/systemd/system/*
	- sudo mkdir -p $(@D)
	- $(macrocmd) \
	    templates/etc/systemd/system/$* \
	    | sudo dd of=$@

~/.bin/%: templates/dotfiles/bin/*
	- mkdir -p $(@D)
	- $(macrocmd) \
	    templates/dotfiles/bin/$* \
	    > $@
	- chmod +x $@

clean/tmp:
	- mkdir -p tmp
	- rm -rf tmp/*

stow/etc/%:
	- sudo --no-folding stow -t /etc -d etc/ $*

stow/dotfile/%:
	- stow --no-folding -t $(HOME) -d dotfiles/ $*

git/emacs.d:
	[ -d ~/.emacs.d ] \
	  && git -C ~/.emacs.d pull \
	  || git clone https://github.com/brunohcastro/emacs ~/.emacs.d

git/password-store:
	[ -d ~/.password-store ] \
	  && git -C ~/.password-store pull \
	  || git clone ssh://git@git.dastro.com.br/bruno/pass ~/.password-store
