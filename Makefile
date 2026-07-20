# Configuration
#
# Local setup defaults
user-email = brunohcastro@gmail.com
user-name = Bruno Castro
user-nick = $(USER)
colorscheme = gruvbox-dark-hard
uname_s = $(shell uname -s)
stale_desktop_packages = i3 polybar rofi picom conky xmonad xmobar p10k xresources lx-apps xdm xorg ukuake bin

# Userspace
#
user/home:
	- xdg-user-dirs-update

user/shell: user/shell/$(uname_s)

user/shell/Linux: core/utils \
                   core/shell/Linux \
                   git/antidote \
                   stow/dotfile/zsh \
                   stow/dotfile/starship

user/shell/Darwin: core/shell/Darwin \
                    git/antidote \
                    stow/dotfile/zsh \
                    stow/dotfile/starship

user/programming: user/programming/$(uname_s)

user/programming/Linux: user/shell/Linux \
                         applications/terminal/Linux \
                         stow/dotfile/nvim \
                         stow/dotfile/tmux \
                         stow/dotfile/kitty

user/programming/Darwin: user/shell/Darwin \
                          applications/terminal/Darwin \
                          stow/dotfile/nvim \
                          stow/dotfile/tmux \
                          stow/dotfile/kitty

user/desktop:
	@echo "user/desktop is archived. Stale desktop configs live under archive/dotfiles."
	@false

user/environments/golang:
	- sudo pacman -S --noconfirm --needed \
	    go \
	    go-tools
	- go install golang.org/x/tools/gopls@latest
	- go install golang.org/x/tools/cmd/goimports@latest
	- go install github.com/go-delve/delve/cmd/dlv@latest
	- go install mvdan.cc/gofumpt@latest

user/environments/rust: ~/.env-rust
	- curl https://sh.rustup.rs -sSf \
	    | sh -s -- --no-modify-path

user/environments/mise:
	- curl https://mise.run | sh

user/environments/asdf user/environments/node user/environments/nodejs:
	@echo "$@ is archived. Use user/environments/mise and a project-level mise config instead."
	@false

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
wm/i3 wm/locker wm/support:
	@echo "$@ is archived. Stale desktop configs live under archive/dotfiles."
	@false

# Desktop Environment
#

de/xfce:
	- sudo pacman -S --noconfirm --needed xfce4

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
	- yay -S --noconfirm --needed \
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
	    offlineimap

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
	- yay -S --noconfirm --needed \
	    chromium \
	    firefox \
	    google-chrome

applications/graphics:
	- yay -S --noconfirm --needed \
	    inkscape \
	    gimp

applications/filesystem: stow/dotfile/ranger
	- yay -S --noconfirm --needed \
	    simple-mtpfs \
	    xarchiver \
	    dropbox \
	    gvfs \
	    ranger

applications/development: applications/docker
	- yay -S --noconfirm --needed \
	    android-studio \
	    webstorm-jre \
		intellij-idea-ultimate-edition-jre \
	    visual-studio-code \
	    aws-cli \
	    kubectl \
	    postman-bin

applications/social:
	- yay -S --noconfirm --needed \
	    telegram-desktop-bin \
	    slack-desktop \
	    discord

applications/multimedia:
	- yay -S --noconfirm --noedit --needed \
	    mellowplayer \
	    yt-dlp \
	    vokoscreen \
	    mpv

applications/utils:
	- yay -S --noconfirm --needed \
	    qbittorrent \
	    copyq \
	    variety \
	    synergy \
	    fastfetch

# Specific

applications/dunst: stow/dotfile/dunst
	- sudo pacman -S --noconfirm --needed dunst

applications/redshift: stow/dotfile/redshift
	- sudo pacman -S --noconfirm --needed redshift

applications/emacs: stow/dotfile/emacs
	- sudo pacman -S --noconfirm --needed emacs

applications/weechat:
	@echo "$@ is archived. The old setup depended on Python 2 and wee-slack."
	@false

applications/taskwarrior: stow/dotfile/taskwarrior
	- sudo pacman -S --noconfirm --needed \
	    task

applications/terminal: applications/terminal/$(uname_s)

applications/terminal/Linux:
	- yay -S --noconfirm --needed \
	    kitty \
	    tmux \
	    neovim \
	    ripgrep \
	    fd \
	    fzf \
	    zoxide \
	    direnv \
	    lazygit \
	    bat \
	    eza

applications/terminal/Darwin:
	- brew install \
	    tmux \
	    neovim \
	    ripgrep \
	    fd \
	    fzf \
	    zoxide \
	    direnv \
	    lazygit \
	    bat \
	    eza
	- brew install --cask kitty

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
      core/printer \
      core/fonts

