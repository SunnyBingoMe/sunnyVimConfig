"u could also source this file at the end of /etc/vim/vimrc, but the functions have to be endded like function!
"sunny vim config v2012.1.1
"admin@SunnyBoy.me
"main ref:http://bit.ly/vyRuFd


"================================
"sunny basic config
"================================
if(has("win32") || has("win95") || has("win64") || has("win16"))
	let g:iswindows=1
	set guifont=Consolas:h11:cANSI
else
	let g:iswindows=0
endif
set autochdir
let mapleader=","

set nocompatible "不要vim模仿vi模式，建议设置，否则会有很多(plugins?)不兼容的问题
set nobackup
set encoding=utf-8
set helplang=en

if has("autocmd") "if this version of vim support autocmd
	autocmd BufEnter *  silent!lcd %:p:h "local pwd
	"autocmd BufEnter * silent! cd %:p:h "global pwd
	autocmd BufWinEnter * silent! loadview
	autocmd BufWinEnter * silent! set list
	autocmd BufWrite * silent! mkview
endif 

filetype on
syntax enable
syntax on
"colorscheme sunnyEvening
colorscheme sunnyDesert
"colorscheme tango
"colorscheme desertEx "only good for c/cpp, do NOT use for the other file tyeps.
set tabstop=4 "the real tab; and the default value for other
"set shiftwidth=4
"set softtabstop=4 "should be used if 'set expandtab'
set noexpandtab "do not expand tab as spaces.
set backspace=2 "enable backspc
set nu " # of line
"set novb "disable beep sound
set vb t_vb=
set wrap "enable auto line wrap
"set nowrap "disable auto line wrap
set linebreak "full-word wrap
set showbreak=…
set listchars=eol:¶,tab:▸\ ,trail:¬,extends:»,precedes:« " 将制表符显示为'> ',将行尾空格显示为'-'; 需要和 set list 配合使用
set list "show escaped制表符 //'tab' is shown as: '^I' or 'listchars'
nmap <Leader>l :set list!<CR>
set hidden          " 没有保存的缓冲区可以被隐藏
set cursorline "highlight current line
set cursorcolumn "highlight current column

"------ state/status line bar
set statusline=[%F]%y%r%m%*%=\ [%l/%L:%c\ %p%%]
set laststatus=2    " always show the status line
set ruler           " 在编辑过程中，在右下角显示光标位置的状态行

"----- inner spell checker
set spell
setlocal spell spelllang=en_us

"----- fcitx im input 
let g:input_toggle = 1
function! Fcitx2en()
	let s:input_status = system("fcitx-remote")
	if s:input_status == 2
		let g:input_toggle = 1
		let l:a = system("fcitx-remote -c")
	endif
endfunction
function! Fcitx2zh()
	let s:input_status = system("fcitx-remote")
	if s:input_status != 2 && g:input_toggle == 1
		let l:a = system("fcitx-remote -o")
		let g:input_toggle = 0
	endif
endfunction
set timeoutlen=150
if has("autocmd")
	autocmd InsertLeave * call Fcitx2en() "退出insert模式自动关闭
	"autocmd InsertEnter * call Fcitx2zh() "进入insert模式自动开启
endif 

"================================
"sunny key config/map
"================================
set winaltkeys=no "disable alt-menu (alt-menubar)
nnoremap ,w :w<CR>
nnoremap ,q :q<CR>
nmap tt "_dd
vmap t "_d
nmap t "_x
nmap tw "_dw
nmap <S-t> "_D
" not working !!!!
vmap <C-j> gj
vmap <C-k> gk
vmap <C-4> g$
vmap <C-6> g^
vmap <C-0> g^
nmap <C-j> gj
nmap <C-k> gk
nmap <C-4> g$
nmap <C-6> g^
nmap <C-0> g^
"select all
nnoremap <C-a> ggvG
inoremap <C-a> <Esc>ggvG
nnoremap <C-z> u
inoremap <C-z> <Esc>ua
"vmap <C-S-c> "+y
"vmap <C-S-x> "+x
"imap <C-v> <S-INS>
"-----arrows and home, end. seems not available in guake 
inoremap <M-h> <Left>
inoremap <M-l> <Right>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-i> <Home>
inoremap <M-a> <End>
inoremap <M-;> <End>

"-----some functions
"current line, first letter of each word to Upper case
nmap <S-F3> :.s/\w*/\u&/<CR>/OK.OK.OK.<CR>
nmap <Leader><Space><CR> :.s/ //<CR>/OK.OK.OK.<CR>

