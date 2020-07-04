set nocompatible              " be iMproved, required
filetype plugin on
set encoding=utf-8

"
" Necessary to have true colors in some terminals (like st)
"
set term=xterm-256color

"
" Automatically install the vim-plug plugin manager if not already present
"
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"
" Install plugins
"
call plug#begin('~/.vim/plugged')
"
" Automatically change Vim working directory to project root for better search
"
Plug 'airblade/vim-rooter'
"
" Show git-related line status in the side column
"
Plug 'airblade/vim-gitgutter'
"
" Lightweight status bar compatible with other plugins
"
Plug 'vim-airline/vim-airline'
"
" Git wrapper. Use :Git or :G followed by a git command. Additionally, :Gedit,
" :Gread, :Gdiffsplit
"
Plug 'tpope/vim-fugitive'
"
" Additional mappings such as ]a (next args), ]b (next buffer), ]l (next
" location), ]q (next quickfix), ]t (next tab), ]f (next file), ]n (next
" conflict marker), ]<Space> (add new line), ]e (exchange next line), yos
" (toggle spelling), ]u (URL-decode), [u (URL-encode)
"
Plug 'tpope/vim-unimpaired'
"
" Additional mappings to manipulate surrounding elements such as cs'" to
" replace ' with ", cst' to replace a html tag with ', ds} to delete braces,
" yss) to wrap the line, ysiw" to quote the current word
"
Plug 'tpope/vim-surround'
"
" Run file through external syntax checker
" Type :SyntasticCheck flake8 for manual check
" Type :Errors for errors to show in location list
"
"Plug 'vim-syntastic/syntastic'
"
" Custom colorscheme
"
Plug 'nanotech/jellybeans.vim'
"
" Additional themes for vim-airline, including jellybeans
"
Plug 'vim-airline/vim-airline-themes'
"
" Fuzzy file, buffer, mru, tag, etc finder. Provides :CtrlP (Control-P), :CtrlPBuffer,
" :CtrlPMixed.
" Use <F5> to purge the cache, <c-f> and <c-b> to cycle between modes,
" <c-d> to switch to filename only search, <c-r> for regexp mode,
" <c-j>, <c-k> to navigate, <c-t> or <c-v>, <c-x> to open in a new tab or in a new split,
" <c-n>, <c-p> for the next/previous string in the prompt's history,
" <c-y> to create a new file and its parent directories,
" <c-z> to mark/unmark multiple files and <c-o> to open them.
"
Plug 'ctrlpvim/ctrlp.vim'
"
" fzf integration in Vim (non functional?)
"
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
"
" Automatically open Jupyter .ipynb files through the jupytext function for
" conversion
"
Plug 'goerz/jupytext.vim'
"
" Command to pass the buffer through an external code formatter
"
Plug 'Chiel92/vim-autoformat'
"
" Realtime syntax checking
"
Plug 'dense-analysis/ale'
"
" Defaults that make sense
"
Plug 'tpope/vim-sensible'
call plug#end()

"
" This defines when the vim-sensible settings are applied.
" Keep your own settings below this
"
runtime! plugin/sensible.vim


"
" Configure line numbering
"
set relativenumber
set number

"
" Activate syntax highligthing by default
"
syn on
syntax enable

"
" Move Vim temporary files out of the current directory to avoid creating a
" mess
"
set backupdir=~/.vim,/tmp
set directory=~/.vim,/tmp

"
" Increment/Decrement a number with Alt-a (Option-a)/Alt-x (Option-x) instead
" of using Control to avoid conflict in Windows mode
"
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

"
" Set spacing defaults
"
set expandtab
set shiftwidth=4
set softtabstop=4
"set tabstop=4

"
" Highlight search results
"
set hlsearch

"
" Ignore case by default for search with no uppercase letters
"
set ignorecase
set smartcase

"
" Sync vim and system clipboard for easier copy-pasting
"
set clipboard=unnamedplus

"
" Create and toggle folds with the spacebar
"
nnoremap <space> za
vnoremap <space> zf

