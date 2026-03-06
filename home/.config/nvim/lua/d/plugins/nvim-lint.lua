return {
  'mfussenegger/nvim-lint',
  config = function()
    local utils = require('d.utils')

    local luaLinters = { 'codespell' }
    if utils.config_exists('selene.toml') then
      table.insert(luaLinters, 'selene')
    end
    if utils.config_exists('.luacheckrc') then
      table.insert(luaLinters, 'luacheck')
    end

    require('lint').linters_by_ft = {
      ruby = { 'codespell' },
      javascript = { 'codespell' },
      javascriptreact = { 'codespell' },
      typescript = { 'codespell' },
      typescriptreact = { 'codespell' },
      lua = luaLinters,
    }
  end,
}
