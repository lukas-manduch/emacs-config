let g:netrw_liststyle = 3
let g:netrw_browse_split = 0

let g:ctrlp_extensions = ['tag', 'buffertag'] 
let g:ale_linters = {'python': ['pyls', 'mypy']}

let g:ale_python_pyls_config = {
	\   'pyls': {
		\    'plugins': {
			\     'pylint': {
				\       'enabled' : v:true 
					\     },
			\     'pyflakes': {
				\       'enabled': v:true
					\     },
			\     'pydocstyle': {
				\      'enabled': v:true
					\     },
			\     'pycodestyle': {
				\      'enabled': v:true
					\     }
			\   }
		\ }
	\}



set nocompatible

set autoread
set autoindent
set completeopt-=preview
set encoding=utf-8
set fileencoding=utf-8
set cursorline
set hidden
set history=50
set incsearch
set laststatus=2
set nowrap
set number
set relativenumber
set ruler
set showcmd
set smartcase
set visualbell
set wildmenu
set wildignore=*.pyc,
set colorcolumn=80
set scrolloff=4

" Disable execution of modeline
set nomodeline
set nomodelineexpr

" Gvim
set guioptions-=r
set guioptions-=L
set guioptions+=m
set guioptions-=T


" Search
set hlsearch
set ignorecase
" USE ENGLISH
set langmenu=en_US
let $LANG = 'en_US'
"-----------------
" Set Path
if has("win32")
   let $PATH = 'C:\msys64\usr\bin;' . $PATH
   set viewdir=~\vimfiles\views
   set dir=~\vimfiles\swap
endif
set path=,.,,**


"  MAPPINGS
map Y y$
" map <C-K> :bprev<CR>
" map <C-J> :bnext<CR>

let mapleader="\<Space>"

" For leader key
noremap <Leader>y "+y
noremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
noremap <Leader>p "+p
noremap <Leader>P "+P
noremap <Leader>n :nohl<CR>
noremap <Leader>c :close<CR>
noremap <Leader>o :only<CR>
noremap <Leader>b :bd<CR>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

noremap <Leader><C-r> :CtrlPBufTag<CR>
noremap <Leader><C-p> :CtrlPTag<CR>
inoremap <silent> <C-Space> <C-\><C-O>:ALEComplete<CR>


"-----------------
set backspace=indent,eol,start

filetype on
syntax on

set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

if has("autocmd")
	augroup rc
		autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
		autocmd BufNewFile,BufRead *.m setfiletype matlab
		autocmd BufWinLeave *.* mkview
		autocmd BufWinEnter *.* silent loadview
	augroup END
endif

colorscheme desert

" Mappings
inoremap jj <Esc>
inoremap jk <Esc>
inoremap <esc> <nop>

vmap X y/<C-R>"<CR>

cd ~
" set makeprg=python\ -m\ unittest\ discover\ -s\ src\ -p\ \"*_test.py\"\ -v\ 2>&1
" set guifont=Consolas:h12

