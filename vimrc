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
Bundle 'altercation/vim-colors-solarized'
"Bundle 'kana/vim-submode'
"Bundle 'tpope/vim-surround'
"Bundle 'klen/python-mode'
"Bundle 'msanders/snipmate.vim'
"_Bundle 'Lokaltog/vim-easymotion'
" vim-scripts repos
"Bundle 'FuzzyFinder'
Bundle 'L9'
Bundle 'mayansmoke'
Bundle 'altercation/vim-colors-solarized'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'nvie/vim-flake8'
"Bundle 'Conque-Shell'
" Bundle 'taglist.vim'
Bundle 'compview'
"Bundle 'pylint.vim'
"Bundle 'orenhe/pylint.vim'
Bundle 'nvie/vim-flake8'
Bundle 'anzaika/go.vim'
" ...

let g:ConqueTerm_PyExe='c:\Python27-32\python.exe'
let g:flake8_ignore="E501,E123,E124,E126,E127,E128"
" 501: line too long
" 261: two spaces before inline comment
" 201: extraneous whitespace around ([{,;:
" 202: same
" 251: whitespace around named parameter equals

" переход к следующему косяку в quickfix
map <C-n> <C-j>j<CR>

set makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
set errorformat=%f:%l:\ %m

" для flake8
let g:flake8_ignore="E501,E1123,E124,E126,E127,E128"
let g:flake8_cmd="flake8"
" E501 line too long
" E261 two spaces before inline comment
" E201, E202 extraneous whitespace around [({
" переход к следующему косяку в quickfix
map <C-n> <C-j>j<CR>

" \f - поиск с выводом списка вариантов, с перемещением по нему
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
" статус-бар всегда виден:
set laststatus=2
" строка ярлычков вкладок всегда видна:
set showtabline=2

set guifont="Ubuntu Mono 10"
set guioptions=*

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
" скроллить буфер, когда курсор подходит к верху/низу окна на scrolloff строк
set scrolloff=3
syntax on
"color torte
"color zenburn
"color mayansmoke
set background=dark
let g:solarized_termcolors=16
"color solarized
color wombat256
" режим вставки из буфера ОС, не портящий отступы
set pastetoggle=<F2>

"" highlight trailing spaces
au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)

" что-то касающееся элементов управления GVim
set guioptions=em

" автообновление измененных на диске файлов
set autoread
" редактор реагирует на мышь
set mouse=a
set wildignore=*.pyc,*.aux

" командой find можно искать и открывать файл в подкаталогах
set path=.,,**

autocmd FileType python set omnifunc=pythoncomplete#Complete

" редактирование и перезагрузка vimrc
nmap <leader>ve :tabnew ~/.vimrc<CR>
nmap <leader>vr :w<CR>:source ~/.vimrc<CR>

" быстрый выход из режима вставки (не надо тянуться к Esc)
" заодно повесим на это действие сохранение
imap jk <Esc>:w<CR>

" сокращения для открытия новой вкладки
cnoreabbrev nt tabnew
cnoreabbrev tn tabnew

" перемещение по словам в режиме вставки
imap <C-l> <C-Right>
imap <C-h> <C-Left>

" чуть более удобный переход к предыдущей вкладке
" (к следующей - gt)
nmap gr gT

" создаем шаблон для замены из слова под курсором
nmap <C-m> :%s/\<<C-r>=expand("<cword>")<cr>\>//g<left><left>

" более удобная кнопка запуска макросов, раскорячиваться для Shitf-2 ужасно
" (убивает какую-то не пригодившуюся мне функциональность кнопки z)
nnoremap z @
nnoremap zz @@

" быстрая версия команд перемещения между сплитами
map <C-l> <C-W><Right>
map <C-h> <C-W><Left>
map <C-k> <C-W><Up>
map <C-j> <C-W><Down>

" \s делает source текущего файла
nmap <leader>s <Esc>:source %<CR>
" \w сохраняет текущий файл
nmap <leader>w <Esc>:w<CR>

" подсвечивает все вхождения слова под курсором
nmap <C-f> :set hlsearch<CR>*#

" не надо зажимать Shift, чтобы перейти в командную строку
"nmap ; :

" изменение отступов строк как в казуальных редакторах
imap <S-Tab> <Esc><<i
nmap <S-Tab> <<
nmap <Tab> >>

" перемещение в начало и конец строки одной клавишей
nnoremap 0 <S-$>
nnoremap 9 <S-^>

" дублирование строки
nmap <C-d> <Esc>yyp
" закрытие окна
nmap <leader>q :q<CR>
" открытие файлового браузера
nmap <leader>n :NERDTreeToggle %:p:h<CR>

" переключение автопереносов строк
nmap <F10> <Esc>:set wrap!<CR>
" переключение нумерации
nmap <F11> <Esc>:set number!<CR>

" открытие терминала
nmap <leader>bt :ConqueTermTab bash<CR>
nmap <leader>bs :ConqueTermSplit bash<CR>
nmap <leader>bv :ConqueTermVSplit bash<CR>

" поиск не учитывает регистр...
set ignorecase
" ...если только в поисковом паттерне нет букв в верхнем регистре
set smartcase
" поиск по мере ввода
set incsearch

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

" кнопка для переключения мышиного режима
" (два состояния:
"    - в одном включены номера строк, и Vim понимает мышиное выделение,
"      но не дает копировать текст в буфер ОС через выделение эмулятора
"      терминала,
"    - в другом Vim не обрабатывает мышь, и можно копировать через эмулятор
"      терминала (при этом номера строк отключаются и не мешаются)
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

" выделение строки, на которой находится курсор, не нужно 
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
set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t

" шикарная фича: вставка с заменой текстового объекта
"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction



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
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х }
map Ъ {
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >
map Ё ~
lnoremap jk ол
lnoremap as <Esc>:w<CR>
lnoremap ;' <Esc>:w<CR>
"inoremap <C-[> 
"inoremap <C-]> 
inoremap <C-\> 

" insert latex command
nmap <leader>l :set opfunc=InsertLatex<CR>g@
function! InsertLatex(type, ...)
    silent exe "normal! `[mu`]mi"
    silent exe "normal! `ui\\{"
    silent exe "normal! `ila}"
    silent exe "normal `ul"
    silent exe "startinsert"
endfunction

" snippets
"ino <c-j> <c-r>=TriggerSnippet()<cr>
"snor <c-j> <esc>i<right><c-r>=TriggerSnippet()<cr>



map <leader>CC :colorscheme wombat256<CR>
