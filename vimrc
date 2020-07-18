"设置编码
set fileencodings=utf-8,usc-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

"启用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key

"设置缩进
set tabstop=4                " tab缩进长度
set shiftwidth=4        "使用<< >> ==控制缩进的长度
set autoindent                "自动缩进
set expandtab                 "tab转空格
set softtabstop=4        "tab转空格长度

"其他
"set paste      "插入模式下粘贴格式不乱,这个命令会令在它之前的好多命令失效！！，建议手动使用
set nu        " set number / set nonumber
set showmatch   "显示括号匹配
set showmode        "显示当前
set showcmd                "显示指令
set t_Co=256        
set textwidth=80
set wrap    "自动换行
set linebreak   "不会单词内部换行
"set laststatus=2 "总是显示状态栏
set ruler   "显示光标位置,放在paste后面，不然不知道为啥无效

"让vimrc配置保存后立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC

"自动补全
"Ctrl + n   Ctrl + p  打开补全列表并移动

"文件类型推导
"查找目录 :!echo $VIMRUNTIME  和 $HOME/.vim/
syntax on        "语法识别 .../syntax/xx.vim
filetype indent on        "根据文件类型自动寻找缩进规则 $VIMRUNTIME/indent/xx.vim
filetype plugin on  "自动找插件.../plugin/xx.vim

""""""""""""""""""""""""""""""""""""""
"map 映射快捷键
"n        普通模式
"i        插入模式
"v        可视化模式
"c        命令模式
"o        命令等待时生效
"un        删除映射
"nore 非递归

"恢复撤销 
nnoremap U <C-r>
"全选 复制 删除
map <C-a> <Esc>ggvG$
map <C-x> d
map <C-c> y
"括号
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap " ""<left>
inoremap ' ''<left>
"""""""""""""""""""""""""""""""""""""""