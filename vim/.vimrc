set nocompatible              " be iMproved, required
"filetype off                 " required
filetype plugin on            " required
syntax enable

source $VIMRUNTIME/mswin.vim
behave mswin

set relativenumber
set number
syn on
"map <F5> :! C:\Python34\Lib\idlelib\idle.pyw %<CR>
"
"set directory=.,$TEMP
set backupdir=~/.vim,/tmp
set directory=~/.vim,/tmp

set encoding=utf-8

nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>
"map <F6> :%s/<\([^>]\)*>/\r&\r/g<enter>:g/^$/d<enter>vat=
"map <F7> /\v^\s*([a-zA-Z\-0-9\$])<enter>qm<F6>nq@q1000@@:1<enter>
"map <F9> :%s/[^\\]\zs\ze;/\r/g<enter>:%s/[^\\]\zs\ze:/\r    /g<enter>:%s/[^\\]=\zs\ze/\r        /g<enter>:%s/[^\\]\|\|\zs\ze/\r        /g<enter>:%s/[^\\]\|[^\|]*[^\\]\|\zs\ze/\r        /g<enter>
"map <F9> :%s/[^\\]\zs\ze;/\r/g<enter>:%s/[^\\]\zs\ze:/\r    /g<enter>:%s/[^\\]=\zs\ze/\r        /g<enter>:%s/[^\\]\|[^\|]*[^\\]\|\zs\ze/\r        /g<enter>
"map <F10> :%s/^\(\s\s\s\s\)*//g<enter>:%s/\n//g<enter>

set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set softtabstop=4
set autoindent
"set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

if has('gui_running')
  set guifont=Inconsolata\ Medium\ 16
  colorscheme desert
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

"Automatic install of the vim-plug plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

"" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
"Plug 'junegunn/vim-easy-align'

"" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
"
"" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
"
"" Using a non-master branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
"
"" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'fatih/vim-go', { 'tag': '*' }
"
"" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
"
"" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"
"" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

Plug 'davidhalter/jedi-vim'
Plug 'airblade/vim-rooter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'

" Initialize plugin system
call plug#end()

" vim-jedi settings
let mapleader = ","
let g:jedi#use_tabs_not_buffers = 1

" Search down into subfolders
set path+=**
" Remove files from C-n autocomplete to prevent latencies
set complete-=i

" Display all matching files when we tab complete
set wildmenu
" Hit tab to :find by partial match
" Use * to make it fuzzy
"
" :b lets you autocomplete any open buffer
