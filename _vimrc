" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" ------------------------------
" |     以下开始为个人配置     |
" ------------------------------

" 建立全局变量判断Windows系统
if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:vimrc_iswindows=1
else
    let g:vimrc_iswindows=0
endif
autocmd BufEnter * lcd %:p:h	" 自动移动到当前目录

set nocompatible	" 移除VIM仿VI模式，以防兼容问题出现 
filetype off		" 不检测文件类型

"---------------------------------------------------------------
" 设置包括vundle和初始化相关的runtime path
set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
let path='$VIM/vimfiles/bundle'

call vundle#begin(path)		" 开始插件配置

" Vundle插件本身
Plugin 'VundleVim/Vundle.vim'

" NERD_tree 文件浏览器
Plugin 'scrooloose/nerdtree'

" MiniBufExplorer 多文件编辑插件
" Plugin 'fholgado/minibufexpl.vim'
" 由于采用Airline后自带Buffer切换功能，所以不再需要 MiniBufExplorer
" Vim-airline 超级状态栏显示插件
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Tagbar 替代TagList的标签列表插件
Plugin 'majutsushi/tagbar'

" a.vim 切换 c 与 h 文件的插件
Plugin 'a.vim'

" AutoComplPop 变量函数自动弹出插件
Plugin 'AutoComplPop'

" OmniCppComplete 自动补全插件
Plugin 'OmniCppComplete'

" ale 语法检查插件
"Plugin 'w0rp/ale'

" NERD Commenter 自动注释插件
Plugin 'scrooloose/nerdcommenter'

" DoxygenToolKit 增加 Doxygen 风格注释插件 
Plugin 'DoxygenToolkit.vim'

call vundle#end()   " 结束插件配置
" 以上为插件管理器vundle配置
"---------------------------------------------------------------

"---------------------------------------------------------------
" ctags&&cscope config
" 设置 F9 用于在当前目录生成 tags 和 cscope.out
map <F9> :call Do_CsTag()<CR>

