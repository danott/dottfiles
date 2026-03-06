local M = {}

function M.config_exists(filename)
  local file = vim.fn.getcwd() .. '/' .. filename
  return vim.fn.filereadable(file) == 1
end

function M.toggle_qf()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists then
    vim.cmd('cclose')
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd('copen')
  else
    vim.notify('quickfix list is empty', vim.log.levels.WARN)
  end
end

function M.toggle_loclist()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win['loclist'] == 1 then
      vim.cmd('lclose')
      return
    end
  end

  if next(vim.fn.getloclist(0)) == nil then
    vim.notify('location list empty', vim.log.levels.WARN)
    return
  end
  vim.cmd('lopen')
end

return M
