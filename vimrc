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
"Bundle 'kana/vim-submode'
Bundle 'tpope/vim-surround'
"_Bundle 'Lokaltog/vim-easymotion'
" vim-scripts repos
Bundle 'FuzzyFinder'
Bundle 'L9'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Conque-Shell'
" Bundle 'taglist.vim'
Bundle 'compview'
" ...
let g:ConqueTerm_PyExe='c:\Python27-32\python.exe'

let Tlist_Ctags_Cmd = "c:\bin\ctags.exe"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>

map <leader>f <Plug>CompView

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
set statusline=%<%f\ [%Y%R%W]%1*%{(&modified)?'\ +\ ':''}%*\ encoding\:\ %{&fileencoding}%=%c%V,%l\ %P\ [%n]
set laststatus=2

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set scrolloff=3
syntax on
"color torte
"color zenburn
color wombat256
set pastetoggle=<F2>
set showtabline=2
set guioptions=em

set autoread
set mouse=a
set wildignore=*.pyc

set path=.,,**

autocmd FileType python set omnifunc=pythoncomplete#Complete

nmap <leader>ve :tabnew ~/.vimrc<CR>
nmap <leader>vr :w<CR>:source ~/.vimrc<CR>

imap jj <Esc>
imap jk <Esc>:w<CR>

cnoreabbrev nt tabnew
cnoreabbrev tn tabnew
imap <C-l> <C-Right>
imap <C-h> <C-Left>

nmap gr gT

nmap <C-s> :%s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>

nnoremap z @
nnoremap zz @@

cnoreabbrev nt tabnew
cnoreabbrev tn tabnew

map <C-l> <C-W><Right>
map <C-h> <C-W><Left>
map <C-k> <C-W><Up>
map <C-j> <C-W><Down>

nmap <leader>s <Esc>:source %<CR>
nmap <leader>w <Esc>:w<CR>

nmap <C-f> :set hlsearch<CR>*#

nmap ; :
imap <S-Tab> <Esc><<i
nmap <S-Tab> <<
nmap <Tab> >>
nnoremap - <S-$>
nnoremap 0 <S-^>
nnoremap 9 <Home>

nmap <C-d> <Esc>yyp
nmap <leader>q :q<CR>
nmap <leader>n :NERDTreeToggle %:p:h<CR>
nmap <F10> <Esc>:set wrap!<CR>
nmap <F11> <Esc>:set number!<CR>
nmap <leader>bt :ConqueTermTab bash<CR>
nmap <leader>bs :ConqueTermSplit bash<CR>
nmap <leader>bv :ConqueTermVSplit bash<CR>

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


"nnoremap <C-i> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
"nnoremap <C-u> ddp

function! MouseAndNumbersToggle()
    if &mouse == ""
        let &mouse = "a"
        set number
        echo "mouse enabled"
    else
        let &mouse = ""
        set nonumber
        echo "mouse disabled"
    endif
endfunction

nnoremap <F12> :call MouseAndNumbersToggle()<CR>

set nocursorline

" Autocomplete on Tab ===================================
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
"
"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction


set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t

" переключение раскладки по Ctrl-6
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

" питоновские фишки
function! PyTest(num)
python << EOF
import vim
i = 0
num = vim.eval("a:num")
num = int(num)
l0 = vim.current.buffer.mark('<')[0]-1
l1 = vim.current.buffer.mark('>')[0]-1
for i in xrange(l0, l1+1):
    vim.current.buffer[i] = vim.current.buffer[i].replace('\\n', str(num))
    num += 1
EOF
endfunction

" мега-функция: ==============================================================
" берет содержимое текущего буфера,
" оборачивает во вспомогательный питоновский код
" и делает доступным по \p
function! Pythonize()
python << EOF
import vim
import tempfile
import os

tmpfn = os.path.join(tempfile.gettempdir(), 'vimpy1.py')
with open(tmpfn, 'w') as f:
    print >>f, """
function! PyTemp1(...)
python << EOF
import vim
args = []

for i in xrange(0, int(vim.eval('a:0'))):
    args.append(vim.eval('a:%d' % (i+1)))

class LinesIter(object):
    def __init__(self, lines):
        self.lines = lines
        self.i = lines.l0

    def __iter__(self):
        return self

    def next(self):
        if self.i > lines.l1:
            raise StopIteration
        self.i += 1
        return self.i-1, self.lines[self.i-1]

class Lines(object):
    def __init__(self):
        self.l0 = vim.current.buffer.mark('<')[0]-1
        self.l1 = vim.current.buffer.mark('>')[0]-1

    def __iter__(self):
        return LinesIter(self)

    def __setitem__(self, i, val):
        vim.current.buffer[i] = val
    def __getitem__(self, i):
        return vim.current.buffer[i]

lines = Lines()"""
    for line in vim.current.buffer[:]:
        print >>f, line

    print >>f, """EOF""" + """
endfunction
"""
vim.command(":source " + tmpfn)
vim.command(r":nmap \p :call PyTemp1()<CR>")
vim.command(r":nmap \P :call PyTemp1()<left>")
vim.command(":vmap \\p :\b\b\b\b\bcall PyTemp1()<CR>")
vim.command(":vmap \\P :\b\b\b\b\bcall PyTemp1()<Left>")
EOF
endfunction

nmap <leader>y :call Pythonize()<CR>
" конец питоновских фишек ==================================================

" Key mapping for Russian QWERTY keyboard in UTF-8
"map й q
"map ц w
"map у e
"map к r
"map е t
"map н y
"map г u
"map ш i
"map щ o
"map з p
"map х [
"map ъ ]
"map ф a
"map ы s
"map в d
"map а f
"map п g
"map р h
"map о j
"map л k
"map д l
"map ж ;
"map э '
"map я z
"map ч x
"map с c
"map м v
"map и b
"map т n
"map ь m
"map б ,
"map ю .
"map Й Q
"map Ц W
"map У E
"map К R
"map Е T
"map Н Y
"map Г U
"map Ш I
"map Щ O
"map З P
"map Х }
"map Ъ {
"map Ф A
"map Ы S
"map В D
"map А F
"map П G
"map Р H
"map О J
"map Л K
"map Д L
"map Ж :
"map Э "
"map Я Z
"map Ч X
"map С C
"map М V
"map И B
"map Т N
"map Ь M
"map Б <
"map Ю >
"map Ё ~
