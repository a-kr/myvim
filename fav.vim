"
" Fav: vim plugin which facilitates switching between lots of windows/tabs.
"
" Vimrc:
"   nnoremap H :call Fav('normal')<CR>
"   nnoremap mm :call FavNextMark()<CR>
"   nnoremap MM :call FavNextMarkDisplay()<CR>
"
" Usage:
"
"   Shift-H:      code explorer (functions, classes) for current window
"   Shift-H, A:   code explorer for all opened windows
"   Shift-H, s:   SQL statements in current window
"   Shift-H, S:   SQL statements in all opened windows
"   Shift-H, M:   mark explorer: shows marks in all/current opened windows
"                 (apostrophe ' toggles all/current)
"   Shift-H, mm:  jump to next mark among all opened windows
"   mm:           same, without opening mark explorer
"
"
python << EOF
import re

FAV_SETTINGS = {
    'more_context': False,
    'only_user_marks': True,
    'last_fav_fill_args': ['old', 'all'],
}

USER_MARK_NAMES = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
MARK_NAMES = USER_MARK_NAMES + '."\''

def enum_visible_windows():
    visited_names = set()
    result = []
    for tabi, tab in enumerate(vim.tabpages):
        for wini, win in enumerate(tab.windows):
            if win.buffer.name not in visited_names:
                visited_names.add(win.buffer.name)
                result.append((tab, win, win.buffer))
    return result


def switch_to_window(filename):
    for tab, win, buf in enum_visible_windows():
        if buf.name == filename:
            vim.current.tabpage = tab
            vim.current.window = win
            break

def find_marks(buf, only_user_marks=False):
    mark_names = MARK_NAMES
    if only_user_marks:
        mark_names = USER_MARK_NAMES
    marked = {}
    for ch in mark_names:
        m = buf.mark(ch)
        if m is not None:
            marked[m[0]] = ch
    return marked


def call_fav_fill_again():
    args = ', '.join('"%s"' % s for s in FAV_SETTINGS['last_fav_fill_args'])
    cmd = "call FavFill(" + args + ")"
    vim.command(cmd)

def set_syntax(old_filetype, use_own):
    if use_own:
        vim.command('set filetype=')
        vim.command("syn match myvimFavNumber /^\d\d*/")
        vim.command("hi def link myvimFavNumber Number")
        vim.command("syn match myvimFavFilename /^>.*$/")
        vim.command("hi def link myvimFavFilename Keyword")
        vim.command("syn match myvimFavMarkMark /^\[[^\]*]\]$/")
        vim.command("hi def link myvimFavMarkMark String")
        #vim.command("syn keyword myvimFavTodo TODO FIXME WTF XXX")
        #vim.command("hi def link myvimFavTodo TODO")
        vim.command("syn match myvimFavComment /^#.*$/")
        vim.command("hi def link myvimFavComment Comment")
    else:
        vim.command('set filetype=%s' % old_filetype)


def get_selected_file_and_line():
    """
        return (window, line_no, extra)
    """
    newbuf = vim.current.buffer
    line = vim.current.line
    cur_i = vim.current.window.cursor[0] - 1

    prevfile_name = None
    while cur_i >= 0:
        if newbuf[cur_i].startswith('>'):
            prevfile_name = newbuf[cur_i][1:]
            if ':' in prevfile_name:
                prevfile_name = prevfile_name.split(':')[0]
            break
        cur_i -= 1

    line_no = None
    if not line.startswith('>'):
        ns = re.findall('^(\d+):', line)
        if ns:
            line_no = int(ns[0])

    extra = re.findall('\[([^\]]+)\]', line)
    if extra:
        extra = extra[0]
    else:
        extra = None

    if prevfile_name:
        for tab, win, buf in enum_visible_windows():
            if buf.name == prevfile_name:
                return (win, line_no, extra)
    return (None, line_no, extra)



def go_to_next_user_mark():
    win = vim.current.window
    cur_fname = win.buffer.name
    cur_line = win.cursor[0]
    cur_mark = (cur_fname, cur_line)

    marks = []  # of (file, line)
    for tab, win, buf in enum_visible_windows():
        if not buf.name:
            continue
        marked = find_marks(buf, only_user_marks=True)
        buf_marks = [(buf.name, i) for i in marked]
        if buf.name == cur_fname and cur_mark not in buf_marks:
            buf_marks.append(cur_mark)
        buf_marks.sort()
        marks.extend(buf_marks)

    i = marks.index(cur_mark)
    if i < 0:
        i = 0
    else:
        i = (i + 1) % len(marks)
    fname, lineno = marks[i]
    #print 'index is', i, 'fname', fname, 'lineno', lineno
    if fname != win.buffer.name:
        switch_to_window(fname)
    vim.current.window.cursor = (lineno, 0)
