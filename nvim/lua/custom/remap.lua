vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>pe', vim.cmd.Ex, { silent = true, desc = "[E]xplorer" })
vim.keymap.set('n', '<leader>%', '<cmd>let @*=expand("%")<CR>', { desc = 'Copy file path' })

-- Delete current buffer, (keep window splits)
vim.keymap.set('n', '<leader>bq', '<cmd>bp|bd #<CR>', { silent = true, desc = '[Q]uit' })
vim.keymap.set('n', '<leader>bw', '<cmd>bw<CR>', { silent = true, desc = '[W]ipe' })

-- [[ Navigation ]]

-- Buffers
vim.keymap.set('n', '[b', ':bp<CR>', { silent = true, desc = 'Previous [B]uffer' })
vim.keymap.set('n', ']b', ':bn<CR>', { silent = true, desc = 'Next [B]uffer' })
vim.keymap.set('n', '[B', ':bf<CR>', { silent = true, desc = 'First [B]uffer' })
vim.keymap.set('n', ']B', ':bl<CR>', { silent = true, desc = 'Last [B]uffer' })

-- Tabs
vim.keymap.set('n', '[t', ':tabp<CR>', { silent = true, desc = 'Previous [T]ab' })
vim.keymap.set('n', ']t', ':tabn<CR>', { silent = true, desc = 'Next [T]ab' })

-- Use Shift + J/K to moves selected lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursor centered when moving
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

-- Keep current search result centered on the screen
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Keep cursor inplace while joining lines
vim.keymap.set('n', 'J', 'mzJ`z')

-- [[ Diagnostic ]]
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous [D]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next [D]iagnostic' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = '[D]iagnostic' })

-- [[ LSP ]]
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function()
		local fzf = require 'fzf-lua'

		-- Code Action
		vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = '[R]ename' })
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[A]ctions' })

		-- Documentation
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })

		-- Project
		vim.keymap.set('n', '<leader>ps', fzf.lsp_workspace_symbols, { desc = '[S]ymbols' })
		vim.keymap.set('n', '<leader>pd', function()
			fzf.lsp_workspace_diagnostics({ winopts = { preview = { layout = 'vertical' } } })
		end, { desc = '[D]iagnostic' })

		-- Buffer
		vim.keymap.set('n', '<leader>bf', vim.lsp.buf.format, { desc = '[F]ormat' })
		vim.keymap.set('n', '<leader>bs', fzf.lsp_document_symbols, { desc = '[S]ymbols' })
		vim.keymap.set('n', '<leader>bd', function()
			fzf.lsp_document_diagnostics({ winopts = { preview = { layout = 'vertical' } } })
		end, { desc = '[D]iagnostic' })

		-- Goto
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
		vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
		vim.keymap.set('n', 'gr', fzf.lsp_references, { desc = '[G]oto [R]eferences' })
	end
})
