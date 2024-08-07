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
vim.o.colorcolumn = '80'
vim.o.guicursor = ''
vim.o.guifont = 'Hack Nerd Font Mono:h13'

--
-- SETTINGS FOR COLORSCHEME DEFAULT
--
vim.cmd.colorscheme('default')
vim.cmd('hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE')
vim.cmd('hi Comment ctermfg=240')
vim.cmd('hi String ctermfg=34')
vim.cmd('hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE') -- pmenu from habamax
vim.cmd('hi PmenuSel ctermfg=234 ctermbg=145 cterm=NONE') -- selection cursor from habamax
vim.cmd('hi! link NormalFloat Pmenu') -- floating windows

--
-- PLUGINS
--
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['branch'] = '0.1.x' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
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
vim.keymap.set('n', '<S-j>', '<C-w><C-j>') -- move down
vim.keymap.set('n', '<S-l>', '<C-w><C-l>') -- move right
vim.keymap.set('n', '<S-h>', '<C-w><C-h>') -- move left
vim.keymap.set('x', '<leader>p', [['_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [['+y]])
vim.keymap.set('n', '<leader>Y', [['+Y]])
vim.keymap.set({'n', 'v'}, '<leader>d', [['_d]])
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

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

autocmd('BufWritePost', {
    group = augroup('BufWritePost', {}),
    pattern = '*',
    command = [[%s/\s\+$//e]],
})

--
-- NETRW
--
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20

--
-- TREESITTER
--
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'go', 'c', 'lua', 'python'},
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
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
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
    local opts = { noremap=true, silent=true }
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

    local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = true })

    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        pattern = { '*' }, -- or '*.go'
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        pattern = { '*' }, -- or '*.go'
        callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { 'source.organizeImports' } }
            local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000) -- timeout in ms 1000
            for _, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, 'UTF-8')
                    else
                        vim.lsp.buf.execute_command(r.command)
                    end
                end
            end
        end,
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
                unreachable = true,
            },
            staticcheck = true,
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

-- RUST-ANALYZER
lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {
        'rustup', 'run', 'stable', 'rust-analyzer',
    },
    settings = {
        ['rust-analyzer'] = {},
    },
}

-- PYLSP
lspconfig.pylsp.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { 'pylsp' },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { 'W391' },
                    maxLineLength = 140,
                }
            }
        }
    }
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

----
---- COPILOT
----
--vim.g.copilot_no_tab_map = true
--vim.g.copilot_assume_mapped = true
---- vim.g.copilot_tab_fallback = ''
--vim.api.nvim_set_keymap('i', '<C-j>', 'copilot#Accept("<CR>")', { silent = true, expr = true })

--cmp.mapping['<C-j>'] = function(fallback)
--    cmp.mapping.abort()
--    local copilot_keys = vim.fn['copilot#Accept']()
--    if copilot_keys ~= '' then
--        vim.api.nvim_feedkeys(copilot_keys, 'i', true)
--    else
--        fallback()
--    end
--end

