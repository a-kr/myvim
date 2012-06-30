"
" Python filetype plugin for running pylint
" Language:     Python (ft=python)
" Maintainer:   Vincent Driessen <vincent@3rdcloud.com>
" Version:      Vim 7 (may work with lower Vim versions, but not tested)
" URL:          http://github.com/nvie/vim-flake8
"
" Only do this when not done yet for this buffer
if exists("b:loaded_pylint_ftplugin")
    finish
endif
let b:loaded_pylint_ftplugin=1

if exists("g:pylint_cmd")
    let s:pylint_cmd=g:pylint_cmd
else
    let s:pylint_cmd="pylint --output-format=parseable -r n -i y"
endif

let s:pylint_ignores=""
if exists("g:pylint_ignore")
    let s:pylint_ignores=" --disable=".g:pylint_ignore
endif

if !exists("*Pylint()")
    function Pylint()
        if !executable("pylint")
            echoerr "pylint not found. Please install it first."
            return
        endif

        set lazyredraw   " delay redrawing
        cclose           " close any existing cwindows

        " store old grep settings (to restore later)
        let l:old_gfm=&grepformat
        let l:old_gp=&grepprg

        " write any changes before continuing
        if &readonly == 0
            update
        endif

        " perform the grep itself
        let &grepformat="%f:%l: %m"
        let &grepprg=s:pylint_cmd.s:pylint_ignores
        silent! grep! %

        " restore grep settings
        let &grepformat=l:old_gfm
        let &grepprg=l:old_gp

        " open cwindow
        let has_results=getqflist() != []
        if has_results
            execute 'belowright copen'
            setlocal wrap
            nnoremap <buffer> <silent> c :cclose<CR>
            nnoremap <buffer> <silent> q :cclose<CR>
        endif

        set nolazyredraw
        redraw!

        if has_results == 0
            " Show OK status
            hi Green ctermfg=green
            echohl Green
            echon "Pylint check OK"
            echohl
        endif
    endfunction
endif

" Add mappings, unless the user didn't want this.
" The default mapping is registered under to <F7> by default, unless the user
" remapped it already (or a mapping exists already for <F7>)
if !exists("no_plugin_maps") && !exists("no_pylint_maps")
    if !hasmapto('Pylint(')
        noremap <buffer> <F6> :call Pylint()<CR>
    endif
endif