EOF

function! Fav(favmode)
python << EOF
import vim
oldbuf = vim.current.buffer
oldwin = vim.current.window

favmode = vim.eval('a:favmode')

old_filetype = vim.eval('&filetype')

vim.command('vnew')
newbuf = vim.current.buffer
vim.command('setlocal buftype=nofile')
vim.command('setlocal modifiable')
vim.command('setlocal nowrap')

newbuf.append('>%s:%s' % (oldbuf.name, oldwin.cursor[0]))
del newbuf[0]

if favmode == 'again':
    call_fav_fill_again()
elif favmode == 'allmarks':
    vim.command('call FavFill("all", "M")')
else:
    vim.command('call FavFill("old", "all")')

vim.command('setlocal nomodifiable')
vim.command('nnoremap <buffer> <CR> :call FavGoto()<CR>')
vim.command('nnoremap <buffer> <C-C> :q<CR>')
vim.command('nnoremap <buffer> <nowait> q :q<CR>')
vim.command('nnoremap <buffer> <nowait> T :call FavFill("all", "T")<CR>')
vim.command('nnoremap <buffer> <nowait> t :call FavFill("old", "T")<CR>')
vim.command('nnoremap <buffer> <nowait> H :call FavFill("old", "all")<CR>')
vim.command('nnoremap <buffer> <nowait> a :call FavFill("old", "all")<CR>')
vim.command('nnoremap <buffer> <nowait> A :call FavFill("all", "all")<CR>')
vim.command('nnoremap <buffer> <nowait> s :call FavFill("old", "Q")<CR>')
vim.command('nnoremap <buffer> <nowait> S :call FavFill("all", "Q")<CR>')
vim.command('nnoremap <buffer> <nowait> M :call FavFill("inv", "M")<CR>')
vim.command('nnoremap <buffer> <nowait> mm :call FavNextMarkDisplay()<CR>')
vim.command('nnoremap <buffer> <nowait> d :call FavDeleteMark()<CR>')
vim.command('nnoremap <buffer> <nowait> L :call FavFill("all", "L")<CR>')
vim.command('nnoremap <buffer> <nowait> c :call FavSetting("more_context")<CR>')
vim.command('nnoremap <buffer> <nowait> C :call FavSetting("more_context")<CR>')
vim.command('nnoremap <buffer> <nowait> \' :call FavSetting("only_user_marks")<CR>')
for i in xrange(1, 10):
    vim.command('nnoremap <buffer> <nowait> %s /%s' % (i, i))

if favmode == 'normal':
    set_syntax(old_filetype, False)

EOF
endfunction

function! FavFill(buffer_selector, line_kind)
python << EOF
import vim

buffer_selector = vim.eval('a:buffer_selector')
line_kind = vim.eval('a:line_kind')

if buffer_selector == 'inv':
    buffer_selector = {
        'old': 'all',
        'all': 'old',
    }[FAV_SETTINGS['last_fav_fill_args'][0]]

FAV_SETTINGS['last_fav_fill_args'] = [buffer_selector, line_kind]

newbuf = vim.current.buffer
oldfile_name = None
oldfile_line = None

more_context = FAV_SETTINGS['more_context']
if line_kind in ('Q', 'M'):
    more_context = not more_context

if len(newbuf) > 0:
    if newbuf[0].startswith('>'):
        oldfile_name = newbuf[0][1:]
        if ':' in oldfile_name:
            oldfile_name, oldfile_line = oldfile_name.split(':', 1)
            try:
                oldfile_line = int(oldfile_line)
            except:
                oldfile_line = None

def clean_line(line):
    # ensure multiline comments are closed
    manyspaces = ' ' * oldwin.width
    if '/*' in line: line += manyspaces + '*/'
    if '"""' in line: line = line.replace('"""', '"')
    if "'''" in line: line = line.replace("'''", "'")
    ticks = [c for c in line if c == '`']
    if len(ticks) % 2 == 1:
        line += manyspaces + '`'
    return line

