scriptencoding utf-8
source ~/.config/nvim/plugins.vim

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Remap leader key to ,
let g:mapleader=','

" Disable line numbers
set nonumber

" Don't show last command
set noshowcmd

" Yank and paste with the system clipboard
set clipboard=unnamed

" Hides buffers instead of closing them
set hidden

" === TAB/Space settings === "
" Insert spaces when TAB is pressed.
set expandtab

" Change number of spaces that a <Tab> counts for during editing ops
set softtabstop=2

" Indentation amount for < and > commands.
set shiftwidth=2

" do not wrap long lines by default
set nowrap

" Don't highlight current kkcursor line
set nocursorline

" Disable line/column number in status line
" Shows up in preview window when airline is disabled if not
set noruler

" Only one line for command line
set cmdheight=1

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300



" === Completion Settings === "

" Don't give completion messages like 'match 1 of 2'
" or 'The only match'
set shortmess+=f

" Relative in normal mode, absolute in insert mode.
set number relativenumber
  
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END 

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" Wrap in try/catch to avoid errors on initial install before plugin is available
try
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Open file commands
call denite#custom#map('insert,normal', "<C-t>", '<denite:do_action:tabopen>')
call denite#custom#map('insert,normal', "<C-v>", '<denite:do_action:vsplit>')
call denite#custom#map('insert,normal', "<C-h>", '<denite:do_action:split>')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ:',
\ 'statusline': 0,
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry

" === Coc.nvim === "

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" === NeoSnippet === "

" Map <C-k> as shortcut to activate snippet if available
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" Load custom snippets from snippets folder
let g:neosnippet#snippets_directory='~/.config/nvim/snippets'

" Hide conceal markers
let g:neosnippet#enable_conceal_markers = 0

" SuperTab like snippets behavior.
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" === NERDTree === "
" Show hidden files/directories
let g:NERDTreeShowHidden = 1

" Remove bookmarks and help text from NERDTree
let g:NERDTreeMinimalUI = 1

" Custom icons for expandable/expanded directories
let g:NERDTreeDirArrowExpandable = '⬏'
let g:NERDTreeDirArrowCollapsible = '⬎'

" Hide certain files and directories from NERDTree
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']

" Wrap in try/catch to avoid errors on initial install before plugin is available
try

" === Vim airline === "

" Enable extensions
let g:airline_extensions = ['branch', 'hunks', 'coc']

" Update section z to just have line number
let g:airline_section_z = airline#section#create(['linenr'])

" Do not draw separators for empty sections (only for the active window) >
let g:airline_skip_empty_sections = 1

" Smartly uniquify buffers names with similar filename, suppressing common parts of paths.
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Custom setup that removes filetype/whitespace from default vim airline bar
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]

let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'

let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

" Configure error/warning section to use coc.nvim
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Hide the Nerdtree status line to avoid clutter
let g:NERDTreeStatusline = ''

" Disable vim-airline in preview mode
let g:airline_exclude_preview = 1

" Enable powerline fonts
let g:airline_powerline_fonts = 1

" Enable caching of syntax highlighting groups
let g:airline_highlighting_cache = 1

" Define custom airline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Don't show git changes to current file in airline
let g:airline#extensions#hunks#enabled=0

catch
  echo 'Airline not installed. It should work after running :PlugInstall'
endtry

" === echodoc === "

" Enable echodoc on startup
let g:echodoc#enable_at_startup = 1

" === vim-javascript === "
" Enable syntax highlighting for JSDoc
let g:javascript_plugin_jsdoc = 1

" === vim-jsx === "
" Highlight jsx syntax even in non .jsx files
let g:jsx_ext_required = 0

" === javascript-libraries-syntax === "
let g:used_javascript_libs = 'underscore,requirejs,chai,jquery'

" === Signify === "
let g:signify_sign_delete = '-'

" === vim-slime === "

" always use tmux
let g:slime_target = 'tmux'

" fix paste issues in ipython
let g:slime_python_ipython = 1

" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1

" === vim-ipython-cell === "

" Use '##' to define cells instead of using marks
let g:ipython_cell_delimit_cells_by = 'tags'


" ============================================================================ "
" ===                                UI                                    === "
" ============================================================================ "

" Enable true color support
set termguicolors

set background=dark
colorscheme gruvbox

" Editor theme
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'hard'

" Vim airline theme
let g:airline_theme='gruvbox'

" Add custom highlights in method that is executed every time a colorscheme is sourced
" See https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f for details
" function! MyHighlights() abort
  " " Hightlight trailing whitespace
  " highlight Trail ctermbg=red guibg=red
  " call matchadd('Trail', '\s\+$', 100)
