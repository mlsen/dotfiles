set nocompatible

if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif


"""""""""""""""""""""""""""""""""""""""""""""""""
"" General
"""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

" Autoread files if they are changed by another program
set autoread

" UTF-8 standard encoding and UNIX standard file type
set encoding=utf8
set ffs=unix,mac,dos

" Turn on backup
set backup

" Turn on persistent undo
if has('persistent_undo')
    set undofile
    set undodir='~/.vim/undo'
    set undolevels=1000
    set undoreload=10000
endif

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Timeout length after a modifier is pressed
set timeoutlen=1000

let mapleader = ","
let g:mapleader = ","


"""""""""""""""""""""""""""""""""""""""""""""""""
"" User interface stuff
"""""""""""""""""""""""""""""""""""""""""""""""""
set ruler
set nofoldenable
set number
set smartcase
set hlsearch
set so=7
set noshowmode

" New windows are normally put on the left/top.
" These settings change this to right/bottom.
set splitright
set splitbelow

set wildmenu

" Always show status bar
set laststatus=2 
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l


"""""""""""""""""""""""""""""""""""""""""""""""""
"" Text related
"""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Disable spelling correction
set nospell

set autoindent
set smartindent
set wrap "Wrap lines
set nostartofline


"""""""""""""""""""""""""""""""""""""""""""""""""
"" Colors & fonts
"""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set guifont=Menlo\ Regular:h14

if $TERM == 'xterm-256color'
    set t_Co=256
endif

if has('gui_running')
    set lines=999 columns=999
    set guioptions-=T
    set guioptions+=e
    set guitablabel=%M\ %t
endif

set background=dark
colorscheme base16-tomorrow


"""""""""""""""""""""""""""""""""""""""""""""""""
"" Keyboard shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>w :w!<cr>

" Search via space, backwards ctrl+space
map <space> /
map <c-space> ?

" Splitting windows
map <leader>wv <C-W>v
map <leader>wh <C-W>s
map <leader>wc <C-W>c
map <leader>ww <C-W>w

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" EasyMotion Bindings
nmap <leader><leader>s <Plug>(easymotion-s2)
map <leader><leader>j <Plug>(easymotion-j)
map <leader><leader>k <Plug>(easymotion-k)

" Toggle NERDTree
map <leader>n <plug>NERDTreeTabsToggle<cr>

" Tab Completion
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vmap <silent> * :call VisualSelection('f')<CR>
vmap <silent> # :call VisualSelection('b')<CR>

" Toggle CtrlP
nmap <leader>f :CtrlP<cr>

" Fugitive
nmap <leader>gs :Gstatus<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gl :Glog<cr>
nmap <leader>gp :Git push<cr>
nmap <leader>ga :Git add -p %<cr>

" Neosnippet
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"


"""""""""""""""""""""""""""""""""""""""""""""""""
"" Language specific shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""
" Golang
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)


"""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree & NERDTree Tabs
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" Neocomplete
let g:acp_enableAtStartup=0
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_smart_case=1
let g:neocomplete#enable_auto_delimiter=1
let g:neocomplete#max_list=15

" EasyMotion
let g:EasyMotion_smartcase=1

" Something for Neosnippet
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" vim-go
let g:go_snippet_engine="neosnippet"

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Helpers
"""""""""""""""""""""""""""""""""""""""""""""""""
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
