local servers = {
	tssever = {},
	lua_ls = {
		Lua = {
			yorkspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	}
}

require('neodev').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('mason').setup()

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })

mason_lspconfig.setup_handlers({
	function(server_name)
		require('lspconfig')[server_name].setup({
			capabilities = capabilities,
			settings = servers[server_name]
		})
	end
})
