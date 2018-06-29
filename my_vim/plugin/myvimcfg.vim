syntax on
set t_Co=256
set background=dark

if has('win32')
    "colorscheme solarized
    "colorscheme one
    "colorscheme molokai
    "colorscheme inkpot
    "colorscheme jellybeans
    "colorscheme darkmate
    colorscheme PaperColor
else
    "colorscheme contrasty
    "colorscheme jellybeans
    colorscheme PaperColor
endif

set path=.,,**                  " Set search path
set path+=./**                  " Add the current directory to path
set autoindent                  " set auto indent on
set smartindent                 " Set smart indent on
set smarttab                    " Set smart tabbing on
set shiftwidth=4                " Shiftwidth to be 4
set expandtab                   " Expand tab to spaces
set tabstop=4                   " 1 tab = 4 spaces
set shiftround                  " Round indent to nearest shiftwidth multiple
set number                      " line numbers
set showmatch                   " Show the matching bracket
set matchtime=1                 " shorten the jump time for showmatch
set ignorecase                  " Ignore case in search
set smartcase                   " Ignore case in searches excepted if an uppercase letter is used
set hls                         " Highlight search
set incsearch                   " Incremental search
set matchpairs+=<:>             " Add < > to match pairs command
set ruler                       " Set ruler on
set backspace=indent,eol,start  " Backspace over everything
set autowrite                   " Auto write modified files
set autowriteall                " Auto write modified files
set autoread                    " Auto load files modified outside of Vim
set equalalways                 " Have all windows of equal size
set virtualedit=block           " Allow visual block mode to select blank spaces as well
set formatoptions+=M            " don't insert space when joining lines
set formatoptions+=j            " remove comment leader when joining lines with comments
set formatoptions+=n            " when editing text recognize numbered lists and indent them
set formatoptions+=2            " use the indent of the second line of para for the rest of the para
set formatoptions+=q            " allow formatting of comments with "gq"
set shortmess=filtIoOA          " shorten up messages
set report=0                    " always get report for all the line changes
set startofline                 " Jump to non-blank start of line
set laststatus=2                " Always show the statusline
set hidden                      " Don't complain about unsaved files when switching buffers.
set gdefault                    " use g in substitute by default. Adding 'g' flag to the command will now toggle it
set lazyredraw                  " Don't redraw while executing macros (good performance config)
set foldcolumn=1                " Add a bit extra margin to the left
set mouse=a                     " use mouse in all modes

" Easy pasting to windows apps - http://vim.wikia.com/wiki/VimTip21
" yank always copies to unnamed register, so it is available in windows clipboard for other applications.
set clipboard=unnamed

 " No Residue files
set noswapfile
set nobackup
"set noundofile

" Default split to right and below
set splitbelow
set splitright

" Ignore bin files in file search
set wildignore+=*.o,*.d,*.a,*.obj,*.bak,*.exe,*.cfa,*.gz,*.zip,*.bin,*.db,*.dat,*.jpg,*.JPG,*.raw,*.tar,*.out,*.elf
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*~,*.pyc
if has('win32')
    set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*  " Windows ('noshellslash')
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store     " Linux/MacOSX
endif

" Use wild chars in Vim search
set wildmenu            " see :h 'wildmenu'
set wildmode=list:longest,full  " see :h 'wildmode' for all the possible values
set wildchar=<Tab>      " <Tab> to complete in cmdline.
set wildignorecase      " ignore case when completing file names and directories.

" diff mode
set diffopt=vertical,filler,context:10,foldcolumn:1

" Session configs
set sessionoptions-=options     " do not store global and local values in a session
set sessionoptions-=folds       " do not store folds
set sessionoptions+=blank       " blank windows
set sessionoptions+=buffers     " hidden and unloaded buffers
set sessionoptions+=curdir      " current directory
set sessionoptions-=help        " do not store help window
set sessionoptions+=tabpages    " all tab pages
set sessionoptions+=winsize     " window sizes
set sessionoptions+=winpos      " position of the whole Vim window

" Save file with C-s
nnoremap <silent><C-s> :w<CR>

" Use '\,' to add a space
nmap \, i<Space><Esc>

" [ completion options ]
set complete=.,w,b,t,i,u,k       " completion buffers
"            | | | | | | |
"            | | | | | | `-dict
"            | | | | | `-unloaded buffers
"            | | | | `-include files
"            | | | `-tags
"            | | `-other loaded buffers
"            | `-windows buffers
"            `-the current buffer
set completeopt=menuone " menu,menuone,longest,preview
set completeopt-=preview " dont show preview window

" Netrw config
let g:netrw_liststyle=1     " Long style listing
let g:netrw_keepdir=1       " Keep current directory immune from browsing directory

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Enable filetype plugins
filetype plugin on
filetype indent on

if has("autocmd")
    "autocmd!               " Clear all autocmds in the group
    autocmd FileType make setlocal noexpandtab

    " Automatically remove all trailing whitespace
    autocmd BufWritePre * :%s/\s\+$//e

    " Auto-save current session
    au VimLeavePre * if v:this_session != '' | exec "mks! " . v:this_session | endif

    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType vim set omnifunc=syntaxcomplete#Complete
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c set omnifunc=ccomplete#Complete

    "autocmd BufNewFile,BufRead *.txt set ft=markdown
    "autocmd BufNewFile,BufRead *.css set ft=css sw=2 sts=2

    " To jump between the '=' and ';' in an assignment using <S-%>. Useful for languages like C/C++ and Java.
    autocmd FileType c,cpp,java set matchpairs+==:;

    " netrw immediately activate when using [g]vim without any filenames, showing the current directory
    augroup VimStartup
        autocmd VimEnter * if expand("%") == "" | e . | endif
    augroup END

    augroup numbertoggle
        autocmd WinEnter,BufEnter,FocusGained,InsertLeave * :setlocal relativenumber
        autocmd WinLeave,BufLeave,FocusLost,InsertEnter   * :setlocal norelativenumber
    augroup END

    " set cursorline only in normal mode
    autocmd InsertLeave,WinEnter * set cursorline
    autocmd InsertEnter,WinLeave * set nocursorline

    " Rainbow parantheses
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound         " ()
    au Syntax * RainbowParenthesesLoadSquare        " []
    au Syntax * RainbowParenthesesLoadBraces        " {}
endif

" function to toggle the number mode
function! g:ToggleNuMode()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
noremap <C-l> :call g:ToggleNuMode()<CR>

" Set print options
set popt=syntax:y,number:y,wrap:y,left:0pt

" Remove GUI options
if has('gui') && has('gui_running')
    set guioptions-=m   "no menus
    set guioptions-=T   "no toolbars
    "set guioptions-=r   "no right-side scrollbar
    "set guioptions-=R   "no right-side scrollbar
    set guioptions-=l   "no left-side scrollbar
    set guioptions-=L   "no left-side scrollbar
    set guioptions+=b   "show bottom scrollbar
    set guioptions+=F   " show footer
    set textwidth=105
    set columns=115
    set lines=50
endif

" Set font
if has("gui") && has("mac")
    set fuopt+=maxhorz
    set macmeta
    set antialias
    set guifont=Monaco:h10
else
    set guifont=Lucida_Sans_Typewriter:h10
endif
set linespace=2

" Configure wrap
set wrap linebreak  " linebreak - Wrap at word boundary
set sidescroll=5
set listchars+=precedes:<,extends:>
set breakat+={}()"|<>&
set textwidth=500

" magic/nomagic: changes special chars that can be used in search patterns
set magic
    " \v: 'very magic', make every character except a-zA-Z0-9 and '_' have special meaning
    " use \v and \V to switch 'very magic' on or off.
    " \m, \M: 'magic' mode.
    " use \m and \M to switch 'magic' on or off.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    if has("win32")
        set undodir=~/vimfiles/temp_dirs/undodir
    else
        set undodir=~/.vim/temp_dirs/undodir
    endif
    set undofile
catch
endtry

" :W sudo saves the file
" (useful for handling the permission-denied error)
if !has("win32")
    command W w !sudo tee % > /dev/null
endif

" Use line diff
noremap \ldt :Linediff<CR>
noremap \ldo :LinediffReset<CR>

" Jump to window 1
nnoremap \1 1<C-w>w
" Jump to window 2
nnoremap \2 2<C-w>w
" Jump to window 3
nnoremap \3 3<C-w>w
" Jump to window 4
nnoremap \4 4<C-w>w

" Shortcuts for tabs
"nnoremap <C-Left> :tabprevious<CR>
"nnoremap <C-Right> :tabnext<CR>
"nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
"nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>
nnoremap <C-Tab> :tabnext<CR>

" Open last accessed tab
let g:lasttab = 1
nmap gl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" duplicate tab
noremap _t :tab split<CR>

" Absolute movement for word-wrapped lines.
nnoremap j gj
nnoremap k gk

" Comment-ify the visually selected block using C style comments
vmap \* omxomy<ESC>`xO/*<ESC>`yo*/<ESC>

