return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "neckbeard",
    },
  },

  -- Disable LSP semantic token highlighting (it overrides treesitter/colorscheme)
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })
    end,
  },
}
