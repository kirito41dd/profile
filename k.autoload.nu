def git_main_branch [] {
    git remote show origin
        | lines
        | str trim
        | find --regex 'HEAD .*?[：: ].+'
        | first
        | ansi strip
        | str replace --regex 'HEAD .*?[：: ]\s*(.+)' '$1'
}

alias g = git
alias ga = git add
alias gb = git branch
alias gcm = git checkout (git_main_branch)
alias gco = git checkout
alias gst = git status
