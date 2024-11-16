return {
	{
		'williamboman/mason.nvim',
		lazy = false,
		opts = {}
	},
	{
		'williamboman/mason-lspconfig.nvim',
		lazy = false,
		opts = {
			ensure_installed = { "lua_ls", "vtsls", "jsonls", "gopls" }
		}
	},
	{
		'neovim/nvim-lspconfig',
		lazy = false,
		dependencies = {
			{ 'j-hui/fidget.nvim', opts = {} },
			'folke/lazydev.nvim',
		},
		config = function()
			local lspconfig = require "lspconfig"
			local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

			lspconfig.denols.setup {
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern "deno.json", "deno.jsonc",
			}
			lspconfig.vtsls.setup {
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern "package.json", "tsconfig.json", "jsconfig.json",
				single_file_support = false
			}
			lspconfig.lua_ls.setup {
				capabilities = capabilities,
				settings = {
					Lua = {
						yorkspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				}
			}
		end
	}
}
