" NERDTree configuration
nnoremap \n :call <SID>MyNERDTreeToggle()<CR>
nnoremap \o :call <SID>NERDTreeOpenAllTabs()<CR>
nnoremap \O :call <SID>NERDTreeCloseAllTabs()<CR>
" Automatically delete the buffer of the file you just deleted with NerdTree
let NERDTreeAutoDeleteBuffer = 1
" Looks
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

let s:nerdtree_globally_active = 0

" Toggle between NERDTree opened at the location of the file or close if already present
fun! s:MyNERDTreeToggle()
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        silent NERDTreeClose
    else
        silent NERDTreeFind
    endif
endfun

" switch NERDTree on for current tab -- mirror it if possible, otherwise create it
fun! s:NERDTreeMirrorOrCreate()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  " if NERDTree is not active in the current tab, try to mirror it
  if !l:nerdtree_open
    let l:previous_winnr = winnr("$")

    silent NERDTreeMirror

    " if the window count of current tab didn't increase after NERDTreeMirror,
    " it means NERDTreeMirror was unsuccessful and a new NERDTree has to be created
    if l:previous_winnr == winnr("$")
      silent NERDTreeToggle
    endif
  endif
endfun

" switch NERDTree on for all tabs while making sure there is only one NERDTree buffer
fun! s:NERDTreeOpenAllTabs()
  let s:nerdtree_globally_active = 1

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo call s:NERDTreeMirrorOrCreate()
  exe 'tabn ' . l:current_tab
endfun

" close NERDTree across all tabs
fun! s:NERDTreeCloseAllTabs()
  let s:nerdtree_globally_active = 0

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo silent NERDTreeClose
  exe 'tabn ' . l:current_tab
endfun

" If nerdtree is globally active open it for new tabs too
fun! s:TabEnterHandler()
  if s:nerdtree_globally_active && !s:IsNERDTreeOpenInCurrentTab()
    call s:NERDTreeMirrorOrCreate()

    " move focus to the previous window
    wincmd p

    " Turn on the 'NewTabCreated' flag
    let s:NewTabCreated = 1
  endif
endfun

" check if NERDTree is open in current tab
fun! s:IsNERDTreeOpenInCurrentTab()
  return exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
endfun

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
fun! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && winnr("$") == 1
    q
  endif
endfun

augroup NERDTreeTabs
    autocmd TabEnter * call <SID>TabEnterHandler()
    " We enable nesting for this autocommand (see :h autocmd-nested) so that
    " exiting Vim when NERDTree is the last window triggers the VimLeave event.
    autocmd WinEnter * nested call <SID>CloseIfOnlyNerdTreeLeft()
augroup END