" search for visually highlighted text
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" Use 'X' to invoke search for visually selected text
vmap X y/<C-R>"<CR>

" Use 'gX' to invoke global search for visually selected text
vmap gX y:vimgrep /<C-R>"/ **/*<CR>

" Toggle scrollbind for all open windows in the tab
nnoremap \j :windo set scb!

" move among buffers with [b,]b
map [b :bnext<CR>
map ]b :bprev<CR>

" Use F8 to toggle between binary/hex
noremap \hx :call HexMe()<CR>
let $in_hex=0
function HexMe()
    set binary
    set noeol
    if $in_hex>0
        :%!xxd -r
        let $in_hex=0
    else
        :%!xxd
        let $in_hex=1
    endif
endfunction

" replace number under cursor with its decimal equivalent
nnoremap _d :call Hex2Dec()<CR>
function Hex2Dec()
    " Save cursor position
    let l:save = winsaveview()
    " yank the current word into register 'l'
    exe 'normal! "ldiw'
    " check if its end of line
    if col('.') == col('$')-1
        exe ":normal! a" . printf("%d", @l)
    else
        exe ":normal! i" . printf("%d", @l)
    endif
    call winrestview(l:save)
endfunction

" replace number under cursor with its hex equivalent
noremap _h :call Dec2Hex()<CR>
function Dec2Hex()
    " Save cursor position
    let l:save = winsaveview()
    " yank the current word into register 'l'
    exe 'normal! "ldiw'
    " check if its end of line
    if col('.') == col('$')-1
        exe ":normal! a" . printf("0x%x", @l)
    else
        exe ":normal! i" . printf("0x%x", @l)
    endif
    " Move cursor to original position
    call winrestview(l:save)
