require 'neodev'.setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require 'cmp_nvim_lsp'.default_capabilities(capabilities)

local lspconfig = require 'lspconfig'
local handlers = {
	function(server_name)
		lspconfig[server_name].setup {
			capabilities = capabilities
		}
	end,
	['denols'] = function()
		lspconfig.denols.setup {
			root_dir = lspconfig.util.root_pattern "deno.json", "deno.jsonc",
		}
	end,
	['vtsls'] = function()
		lspconfig.vtsls.setup {
			root_dir = lspconfig.util.root_pattern "package.json", "tsconfig.json", "jsconfig.json",
			single_file_support = false
		}
	end,
	['lua_ls'] = function()
		lspconfig.lua_ls.setup {
			settings = {
				Lua = {
					yorkspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			}
		}
	end
}

require 'mason'.setup()
require 'mason-lspconfig'.setup { ensure_installed = { "lua_ls", "vtsls", "jsonls", "gopls" }, handlers = handlers }
