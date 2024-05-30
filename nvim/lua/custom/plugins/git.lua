return {
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			on_attach = function()
				local gs = package.loaded.gitsigns

				vim.keymap.set('n', ']c', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return '<Ignore>'
				end, { expr = true, desc = 'Next [H]unk' })

				vim.keymap.set('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, { expr = true, desc = 'Previous [H]unk' })
			end
		}
	},
}
