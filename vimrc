set nocompatible

" Vundle =======================================================================
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
"_Bundle 'Lokaltog/vim-easymotion'
" vim-scripts repos
Bundle 'FuzzyFinder'
Bundle 'L9'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'scrooloose/nerdtree'
Bundle 'ScrollColors'
" ...

filetype plugin indent on     " required! 
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ ================================

set encoding=utf-8
set number
set t_Co=256
let python_highlight_all = 1

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set scrolloff=3
syntax on
color torte
set pastetoggle=<F2>
set showtabline=2
set guioptions=em

set autoread
set mouse=a
set wildignore=*.pyc

autocmd FileType python set omnifunc=pythoncomplete#Complete

nmap <leader>ve :tabnew ~/.vimrc<CR>
nmap <leader>vr :w<CR>:source ~/.vimrc<CR>

imap jj <Esc>

map <C-l> <C-W><Right>
map <C-h> <C-W><Left>
map <C-i> <C-W><Up>
map <C-u> <C-W><Down>

map <C-S> <Esc>:w<CR>

nmap ; :
imap <S-Tab> <Esc><<i
nmap <S-Tab> <<

nmap <C-d> <Esc>yypi
nmap <leader>q :q<CR>
nmap <leader>n :NERDTreeToggle %:p:h<CR>
nmap <F10> <Esc>:set wrap!<CR>

set ignorecase
set smartcase
set incsearch

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! Diff call s:DiffWithSaved()     
nmap <leader>df :Diff<CR>

function! s:DiffWithGITCheckedOut()
  let filetype=&ft
  diffthis
  vnew | exe "%!git diff " . expand("#:p:h") . "| patch -p 1 -Rs -o /dev/stdout"
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
  diffthis
endfunction
com! Diffgit call s:DiffWithGITCheckedOut()
nmap <leader>gd :Gdiff<CR><C-h>
nmap <leader>gs :Gstatus<CR>
nmap <leader>dd <Esc>:diffoff<CR>:q<CR>

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
        au! auto_highlight
        augroup! auto_highlight
        setl updatetime=4000
        echo 'Highlight current word: off'
        return 0
    else
        augroup auto_highlight
        au!
        au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
        augroup end
        setl updatetime=500
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction

nmap <C-K> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
nmap <C-J> ddp

set nocursorline

" Autocomplete on Tab ===================================

"function InsertTabWrapper()
"    let col = col('.') - 1
"    if !col || getline('.')[col - 1] !~ '\k'
"        return "\"
"    else
"        return "\<c-p>"
"    endif
"endfunction

imap  <c-r> InsertTabWrapper() 
set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t
