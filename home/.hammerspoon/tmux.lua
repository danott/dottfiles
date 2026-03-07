-- tmux.lua
-- App-scoped tmux hotkeys for terminal emulators.
-- Require from init.lua: require("tmux")
--
-- ## How it works
--
-- Hammerspoon intercepts Cmd+key events only when the focused Ghostty window
-- is running an active tmux client. Detection uses two temp files as a
-- match test:
--
--   /tmp/ghostty-focused-window  — TTY of the currently focused Ghostty window
--   /tmp/tmux-focused-client     — TTY of the most recently focused tmux client
--
-- If both files contain the same TTY, the focused Ghostty window IS a tmux
-- client, and we intercept keys. If they differ (or one is missing), we pass
-- through — allowing normal OS/app behavior.
--
-- ## Who writes to each file
--
--   ghostty-focused-window: written by tmux client-focus-in hook (tmux windows)
--                           written by zsh _terminal_focus_in (non-tmux windows)
--   tmux-focused-client:    written by tmux client-focus-in hook
--                           written by updateFocusFile() when Ghostty switches
--                           windows via cmd+~ without triggering tmux focus events
--
-- ## Required ~/.tmux.conf
--   set -g focus-events on
--   set-hook -g client-focus-in "run-shell 'echo #{client_tty} > /tmp/tmux-focused-client && echo #{client_tty} > /tmp/ghostty-focused-window'"

local M = {}

local TMUX       = "/opt/homebrew/bin/tmux"
local TMUX_TTY_FILE = "/tmp/tmux-focused-client"

local TERMINAL_APPS = { "Ghostty" }

local function isTerminal()
  local app = hs.application.frontmostApplication()
  if not app then return false end
  local name = app:name()
  for _, n in ipairs(TERMINAL_APPS) do
    if name == n then return true end
  end
  return false
end

local GHOSTTY_TTY_FILE = "/tmp/ghostty-focused-window"

local function readFile(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local val = f:read("*l")
  f:close()
  if not val or val == "" then return nil end
  return val:match("^%s*(.-)%s*$")
end

-- Returns { tty, session } only when:
--   1. The focused Ghostty window's TTY (written by the shell on focus-in)
--   2. Matches the focused tmux client's TTY (written by tmux on client-focus-in)
-- If the focused Ghostty window is not running tmux, the TTYs won't match
-- and we return nil, allowing keys to pass through.
local function frontmostTmuxInfo()
  local ghosttyTty = readFile(GHOSTTY_TTY_FILE)
  if not ghosttyTty then return nil end

  local tmuxTty = readFile(TMUX_TTY_FILE)
  if not tmuxTty then return nil end

  if ghosttyTty ~= tmuxTty then return nil end

  local clientsOut = hs.execute(TMUX .. " list-clients -F '#{client_tty} #{session_name}' 2>/dev/null")
  if not clientsOut then return nil end

  for line in clientsOut:gmatch("[^\n]+") do
    local clientTty, session = line:match("^(%S+)%s+(.+)$")
    if clientTty == tmuxTty then
      return { tty = tmuxTty, session = session }
    end
  end

  return nil
end

-- When Hammerspoon detects a Ghostty window focus change, ask tmux which
-- client was most recently active and update the focus file. This covers
-- the case where Ghostty doesn't propagate focus events to tmux on window
-- switch (cmd+~), leaving the file stale.
local function updateFocusFile()
  local out = hs.execute(TMUX .. " list-clients -F '#{client_activity} #{client_tty}' 2>/dev/null | sort -rn | head -1")
  if not out or out == "" then return end
  local tty = out:match("%S+$")
  if not tty then return end
  local f = io.open(TMUX_TTY_FILE, "w")
  if f then f:write(tty .. "\n"); f:close() end
end

M.windowFilter = hs.window.filter.new("Ghostty")
M.windowFilter:subscribe(hs.window.filter.windowFocused, function()
  -- Brief delay to allow Ghostty to propagate focus to tmux first.
  -- If tmux fires the hook itself, it wins. If not, we fall back.
  hs.timer.doAfter(0.1, updateFocusFile)
end)

local function tmux(...)
  hs.task.new(TMUX, nil, {...}):start()
end

local CWD  = "-c"
local PCWD = "#{pane_current_path}"

-- Bindings table: { mods, key, action(info) }
-- mods must match exactly — no extra modifiers.
local bindings = {
  -- Window management
  { {"cmd"},         "n", function(_) end }, -- prevent new OS window when tmux is running
  { {"cmd"},         "t", function(i) tmux("new-window", "-t", i.session, CWD, PCWD) end },
  { {"cmd"},         "w", function(i) tmux("kill-pane", "-t", i.session) end },
  { {"cmd"},         ",", function(i) tmux("command-prompt", "-t", i.tty, "-I", "#W", "rename-window '%%'") end },
  { {"cmd","shift"}, ",", function(i) tmux("command-prompt", "-t", i.tty, "-I", "#S", "rename-session '%%'") end },

  -- Window navigation
  { {"cmd"}, "[", function(i) tmux("select-window", "-t", i.session .. ":-") end },
  { {"cmd"}, "]", function(i) tmux("select-window", "-t", i.session .. ":+") end },

  -- Pane splits
  { {"cmd"}, "l", function(i) tmux("split-window", "-h",       "-t", i.session, CWD, PCWD) end }, -- right
  { {"cmd"}, "h", function(i) tmux("split-window", "-h", "-b", "-t", i.session, CWD, PCWD) end }, -- left
  { {"cmd"}, "j", function(i) tmux("split-window", "-v",       "-t", i.session, CWD, PCWD) end }, -- down
  { {"cmd"}, "k", function(i) tmux("split-window", "-v", "-b", "-t", i.session, CWD, PCWD) end }, -- up
}

-- Window selection by index (cmd+1 through cmd+9)
for n = 1, 9 do
  local idx = tostring(n)
  table.insert(bindings, {
    {"cmd"}, idx,
    function(i) tmux("select-window", "-t", i.session .. ":" .. idx) end
  })
end

-- Check that the event's modifiers match exactly.
local ALL_MODS = { "cmd", "ctrl", "alt", "shift", "fn" }

local function modsMatch(flags, mods)
  local want = {}
  for _, m in ipairs(mods) do want[m] = true end
  for _, m in ipairs(ALL_MODS) do
    if (flags[m] and not want[m]) or (not flags[m] and want[m]) then
      return false
    end
  end
  return true
end

M.tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if not isTerminal() then return false end

  local info = frontmostTmuxInfo()
  if not info then return false end

  local flags = event:getFlags()
  local char  = hs.keycodes.map[event:getKeyCode()]

  for _, binding in ipairs(bindings) do
    local mods, key, action = binding[1], binding[2], binding[3]
    if char == key and modsMatch(flags, mods) then
      action(info)
      return true  -- consume the event
    end
  end

  return false  -- pass through
end)

M.tap:start()

return M