"=================================================
" auto-pair-close 括号自动智能位置补全, 闭括号重复性检测,  http://is.gd/hqJp0L
"=================================================
:inoremap <S-ENTER> <c-r>=SkipPair()<CR>
:inoremap <S-SPACE> <ESC>la
:inoremap <C-ENTER> <ESC>A;<CR>
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { <c-r>=ClsoeBrace()<CR>
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
"加了del,只在 coldComplete 括号重复时使用
:inoremap ;; <Del><ESC>A;<CR>

function! ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf
function! Semicolon()
	"echo getline('.')[col('.')]
	if getline('.')[col('.')] == ')'
		return "<ESC>A;"
	elseif getline('.')[col('.')] == '}'
		return "\<ESC>A;"
	elseif getline('.')[col('.')] == ']'
		return "\<ESC>A;"
	else
		return ";"
	endif
endf
function! SkipPair()
	if getline('.')[col('.') - 1] == ')'
		return "\<ESC>o"
	else
		normal j
		let curline = line('.')
		let nxtline = curline
		while curline == nxtline
			if getline('.')[col('.') - 1] == '}'
				normal j
				let nxtline = nxtline + 1
				let curline = line('.')
				continue
			else
				return "\<ESC>i"
			endif
		endwhile
		return "\<ESC>o"
	endif
endf
function! ClsoeBrace()
	if getline('.')[col('.') - 2] == '='
		return "{}\<ESC>i"
	elseif getline('.')[col('.') - 3] == '='
		return "{}\<ESC>i"
	elseif getline('.')[col('.') - 1] == '{'
		return "{}\<ESC>i"
	elseif getline('.')[col('.') - 2] == '{'
		return "{}\<ESC>i"
	elseif getline('.')[col('.') - 2] == ','
		return "{}\<ESC>i"
	elseif getline('.')[col('.') - 3] == ','
		return "{}\<ESC>i"
	else
		return "{\<ENTER>}\<ESC>O"
	endif
endf


"=================================================
"about search and replace
"=================================================
set hlsearch "High Ligh search
set incsearch "INCrement search
set gdefault "G default // replace all insteadof only the first one of one line

"=================================================
"about programming
"=================================================
set completeopt=longest,menu    " 关掉 智能补全's 预览窗口
filetype plugin on
filetype plugin indent on       " 加了这句才可以用智能补全
"set tags=/home/nfs/microwindows/src/tags
set showmatch       " 设置匹配模式，类似当输入一个左括号时会匹配相应的那个右括号
set shiftwidth=4    " 换行时,行间交错使用4个空格
set autoindent      " 自动对齐,(沿用上一行)
set smartindent     " 智能对齐 
set cindent         " 更智能对齐,能识别一些c语法
"set indentexpr      " 最灵活的一个: 根据表达式来计算缩进。若此选项非空，则将其他选项覆盖
set ai!             " 自动缩进

"-------代码折叠 : za, zM(Minimize all), zR(Restore all)
:nnoremap <space> za
"set foldlevel=3       " when start, default level to start fold
set foldcolumn=4       "在左侧显示缩进的层次
"set foldmarker={,}
"set foldmethod=marker
"set foldmethod=syntax "grammer
"set foldmethod=diff "fold non-changed code
set foldmethod=indent
"set foldopen-=search   " don't auto-open folds when search into
"set foldopen-=undo     " don't auto-open folds when undo stuff

"-------单文件编译 make/compile one single file
map <F5> :call Do_OneFileMake()<CR>
function Do_OneFileMake()
	if expand("%:p:h")!=getcwd()
		echohl WarningMsg | echo "Fail to make! This file is not in the current dir! Press <F7> to redirect to the dir of this file." | echohl None
		return
	endif
	let sourcefileename=expand("%:t")
	if (sourcefileename=="" || (&filetype!="cpp" && &filetype!="c"))
		echohl WarningMsg | echo "Fail to make! Please select the right file!" | echohl None
		return
	endif
	let deletedspacefilename=substitute(sourcefileename,' ','','g')
	if strlen(deletedspacefilename)!=strlen(sourcefileename)
		echohl WarningMsg | echo "Fail to make! Please delete the spaces in the filename!" | echohl None
		return
	endif
	if &filetype=="c"
		if g:iswindows==1
			set makeprg=gcc\ -o\ %<.exe\ %
		else
			set makeprg=gcc\ -o\ %<\ %
		endif
	elseif &filetype=="cpp"
		if g:iswindows==1
			set makeprg=g++\ -o\ %<.exe\ %
		else
			set makeprg=g++\ -o\ %<\ %
		endif
		"elseif &filetype=="cs"
		"set makeprg=csc\ \/nologo\ \/out:%<.exe\ %
	endif
	if(g:iswindows==1)
		let outfilename=substitute(sourcefileename,'\(\.[^.]*\')' ,'.exe','g')
		let toexename=outfilename
	else
		let outfilename=substitute(sourcefileename,'\(\.[^.]*\')' ,'','g')
		let toexename=outfilename
	endif
	if filereadable(outfilename)
		if(g:iswindows==1)
			let outdeletedsuccess=delete(getcwd()."\\".outfilename)
		else
			let outdeletedsuccess=delete("./".outfilename)
		endif
		if(outdeletedsuccess!=0)
			set makeprg=make
			echohl WarningMsg | echo "Fail to make! I cannot delete the ".outfilename | echohl None
			return
		endif
	endif
	execute "silent make"
	set makeprg=make
	execute "normal :"
	if filereadable(outfilename)
		if(g:iswindows==1)
			execute "!".toexename
		else
			execute "!./".toexename
		endif
	endif
	execute "copen"
endfunction
"进行make的设置
map <F6> :call Do_make()<CR>
map <c-F6> :silent make clean<CR>
function Do_make()
	set makeprg=make
	execute "silent make"
	execute "copen"
endfunction


"=========================================
"for plugins
"=========================================
"
"------ auto close
"OBS: this setting will partly overwrite the previous settings in 'auto-pair-close'
let g:AutoClosePairs = {'[': ']', '(': ')', '"': '"', "'": "'"}

"------ vim latex suit
filetype plugin on
if g:iswindows==1
	set shellslash
endif
set grepprg=grep\ -nH\ $* "has problem in windows
filetype indent on
let g:tex_flavor='latex'

"------ctag path of sys include, the buildin ctags is NOT ok, 'Exuberant Ctags' is needed 
"ctags -R -f ~/.vim/systags --c-kinds=+p /usr/include /usr/local/include
set tags+=~/.vim/systags

"------tag list // based on ctags
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
set ignorecase "ignore case

"------echofunc : hint of the function definition, needs: 'ctags -R --fields=+lS'
"" confilct/ uncompatible with codeComplete
"" the following two lines is showing echofunc hint on statusline
"let g:EchoFuncShowOnStatus = 1
"set statusline=[%F]%y%r%m%*%{EchoFuncGetStatusLine()}%=%l/%L:%c\ \ %p%%

"------ omniCppcomplete setting. based on ctags & LLVM (llvm seems buildin)
set completeopt=menu,menuone
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype in popup window
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DisplayMode=1
let OmniCpp_DefaultNamespaces=["std"]
inoremap <expr> <CR>       pumvisible()?"\<C-y>":"\<CR>"
inoremap <expr> <M-n>      pumvisible()?"\<C-n>":"\<M-n>"
inoremap <expr> <M-p>      pumvisible()?"\<C-p>":"\<M-p>"
inoremap <expr> <M-e>      pumvisible()?"\<C-e>":"\<M-e>" 

"------quick fix
nmap <F6> :cn<cr>
nmap <F7> :cp<cr>

"------c scope, cScope
set cscopequickfix=s-,c-,d-,i-,t-,e- "use quick fix to display c-scope results
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
map <F10> :call Do_CsTag()<CR>
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
function! Do_CsTag()
	let dir = getcwd()
	if filereadable("tags")
		if(g:iswindows==1)
			let tagsdeleted=delete(dir."\\"."tags")
		else
			let tagsdeleted=delete("./"."tags")
		endif
		if(tagsdeleted!=0)
			echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
			return
		endif
	endif
	if has("cscope")
		silent! execute "cs kill -1"
	endif
	if filereadable("cscope.files")
		if(g:iswindows==1)
			let csfilesdeleted=delete(dir."\\"."cscope.files")
		else
			let csfilesdeleted=delete("./"."cscope.files")
		endif
		if(csfilesdeleted!=0)
			echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
			return
		endif
	endif
	if filereadable("cscope.out")
		if(g:iswindows==1)
			let csoutdeleted=delete(dir."\\"."cscope.out")
		else
			let csoutdeleted=delete("./"."cscope.out")
		endif
		if(csoutdeleted!=0)
			echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
			return
		endif
	endif
	if(executable('ctags'))
		"silent! execute "!ctags -R --c-types=+p --fields=+lS *"
		silent! execute "!ctags -R --c++-kinds=+p --fields=+ialS --extra=+q ."
	endif
	if(executable('cscope') && has("cscope") )
		if(g:iswindows!=1)
			silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
		else
			silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
		endif
		silent! execute "!cscope -b"
		execute "normal :"
		if filereadable("cscope.out")
			execute "cs add cscope.out"
		endif
	endif
endfunction

"this is for experiment
cs add /home/solo/vim71/cscope.out /home/solo/vim71 

"------win manager
let g:winManagerWindowLayout='FileExplorer|TagList' "fileExplorer is a build-in plugin named netrw.vim
nmap :wm :WMToggle<cr>

"------ nerd tree, nerdtree
nmap <Leader>e :NERDTreeToggle<CR> 
"use nerd tree within win-manager
let g:NERDTree_title="[NERD Tree]" 
let g:winManagerWindowLayout='NERDTree|TagList,BufExplorer' 
	"will overwrite the previous win-manager config of 'FileExplorer|TagList'
	"to show buffer explorer in win-manager, replace the ',' in the previous
	"line with '|'
function! NERDTree_Start()
	exec 'NERDTree'
endfunction
function! NERDTree_IsValid()
	return 1
endfunction
nmap :wm :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>
nmap <F3> :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>

"------mini bufer explorer
let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplMapWindowNavVim = 1 "<C-h,j,k,l>切换上下左右窗口 // not available
let g:miniBufExplMapWindowNavArrows = 1 "<C-箭头>切换上下左右窗口, C-arrows

"----- c header switch a.vim
nnoremap <silent> <F11> :A<CR>

"----- grep
nnoremap <silent> <F3> :Grep<CR>

"----- neo compl cache. (google: confilct with clangComplete)
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" auto start 
let g:neocomplcache_enable_at_startup = 1
" auto select 1st result
let g:neocomplcache_enable_auto_select = 1 
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" camel-case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" minimum triggre keyword length.
let g:neocomplcache_min_syntax_length = 2
" use <CR> to select and insert
inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
" Define dictionary.
"let g:neocomplcache_dictionary_filetype_lists = {
"	 \ 'default' : '',
"	 \ 'vimshell' : $HOME.'/.vimshell_hist',
"	 \ 'scheme' : $HOME.'/.gosh_completions'
"	 \ }

"----- c.vim cvim
let g:C_Comments = "no"         " 不用c风格,//用C++的注释风格
let g:C_BraceOnNewLine = "no"   " { 单独一行
let g:C_AuthorName = "SunnyBoy.me"
let g:C_Project="F9"
let g:C_TypeOfH = "c"           " *.h文件的文件类型是C还是C++

"----- nerd comment
nmap ,cc <Leader>cc

"----- doxygenTookit, documentation, comments
let g:DoxygenToolkit_briefTag_pre="@Synopsis  " 
let g:DoxygenToolkit_paramTag_pre="@Param " 
let g:DoxygenToolkit_returnTag="@Returns   " 
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------" 
let g:DoxygenToolkit_blockFooter="--------------------------------------------------------------------------" 
let g:DoxygenToolkit_authorName="admin@SunnyBoy.me"
"!!! Does not end with "\<enter>"
let g:DoxygenToolkit_licenseTag="GNU/GPL v3"

"----- :Voom Vim two-pane outliner 
" :Voom

"----- mark.vim 
"\m, \*, *

"----- languageTool. seems openOffice/libreOffice is needed ???
" http://www.vim.org/scripts/script.php?script_id=3223
" :help LanguageTool ;  :LanguageToolCheck ; zg,zug,z=,[s,]s,
let g:languagetool_jar=$HOME . '/.vim/plugin/LanguageTool/LanguageTool.jar'

"----- sdcv全称为stardict console version, apt-get install sdcv.
" http://www.linuxidc.com/Linux/2011-01/31182.htm
function! Mydict()
	let expl=system('sdcv -n ' .
		\  expand("<cword>"))
	windo if
		\ expand("%")=="diCt-tmp" |
		\ q!|endif
	25vsp diCt-tmp
	setlocal buftype=nofile bufhidden=hide noswapfile
	1s/^/\=expl/
	1
endfunction
nmap F :call Mydict()<CR>

