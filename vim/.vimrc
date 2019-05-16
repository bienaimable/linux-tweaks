set nocompatible              " be iMproved, required
filetype plugin on

"Automatic install of the vim-plug plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'davidhalter/jedi-vim'
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'vim-syntastic/syntastic'
Plug 'nanotech/jellybeans.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
call plug#end()

source $VIMRUNTIME/mswin.vim
behave mswin

set relativenumber
set number
syn on
set backupdir=~/.vim,/tmp
set directory=~/.vim,/tmp

set encoding=utf-8

nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set softtabstop=4
set autoindent

if has('gui_running')
  set guifont=Inconsolata\ Medium\ 13
endif

set hlsearch
nmap <C-P> :bp<CR>
nmap <C-N> :bn<CR>
set ignorecase
set smartcase
set clipboard=unnamedplus
nnoremap <space> za
vnoremap <space> zf
nnoremap <buffer> <F8> :cd /tmp<cr>:let foo =strftime('%T')<cr>:exec 'w! '.foo<cr>:exec '!chmod u+x '.foo<cr>:exec 'read !./'.foo<cr><cr>
nnoremap <buffer> <F9> :cd /tmp<cr>:let foo =strftime('%T')<cr>:exec 'w! '.foo<cr>:exec '!chmod u+x '.foo<cr>:exec '!./'.foo<cr>
autocmd BufNewFile,BufRead *.ts   set syntax=javascript
autocmd BufNewFile,BufRead nginx.conf   set syntax=javascript
autocmd BufNewFile,BufRead *.conf set syntax=json
autocmd BufNewFile,BufRead *.item set syntax=html
autocmd BufNewFile,BufRead *.list set syntax=html
autocmd BufNewFile,BufRead *.list set syntax=html
autocmd BufNewFile,BufRead *.region set syntax=html
autocmd BufNewFile,BufRead *.block set syntax=html
let mapleader = ","

" Search down into subfolders
set path+=**
set wildignore+=*.pyc,*.swp,**/.git/**,**/venv/**

" Display all matching files when we tab complete
set wildmenu
"
" Recommended settings for Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8', 'mypy']

syntax enable
"colorscheme desert
colorscheme jellybeans

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Hide toolbar in gvim
set guioptions -=T
map <leader>t :!nosetests %<CR>

" Deactivate ex mode shortcut
:nnoremap Q <Nop>
