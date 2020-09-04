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
	- yay -S --noconfirm --needed xorg-xsetroot

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
	- source ~/.zshrc

user/environments/jvm: user/environments/sdkman
	- sdk install java
	- sdk install kotlin
	- sdk install gradle
	- sdk install ant
	- sdk install maven

user/git-identity:
	- git config --global user.name $(user-name)
	- git config --global user.email $(user-email)

# Window Managers
#
wm/i3: stow/dotfile/i3 stow/dotfile/polybar wm/locker wm/support
	- sudo -v
	- yay -S --noconfirm --noedit --needed \
	    i3-gaps \
	    polybar \
	    jsoncpp \
	    i3ipc-glib-git

wm/locker:
	- yay -S --noconfirm --noedit --needed \
	    i3lock \
	    python-cairo \
	    python-gobject \
	    python-dbus

wm/support: applications/scrot applications/dunst
	- yay -S --noconfirm --noedit --needed \
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

# Desktop Environment
#

de/xfce:
	- pacman -S --noconfirm --needed xfce4

# Applications
#

# Groups

applications: applications/appearance \
              applications/productivity \
              applications/mail \
              applications/tex \
              applications/browsers \
              applications/graphics \
              applications/filesystem \
              applications/social \
              applications/development \
              applications/utils

applications/appearance: stow/dotfile/qt
	- yay -S --noconfirm --noedit --needed \
	    arc-gtk-theme \
	    qt5-styleplugins \
	    qt5ct \
	    lxappearance \
	    papirus-icon-theme-git \
	    gnome-themes-standard

applications/productivity: applications/taskwarrior
	- yay -S --noconfirm --noedit --needed \
	    libreoffice \
	    evince-no-gnome \
	    todoist-linux-bin \
	    tomatoapp-bzr \
	    rednotebook

applications/mail:
	- yay -S --noconfirm --noedit --needed \
	    mu \
	    mutt \
	    offlineimap \
	    mailspring

applications/tex:
	- yay -S --noconfirm --noedit --needed \
	    texlive-most \
	    texstudio

applications/science:
	- yay -S --noconfirm --noedit --needed \
	    scilab-bin \
	    octave \
	    octave-control \
	    octave-signal \
	    octave-general \
	    octave-plot \
	    galculator \
	    qucs

applications/browsers:
	- yay -S --noconfirm --noedit --needed \
	    chromium \
	    firefox \
	    google-chrome

applications/graphics:
	- yay -S --noconfirm --needed --noedit \
	    inkscape \
	    gimp \
	    mirage \
	    pencil

applications/filesystem: stow/dotfile/ranger
	- yay -S --noconfirm --noedit --needed \
	    pcmanfm \
	    simple-mtpfs \
	    xarchiver \
	    dropbox \
	    gvfs \
	    ranger

applications/development: applications/docker applications/gitkraken
	- yay -S --noconfirm --noedit --needed \
	    android-studio \
	    webstorm-jre \
		intellij-idea-ultimate-edition-jre \
	    visual-studio-code \
	    aws-cli \
	    chef-dk \
	    the_silver_searcher \
	    staruml \
	    kubectl-bin \
	    robo3t-bin \
	    postman-bin \
	    kube-aws

applications/social: applications/weechat
	- yay -S --noconfirm --noedit --needed \
	    telegram-desktop-bin \
	    slack-desktop

applications/multimedia:
	- yay -S --noconfirm --noedit --needed \
	    mellowplayer \
	    youtube-dl \
	    vokoscreen \
	    mpv

applications/utils: applications/password-store applications/redshift
	- yay -S --noconfirm --noedit --needed \
	    qbittorrent \
	    copyq \
	    variety \
		synergy \
	    screenfetch

# Specific

applications/dunst: stow/dotfile/dunst
	- sudo pacman -S --noconfirm --needed dunst

applications/redshift: stow/dotfile/redshift
	- sudo pacman -S --noconfirm --needed redshift

applications/emacs: git/emacs.d
	- sudo pacman -S --noconfirm --needed emacs

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
	- yay -S --noconfirm --noedit --needed \
	    rxvt-unicode-patched \
	    oh-my-zsh-git \
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

applications/gitkraken:
	- gpg --recv-keys 5CC908FDB71E12C2
	- yay -S --noconfirm --needed --noedit \
	    gitkraken

applications/password-store: git/password-store
	- gpg --recv-keys 011FDC52DA839335
	- yay -S --noconfirm --needed --noedit \
	    pass \
	    browserpass

# Core
#

core: core/utils \
      core/aur-helper \
      core/xorg \
      core/printer \
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
	  ntfs-3g \
	  p7zip \
	  xsel

core/printer:
	yay -S --noconfirm --noedit --needed \
	  cups \
	  system-config-printer \
	  epson-inkjet-printer-201401w \
	  gtk3-print-backends \
	  xsane

core/fonts:
	yay -S --noconfirm --noedit --needed \
	  libxft \
	  ttf-dejavu \
	  noto-fonts \
	  ttf-ms-fonts \
	  ttf-roboto \
	  siji-git \
	  ttf-unifont \
	  ttf-ubuntu-font-family \
		ttf-font-awesome-4 \
	  nerd-fonts-complete
		
core/aur-helper: core/aur-helper/cower
	cd tmp \
		&& curl -L -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
		&& tar -xvf yay.tar.gz \
		&& cd yay \
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
	- yay -S --noconfirm --noedit --needed \
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
	- yay -S --noconfirm --noedit --needed \
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
	- sudo yay -S --noconfirm --needed --noedit \
	    networkmanager \
	    wireless_tools
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
	- yay -S --noconfirm --noedit --needed \
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
	- yay -S --noconfirm --noedit --needed \


device/imac: device/common
	- echo "TODO"

device/asus-k555: core \
                  system/common \
                  system/notebook \
                  system/hybrid-graphics \
                  user/desktop \
                  user/environments/nodejs
	- yay -S --noconfirm --noedit --needed \
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
	- yay -S --noconfirm --noedit --needed \
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