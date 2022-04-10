syntax enable

set tabstop=4 
set shiftwidth=4
set softtabstop=4
set expandtab
set nowrap
set number
set nohlsearch
set noerrorbells
set smartindent
set nobackup
set incsearch
set colorcolumn=90
set ai "Auto Indent
set si "Smart Indent
"set textwidth=0
"set wrapmargin=0
"set wrap
"set linebreak

call plug#begin('~/.vim/plugged')

Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Lualine
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Themes
Plug 'gruvbox-community/gruvbox'
Plug 'mhartington/oceanic-next'
Plug 'dikiaap/minimalist'
Plug 'sainnhe/everforest'

" Telescope requirements
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'

" LSP autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

call plug#end()

" Everforest theme settings
if has('termguicolors')
    set termguicolors
endif

set background=dark
let g:everforest_background = 'hard'
let g:everforest_better_performance = 1

colorscheme everforest
set guifont=Hack

" Files Explorer
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_winsize = 25
let g:netrw_keepdir = 0
nnoremap <leader>df :Vexplore %:p:h<CR> "Directory of current file
nnoremap <leader>dc :Vexplore<CR> "Current working directory

" AWESOME REMAPS
" Keeping it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Telescope maps
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>gc <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <leader>gb <cmd>lua require('telescope.builtin').git_branches()<cr>

" Go lua requirements
autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
"autocmd BufWritePre *.go lua goimports(1000)

" Lua files
lua require('lualine_config')
lua require('lsp_config')