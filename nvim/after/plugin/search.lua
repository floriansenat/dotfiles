local wk = require('which-key')
local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

pcall(telescope.load_extension, 'fzf')

-- [[Keymaps]]
vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	require('telescope.builtin').current_buffer_fuzzy_find(themes.get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = 'Fuzzily search in current buffer' })
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

wk.register({ ['<leader>s'] = { name = '[S]earch' } })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[F]iles' })
vim.keymap.set('n', '<leader>s?', builtin.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'With [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[D]iagnostics' })
vim.keymap.set('n', '<leader>se', function()
	require 'telescope.builtin'.find_files({ find_command = { 'rg', '--files', '-g', '.env*' } })
end, { desc = 'Search [E]nvs' })
