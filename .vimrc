"----------------------------------------------------------------------
" Vim Configuration Start
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" Common Configuration
"----------------------------------------------------------------------

" Set map leader for extra key combinations
let mapleader = ","

" Set vim to be vim instead of vi
set nocompatible

" Set number
set number
set relativenumber

" Set indentation
set tabstop=4      " 1 tab == 4 spaces
set softtabstop=4  " 1 tab == 4 spaces
set shiftwidth=4   " 1 tab == 4 spaces
set expandtab      " use spaces instead of tabs
set smarttab       " use the value of shiftwidth when tab

set autoindent     " copy indent from current line
set smartindent    " indent based on syntax/style
set cino=N-s       " do not indent c++ namespace

" Search Setting
set hlsearch       " highlight search results
set incsearch      " do incremental searching

set ignorecase     " ignore case when searching
set smartcase      " upper case characters imply case-sensitive searching

" Undo Setting
set nobackup       " no backup after write file
set nowritebackup  " no backup even without write file
set noswapfile     " no swap file when crash

" set backup
" set undofile
" set backupdir=$HOME/.vim/bkup//
" set directory=$HOME/.vim/swap//
" set undodir=$HOME/.vim/undodir//

" Split Setting
set splitbelow     " :sp onen window below
set splitright     " :vs open window on the right

" Set various details
set autochdir      " change the working directory to the directory containing the current file
set nowrap         " keep long lines in the same line, don't continue on a new line
set scrolloff=10   " keep 10 lines to the cursor - when moving vertically using j/k
set signcolumn=yes " always show sign column so that text doesn't shift
set clipboard^=unnamed,unnamedplus  " use the same clipboard everywhere
let g:netrw_dirhistmax = 0          " diable netrw hist file

"----------------------------------------------------------------------
" Neovim Configuration that differ from Vim
"----------------------------------------------------------------------

" Enable syntax highlighting
syntax enable

" Enable filetype configuration
filetype plugin on
filetype indent on

" Set true colors
set termguicolors

" Set backspace
set backspace=indent,eol,start

" Set various details
set encoding=utf8  " default encoding using utf8
set mouse=a        " enable the use of mouse
set ruler          " show current position
set showcmd        " display incomplete commands
set wildmenu       " command line completion in an enhanced mode

"----------------------------------------------------------------------
" Keymaps Configuration
"----------------------------------------------------------------------

" Stop highlight when <leader><cr>
noremap <silent> <leader><cr> :noh<cr>

" Go across files
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep indent selection
vnoremap < <gv
vnoremap > >gv

" Move lines up / down
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

"----------------------------------------------------------------------
" Vim Configuration End
"----------------------------------------------------------------------
