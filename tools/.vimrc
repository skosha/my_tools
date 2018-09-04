"""""""""""""""""""""" Vundle config
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'

Plugin 'tpope/vim-fugitive'                 " Git wrapper
Plugin 'scrooloose/nerdtree'                " NERD Tree file explorer
Plugin 'Xuyuanp/nerdtree-git-plugin'        " Shows git status in nerd tree
Plugin 'airblade/vim-gitgutter'             " Shows a git diff in the 'gutter'
Plugin 'zivyangll/git-blame.vim'            " Shows a full blown git blame for the entire file
Plugin 'w0rp/ale'                           " Asynchronous Lint Engine
Plugin 'majutsushi/tagbar'                  " A class outline viewer for vim
Plugin 'godlygeek/tabular'                  " Vim script for text filtering and alignment
Plugin 'christoomey/vim-tmux-navigator'     " Seamless navigation between tmux panes and vim splits
Plugin 'ctrlpvim/ctrlp.vim'                 " Fuzzy file finder
Plugin 'machakann/vim-highlightedyank'      " Make the yanked region apparent!
Plugin 'yegappan/mru'                       " most recently used files
Plugin 'maxbrunsfeld/vim-yankstack'         " yank ring
Plugin 'tpope/vim-eunuch'
Plugin 'severin-lemaignan/vim-minimap'
Plugin 'skwp/greplace.vim'                  " Global search and replace for VI

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let win_shell = (has('win32') || has('win64')) && &shellcmdflag =~ '/'
let vimDir = win_shell ? '$HOME/vimfiles' : '$HOME/.vim'
let &runtimepath .= ',' . expand(vimDir . '/bundle/Vundle.vim')
call vundle#rc(expand(vimDir . '/bundle'))

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" End of Vundle config
