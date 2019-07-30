" VIM Configuration
" Annule la compatibilite avec l’ancetre Vi : totalement indispensable
set nocompatible

filetype off

" -- Plugin with Vundle
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'ledger/vim-ledger'
Plugin 'scrooloose/nerdtree'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'junegunn/goyo.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'airblade/vim-gitgutter'
" Plugin 'LustyExplorer'
Plugin 'w0rp/ale'
" Plugin 'Shougo/deoplete.nvim'
" Plugin 'roxma/nvim-yarp' " needs for deoplete
" Plugin 'roxma/vim-hug-neovim-rpc' " needs for deoplete
Plugin 'ervandew/supertab'
Plugin 'cespare/vim-toml'
" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required

" Active les comportements specifiques aux types de fichiers comme
" la syntaxe et l’indentation
filetype on
filetype plugin on
filetype indent on

" appuyez sur jj pour sortir du mode d'insertion
imap jj <Esc>

" -- Affichage
set ruler " Affiche la position actuelle du curseur
" set rulerformat=%-10.(%l,%c%V%)\ %P
set nowrap " N'affiche pas les lignes trop longues sur plusieurs lignes
set scrolloff=3 " Affiche un minimum de 3 lignes autour du curseur (pour le scroll)
set hidden " Cache les fichiers lors de l’ouverture d’autres fichiers
syntax on " Active la coloration syntaxique

" -- Beep
set visualbell " Empeche Vim de beeper
set noerrorbells " Empeche Vim de beeper

" -- Recherche
set ignorecase " Ignore la casse lors d’une recherche
set smartcase " Si une recherche contient une majuscule,
              " re-active la sensibilite a la casse
set incsearch " Surligne les resultats de recherche pendant la saisie
set hlsearch " Surligne les resultats de recherche

" Active le comportement ’habituel’ de la touche retour en arriere
set backspace=indent,eol,start

set title " Set the terminal's title

" -- Coloration
" Utilise la version sombre de Solarized
set background=dark
colorscheme solarized
" colorscheme molokai

" -- Ledger
au BufNewFile,BufRead *.ldg,*.ledger setf ledger | comp ledger
au FileType ledger noremap { ?^\d<CR>
au FileType ledger noremap } /^\d<CR>

let g:ledger_extra_options = '--pedantic --explicit --check-payees'
let g:ledger_align_at = 53
let g:ledger_default_commodity = '€'

if exists('g:ycm_filetype_blacklist')
	call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif

function LedgerAlignAll()
    :%LedgerAlign
endfunction
command LedgerAlignAll call LedgerAlignAll()

" -- NERDTree
let NERDTreeShowHidden=1

" Tabs and indentation.
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis

let mapleader = ',' " change the mapleader from \ to ,

" -- Editer/recharger rapidement le fichier vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

"  Clean code function
function! CleanCode()
  %retab          " Replace tabs with spaces
  %s///eg     " Turn DOS returns ^M into real returns
  %s=  *$==e      " Delete end of line blanks
  echo "Cleaned up this mess."
endfunction
nmap <leader>tt :call CleanCode()<cr>

" -- active la complétion avec deoplete
let g:deoplete#enable_at_startup = 1

" -- gitcommit message
autocmd Filetype gitcommit setlocal spell textwidth=72
