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




"----------------------------------------------------------------------
" Vim Plugin Configuration Start
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" Vim Plug
"----------------------------------------------------------------------

call plug#begin('~/.vim/bundle')

" Colorscheme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'rose-pine/vim', { 'as': 'rose-pine' }

" LSP
Plug 'dense-analysis/ale'                " LSP client + linter

" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Syntax Highlight
Plug 'bfrg/vim-cpp-modern'               " cpp highlight

call plug#end()

"----------------------------------------------------------------------
" Colorscheme
"----------------------------------------------------------------------

" diable italics
let &t_ZH=""
let &t_ZR=""

" change colorscheme
colorscheme rosepine

"----------------------------------------------------------------------
" ALE
"----------------------------------------------------------------------

" auto completion
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" LSP actions
nnoremap K :ALEHover<cr>
nnoremap gd :ALEGoToDefinition<cr>
nnoremap gr :ALEFindReferences<cr>
nnoremap <leader>rn :ALERename<cr>
nnoremap <leader>ca :ALECodeAction<cr>

" navigate between errors
nnoremap [d <Plug>(ale_previous_wrap)
nnoremap ]d <Plug>(ale_next_wrap)

" c++ hack fix
let g:ale_cpp_cc_options = '-std=c++20 -Wall -Wextra'

"----------------------------------------------------------------------
" FZF
"----------------------------------------------------------------------

let g:fzf_action = {
    \ 'ctrl-t': 'tab drop',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit',
    \ }
let g:fzf_buffers_jump = 1  " Jump to the existing window if possible

function! GetGitRoot()
    let top_level = systemlist('git rev-parse --show-toplevel')[0]
    return v:shell_error ? '' : top_level
endfunction

function! ListCurrentFiles()
    let top_level = GetGitRoot()
    if empty(top_level)  " this isn't a git repo
        return fzf#vim#files(getcwd())
    else
        return fzf#vim#gitfiles('--recurse-submodules')
    endif
endfunction

function! ListGGrepFiles(pattern, bang)
    let top_level = GetGitRoot()
    if executable('rg')
        if empty(top_level)
            return fzf#vim#grep2('rg --column --line-number --no-heading --color=always --smart-case -- ', a:pattern,
                        \       fzf#vim#with_preview({'dir': getcwd(), 'options': ['--delimiter', '/', '--with-nth', '-2..']}), a:bang)
        else
            return fzf#vim#grep2('rg --column --line-number --no-heading --color=always --smart-case -- ', a:pattern,
                        \       fzf#vim#with_preview({'dir': top_level, 'options': ['--delimiter', '/', '--with-nth', '-2..']}), a:bang)
        endif
    else
        if empty(top_level)
            return fzf#vim#grep2('fgrep -r --line-number --color=always --ignore-case -- ', a:pattern,
                        \       fzf#vim#with_preview({'dir': getcwd(), 'options': ['--delimiter', '/', '--with-nth', '-2..']}), a:bang)
        else
            return fzf#vim#grep2('git grep --column --line-number --color=always --ignore-case -- ', a:pattern,
                        \       fzf#vim#with_preview({'dir': top_level, 'options': ['--delimiter', '/', '--with-nth', '-2..']}), a:bang)
        endif
    endif
endfunction

command! -bang -nargs=? -complete=dir LFiles call ListCurrentFiles()
noremap <C-P> :execute 'LFiles'<cr>

command! -bang -nargs=* FGrep call ListGGrepFiles(<q-args>, <bang>0)
noremap \ :execute 'FGrep<space>'<cr>

command! -bang -nargs=* GGrep call ListGGrepFiles(expand('<cword>'), <bang>0)
noremap \\ :execute 'GGrep<space>'<cr>

"----------------------------------------------------------------------
" Vim Plugin Configuration End
"----------------------------------------------------------------------
