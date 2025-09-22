if (sys host | get name) == "Windows" {
    $env.config.buffer_editor = "code"
} else if (sys host | get name) == "Darwin" {
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



def find_git_dir [] {
    mut current_dir = $env.PWD

    while $current_dir != ($current_dir | path dirname) {
        let git_dir = ($current_dir | path join ".git")
 
        if ($git_dir | path exists) {
            return $git_dir
        }
 
        # 进入上一级目录
        $current_dir = ($current_dir | path dirname)
    }
    
    # 如果没有找到 .git 目录，返回空
    return null
}

# 获取git仓库的当前分支，如果不在git仓库中返回null
def git_current_branch [] {
    let git_dir = find_git_dir;
    if $git_dir == null {
        return null
    }

    # 读取 .git/HEAD 文件
    let head_content = ($git_dir | path join "HEAD" | open)

    let ref = if $head_content =~ "^ref: refs/heads/" {
    # 如果在分支上，提取分支名
    $head_content | str trim | str replace "ref: refs/heads/" ""
    } else if $head_content =~ "^ref: refs/tags/" {
        # 如果在标签上，提取标签名
        $head_content | str trim | str replace "ref: refs/tags/" ""
    } else {
        # 如果直接在一个提交上，返回提交的哈希值
        $head_content | str trim | str substring 0..7
    }

    $ref
}

$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default [] | append {||
    let git_dir = find_git_dir
    if $git_dir != null {
        $env.K_GIT_DIR = $git_dir
    } else {
        $env.K_GIT_DIR = null
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
        $" (ansi blue_bold)git:\((ansi red)($b)(ansi blue_bold)\)(ansi reset)"
    } else {
        ""
    }
    let color_path = $"(ansi green_bold)($custom_path)(ansi reset)"
    let color_arrow = $"(if $env.LAST_EXIT_CODE == 0 {ansi green_bold} else {ansi red_bold})➜(ansi reset)"
    $"($color_arrow) ($color_path)($git_display) "
}

$env.PROMPT_COMMAND =  { gen_prompt }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""


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
alias grbm = git rebase (git_main_branch)
alias configk = ^$env.config.buffer_editor ($nu.user-autoload-dirs.0)/k.autoload.nu


# 加载.env文件，带参数可以指定路径
def --env load-env-file [
    file?: string = ".env"  # 可选参数，默认加载当前目录的 .env 文件
] {
    open $file | lines 
    | split column '#' 
    | get column1 
    | where {($in | str length) > 0} 
    | parse "{key}={value}"
    | update value {str trim -c '"'}
    | transpose -r -d
    | load-env
}
