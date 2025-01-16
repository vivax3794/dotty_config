if test -z "$DISPLAY" -a (tty) = "/dev/tty1"
    exec Hyprland
end

set -x EDITOR nvim

# ========= HYPRLAND ===========
abbr --add mn hyprctl keyword monitor HDMI-A-1,1920x1080@60,auto-left,1,transform,0
abbr --add mr hyprctl keyword monitor HDMI-A-1,1920x1080@60,auto-left,1,transform,1

# ========= TOOL REPLACEMENTS ===========
abbr --add ls exa -al
abbr --add grep rg
abbr --add cat bat # Maybe not? idk

# ========= EXTRA FLAGS ===========
# I love myself --verbose! good to know stuff is happening :P
abbr --add cp cp -rv
abbr --add rm rm -rv
abbr --add mv mv -v

# ========= GIT ===========
abbr --add ghr gh repo create
abbr --add clone gh repo clone
abbr --add gp git pull
abbr --add g lazygit

# ========= LAZY GIT STUFF ===========
# "Lazy Git" - i.e this is for when I am extra lazy
# I normally use `lazygit` for commits and all that nice stuff
# these are for when I just need to do a backup of a folder and its not really a important project
# Like my dotfiles
abbr --add backup 'git add .; git commit -m "$(date)"; git push'

# ========= RUST ===========
# Most of the time I will just be using bacon, but its nice to have
abbr --add c cargo
abbr --add cn cargo new
abbr --add cr cargo run
abbr --add ct cargo nextest run
abbr --add b bacon

# ========= QOL ===========
abbr --add n nvim
abbr --add co cd ~/coding

# ========= EXTRA FLAGS ===========
# (the MAC address is my headset)
abbr --add bc bluetoothctl connect AC:80:0A:F4:0B:FC
abbr --add bd bluetoothctl disconnect AC:80:0A:F4:0B:FC

set -Ux fish_user_paths $HOME/.cargo/bin $fish_user_paths
set -Ux fish_user_paths $HOME/.rustup/toolchains/(rustup show active-toolchain | cut -d' ' -f1)/bin $fish_user_paths