" endfunction

" augroup MyColors
  " autocmd!
  " autocmd ColorScheme * call MyHighlights()
" augroup END

" Change vertical split character to be a space (essentially hide it)
set fillchars+=vert:.

" Set preview window to appear at bottom
set splitbelow

" Don't dispay mode in command line (airilne already shows it)
set noshowmode

" Set floating window to be slightly transparent
set winbl=10

" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type

" Make background transparent for many things
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
hi! LineNr ctermfg=NONE guibg=NONE
hi! SignColumn ctermfg=NONE guibg=NONE
hi! StatusLine guifg=#16252b guibg=#6699CC
hi! StatusLineNC guifg=#16252b guibg=#16252b

" Try to hide vertical spit and end of buffer symbol
hi! VertSplit gui=NONE guifg=#17252c guibg=#17252c
hi! EndOfBuffer ctermbg=NONE ctermfg=NONE guibg=#17252c guifg=#17252c

" Customize NERDTree directory
hi! NERDTreeCWD guifg=#99c794

" Make background color transparent for git changes
hi! SignifySignAdd guibg=NONE
hi! SignifySignDelete guibg=NONE
hi! SignifySignChange guibg=NONE

" Highlight git change signs
hi! SignifySignAdd guifg=#99c794
hi! SignifySignDelete guifg=#ec5f67
hi! SignifySignChange guifg=#c594c5

" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Change highlight group of preview window when open
function! Handle_Win_Enter()
  if &previewwindow
    setlocal winhighlight=Normal:MarkdownError
  endif
endfunction

" === vim-ledger === "
" number of columns to fold text
let g:ledger_maxwidth = 80

" string between account name and amount
let g:ledger_fillstring = '    -'

" account completion by depth
let g:ledger_detailed_first = 1

" run :LedgerSort to order and format new transactions
" from https://justyn.io/blog/automatically-sort-and-align-ledger-transactions-in-vim/
au BufNewFile,BufRead *.ldg,*.ledger setf ledger | comp ledger
let g:ledger_maxwidth = 120
let g:ledger_fold_blanks = 1
function LedgerSort()
    :%! ledger -f - print --sort 'date, amount'
    :%LedgerAlign
endfunction
command LedgerSort call LedgerSort()

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" === Preview Markdown === "
nmap <C-p> <Plug>MarkdownPreviewToggle

" === Search & replace word under cursor === "
:nnoremap <Leader>S :%s/\<<C-r><C-w>\>//g<Left><Left>


" === Show matched strings at the center of the screen === "
nnoremap n nzz
nnoremap N Nzz

" === Denite shorcuts === "
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
nmap ; :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
imap <silent><buffer> <C-o>
\ <Plug>(denite_filter_quit)
inoremap <silent><buffer><expr> <Esc>
\ denite#do_map('quit')
nnoremap <silent><buffer><expr> <Esc>
\ denite#do_map('quit')
inoremap <silent><buffer><expr> <CR>
\ denite#do_map('do_action')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
nnoremap <silent><buffer><expr> <CR>
\ denite#do_map('do_action')
nnoremap <silent><buffer><expr> q
\ denite#do_map('quit')
nnoremap <silent><buffer><expr> <Esc>
\ denite#do_map('quit')
nnoremap <silent><buffer><expr> d
\ denite#do_map('do_action', 'delete')
nnoremap <silent><buffer><expr> p
\ denite#do_map('do_action', 'preview')
nnoremap <silent><buffer><expr> i
\ denite#do_map('open_filter_buffer')
nnoremap <silent><buffer><expr> <C-o>
\ denite#do_map('open_filter_buffer')
endfunction

" === Nerdtree shorcuts === "
"  <leader>n - Toggle NERDTree on/off
"  <leader>f - Opens current file location in NERDTree
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

" === vim-better-whitespace === "
"   <leader>y - Automatically remove trailing whitespace
nmap <leader>y :StripWhitespace<CR>

" === Search shorcuts === "
"   <leader>/ - Claer highlighted search terms while preserving history
nmap <silent> <leader>/ :nohlsearch<CR>

" === Easy-motion shortcuts ==="
"   <leader>w - Easy-motion highlights first word letters bi-directionally
map <leader>w <Plug>(easymotion-bd-w)
nmap <space> <Plug>(easymotion-bd-w)

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %

" === vim-jsdoc shortcuts ==="
" Generate jsdoc for function under cursor
nmap <leader>z :JsDoc<CR>

" Delete current visual selection and dump in black hole buffer before pasting
" Used when you want to paste over something without it getting copied to
" Vim's default buffer
vnoremap <leader>p "_dP

