return {
	'nvim-lualine/lualine.nvim',
	opts = {
		options = {
			always_divide_middle = false,
			icons_enabled = false,
			theme = 'everforest',
			component_separators = '|',
			section_separators = '',
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { 'filename' },
				lualine_x = {},
				lualine_y = { 'location' },
				lualine_z = { 'encoding', 'fileformat', 'filetype' },
			},
		},
	},
}
