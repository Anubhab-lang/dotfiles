"#################################################################
"#                      .VIMRC BY              __  __            #
"#    _________  _______  __   ____ ___  ___  / /_/ /____  _____ #
"#   / ___/ __ \/ ___/ / / /  / __ `__ \/ _ \/ __/ __/ _ \/ ___/ #
"#  / /__/ /_/ / /  / /_/ /  / / / / / /  __/ /_/ /_/  __/ /     #
"#  \___/\____/_/   \__, /  /_/ /_/ /_/\___/\__/\__/\___/_/      #
"#                 /____/                                        #
"#################################################################
"preferences        ___
"     ___  _______ / _/__ ___________ ___  _______ ___
"    / _ \/ __/ -_) _/ -_) __/ __/ -_) _ \/ __/ -_|_-<
"   / .__/_/  \__/_/ \__/_/  \__/\__/_//_/\__/\__/___/
"  /_/

"Enable mouse control
set mouse=a

"Start with NERDTree open
"autocmd vimenter * NERDTree

"plugins    __          _
"     ___  / /_ _____ _(_)__  ___
"    / _ \/ / // / _ `/ / _ \(_-<
"   / .__/_/\_ _/\_, /_/_//_/___/
"  /_/          /___/

"Enable vim-plug and set the plugin location
call plug#begin('~/.vim/plugins')

" ###LIST PLUGINS AND THEIR RESPECTIVE REPOS DOWN BELOW###
"Colorscheme plugin (https://github.com/flazz/vim-colorschemes.git)
"Plug 'flazz/vim-colorschemes', {'do': 'ln -Ffis /users/cory/.vim/plugins/vim-colorschemes/colors /users/cory/.vim/colors'}

"Indention guides (https://github.com/nathanaelkane/vim-indent-guides.git)
Plug 'nathanaelkane/vim-indent-guides'

"Automatic surrounding characters (https://github.com/tpope/vim-surround.git)
Plug 'tpope/vim-surround'

"Syntax checking (https://github.com/vim-syntastic/syntastic.git)
Plug 'vim-syntastic/syntastic'

"Sensible vim default settings (https://github.com/tpope/vim-sensible.git)
Plug 'tpope/vim-sensible'

"Powerline plugin (https://github.com/powerline/powerline.git)
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

"Git diff shown in the gutter (https://github.com/airblade/vim-gitgutter.git)
Plug 'airblade/vim-gitgutter'

"Nerd Tree file explorer plugin (https://github.com/scrooloose/nerdtree.git)
Plug 'scrooloose/nerdtree'

" ###DO NOT ADD ANY PLUGINS BELOW THIS LINE###
call plug#end()

"mappings                  _
"    __ _  ___ ____  ___  (_)__  ___ ____
"   /  ' \/ _ `/ _ \/ _ \/ / _ \/ _ `(_-<
"  /_/_/_/\_,_/ .__/ .__/_/_//_/\_, /___/
"            /_/  /_/          /___/

"Map <LEADER> to space
let mapleader = " "

"Disable timeout after hitting leader key
set notimeout

"Window management
nmap <Leader>q :q<CR>
nmap <Leader>Q :qa!<CR>
nmap <Leader>w :wa!<CR>
nmap <Leader>v :vsplit<CR>
nmap <Leader>s :split<CR>
nmap <Leader>l <C-W>l<ESC>
nmap <Leader>h <C-W>h<ESC>
nmap <Leader>j <C-W>j<ESC>
nmap <Leader>k <C-W>k<ESC>

"Visual expand
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"View registers and act on them
nnoremap Q :registers<CR>:echo '>' . getline('.')<CR>:normal! "
nnoremap <Leader>c :call PingCursor()<CR>
nnoremap <F5> :GundoToggle<CR>
nnoremap <F4> :TagbarToggle<CR>

"Retain visual selection when indenting
xnoremap < <gv
xnoremap > >gv

"Fast search and replace
nnoremap <Space>% :%s/\<<C-r>=expand("<cword>")<CR>\>/

"Escape on jj
imap jj <ESC>

"Toggle NERDTree window
map <Leader>o :NERDTreeToggle<CR>

"display___          __
"   ___/ (_)__ ___  / /__ ___ __
"  / _  / (_-</ _ \/ / _ `/ // /
"  \_,_/_/___/ .__/_/\_,_/\_, /
"           /_/          /___/

"Set the colorscheme(Reuires flazz/vim-colorschemes plguin)
colorscheme solarized

"Set the background color
set background=dark

"Line numbers
set nu
set hidden
set cursorline
set nolist
set modeline
set modelines=1

"Show indent guides
let g:indent_guides_enable_on_vim_startup = 1

"Hightlight matching paren groups
let g:mta_use_matchparen_group = 1

"Change the cursor to a block shape in terminal
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

"Cursor line highlighting
hi CursorLineNr   term=bold ctermfg=Yellow gui=bold guifg=Yellow
hi CursorLine ctermbg=236

"autosave      __
"   ___ ___ __/ /____  ___ ___ __  _____
"  / _ `/ // / __/ _ \(_-</ _ `/ |/ / -_)
"  \_,_/\_,_/\__/\___/___/\_,_/|___/\__/
"

"Configure swap file directory
set directory=~/.vim/dirs/tmp     " directory to place swap files in

"Configure backups
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files

"Enable and configure persistent undo
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo

"Create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

"automagic     __                       _
"   ___ ___ __/ /____  __ _  ___ ____ _(_)___
"  / _ `/ // / __/ _ \/  ' \/ _ `/ _ `/ / __/
"  \_,_/\_,_/\__/\___/_/_/_/\_,_/\_, /_/\__/
"                               /___/

"Auto sources vimrc when it is saved
autocmd BufWritePost .vimrc so $MYVIMRC

"Auto close vim if the last buffer is a NERDTree window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
