if (sys host | get name) == "Windows" {
    $env.config.buffer_editor = "code"
} else {
    $env.config.buffer_editor = "vim"
}

$env.config = {
    # 时间展示的默认格式化
    datetime_format: {
        normal: "%Y/%m/%d %H:%M:%S %z"
        table: "%Y/%m/%d %H:%M:%S"
    }
}

# 获取git仓库的当前分支，如果不在git仓库中返回null
def git_current_branch [] {
    let b = do { git rev-parse --abbrev-ref HEAD } | complete
    if $b.exit_code != 0 {
        return
    }
    let b = $b.stdout | str trim
    if $b == "HEAD" {
        git rev-parse --short=8 HEAD
    } else {
        $b
    }
}

# 获取git仓库的主分支
def git_main_branch [] {
    git branch --format='%(refname:short)' | lines | find -nr '(^main$)|(^master$)' | first
}

# 构造命令行提示符
def gen_prompt [] {
    let custom_path = if (pwd) == ($nu.home-path | path expand) {
        "~"
    } else {
        (pwd | path basename)
    }

    let b = git_current_branch
    let git_display = if $b != null {
        $" (ansi blue_bold)git:\((ansi red)($b)\)(ansi reset)"
    } else {
        ""
    }
    let color_path = $"(ansi green_bold)($custom_path)(ansi reset)"
    let color_arrow = $"(ansi green)➜(ansi reset)"
    $"($color_path)($git_display)"
}

$env.PROMPT_COMMAND =  { gen_prompt }
$env.PROMPT_COMMAND_RIGHT = { date now | format date "%Y/%m/%d %H:%M:%S" }

def open-folder [path?: string] {
    let host = sys host | get name;
    let target_path = if $path != null {
        $path | path expand
    } else {
        $env.PWD | path expand
    }
    if $host == "Windows" {
        explorer $target_path
    } else if $host == "Darwin" {
        ^open $target_path
    } else {
        error make {msg: "Unsupported host: $host"}
    }
}

alias g = git
alias ga = git add
alias gb = git branch
alias gcm = git checkout (git_main_branch)
alias gco = git checkout
alias gst = git status
