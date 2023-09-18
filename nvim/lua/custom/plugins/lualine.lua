return {
	'nvim-lualine/lualine.nvim',
	opts = {
		options = {
			icons_enabled = false,
			theme = 'rose-pine',
			component_separators = '',
			section_separators = '',
		},
		sections = {
			lualine_a = { 'mode' },
			lualine_b = { 'diff', 'diagnostics' },
			lualine_c = { '%=', { 'filename', path = 1 } },
			lualine_x = {},
			lualine_y = { 'encoding', 'fileformat', 'filetype' },
			lualine_z = { 'branch' },
		},
	},
}
