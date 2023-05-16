require('nightfox').setup({
    options = {
        styles = {
            functions = "bold",
            comments = "italic",
            keywords = "bold",
            constants = "bold",
        },
    },
})

function ColorMePasi(color)
    color = color or 'nightfox'
    vim.cmd.colorscheme(color)

    -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

-- nordfox | terafox
ColorMePasi('terafox')
