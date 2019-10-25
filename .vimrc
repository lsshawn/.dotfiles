set nocompatible
filetype plugin on
syntax on

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'junegunn/goyo.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'reedes/vim-pencil'
Plug 'tpope/vim-surround'
Plug 'pondrejk/vim-readability'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/limelight.vim'
Plug 'chrisbra/csv.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

let mapleader = "\<Space>"

let g:vim_markdown_folding_disabled = 1

if strftime("%H") > 19
  colo seoul256
else
  colo seoul256-light
endif

set tabstop=4
set shiftwidth=4

autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Relative in normal mode, absolute in insert mode.
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

nnoremap Y y$
nnoremap <leader>rv :source $MYVIMRC<CR>
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
" Insert blank line above  
inoremap <C-k> <Esc>O<Esc>jA
" Navigate new tabs
nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>
inoremap jj <Esc>
cnoremap jj <Esc>
