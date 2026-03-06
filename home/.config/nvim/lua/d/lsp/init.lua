local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('DanLspAttach', {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      local bufnr = args.buf

      if client.name == 'copilot' then
        return
      end

      local function opts(desc)
        return { buffer = bufnr, desc = desc }
      end

      vim.keymap.set('n', 'gld', vim.lsp.buf.definition, opts('goto definitions'))
      vim.keymap.set('n', 'gly', vim.lsp.buf.type_definition, opts('goto type definitions'))
      vim.keymap.set('n', 'glt', '<cmd>execute "normal! <C-]>"<cr>', opts('tag jump'))
      vim.keymap.set('n', 'glD', vim.lsp.buf.declaration, opts('goto declaration'))
      vim.keymap.set('n', 'gli', vim.lsp.buf.implementation, opts('goto implementations'))
      vim.keymap.set('n', 'glr', vim.lsp.buf.references, opts('goto references'))
      vim.keymap.set('n', 'glS', vim.lsp.buf.signature_help, opts('signature help'))
      vim.keymap.set('n', 'gls', vim.lsp.buf.document_symbol, opts('document symbols'))
      vim.keymap.set('n', 'glw', vim.lsp.buf.workspace_symbol, opts('workspace symbols'))
      vim.keymap.set('n', 'gll', vim.lsp.codelens.run, opts('codelens run'))
      vim.keymap.set('n', 'glR', vim.lsp.buf.rename, opts('rename'))
      vim.keymap.set('n', 'glf', vim.lsp.buf.format, opts('format'))
      vim.keymap.set('n', 'glc', vim.lsp.buf.incoming_calls, opts('incoming calls'))
      vim.keymap.set('n', 'glC', vim.lsp.buf.outgoing_calls, opts('outgoing calls'))
      vim.keymap.set('n', 'glh', vim.lsp.buf.typehierarchy, opts('type hierarchy'))
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('hover'))
      vim.keymap.set('n', 'glK', vim.lsp.buf.hover, opts('hover'))
      vim.keymap.set({ 'n', 'v' }, 'gla', vim.lsp.buf.code_action, opts('code actions'))

      -- inlay hints
      vim.keymap.set('n', 'glH', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, opts('toggle inlay hints'))

      if client:supports_method('textDocument/inlayHint') then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      if client:supports_method('textDocument/codeLens') then
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
      end
    end,
  })

  vim.lsp.enable({
    'bashls',
    'cssls',
    'html',
    'jsonls',
    'lua_ls',
    'tailwindcss',
    'vimls',
    'yamlls',
  })
end

return M