endfunction

" replace ascii hex under cursor with its char equivalent
noremap _c :call Ascii2Char()<CR>
function Ascii2Char()
    " Save cursor position
    let l:save = winsaveview()
    " yank the current word into register 'l'
    exe 'normal! "ldiw'
    " check if its end of line
    if col('.') == col('$')-1
        exe ":normal! a" . nr2char(@l)
    else
        exe ":normal! i" . nr2char(@l)
    endif
    " Move cursor to original position
    call winrestview(l:save)
endfunction

" replace char under cursor with its ascii hex equivalent
noremap _a :call Char2Ascii()<CR>
function Char2Ascii()
    " Save cursor position
    let l:save = winsaveview()
    " yank the char into register 'l'
    exe 'normal! "lx'
    " check if its end of line
    if col('.') == col('$')-1
        exe ":normal! a" . printf("0x%x", char2nr(@l))
    else
        exe ":normal! i" . printf("0x%x", char2nr(@l))
    endif
    " Move cursor to original position
    call winrestview(l:save)
endfunction

" Shortcuts for navigating quickfix list
noremap ]q :cnext<CR>
noremap [q :cprev<CR>
noremap ]Q :cnfile<CR>
noremap [Q :cpfile<CR>
noremap \q :cfirst<CR>
noremap \Q :clast<CR>
noremap \qo :cwindow<CR>
noremap \qc :cclose<CR>

" Shortcut for toggling a diff in a window
nnoremap \a :call WinStartDiff()<CR>
let $diff_started=0
function WinStartDiff()
    if $diff_started>0
        let $diff_started=0
        :windo diffoff
    else
        let $diff_started=1
        :windo diffthis
    endif
endfunction

" Tab names for non-GUI
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set guitablabel=%!MyTabLine()
    set showtabline=2
    highlight link TabNum Special
endif

" Close all hidden buffers
function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction

" Display number of open buffers
fun! NumberOfOpenBuffers()
    echo len(getbufinfo({'buflisted':1}))
endfun

" rebuild cscope, make sure it is called from the right directory
function! RebuildCscope(total)
    " Kill all prev connections
    let l:x = 0
    while l:x != a:total
        silent execute 'cs kill '.l:x
        let l:x = l:x + 1
    endwhile

    if has('win32')
        execute '!.\cscope_sym.bat '.a:total
    else
        execute '!./cscope_sym.sh '.a:total
    endif
    cs add cscope.out
endfunction

" Helper functions
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

""""""""""""""""""""""""""""""
" => YankStack
""""""""""""""""""""""""""""""
let g:yankstack_yank_keys = ['y', 'd']
nmap \p <Plug>yankstack_substitute_older_paste
nmap \P <Plug>yankstack_substitute_newer_paste

"""""""""""""""""""""" Plugin configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'] " use .gitignore to exclude caching of those files
if has('win32')
    let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d' " Windows
else
    let g:ctrlp_user_command = 'find %s -type f'       " MacOSX/Linux
endif
let g:ctrlp_match_window = 'max:35'
let g:ctrlp_max_files = 0 " Set no max file limit
let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_lazy_update = 0
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_tabpage_position = 'ac'
let g:ctrlp_clear_cache_on_exit = 0     " Hit <F5> to refresh index
let g:ctrlp_extensions = ['mixed', 'changes', 'quickfix']
let g:ctrlp_cmd='CtrlPMixed'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
            \ }

""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map _f :MRU<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=0
nnoremap _g :GitGutterToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale Lint
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap _a <Plug>(ale_next_wrap)
" Only run linting when saving the file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE:
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE:
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim...
if has('win32')
    set csprg=C:\Work\Tools\my_gvim\cscope.exe
    let $TMP="C:/tmp"
else
    set csprg=/usr/bin/cscope
endif

let g:cscope_loaded = 0
if (g:cscope_loaded == 0)

    """"""""""""" Standard cscope/vim boilerplate

    let g:cscope_loaded = 1

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set cscopetagorder=0

    " add any cscope database in current directory
    if filereadable("./cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose

    " Use relative path from cscope.out directory
    set cscoperelative

    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit '\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "

    if has('win32')
        "symbol
        nmap \s :cs find s <C-R><C-W><CR>
        "global
        nmap \g :cs find g <C-R><C-W><CR>
        "calls
        nmap \c :cs find c <C-R><C-W><CR>
        "called
        nmap \d :cs find d <C-R><C-W><CR>
        "file
        nmap \f :cs find f
        "text
        nmap \t :cs find t
        "egrep
        nmap \e :cs find e
        "includes
        nmap \i :cs find i <C-R><C-W><CR>
    else
        " symbol
        nmap \s :cs find s <C-R>=expand("<cword>")<CR><CR>
        " global
        nmap \g :cs find g <C-R>=expand("<cword>")<CR><CR>
        " calls
        nmap \c :cs find c <C-R>=expand("<cword>")<CR><CR>
        " called
        nmap \d :cs find d <C-R>=expand("<cword>")<CR><CR>
        " text
        nmap \t :cs find t <C-R>=expand("<cword>")<CR><CR>
        " egrep
        nmap \e :cs find e <C-R>=expand("<cword>")<CR><CR>
        " file
        nmap \f :cs find f <C-R>=expand("<cfile>")<CR><CR>
        " includes
        nmap \i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    endif


    " Using '\' + capital search types (s,g,c,t,e,f,i,d) opens the search item in new tab

    if has('win32')
        nmap \S :tab cs find s <C-R><C-W><CR>
        nmap \G :tab cs find g <C-R><C-W><CR>
        nmap \C :tab cs find c <C-R><C-W><CR>
        nmap \D :tab cs find d <C-R><C-W><CR>
        nmap \F :tab cs find f
        nmap \T :tab cs find t
        nmap \E :tab cs find e
        nmap \I :tab cs find i <C-R><C-W><CR>
    else
        nmap \S :vert scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap \G :vert scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap \C :vert scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap \T :vert scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap \E :vert scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap \F :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap \I :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap \D :vert scs find d <C-R>=expand("<cword>")<CR><CR>
    endif


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "

    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif
