vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function()
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[D]efinition' })
    vim.keymap.set('n', 'gD', builtin.lsp_type_definitions, { desc = '[D]eclaration' })
    vim.keymap.set('n', 'gI', builtin.lsp_implementations, { desc = '[I]mplementation' })
    vim.keymap.set('n', 'gA', builtin.lsp_references, { desc = '[A]ll references' })
    vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, { desc = 'Buffer [S]ymbols' })
    vim.keymap.set('n', 'ge', function()
      builtin.diagnostics { bufnr = 0 }
    end, { desc = 'Buffer [E]rrors' })
    vim.keymap.set('n', 'gE', builtin.diagnostics, { desc = 'Project [E]rros' })
    vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', { desc = '[I]nfo' })
    vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { desc = '[R]estart' })
  end,
})
