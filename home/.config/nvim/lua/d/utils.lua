local M = {}

function M.config_exists(filename)
  local file = vim.fn.getcwd() .. '/' .. filename
  return vim.fn.filereadable(file) == 1
end

return M
