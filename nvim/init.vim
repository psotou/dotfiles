syntax enable
set tabstop=4 
set shiftwidth=4
set softtabstop=4
set expandtab
set nowrap
set number relativenumber
set nohlsearch
set noerrorbells
set smartindent
set nobackup
set incsearch
set colorcolumn=90
set noswapfile
set autoindent
set smartindent
set cindent
set completeopt=menuone,noselect,noinsert
set shell=zsh

call plug#begin('~/.vim/plugged')

Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'sebdah/vim-delve'

" Lualine
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Themes
Plug 'gruvbox-community/gruvbox'
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
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

call plug#end()

" Everforest theme settings
if has('termguicolors')
    set termguicolors
endif
let g:everforest_background = 'hard'
let g:everforest_better_performance = 1

set background=dark
"let g:gruvbox_contrast_dark = 'hard'

colorscheme everforest
"colorscheme gruvbox
set guifont=Hack

" Files Explorer
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_winsize = 20
let g:netrw_keepdir = 0
nnoremap <leader>df :Lexplore %:p:h<CR> " df -> directory of current file 
nnoremap <leader>dc :Lexplore<CR>       " dc -> current working directory

" AWESOME REMAPS
" Keeping it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Moving through functions Go
nnoremap ]] :call search("^func")<CR>
nnoremap [[ :call search("^func", "b")<CR>

" Telescope maps
nnoremap gd <cmd>lua require('telescope.builtin').lsp_definitions()<CR>
nnoremap gr <cmd>lua require('telescope.builtin').lsp_references()<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>ds <cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>gc <cmd>lua require('telescope.builtin').git_commits()<CR>
nnoremap <leader>gb <cmd>lua require('telescope.builtin').git_branches()<CR>

" Go lua requirements
autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
autocmd BufWritePre *.go lua OrganizeImports(1000)

" Lua files
lua require('lualine_config')
lua require('lsp_config')
