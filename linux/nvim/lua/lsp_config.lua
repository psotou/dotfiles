local nvim_lsp = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)
    -- Mappings
    local opts = { noremap=true, silent=true }
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    if client.server_capabilities.document_formatting then
        vim.cmd([[
            augroup formatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()
                autocmd BufWritePre <buffer> lua OrganizeImports(1000)
            augroup END
        ]])
    end
end

local function config(_config)
    return vim.tbl_deep_extend('force', {
        capabilities = capabilities,
        on_attach = on_attach,
    }, _config or {})
end

-- gopls
nvim_lsp.gopls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {'gopls', 'serve'},
    setting = {
        gopls = {
            gofumpt = true,
            analyses = {
                unreachable = true,
                unusedparams = true,
                nilness = true,
                shadow = true,
            },
            staticcheck = true,
        },
    },
}

-- tsserver
-- nvim_lsp.tsserver.setup{}
nvim_lsp.tsserver.setup(config())

-- elixir
nvim_lsp.elixirls.setup{
    cmd = {"/Users/vn53v0d/elixir/.elixir-ls/release/language_server.sh"},
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false,
            enableTestLenses = false,
            suggestSpecs = false,
        }
    }
}

-- eslint
-- nvim_lsp.eslint.setup{}
nvim_lsp.eslint.setup(config())

-- LSP autocomplete
-- luasnip setup
local luasnip = require('luasnip')

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    --completion = cmp.config.window.bordered(),
    --documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

function OrganizeImports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

-- Telescope
require('telescope').setup{
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            height = 0.95,
            width = 0.95,
        },
    },
}

-- tresitter
require('nvim-treesitter.configs').setup{
    ensure_installed = "elixir",
    sync_install = false,
    ignore_install = { },
    highlight = {
        enable = true,
        disable = { },
    },
}

