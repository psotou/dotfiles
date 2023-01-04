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
set completeopt=menuone,noselect,noinsert
set shell=zsh
" To open split panes to right and bottom. Feels more natural to me
set splitright
set splitbelow

" call plug#begin('~/.vim/plugged')
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" Lualine
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Themes
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/everforest'

" Telescope requirements
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

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

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" TS/JS
" Plug 'sbdchd/neoformat'
" Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

call plug#end()

" " use a project local version of Prettier
" let g:neoformat_try_node_exe = 1

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
let g:netrw_preview = 1
" let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_keepdir = 0
nnoremap <leader>dc :Lexplore<CR>       " dc -> current working directory
nnoremap <leader>df :Lexplore %:p:h<CR> " df -> directory of current file 

" Keeping it centered
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzz

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Moving through splits
nnoremap <S-j> <C-w><C-j>
nnoremap <S-k> <C-w><C-k>
nnoremap <S-l> <C-w><C-l>
nnoremap <S-h> <C-w><C-h>

" Telescope maps
" nnoremap gd <cmd>lua require('telescope.builtin').lsp_definitions()<CR>
" nnoremap gi <cmd>lua require('telescope.builtin').lsp_implementations()<CR>
" nnoremap gr <cmd>lua require('telescope.builtin').lsp_references()<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>ds <cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>gc <cmd>lua require('telescope.builtin').git_commits()<CR>
nnoremap <leader>gb <cmd>lua require('telescope.builtin').git_branches()<CR>


autocmd BufWritePre *.{go,js,jsx,ts,tsx} lua vim.lsp.buf.format({ async = true })
autocmd BufWritePre *.{go,js,jsx,ts,tsx} lua OrganizeImports(1000)
" autocmd BufWritePre *.{js,jsx,ts,tsx} Neoformat
" autocmd BufWritePost *.{js,jsx,ts,tsx} EslintFixAll

" indent accordingly
autocmd BufRead,BufNewFile *.{js,jsx,ts,tsx,ex} setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufRead,BufNewFile *.{txt,md} setlocal wrap 

" Lua files
lua require('lualine_config')
lua require('lsp_config')
