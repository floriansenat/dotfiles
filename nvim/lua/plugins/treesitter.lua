return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
	config = function()
		pcall(require('nvim-treesitter.install').update({ with_sync = true }))

		require('nvim-treesitter.configs').setup({
			ensure_installed = {
				'lua',
				'rust',
				'tsx',
				'typescript',
				'help',
				'vim',
				'markdown',
				'markdown_inline',
				'html',
				'javascript',
				'json',
			},
			highlight = { enable = true },
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
				},
			},
		})
	end,
}
