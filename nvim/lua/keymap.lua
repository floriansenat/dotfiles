vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>e', vim.cmd.Ex, { silent = true, desc = "[E]xplorer" })

--
---:: Movements ::---
--
-- Use Shift + J/K to moves selected lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
-- Keep cursor centered when moving
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z') -- Keep cursor inplace while joining lines

--
---:: Buffers ::---
--
vim.keymap.set('n', '<leader>q', ':bp|bd #<CR>', { silent = true, desc = '[Q]uit' }) -- (keep window splits)
vim.keymap.set('n', '[b', ':bp<CR>', { silent = true, desc = 'Previous [B]uffer' })
vim.keymap.set('n', ']b', ':bn<CR>', { silent = true, desc = 'Next [B]uffer' })
vim.keymap.set('n', '[B', ':bf<CR>', { silent = true, desc = 'First [B]uffer' })
vim.keymap.set('n', ']B', ':bl<CR>', { silent = true, desc = 'Last [B]uffer' })


--
---:: Tabs ::---
--
vim.keymap.set('n', '[t', ':tabp<CR>', { silent = true, desc = 'Previous [T]ab' })
vim.keymap.set('n', ']t', ':tabn<CR>', { silent = true, desc = 'Next [T]ab' })

--
---:: Diagnostics ::---
--
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { silent = true, desc = 'Previous [D]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { silent = true, desc = 'Next [D]iagnostic' })
vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { desc = 'Show inline error' })


--
---:: Quickfix ::---
--
vim.keymap.set('n', '[q', ':cprev<CR>', { silent = true, desc = 'Previous [Q]uickfix Item' })
vim.keymap.set('n', ']q', ':cnext<CR>', { silent = true, desc = 'Next [Q]uickfix Item' })
vim.keymap.set('n', '[Q', ':cfirst<CR>', { silent = true, desc = 'First [Q]uickfix Item' })
vim.keymap.set('n', ']Q', ':clast<CR>', { silent = true, desc = 'Last [Q]uickfix Item' })
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { silent = true, desc = '[O]pen' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { silent = true, desc = '[C]lose' })

--
---:: Files ::---
--
vim.api.nvim_create_user_command('Reveal',
	function()
		local path = vim.api.nvim_buf_get_name(0)
		os.execute('open -R ' .. path)
	end,
	{}
)
vim.keymap.set('n', '<leader>fr', '<cmd>Reveal<CR>', { desc = '[R]eveal in finder' })
vim.keymap.set('n', '<leader>f/', '<cmd>let @*=expand("%")<CR>', { desc = 'Copy relative path' })
vim.keymap.set('n', '<leader>f%', '<cmd>let @*=expand("%:t")<CR>', { desc = 'Copy name' })

--
---:: LSP ::---
--
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function()
		local builtin = require('telescope.builtin')

		vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
		vim.keymap.set('n', 'g.', vim.lsp.buf.code_action, { desc = '[A]ctions' })
		vim.keymap.set('n', 'gr', vim.lsp.buf.rename, { desc = '[R]ename' })
		vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[D]efinition' })
		vim.keymap.set('n', 'gD', builtin.lsp_type_definitions, { desc = '[D]eclaration' })
		vim.keymap.set('n', 'gI', builtin.lsp_implementations, { desc = '[I]mplementation' })
		vim.keymap.set('n', 'gA', builtin.lsp_references, { desc = '[A]ll references' })
		vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, { desc = 'Buffer [S]ymbols' })
		vim.keymap.set('n', 'ge', function() builtin.diagnostics({ bufnr = 0 }) end, { desc = 'Buffer [E]rrors' })
		vim.keymap.set('n', 'gE', builtin.diagnostics, { desc = 'Project [E]rros' })

		vim.keymap.set('n', '<leader>li', "<cmd>LspInfo<CR>", { desc = '[I]nfo' })
		vim.keymap.set('n', '<leader>lr', "<cmd>LspRestart<CR>", { desc = '[R]estart' })
	end
})
