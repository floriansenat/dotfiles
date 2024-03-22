return {
	"ibhagwan/fzf-lua",
	config = function()
		local fzf = require 'fzf-lua'

		fzf.setup({ winopts = { fullscreen = true } })

		-- Common
		vim.keymap.set('n', '<C-p>', fzf.files)
		vim.keymap.set('n', '<leader>?', fzf.man_pages, { desc = 'Man pages' })
		vim.keymap.set('n', '<leader>/', fzf.search_history, { desc = 'Search history' })
		vim.keymap.set('n', '<leader>:', fzf.command_history, { desc = 'Command history' })
		vim.keymap.set('n', '<leader><space>', fzf.buffers, { desc = 'Opened buffers' })

		-- Grep
		vim.keymap.set('n', '<leader>sg', fzf.grep, { desc = '[G]rep' })
		vim.keymap.set('n', '<leader>sl', fzf.live_grep, { desc = '[L]ive' })
		vim.keymap.set('n', '<leader>sc', fzf.grep_cword, { desc = '[C]ursor' })
		vim.keymap.set('n', '<leader>sr', fzf.live_grep_resume, { desc = '[R]esume' })

		-- Buffer
		vim.keymap.set('n', '<leader>bg', fzf.lgrep_curbuf, { desc = '[G]rep' })
	end
}