set laststatus=2
set statusline=
set statusline+=%m
set statusline+=\ 
set statusline+=%m
set statusline+=\ 
set statusline+=%F
set statusline+=%=
set statusline+=%{winnr()}
set statusline+=\ 
set statusline+=|
set statusline+=\ 
set statusline+=%{strftime(\"%H:%M\")}
set statusline+=\ 
set statusline+=|
set statusline+=\ 
set statusline+=%k
set statusline+=\ 
set statusline+=%{strlen(&fenc)?&fenc:'none'}
set statusline+=\ 
set statusline+=%{&ff}
set statusline+=\ 
set statusline+=%y
set statusline+=\ 
set statusline+=|
set statusline+=\ 
set statusline+=<
set statusline+=%c
set statusline+=>
set statusline+=\ 
set statusline+=%l
set statusline+=/
set statusline+=%L


function! s:CreateDirectory(dirName)
	if isdirectory(a:dirName)
		return 1
	endif
	if !empty(glob(a:dirName))
		return 0
	endif

	call mkdir(a:dirName, "p", 0700)
	if isdirectory(a:dirName)
		return 1
	endif
	return 0
endfunction


function! s:SetupDirectories(rtpDirName)
	let l:result = 1
	if !s:CreateDirectory(a:rtpDirName)
		echom "Cannot create" . a:rtpDirName
		return 0
	endif

	if !s:CreateDirectory(a:rtpDirName . "/views")
		echom "Cannot creted dir for   views"
		let l:result = 0
	endif

	if !s:CreateDirectory(a:rtpDirName . "/sessions")
		echom "Cannot creted dir for   sessions"
		let l:result = 0
	endif
	if !s:CreateDirectory(a:rtpDirName . "/swap")
		echom "Cannot creted dir for  /swap"
		let l:result = 0
	endif
	if !s:CreateDirectory(a:rtpDirName . "/pack/plugins/start")
		echom "Cannot creted dir for   pack/plugins/start"
		let l:result = 0
	endif
	if !s:CreateDirectory(a:rtpDirName . "/pack/plugins/opt")
		echom "Cannot creted dir for   pack/plugins/opt"
		let l:result = 0
	endif
	if !s:CreateDirectory(a:rtpDirName . "/pack/themes/start")
		echom "Cannot creted dir for   pack/themes/start"
		let l:result = 0
	endif
	return l:result
endfunction

function s:SetupVimSettings(dir)
	if !isdirectory(a:dir)
		echom "Invalid directory " . a:dir
	endif
	" Views
	if isdirectory(a:dir . "/views")
		let &viewdir= a:dir . "/views"
	else
		echom "No view directory"
	endif
	" Swap
	if isdirectory(a:dir . "/swap")
		let &viewdir = a:dir . "/swap"
	else
		echom "No swap directory"
	endif
	if has('shada')
		let &shada = "!,%,'100,/10,:10,<50,s10,h"
		let &shadafile = a:dir . "/shada"
	endif
	if executable('rg')
		let &grepprg = "rg --vimgrep --color=auto $*"
	endif
endfunction




function! s:SetupVimPlug(path)
	let l:user_wd = getcwd()
	let l:plugin_path = a:path
	let l:plug_start =  l:plugin_path . "/pack/plugins/opt"

	if !isdirectory(l:plug_start)
		echom "NE " . l:plug_start
		return 0
	endif
	if confirm("Setup in dir " . l:plug_start, "Yes\nNo", 2) == 2
		return 2
	endif

	echom "Cloning vimplug"
	if !executable('git')
		echom "Git executable not found :("
		return 0
	endif
	if isdirectory(l:plug_start)
		execute "cd" fnameescape(l:plug_start)
		pwd
		!git clone https://github.com/junegunn/vim-plug.git ./vim-plug/plugin
	endif
	execute "cd" fnameescape(l:user_wd)
endfunction

function! s:CommonSetup()
	if empty(&rtp)
		echom "No path found (rtp)"
		return 1
	endif
	let l:plugin_path =  split(&rtp, ",")[0]
	call s:SetupVimSettings(l:plugin_path)
endfunction
call s:CommonSetup()

function! s:SetUpDependencies(rootDir)
	let l:opt = a:rootDir . "/pack/plugins/opt/"
	let l:start = a:rootDir . "/pack/plugins/start/"
	if !isdirectory(l:opt)
		echom "No opt dir"
		return 1
	endif
	if !isdirectory(l:start)
		echom "No start dir"
		return 1
	endif
		

	call plug#begin(l:start)
	Plug 'tpope/vim-sensible'
	Plug 'tpope/vim-surround'
	Plug 'psliwka/vim-smoothie'
	if executable('fzf')
		Plug 'junegunn/fzf'
		Plug 'junegunn/fzf.vim'
	endif
	call plug#end()
	PlugInstall
	PlugUpdate

	call plug#begin(l:opt)
	Plug 'dense-analysis/ale'
	call plug#end()
	PlugInstall
	PlugUpdate
	packloadall
endfunction

function! MYSetupVim()
	if empty(&rtp)
		echom "No path found (rtp)"
		return 1
	endif
	let l:plugin_path =  split(&rtp, ",")[0]
	call s:SetupDirectories(l:plugin_path)
	call s:SetupVimPlug(l:plugin_path)
	packloadall
	packadd vim-plug
	if !exists('g:loaded_plug')
		return
	endif
	call s:SetUpDependencies(l:plugin_path)
	call s:CommonSetup()
endfunction