"
" Shortcuts to execute the buffer as a script, based on the hashbang in the
" file. Print the result in Vim's console or directly in the buffer
"
nnoremap <buffer> <F8> :cd /tmp<cr>:let foo ='/tmp/'.strftime('%T')<cr>:exec 'w! '.foo<cr>:exec '!chmod u+x '.foo<cr>:exec 'read !'.foo<cr><cr>
nnoremap <buffer> <F9> :cd /tmp<cr>:let foo ='/tmp/'.strftime('%T')<cr>:exec 'w! '.foo<cr>:exec '!chmod u+x '.foo<cr>:exec '!'.foo<cr>

"
" Fix syntax highlighting for unrecognized file extensions
"
autocmd BufNewFile,BufRead *.ts   set syntax=javascript
autocmd BufNewFile,BufRead nginx.conf   set syntax=javascript
autocmd BufNewFile,BufRead *.conf set syntax=json

"
" Fix syntax highlighting for Squarespace file extensions
"
autocmd BufNewFile,BufRead *.item set syntax=html
autocmd BufNewFile,BufRead *.list set syntax=html
autocmd BufNewFile,BufRead *.list set syntax=html
autocmd BufNewFile,BufRead *.region set syntax=html
autocmd BufNewFile,BufRead *.block set syntax=html

"
" Remap the <Leader> key
"
let mapleader = ","

"
" Search down into subfolders when using gf, [f, ]f, ^Wf, find, sfind, tabfind
"
set path+=**

"
" Display all matching files when pressing tab in search, and ignore
" auto-generated files to speed up the search
"
set wildmenu
set wildignore+=*.pyc,*.swp,**/.git/**,**/venv/**
set wildignore+=**/node_modules/**
set wildignore+=**/build/**

"
" Define colorscheme
"
colorscheme jellybeans
set termguicolors                    " Enable GUI colors for the terminal to get truecolor

"
" Hide unsightly toolbar in gvim
"
set guioptions -=T

"
" Deactivate ex mode shortcut. This mode is rarely used and hard to exit, yet
" the shortcut is easy to hit by mistake
"
nnoremap Q <Nop>

"
" Consider dash-separated group of letters to be part of the same word
"
set iskeyword+=-

"
" Make spacing appropriate for Python files
"
au BufNewFile,BufRead *.py set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ fileformat=unix

"
" Make web files more compact by reducing spacing
"
au BufNewFile,BufRead *.js set
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

au BufNewFile,BufRead *.html set
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

au BufNewFile,BufRead *.css set
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

"
" Highlight trailing whitespace as a reminder to keep files clean
"
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"
" Use Control-B to list and switch between opened buffers
"
nmap <C-B> :CtrlPBuffer<CR>

"
"
set tags=tags;/

"
" Option to make thegoerz/jupytext.vim plugin open the .ipynb files as Python
" files by default
"
let g:jupytext_fmt = 'py'

"
" Shortcut to reopen the same document in a new instance of vim.
" This is useful to edit files coming from MITMproxy since requests will hang
" otherwise
"
command Ingvim execute 'silent' '! vimbg /tmp/ingvim_tmp_file_%:t' | w /tmp/ingvim_tmp_file_%:t | q

"
" Deactivate annoying automatic indent jumps
"
filetype indent off

let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_lint_on_filetype_changed = 0

" Paste from clipboard when in insert mode.
imap <C-V> <ESC>"+gpa
" Paste from clipboard when in visual mode. (Replace whatever is selected in visual mode.)
vmap <C-V> "+gp

"
" LEGACY
"
"
" Shortcuts for Python debugging
"
"au BufNewFile,BufRead *.py map <leader>t :!nosetests %<CR>
"au BufNewFile,BufRead *.py nmap <leader>b oimport pdb; pdb.set_trace()<ESC>
"
"
" Shortcuts to create newlines without entering the Insert mode
"
"nmap <S-Enter> O<Esc>
"nmap <CR> o<Esc>
"
"
"set smarttab
"
"" Enable the list of buffers
"let g:airline#extensions#tabline#enabled = 1
"" Show just the filename
"let g:airline#extensions#tabline#fnamemod = ':t'

"
" Recommended settings for Syntastic
"
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_python_checkers = ['flake8']
"
"
"set autoindent
"
" Make defaults closer to Windows
"
"source $VIMRUNTIME/mswin.vim
"behave mswin