def scan_single_buf(buf, buf_curr_line):
    default_kinds = ['C', 'T', 'M']
    kinds_to_seek = default_kinds if line_kind == 'all' else [line_kind]
    items = []

    marked = {}
    if 'M' in kinds_to_seek:
        if not FAV_SETTINGS['only_user_marks']:
            marked[buf_curr_line] = '_'
        marked.update(find_marks(buf, only_user_marks=FAV_SETTINGS['only_user_marks']))

    for i, line in enumerate(buf):
        i += 1
        line0 = line.lstrip()
        do = False
        kind = ''
        if line_kind == 'L':
            do = True; kind = 'L'
        if line0.startswith('type ') or line0.startswith('func') or line0.startswith('def ') or line0.startswith('class '):
            do = True; kind = 'C'
        if 'XXX' in line0 or 'TODO' in line0 or 'FIXME' in line0 or 'WTF' in line0:
            do = True; kind = 'T'
        if 'SELECT' in line0 or 'INSERT' in line0 or 'UPDATE' in line0 or 'DELETE' in line0 or 'CREATE' in line0 or 'ALTER' in line0 or 'DROP' in line0:
            do = True; kind = 'Q'
        if not FAV_SETTINGS['only_user_marks']:
            if buf.name == oldfile_name and i == oldfile_line:
                do = True; kind = 'M'
            if i == buf_curr_line:
                do = True; kind = 'M'
        if i in marked:
            do = True; kind = 'M'
        line = clean_line(line)
        p = pl = ''
        if line_kind == 'M':
            p = p1 = '    '
            if i in marked:
                pl = '[%s] ' % marked[i]
        if do and kind in kinds_to_seek:
            if more_context and i > 1:
                items.append((i - 1, p + clean_line(buf[i-2])))
            items.append((i, pl + line))
            if more_context and i < len(buf) - 1:
                items.append((i + 1, p + clean_line(buf[i])))
        if line_kind == 'L':
            break

    max_lineno_size = 1
    for (i, _) in items:
        s = '%d: ' % i
        max_lineno_size = max(max_lineno_size, len(s))

    if not items:
        return
    if len(newbuf) > 3 and line_kind not in ('L'):
        newbuf.append('')
    newbuf.append('>' + buf.name)
    if line_kind == 'L':
        return

    printed_lines = set()
    last_nearby_line = None
    for ii, (i, line) in enumerate(items):
        if i in printed_lines:
            continue
        printed_lines.add(i)
        ln = '%-{}s'.format(max_lineno_size) % ('%d:' % i)
        newbuf.append(ln + line)
        if buf.name == oldfile_name and ((i <= oldfile_line) or (last_nearby_line is None)):
            last_nearby_line = len(newbuf)

    if last_nearby_line is not None:
        vim.current.window.cursor = (last_nearby_line, 0)
vim.command('setlocal modifiable')
newbuf[:] = None
if oldfile_name:
    newbuf.append('>%s:%s' % (oldfile_name, oldfile_line or 1))

for tab, win, buf in enum_visible_windows():
    if not buf.name:
        continue
    if buffer_selector == 'all' or (buffer_selector == 'old' and buf.name == oldfile_name):
        cur_i = win.cursor[0]
        scan_single_buf(buf, cur_i)
del newbuf[0]

if line_kind == 'M':
    newbuf.append('')
    newbuf.append('# Press d to delete mark; press mm to switch to next mark.')


vim.command('setlocal nomodifiable')
set_syntax('', True)
print "t/T (todos in single/all files); M (marks); mm (next mark); s/S (SQL queries); a/A (all items); L (list windows); c (context 1/3); ' (only user marks)"
EOF
endfunction

function! FavGoto()
python << EOF
import vim, re

target_win, target_line, extra = get_selected_file_and_line()
vim.command('q')
if target_win:
    if target_win.buffer.name != vim.current.buffer.name:
        switch_to_window(target_win.buffer.name)
    if target_line is not None:
        vim.current.window.cursor = (target_line, 0)

print ''

EOF
endfunction

function! FavDeleteMark()
python << EOF
target_win, target_line, extra = get_selected_file_and_line()
if target_win and extra:
    current_buf = vim.current.buffer
    vim.current.buffer = target_win.buffer
    vim.command("delm %s" % extra)
    vim.current.buffer = current_buf
    vim.command("q")
    vim.command("call Fav('again')")
EOF
endfunction



function! FavSetting(setting_name)
python << EOF
setting_name = vim.eval('a:setting_name')
if setting_name == 'more_context':
    FAV_SETTINGS['more_context'] = not FAV_SETTINGS['more_context']
if setting_name == 'only_user_marks':
    FAV_SETTINGS['only_user_marks'] = not FAV_SETTINGS['only_user_marks']

call_fav_fill_again()
EOF
endfunction

function! FavNextMark()
python << EOF
go_to_next_user_mark()
EOF
endfunction

function! FavNextMarkDisplay()
python << EOF
FAV_SETTINGS['only_user_marks'] = True
if not vim.current.buffer.name:
    vim.command("q")
    go_to_next_user_mark()
EOF
call Fav('allmarks')
endfunction
