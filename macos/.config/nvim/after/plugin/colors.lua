-- require('rose-pine').setup({
--     dark_variante = 'moon',
--     disable_background = true,
--     dim_nc_background = false,
--     disable_float_background = true,
-- })

require('nightfox').setup({
    palettes = {
        nordfox = {},
    },
})

function ColorMyPencils(color)
    color = color or 'nightfox'
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

ColorMyPencils()
