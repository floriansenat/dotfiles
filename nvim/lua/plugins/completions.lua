return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
	opts = function()
		local cmp = require "cmp"
		return {
			mapping = cmp.mapping.preset.insert {
				["<C-Space>"] = cmp.mapping.complete {},
				["<CR>"] = cmp.mapping.confirm { select = true },
				["S-<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace },
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = 'path' },
			},
		}
	end
}
