local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gg', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

require('telescope').setup{
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            height = 0.95,
            width = 0.95,
        },
        -- file_ignore_patterns = { 'vendor' },
    },
}
