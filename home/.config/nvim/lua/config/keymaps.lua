-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Seamless navigation between vim splits and tmux panes with Ctrl+hjkl
local function navigate(direction, tmux_direction)
  return function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd("wincmd " .. direction)
    if vim.api.nvim_get_current_win() == win then
      vim.fn.system("tmux select-pane -" .. tmux_direction)
    end
  end
end

vim.keymap.set("n", "<C-h>", navigate("h", "L"), { desc = "Navigate left" })
vim.keymap.set("n", "<C-j>", navigate("j", "D"), { desc = "Navigate down" })
vim.keymap.set("n", "<C-k>", navigate("k", "U"), { desc = "Navigate up" })
vim.keymap.set("n", "<C-l>", navigate("l", "R"), { desc = "Navigate right" })
