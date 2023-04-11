return {
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				view = { width = 50, side = 'right' },
				renderer = {
					icons = {
						show = {
							file = false,
							folder = false,
							folder_arrow = false
						}
					}
				}
			})
		end
	}
}
