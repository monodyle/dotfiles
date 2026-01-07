set fish_greeting

set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $PATH

if status is-interactive
# Commands to run in interactive sessions can go here
end

alias z "zoxide"
alias c "clear"
alias ls "exa"
alias vi "nvim"
alias prv "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

alias cs "open $argv -a 'Cursor'"
alias vs "open $argv -a 'Visual Studio Code'"

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
set -gx VOLTA_FEATURE_PNPM 1
