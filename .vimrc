"please also source this file at the end of /etc/vim/vimrc
"sunny vim config v2012.1.1
"admin@SunnyBoy.me
"main ref:http://bit.ly/vyRuFd

"================sunny key map
"select all
nmap <C-a> ggvG 
"-----arrows and home, end ; seems not available in terminal
:inoremap <M-h> <Left>
:inoremap <M-l> <Right>
:inoremap <M-j> <Down>
:inoremap <M-k> <Up>
:inoremap <M-i> <Home>
:inoremap <M-a> <End>
:inoremap <M-;> <End>

"================sunny basic config
set nobackup
set encoding=utf-8
set helplang=en
syntax enable
syntax on
"colorscheme tango
colorscheme desert

set tabstop=4
set backspace=2 "enable backspc
set nu "// can not find the diff between 'nu!' and 'nu'
"set novb "disable beep sound
"set wrap "enable auto line wrap
set nowrap "disable auto line wrap
set linebreak "full-word wrap
"set list "show escaped 制表符 //tabs is shown: ^I => i hate it ....
"set listchars = tab:>-,trail:- " 将制表符显示为'>---',将行尾空格显示为'-' //wrong !!!!
"set listchars = tab:./ ,trail:. 
"set hidden          " 没有保存的缓冲区可以自动被隐藏

"=================================================
" 括号自动智能位置补全, 闭括号重复性检测,  http://is.gd/hqJp0L
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
:inoremap ;; <ESC>A;<CR>

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
"about state bar
"=================================================
set statusline=[%F]%y%r%m%*%=%l/%L:%c\ \ %p%%
set laststatus=2    " always show the status line
"set ruler           " 在编辑过程中，在右下角显示光标位置的状态行

"=================================================
"about programming
"=================================================
set completeopt=longest,menu    " 关掉 智能补全's 预览窗口
filetype pluginindenton       " 加了这句才可以用智能补全
"set tags=/home/nfs/microwindows/src/tags
set showmatch       " 设置匹配模式，类似当输入一个左括号时会匹配相应的那个右括号
set shiftwidth=4    " 换行时,行间交错使用4个空格
set autoindent      " 自动对齐
set smartindent     " 智能对齐 
set ai!             " 自动缩进
"--------------------------------------------------------------------------------
" 代码折叠
"--------------------------------------------------------------------------------
"set foldmarker={,}
"set foldmethod=marker
set foldmethod=syntax
set foldlevel=100       " Don't autofold
"set foldopen-=search   " don't auto-open folds when search into
"set foldopen-=undo     " don't auto-open folds when undo stuff
"set foldcolumn=4

"=========================================
"for plugins
"=========================================

"------tag list
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
set ignorecase "ignore case

"------quick fix
nmap <F6> :cn<cr>
nmap <F7> :cp<cr>

"------c scope
set cscopequickfix=s-,c-,d-,i-,t-,e- "use quick fix to display c-scope results
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"this is for experiment
cs add /home/solo/vim71/cscope.out /home/solo/vim71 

"------win manager
let g:winManagerWindowLayout='FileExplorer|TagList'
nmap :wm :WMToggle<cr>

"------mini bufer explorer
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavVim = 1 "<C-h,j,k,l>切换上下左右窗口
let g:miniBufExplMapWindowNavArrows = 1 "<C-箭头>切换上下左右窗口

"----- c header switch a.vim
nnoremap <silent> <F11> :A<CR>

"----- grep
nnoremap <silent> <F3> :Grep<CR>

"----- neo compl cache
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
let g:neocomplcache_min_syntax_length = 1
" Define dictionary.
"let g:neocomplcache_dictionary_filetype_lists = {
"    \ 'default' : '',
"    \ 'vimshell' : $HOME.'/.vimshell_hist',
"    \ 'scheme' : $HOME.'/.gosh_completions'
"    \ }

"----- 

