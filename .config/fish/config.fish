set fish_greeting
set -gx PATH /home/monody/.local/bin /usr/local/go/bin $HOME/.cargo/bin $PATH

# set -x BROWSER /mnt/c/Program\ Files/Firefox\ Nightly/firefox.exe

# tauri
# set -x DISPLAY (powershell.exe -c ipconfig | grep -A4 WSL | tail -1 | awk '{ print $NF }' | tr -d '\r'):0 
# set -x LIBGL_ALWAYS_INDIRECT 1

# alias
alias c="clear"
# alias coding="cd $HOME/coding"
alias ls="exa"
alias vi="nvim"
alias bat="batcat"
alias prv="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

function vs --argument-names "path"
    if test -n "$path"
        code $path
    else
        code .
    end
end

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/monody/google-cloud-sdk/path.fish.inc' ]; . '/home/monody/google-cloud-sdk/path.fish.inc'; end

# set -x VIRTUAL_ENV_DISABLE_PROMPT 1
