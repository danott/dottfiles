-- tmux.lua
-- App-scoped tmux hotkeys for terminal emulators.
-- Require from init.lua: require("tmux")

local M = {}

-- Add any terminal emulators you use here.
local TERMINAL_APPS = {
  "Ghostty",
  "iTerm2",
  "Terminal",
  "Alacritty",
  "kitty",
}

local TMUX = "/opt/homebrew/bin/tmux"

-- Run a tmux command asynchronously, targeting the most recently active client.
local function tmux(...)
  hs.task.new(TMUX, nil, {...}):start()
end

-- Build a modal so keys are only intercepted when a terminal is focused.
-- Unbound keys pass through normally.
local modal = hs.hotkey.modal.new()

-- Window management
modal:bind({"cmd"}, "t", function() tmux("new-window") end)
modal:bind({"cmd"}, "w", function() tmux("kill-pane") end)

modal:bind({"cmd"}, ",", function()
  tmux("command-prompt", "-I", "#W", "rename-window '%%'")
end)

modal:bind({"cmd", "shift"}, ",", function()
  tmux("command-prompt", "-I", "#S", "rename-session '%%'")
end)

-- Window navigation
modal:bind({"cmd"}, "[", function() tmux("select-window", "-t", ":-") end)
modal:bind({"cmd"}, "]", function() tmux("select-window", "-t", ":+") end)

-- Pane splits
-- -h  = horizontal split (new pane to the right)
-- -hb = horizontal split before (new pane to the left)
-- -v  = vertical split (new pane below)
-- -vb = vertical split before (new pane above)
modal:bind({"cmd"}, "l", function() tmux("split-window", "-h")        end)
modal:bind({"cmd"}, "h", function() tmux("split-window", "-h", "-b")  end)
modal:bind({"cmd"}, "j", function() tmux("split-window", "-v")        end)
modal:bind({"cmd"}, "k", function() tmux("split-window", "-v", "-b")  end)

-- Window selection by index (cmd+1 through cmd+9)
for i = 1, 9 do
  local idx = tostring(i)
  modal:bind({"cmd"}, idx, function() tmux("select-window", "-t", ":" .. idx) end)
end

-- Helpers

local function isTerminal(appName)
  for _, name in ipairs(TERMINAL_APPS) do
    if appName == name then return true end
  end
  return false
end

-- Activate modal when a terminal gains focus; deactivate when it loses it.
M.watcher = hs.application.watcher.new(function(name, event, _app)
  if not isTerminal(name) then return end

  if event == hs.application.watcher.activated then
    modal:enter()
  elseif event == hs.application.watcher.deactivated then
    modal:exit()
  end
end)

M.watcher:start()

-- Handle the case where a terminal is already focused when Hammerspoon reloads.
local front = hs.application.frontmostApplication()
if front and isTerminal(front:name()) then
  modal:enter()
end

return M
