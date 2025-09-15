vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.o.undofile = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.scrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.updatetime = 50
vim.o.colorcolumn = '90'
vim.o.guicursor = ''
-- vim.o.guifont = 'Hack Nerd Font Mono:h13'

--
-- SETTINGS FOR COLORSCHEME
--

vim.cmd('hi clear')

vim.cmd('hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE')
vim.cmd('hi Comment ctermfg=240')
vim.cmd('hi String ctermfg=114')
vim.cmd('hi Function ctermfg=74 ctermbg=NONE cterm=bold')
vim.cmd('hi Special ctermfg=NONE ctermbg=NONE cterm=bold')
vim.cmd('hi Identifier ctermfg=74 ctermbg=NONE cterm=bold')
vim.cmd('hi Type ctermfg=NONE cterm=bold')                  -- all builtin types
vim.cmd('hi Constant ctermfg=NONE ctermbg=NONE cterm=bold') -- nil iota (and literals)
vim.cmd('hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE')   -- pmenu from habamax
vim.cmd('hi PmenuSel ctermfg=234 ctermbg=145 cterm=NONE') -- selection cursor from habamax
vim.cmd('hi! link NormalFloat Pmenu')                     -- floating windows

vim.cmd('hi Statement ctermfg=NONE ctermbg=NONE cterm=bold') -- func, return, type, const.


-- requeires treesitter
vim.api.nvim_set_hl(0, "@keyword.go", { bold = true })
vim.api.nvim_set_hl(0, "@function.go", { fg = "#B3EBF2", bold = true })
vim.api.nvim_set_hl(0, "@function.call.go", { fg = "#B3EBF2", bold = true })
vim.api.nvim_set_hl(0, "@function.method.go", { fg = "#B3EBF2", bold = true })
vim.api.nvim_set_hl(0, "@function.method.call.go", { fg = "#B3EBF2", bold = true })
vim.api.nvim_set_hl(0, "@function.builtin.go", { fg = "#FAF9F6", bold = true })
vim.api.nvim_set_hl(0, "@type.builtin.go", { fg = "#FAF9F6", bold = true })
vim.api.nvim_set_hl(0, "@constant.builtin.go", { fg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "@constructor.go", { fg = "#B3EBF2", bold = true })
vim.api.nvim_set_hl(0, "@property.go", { fg = "#D3D3D3" })
vim.api.nvim_set_hl(0, "@type.go", { fg = "#D3D3D3", bold = true })
vim.api.nvim_set_hl(0, "@type.definition.go", { fg = "#D3D3D3", bold = true })
vim.api.nvim_set_hl(0, "@string.go", { fg = "#BADBA2", bold = false })

--
-- PLUGINS
--
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['branch'] = '0.1.x' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
Plug('junegunn/fzf', { ['do'] = function() vim.fn['fzf#install']() end })
Plug('junegunn/fzf.vim')
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('saadparwaiz1/cmp_luasnip')
Plug('L3MON4D3/LuaSnip', { ['tag'] = 'v2.*', ['do'] = 'make install_jsregexp' })
Plug('tpope/vim-fugitive')
Plug('tpope/vim-commentary')
Plug('tpope/vim-surround')
vim.call('plug#end')

--
-- REMAPS
--
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<leader>df', ':Lexplore %:p:h<CR>')
vim.keymap.set('n', '<leader>dc', ':Lexplore<CR>')
vim.keymap.set('n', '<S-l>', '<C-w><C-l>') -- move right
vim.keymap.set('n', '<S-h>', '<C-w><C-h>') -- move left
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')

-- 
-- FZF
--
vim.keymap.set('n', '<leader>gf', ':GFiles<CR>')
vim.keymap.set('n', '<leader>ff', ':Files .<CR>')
vim.keymap.set('n', '<leader>bb', ':Buffers<CR>')

-- vim.g.fzf_vim = {}
-- vim.g.fzf_vim.preview_window = { 'left,40%', 'ctrl-/' }

vim.cmd [[
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.95, 'relative': v:true } }

    let g:fzf_vim = {}
    let g:fzf_vim.preview_window = ['up,50%', 'ctrl-/']
]]


--
-- COMMANDS & GROUPS
--
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
    group = augroup('HighlightOnYank', {}),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 50 }
    end
})

--
-- NETRW
--
vim.g.netrw_keepdir = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20

--
-- TREESITTER
--
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'go', 'c' },
    sync_install = false,
    auto_install = false,
    indent = { enable = true },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

--
-- TELESCOPE
--
local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>gg', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

require('telescope').setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.9 },
        -- file_ignore_patterns = { 'vendor' },
    },
}

--
-- LSP
--
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
    local opts = { noremap=false, silent=true }
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
    vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)

    autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = {only = {"source.organizeImports"}}
            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
            -- machine and codebase, you may want longer. Add an additional
            -- argument after params if you find that you have to write the file
            -- twice for changes to be saved.
            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
            for cid, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                  vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
              end
            end
            vim.lsp.buf.format({async = false})
        end
    })

end

-- GOPLS
lspconfig.gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { 'gopls', 'serve' },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
}

-- CLANGD
lspconfig.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--import-insertions",
        "--completion-style=detailed",
        "--function-arg-placeholders",
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
}

-- Typescript/Javascript
lspconfig.ts_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

--
-- AUTOCOMPLETION
--

-- luasnip setup
local luasnip = require('luasnip')

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


