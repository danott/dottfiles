return {
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = '1.*',
  opts = {
    keymap = {
      preset = 'default',
      ['<Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up' },
      ['<C-d>'] = { 'scroll_documentation_down' },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },

    cmdline = {
      completion = {
        menu = {
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
            },
          },
          auto_show = true,
        },
      },
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == '/' or type == '?' then
          return { 'buffer' }
        end
        if type == ':' or type == '@' then
          return { 'cmdline', 'buffer' }
        end
        return {}
      end,
    },

    sources = {
      default = { 'lsp', 'snippets', 'buffer', 'path' },
      per_filetype = {
        markdown = {},
        gitcommit = {},
      },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
}
