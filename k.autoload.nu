if (sys host | get name) == "Windows" {
    $env.config.buffer_editor = "code"
} else {
    $env.config.buffer_editor = "vim"
}

$env.config = {
  datetime_format: {
      normal: "%Y/%m/%d %H:%M:%S %z"
      table: "%Y/%m/%d %H:%M:%S"
  }
}

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
