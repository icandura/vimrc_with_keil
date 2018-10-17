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
" |     ���¿�ʼΪ��������     |
" ------------------------------

" ����ȫ�ֱ����ж�Windowsϵͳ
if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:vimrc_iswindows=1
else
    let g:vimrc_iswindows=0
endif
autocmd BufEnter * lcd %:p:h	" �Զ��ƶ�����ǰĿ¼

set nocompatible	" �Ƴ�VIM��VIģʽ���Է������������ 
filetype off		" ������ļ�����

"---------------------------------------------------------------
" ���ð���vundle�ͳ�ʼ����ص�runtime path
set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
let path='$VIM/vimfiles/bundle'

call vundle#begin(path)		" ��ʼ�������

" Vundle�������
Plugin 'VundleVim/Vundle.vim'

" NERD_tree �ļ������
Plugin 'scrooloose/nerdtree'

" MiniBufExplorer ���ļ��༭���
" Plugin 'fholgado/minibufexpl.vim'
" ���ڲ���Airline���Դ�Buffer�л����ܣ����Բ�����Ҫ MiniBufExplorer
" Vim-airline ����״̬����ʾ���
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Tagbar ���TagList�ı�ǩ�б���
Plugin 'majutsushi/tagbar'

" a.vim �л� c �� h �ļ��Ĳ��
Plugin 'a.vim'

" AutoComplPop ���������Զ��������
Plugin 'AutoComplPop'

" OmniCppComplete �Զ���ȫ���
Plugin 'OmniCppComplete'

" ale �﷨�����
"Plugin 'w0rp/ale'

" NERD Commenter �Զ�ע�Ͳ��
Plugin 'scrooloose/nerdcommenter'

" DoxygenToolKit ���� Doxygen ���ע�Ͳ�� 
Plugin 'DoxygenToolkit.vim'

call vundle#end()   " �����������
" ����Ϊ���������vundle����
"---------------------------------------------------------------

"---------------------------------------------------------------
" ctags&&cscope config
" ���� F9 �����ڵ�ǰĿ¼���� tags �� cscope.out
map <F9> :call Do_CsTag()<CR>

" �Զ����� tags �� cscope �����ļ����ܺ���
function Do_CsTag()
    let dir = getcwd()		" ��ȡ��ǰ�ļ�λ��
	" ɾ��֮ǰ�� tags �ļ�
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
	" �Ƴ� cscope ���Ӳ�ɾ��ԭ�ȵ������ļ�
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
	" �����µ� ctags �ļ�
    if(executable('ctags'))
        silent! execute "!ctags -R --c-types=+p --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
	" �����µ� cscope �����ļ�
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
" ���� F2 ���ڿ����͹ر�
map <F2> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
" �ر�vimʱ������򿪵��ļ�����NERDTreeû�������ļ�ʱ�����Զ��رգ����ٶ�ΰ�:q!
" autocmd vimenter * NERDTree	" ��vimʱ�Զ���NERDTree
"let NERDTreeQuitOnOpen=1	" ���ļ��Զ�����
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
"let g:airline_powerline_fonts = 1	" ���� Powerline ����   
"let g:airline_theme='solarized'	" ��������   
let g:airline_theme='molokai'	" ��������   
let g:airline#extensions#tabline#enabled = 1	" ��ʾ���� tab �� buffer
let g:airline#extensions#tabline#buffer_nr_show = 1

nnoremap <F11> :bp<CR>
nnoremap <F12> :bn<CR>
"---------------------------------------------------------------

"---------------------------------------------------------------
" TagBar config
map <F3> :TagbarToggle<CR>
let g:tagbar_ctags_bin='ctags'	" ctags�����·��
let g:tagbar_width = 30		" ����tagbar�Ŀ��Ϊ30�У�Ĭ��40
"let g:tagbar_left = 1		" ��tagbar��ҳ�������ʾ��Ĭ���ұ�
"let g:tagbar_autofocus = 1	" ����tagbarһ�򿪣���꼴��tagbarҳ���ڣ�Ĭ����vim�򿪵��ļ���
"let g:tagbar_sort = 0		" ���ñ�ǩ������Ĭ������
autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()	" ��ĳЩ������Զ���tagbar
"---------------------------------------------------------------

"---------------------------------------------------------------
" A.vim config
nnoremap <silent><F4> :A<CR>
"---------------------------------------------------------------

"---------------------------------------------------------------
"" ALE config
""ʼ�տ�����־��
"let g:ale_sign_column_always = 1
"let g:ale_set_highlights = 1
"
""�ļ����ݷ����仯ʱ�����м��
"let g:ale_lint_on_text_changed = 'never'
"���ļ�ʱ�����м��
"let g:ale_lint_on_enter = 0
"
""�Զ���error��warningͼ��
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'
"
""��vim�Դ���״̬��������ale
"let g:ale_statusline_format = ['E:%d', 'W:%d', 'OK']
"
""��ʾLinter����,����򾯸�������Ϣ
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"
""��ͨģʽ�£�spǰ����һ������򾯸棬snǰ����һ������򾯸�
"nmap sp <Plug>(ale_previous_wrap)
"nmap sn <Plug>(ale_next_wrap)
"
""<Leader>s����/�ر��﷨���
"nmap <Leader>s :ALEToggle<CR>
"
""<Leader>d�鿴����򾯸����ϸ��Ϣ
"nmap <Leader>d :ALEDetail<CR>
"---------------------------------------------------------------

"---------------------------------------------------------------
" NERD_commenter config
let NERDShutUp = 1
let NERDSpaceDelims = 1		" ע���������һ���ո�
let NERDCompactSexyComs = 1	" �Ըз��ע��
let g:NERDDefaultAlign = 'left'	" ����ע���Զ������

" ���� Crtl+/ ��ݼ������Զ�����ע��
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
let g:DoxygenToolkit_briefTag_funcName = "yes"	" �Ƿ���ע���� �Զ� ������������
let g:DoxygenToolkit_maxFunctionProtoLines = 30

" ���� F5 ��ݼ�������� Doxygen ���ע��
map <F5> : Dox<CR>
" ���� F6 ��ݼ��������ļ���ͷ���������Ϣ
map <F6> gg: DoxAuthor<CR>
"---------------------------------------------------------------

if(g:vimrc_iswindows==1)
    "��������ʹ��
	if has('mouse')
        set mouse=a
    endif
	" ���� VIM ʱ���
    autocmd GUIEnter * simalt ~x
endif

set nu	" ��ʾ�к�
syntax enable	" ���ø���
syntax on		" �﷨����
set tags=tags;	" ���� tags ·��Ϊ��ǰ�ļ�����tagsĿ¼
set autochdir	" �Զ��л���ǰĿ¼
set hlsearch	" �����������(������ʹ�� :noh �������)
set incsearch	" ��������ʵʱƥ��
colorscheme sublimemonokai	" ����������ɫ

set tabstop=4		" �趨 tab ����Ϊ 4
set softtabstop=4	" ��һ���˸�ɾ�� 4 ���ո�
set shiftwidth=4	" �趨 << �� >> �����ƶ����Ϊ 4
set autoindent		" �Զ�����
set cindent			" C�Զ�����

set ruler " ��ʾ���
set guifont=Consolas_NF:h12 " ��������
set helplang=cn	" �������İ���
set showcmd		" ��ʾ���������

set foldenable	" �����۵�
set foldmethod=manual	" �ֶ��۵�

" ����Keil���б�������
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