" 自动生成 tags 和 cscope 引索文件功能函数
function Do_CsTag()
    let dir = getcwd()		" 获取当前文件位置
	" 删除之前的 tags 文件
    if filereadable("tags")
        if(g:vimrc_iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to delete the tags" | echohl None
            return
        endif
    endif
	" 移除 cscope 链接并删除原先的引索文件
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:vimrc_iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:vimrc_iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to delete the cscope.out" | echohl None
            return
        endif
    endif
	" 生成新的 ctags 文件
    if(executable('ctags'))
        silent! execute "!ctags -R --c-types=+p --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
	" 生成新的 cscope 引索文件
    if(executable('cscope') && has("cscope") )
        if(g:vimrc_iswindows==1)
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        else
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction
"---------------------------------------------------------------

"---------------------------------------------------------------
" NERDTree config
" 设置 F2 用于开启和关闭
map <F2> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
" 关闭vim时，如果打开的文件除了NERDTree没有其他文件时，它自动关闭，减少多次按:q!
" autocmd vimenter * NERDTree	" 打开vim时自动打开NERDTree
"let NERDTreeQuitOnOpen=1	" 打开文件自动隐藏
"---------------------------------------------------------------

"---------------------------------------------------------------
" MiniBufExplorer config
"let g:miniBufExplMapWindowNavVim = 1   
"let g:miniBufExplMapWindowNavArrows = 1   
"let g:miniBufExplMapCTabSwitchBufs = 1   
"let g:miniBufExplModSelTarget = 1  
"let g:miniBufExplMoreThanOne=0
"
"map <F11> :MBEbp<CR>
"map <F12> :MBEbn<CR>
"---------------------------------------------------------------

"---------------------------------------------------------------
" Vim-Airline config
"let g:airline_powerline_fonts = 1	" 采用 Powerline 字体   
"let g:airline_theme='solarized'	" 定义主题   
let g:airline_theme='molokai'	" 定义主题   
let g:airline#extensions#tabline#enabled = 1	" 显示窗口 tab 和 buffer
let g:airline#extensions#tabline#buffer_nr_show = 1

nnoremap <F11> :bp<CR>
nnoremap <F12> :bn<CR>
"---------------------------------------------------------------

"---------------------------------------------------------------
" TagBar config
map <F3> :TagbarToggle<CR>
let g:tagbar_ctags_bin='ctags'	" ctags程序的路径
let g:tagbar_width = 30		" 设置tagbar的宽度为30列，默认40
"let g:tagbar_left = 1		" 让tagbar在页面左侧显示，默认右边
"let g:tagbar_autofocus = 1	" 这是tagbar一打开，光标即在tagbar页面内，默认在vim打开的文件内
"let g:tagbar_sort = 0		" 设置标签不排序，默认排序
autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()	" 在某些情况下自动打开tagbar
"---------------------------------------------------------------

"---------------------------------------------------------------
" A.vim config
nnoremap <silent><F4> :A<CR>
"---------------------------------------------------------------

"---------------------------------------------------------------
"" ALE config
""始终开启标志列
"let g:ale_sign_column_always = 1
"let g:ale_set_highlights = 1
"
""文件内容发生变化时不进行检查
"let g:ale_lint_on_text_changed = 'never'
"打开文件时不进行检查
"let g:ale_lint_on_enter = 0
"
""自定义error和warning图标
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'
"
""在vim自带的状态栏中整合ale
"let g:ale_statusline_format = ['E:%d', 'W:%d', 'OK']
"
""显示Linter名称,出错或警告等相关信息
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"
""普通模式下，sp前往上一个错误或警告，sn前往下一个错误或警告
"nmap sp <Plug>(ale_previous_wrap)
"nmap sn <Plug>(ale_next_wrap)
"
""<Leader>s触发/关闭语法检查
"nmap <Leader>s :ALEToggle<CR>
"
""<Leader>d查看错误或警告的详细信息
"nmap <Leader>d :ALEDetail<CR>
"---------------------------------------------------------------

"---------------------------------------------------------------
" NERD_commenter config
let NERDShutUp = 1
let NERDSpaceDelims = 1		" 注释与语句留一个空格
let NERDCompactSexyComs = 1	" 性感风格注释
let g:NERDDefaultAlign = 'left'	" 多行注释自动左对齐

" 增加 Crtl+/ 快捷键用于自动增加注释
map <C-/> \c<space>
"---------------------------------------------------------------

"---------------------------------------------------------------
" DoxygenToolKit config
let g:DoxygenToolkit_authorName="Candura"
"let g:DoxygenToolkit_licenseTag="My ownlicense\<enter>"
let g:DoxygenToolkit_undocTag="DOXIGEN_SKIP_BLOCK"
let g:DoxygenToolkit_briefTag_pre = "@brief\t"
let g:DoxygenToolkit_paramTag_pre = "@param\t"
let g:DoxygenToolkit_returnTag = "@return\t"
let g:DoxygenToolkit_briefTag_funcName = "yes"	" 是否在注释中 自动 包含函数名称
let g:DoxygenToolkit_maxFunctionProtoLines = 30

" 增加 F5 快捷键用于添加 Doxygen 风格注释
map <F5> : Dox<CR>
" 增加 F6 快捷键用于在文件开头添加作者信息
map <F6> gg: DoxAuthor<CR>
"---------------------------------------------------------------

if(g:vimrc_iswindows==1)
    "允许鼠标的使用
	if has('mouse')
        set mouse=a
    endif
	" 启动 VIM 时最大化
    autocmd GUIEnter * simalt ~x
endif

set nu	" 显示行号
syntax enable	" 设置高亮
syntax on		" 语法高亮
set tags=tags;	" 设置 tags 路径为当前文件夹下tags目录
set autochdir	" 自动切换当前目录
set hlsearch	" 搜索结果高亮(高亮后使用 :noh 清除高亮)
set incsearch	" 搜索输入实时匹配
colorscheme sublimemonokai	" 设置主题配色

set tabstop=4		" 设定 tab 长度为 4
set softtabstop=4	" 按一次退格删掉 4 个空格
set shiftwidth=4	" 设定 << 和 >> 命令移动宽度为 4
set autoindent		" 自动缩进
set cindent			" C自动缩进

set ruler " 显示标尺
set guifont=Consolas_NF:h12 " 设置字体
set helplang=cn	" 设置中文帮助
set showcmd		" 显示输入的命令

set foldenable	" 允许折叠
set foldmethod=manual	" 手动折叠

" 调用Keil进行编译下载
function MakeKeilTarget(options)
    let l:target = ''
 
    if !empty(glob('*.uvprojx'))
        let l:target =  glob('*.uvprojx')
    elseif !empty(glob('../../*.uvprojx'))
        let l:target =  glob('../../*.uvprojx')
    elseif !empty(glob('../Project/*.uvprojx'))
        let l:target =  glob('../Project/*.uvprojx')
	endif
 
    if !empty(l:target)
        execute ':silent !uv4 '.a:options.l:target.' -o "\%TEMP\%/mdk_log.txt"'
        "execute ':!uv4 '.a:options.l:target.' -o "\%TEMP\%/mdk_log.txt" && type "\%TEMP\%\mdk_log.txt" && pause'
		execute ':silent !type "\%TEMP\%\mdk_log.txt" && pause'
    else
        echo 'Target not found!'
    endif
endfunction
nnoremap <leader>kb :call MakeKeilTarget('-b ')<CR>
"nnoremap <leader>kr :call MakeKeilTarget('-b -z ')<CR>
nnoremap <leader>kr :call MakeKeilTarget('-cr ')<CR>
nnoremap <leader>kd :call MakeKeilTarget('-f ')<CR>