core/utils:
	sudo pacman -S --noconfirm --needed \
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

core/shell: core/shell/$(uname_s)

core/shell/Linux:
	sudo pacman -S --noconfirm --needed \
	  starship \
	  fzf \
	  zoxide \
	  direnv

core/shell/Darwin:
	- brew install \
	  git \
	  stow \
	  starship \
	  fzf \
	  zoxide \
	  direnv

core/printer:
	yay -S --noconfirm --needed \
	  cups \
	  system-config-printer \
	  epson-inkjet-printer-201401w \
	  gtk3-print-backends \
	  xsane

core/fonts:
	yay -S --noconfirm --needed \
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
		
core/aur-helper: clean/tmp
	cd tmp \
		&& curl -L -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
		&& tar -xvf yay.tar.gz \
		&& cd yay \
		&& makepkg -sri --noconfirm

core/aur-helper/cower:
	@echo "$@ is archived. Use core/aur-helper to install yay."
	@false

core/xorg:
	@echo "$@ is archived. X11/window-manager configs live under archive/dotfiles."
	@false

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
                        system/notebook 

device/desktop: device/common
	- yay -S --noconfirm --noedit --needed \


device/imac: device/common
	- echo "TODO"

device/asus-k555:
	@echo "$@ is archived. Rebuild this hardware profile before using it again."
	@false

device/acer-vx5: device/common/notebook
	- echo "TODO"

device/macbook-air: device/common/notebook
	- echo "TODO"

device/surface: device/common/notebook
	- echo "TODO"

# Task utils
#
olkb/install:
	- yay -S --noconfirm --needed \
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

/etc/vconsole.conf:
	@echo "$@ has no tracked source in this repo."
	@false

/etc/modprobe.d/%: etc/modprobe.d/%
	- sudo cp etc/modprobe.d/$* $@

/etc/%: etc/%
	- sudo cp etc/$* $@

/etc/X11/xorg.conf.d/%.conf: etc/X11/xorg.conf.d/%.conf
	- sudo cp etc/X11/xorg.conf.d/$*.conf $@

/etc/systemd/system/%:
	@echo "$@ has no tracked source in this repo."
	@false

~/.bin/%:
	@echo "$@ is archived. Old generated scripts live under archive/dotfiles/bin."
	@false

clean/tmp:
	- mkdir -p tmp
	- rm -rf tmp/*

sync/agents:
	mkdir -p dotfiles/agents dotfiles/codex/.codex/rules
	rsync -a --delete \
	  --exclude '.git/' \
	  --exclude '.DS_Store' \
	  $(HOME)/.agents/ dotfiles/agents/.agents/
	rsync -a $(HOME)/.codex/config.toml dotfiles/codex/.codex/config.toml
	rsync -a $(HOME)/.codex/rules/default.rules dotfiles/codex/.codex/rules/default.rules

sync/git:
	mkdir -p dotfiles/git/.config/git
	rsync -a $(HOME)/.gitconfig dotfiles/git/.gitconfig
	rsync -a $(HOME)/.config/git/ignore dotfiles/git/.config/git/ignore

sync/nvim-lock:
	mkdir -p dotfiles/nvim/.config/nvim
	rsync -a $(HOME)/.config/nvim/nvim-pack-lock.json dotfiles/nvim/.config/nvim/nvim-pack-lock.json

clean/nvim-live:
	find $(HOME)/.config/nvim/lua -xtype l -delete
	rm -f $(HOME)/.config/nvim/lazy-lock.json

archive/stale-desktop:
	for pkg in $(stale_desktop_packages); do \
	  [ ! -e dotfiles/$$pkg ] || stow -D --no-folding -t $(HOME) -d dotfiles/ $$pkg; \
	done
	mkdir -p archive/dotfiles
	for pkg in $(stale_desktop_packages); do \
	  [ ! -e dotfiles/$$pkg ] || git mv dotfiles/$$pkg archive/dotfiles/; \
	done

stow/etc/%:
	- sudo stow --no-folding -t /etc -d etc/ $*

stow/dotfile/%:
	- stow --no-folding -t $(HOME) -d dotfiles/ $*

git/emacs.d:
	[ -d ~/.emacs.d ] \
	  && git -C ~/.emacs.d pull \
	  || git clone https://github.com/brunohcastro/emacs ~/.emacs.d

git/antidote:
	[ -d ~/.antidote/.git ] \
	  && git -C ~/.antidote pull --ff-only \
	  || git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote

git/password-store:
	[ -d ~/.password-store ] \
	  && git -C ~/.password-store pull \
	  || git clone ssh://git@git.dastro.com.br/bruno/pass ~/.password-store
