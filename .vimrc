" Dependencies:
"  - Tmux
"  - FZF
"  - Ripgrep
"
"  Copy this file and run ":PlugInstall" inside vim

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

syntax on
set number
set relativenumber
set clipboard=unnamed
set hidden
set path=.,/usr/include,,**
execute pathogen#infect()
call pathogen#helptags()
autocmd vimenter * NERDTree
autocmd vimenter * wincmd p

" installs vim-plug if doesnt exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" Autoclose plugin
Plug 'townk/vim-autoclose'

" Ripgrep integration
Plug 'jremmen/vim-ripgrep'

" Fugitive
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" post install (yarn install | npm install)
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" tsx support
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" coc vim
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" emmet
Plug 'mattn/emmet-vim'

" Colorizer (hexcodes)
Plug 'chrisbra/Colorizer'

" Initialize plugin system
call plug#end()

let mapleader= "\<space>"
let colorizer_auto_filetype = 'css,scss,less'

aug FT_ColorizerPlugin
	au!
	exe "au Filetype" g:colorizer_auto_filetype 
	    \ "call Colorizer#LocalFTAutoCmds(1)\|
	    \ :ColorHighlight"
aug END

nnoremap <leader>p :FZF<Cr>
nnoremap <leader>f :Rg  
nnoremap <leader>r :NERDTreeFind <bar> wincmd p<Cr>
nnoremap <F6> :NERDTreeToggle <bar> wincmd p<Cr>
nnoremap <leader>t :tabedit \| :NERDTreeToggle <bar> wincmd p<Cr>
nnoremap <leader>y :tabclose<Cr>
nnoremap <leader>c :ColorHighlight<Cr>