nnoremap <leader>rv :source $NVIMINIT<CR>
nnoremap <leader>ev :tabnew $NVIMINIT<CR>

" Ctrl / to toggle comment (VScode shortcut)
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv
let g:NERDSpaceDelims = 1

set clipboard=unnamedplus

" Tabbing
nmap <S-Tab> :tabprev<Return>
nmap <Tab> :tabnext<Return>
nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>
inoremap jj <Esc>
cnoremap jj <Esc>

"""""""""""""""""""""""""""""""""
" ===       Python          === "
"""""""""""""""""""""""""""""""""

" vim-ipython-cell

" map <Leader>r to run script
autocmd FileType python nnoremap <buffer> <Leader>i :IPythonCellRun<CR>

" map <Leader>R to run script and time the execution
autocmd FileType python nnoremap <buffer> <Leader>I :IPythonCellRunTime<CR>

" map <Leader>c to execute the current cell
autocmd FileType python nnoremap <buffer> <Leader>c :IPythonCellExecuteCell<CR>

" map <Leader>C to execute the current cell and jump to the next cell
autocmd FileType python nnoremap <buffer> <Leader>C :IPythonCellExecuteCellJump<CR>

" map <Leader>l to clear IPython screen
autocmd FileType python nnoremap <buffer> <Leader>l :IPythonCellClear<CR>

" map <Leader>x to close all Matplotlib figure windows
autocmd FileType python nnoremap <buffer> <Leader>x :IPythonCellClose<CR>

" map [c and ]c to jump to the previous and next cell header
autocmd FileType python nnoremap <buffer> [c :IPythonCellPrevCell<CR>
autocmd FileType python nnoremap <buffer> ]c :IPythonCellNextCell<CR>

" map <Leader>h to send the current line or current selection to IPython
let g:slime_no_mappings = 1
autocmd FileType python nnoremap <buffer> <Leader>h <Plug>SlimeSendCurrentLine
autocmd FileType python xnoremap <buffer> <Leader>h <Plug>SlimeRegionSend

" TODO: look at this git for sample of bindings but in PyShell https://github.com/greghor/vimux-ds-workflow/blob/master/src/.vimrc

" ============================================================================ "
" ===                                 MISC.                                === "
" ============================================================================ "

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" === Search === "
" ignore case when searching
set ignorecase

" if the search string has an upper case letter in it, the search will be case sensitive
set smartcase

" Automatically re-read file if a change was detected outside of vim
set autoread

" Enable line numbers
set number

" Set backups
if has('persistent_undo')
  set undofile
  set undolevels=3000
  set undoreload=10000
endif
set backupdir=~/.local/share/nvim/backup " Don't put backups in current dir
set backup
set noswapfile

" Reload icons after init source
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" ================ "
" === Markdown === "
" ================ "

autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

let g:vim_markdown_folding_disabled = 1

" ========================== "
" === javascript folding === "
" ========================== "

" set foldmethod=syntax "syntax highlighting items specify folds
set foldmethod=indent
" set foldcolumn=1 "defines 1 col at window left, to indicate folding
let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=99 "start file with all folds opened:


" ========================= "
" === Turbo Console Log === "
" ========================= "

function! TurboLog() abort
  let l:word = expand('<cword>')
  " TODO: use regex to find function name. 2 possible ways:
  " 1. const funcName = () => {
  " 2. function funcName() {
  let l:funcName = getline(search('\v^[[:alpha:]$_]', "bn", 1, 100))
  let l:str = "console.log(\"TCL: "
  let l:str = l:str . l:funcName . ' -> ' . l:word . ' ", ' . l:word
  let l:str = l:str . ")"

  call append('.', l:str)
endfunction

nnoremap <silent> <buffer> <leader>cl :call TurboLog()<CR>

" delete TCL logs
nnoremap <leader>dcl :g/console.log("TCL:/d<CR>
" comment TCL logs
nnoremap <leader>ccl :g/console.log("TCL:/norm I// <CR>
" uncomment TCL logs
nnoremap <leader>ucl :g/console.log("TCL:/s@^\s*// @@<CR>

" ===================================== "
" === Save/Load views automatically === "
" ===================================== "
" https://vim.fandom.com/wiki/Make_views_automatic
augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* silent! loadview
    " autocmd BufWinLeave ?* mkview | filetype detect
    " autocmd BufWinEnter ?* silent! loadview | filetype detect
augroup END

" ======================= "
" === Persistent undo === "
" ======================= "

set undodir=~/.config/nvim/undodir
