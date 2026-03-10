-- tmux.lua
-- Hammerspoon side of the Ghostty+tmux keyboard integration.
--
-- This file works in concert with:
--   - ~/.config/tmux/ghostty-tmux-integration.conf  (registers tmux sessions via hs CLI)
--
-- How it works:
--   Hammerspoon maintains a set of known tmux session names. When a tmux
--   client gains focus it calls registerSession() via the hs CLI to add
--   that session to the set. On every keypress, the focused window's title
--   (set by tmux to #{session_name}) is checked against the set. If the
--   session is known, hotkeys are intercepted and translated to tmux
--   commands targeting that session. Otherwise keys pass through unchanged.
--
-- Install:
--   1. Run once in Hammerspoon console: hs.ipc.cliInstall()
--   2. Add to ~/.hammerspoon/init.lua: require("ghostty-tmux-integration")

local M = {}

local TMUX = "/opt/homebrew/bin/tmux"

-- Set of known tmux session names.
local sessions = {}

-- Called by the tmux client-focus-in hook via:
--   hs -c "require('ghostty-tmux-integration').registerSession('session_name')"
function M.registerSession(session)
  sessions[session] = true
end

-- Called by the tmux client-detached hook via:
--   hs -c "require('ghostty-tmux-integration').unregisterSession('session_name')"
function M.unregisterSession(session)
  sessions[session] = nil
end

-- Backwards-compatible aliases for existing tmux hooks during transition.
function M.registerFocus(tty, session)
  M.registerSession(session)
end

function M.unregisterFocus(tty)
  -- Look up session by tty from tmux if needed, but the session-renamed
  -- and client-session-changed hooks keep the set current anyway.
end

-- Returns the tmux session name for the focused window, or nil.
local function frontmostSession()
  local win = hs.window.focusedWindow()
  if not win then return nil end
  local title = win:title()
  if sessions[title] then return title end
  return nil
end

-- Debug: call from Hammerspoon console to inspect state
-- hs -c "require('ghostty-tmux-integration').debug()"
function M.debug()
  local win = hs.window.focusedWindow()
  local title = win and win:title() or "(no window)"
  local winId = win and win:id() or "(none)"
  local lines = { "Window ID: " .. tostring(winId), "Window title: " .. title, "Sessions:" }
  for session in pairs(sessions) do
    table.insert(lines, "  " .. session)
  end
  local msg = table.concat(lines, "\n")
  print(msg)
  return msg
end

-- When a tmux command fails (e.g. server gone), remove the session from
-- the set and replay the keystroke so it passes through to the app natively.
local replayEvent = nil

local function tmux(session, mods, key, ...)
  hs.task.new(TMUX, function(exitCode)
    if exitCode ~= 0 and session then
      sessions[session] = nil
      replayEvent = true
      hs.eventtap.keyStroke(mods, key)
    end
  end, {...}):start()
end

local CWD  = "-c"
local PCWD = "#{pane_current_path}"

local bindings = {
  -- Window management
  { {"cmd"},         "t", function(s, m, k) tmux(s, m, k, "new-window",   "-t", s .. ":", CWD, PCWD) end },
  { {"cmd"},         "w", function(s, m, k) tmux(s, m, k, "kill-pane",    "-t", s) end },
  { {"cmd"},         ",", function(s, m, k) tmux(s, m, k, "command-prompt", "-t", s, "-I", "#W", "rename-window '%%'") end },
  { {"cmd","shift"}, ",", function(s, m, k) tmux(s, m, k, "command-prompt", "-t", s, "-I", "#S", "rename-session '%%'") end },

  -- Window navigation
  { {"cmd","shift"}, "[", function(s, m, k) tmux(s, m, k, "select-window", "-t", s .. ":-") end },
  { {"cmd","shift"}, "]", function(s, m, k) tmux(s, m, k, "select-window", "-t", s .. ":+") end },

  -- Pane splits (new pane inherits cwd)
  -- Ghostty native: Cmd+D = Split Right, Shift+Cmd+D = Split Down
  { {"cmd"},         "d", function(s, m, k) tmux(s, m, k, "split-window", "-h",       "-t", s, CWD, PCWD) end }, -- right
  { {"cmd","shift"}, "d", function(s, m, k) tmux(s, m, k, "split-window", "-v",       "-t", s, CWD, PCWD) end }, -- down
  -- vim-style aliases
  { {"cmd"}, "l", function(s, m, k) tmux(s, m, k, "split-window", "-h",       "-t", s, CWD, PCWD) end }, -- right
  { {"cmd"}, "h", function(s, m, k) tmux(s, m, k, "split-window", "-h", "-b", "-t", s, CWD, PCWD) end }, -- left
  { {"cmd"}, "j", function(s, m, k) tmux(s, m, k, "split-window", "-v",       "-t", s, CWD, PCWD) end }, -- down
  { {"cmd"}, "k", function(s, m, k) tmux(s, m, k, "split-window", "-v", "-b", "-t", s, CWD, PCWD) end }, -- up

  -- Pane zoom: Ghostty "Zoom Split" = Shift+Cmd+Enter
  { {"cmd","shift"}, "return", function(s, m, k) tmux(s, m, k, "resize-pane", "-Z", "-t", s) end },

  -- Pane navigation: Ghostty "Select Split" = Opt+Cmd+Arrow
  { {"cmd","alt"}, "right", function(s, m, k) tmux(s, m, k, "select-pane", "-t", s, "-R") end },
  { {"cmd","alt"}, "left",  function(s, m, k) tmux(s, m, k, "select-pane", "-t", s, "-L") end },
  { {"cmd","alt"}, "down",  function(s, m, k) tmux(s, m, k, "select-pane", "-t", s, "-D") end },
  { {"cmd","alt"}, "up",    function(s, m, k) tmux(s, m, k, "select-pane", "-t", s, "-U") end },

  -- Pane resize: Ghostty "Move Divider" = Ctrl+Cmd+Arrow
  { {"cmd","ctrl"}, "right", function(s, m, k) tmux(s, m, k, "resize-pane", "-t", s, "-R", "5") end },
  { {"cmd","ctrl"}, "left",  function(s, m, k) tmux(s, m, k, "resize-pane", "-t", s, "-L", "5") end },
  { {"cmd","ctrl"}, "down",  function(s, m, k) tmux(s, m, k, "resize-pane", "-t", s, "-D", "5") end },
  { {"cmd","ctrl"}, "up",    function(s, m, k) tmux(s, m, k, "resize-pane", "-t", s, "-U", "5") end },
}

-- Window selection by index (cmd+1 through cmd+9)
for n = 1, 9 do
  local idx = tostring(n)
  table.insert(bindings, {
    {"cmd"}, idx,
    function(s, m, k) tmux(s, m, k, "select-window", "-t", s .. ":" .. idx) end
  })
end

-- Exact modifier matching — bindings won't fire if extra modifiers are held.
-- fn is excluded: macOS sets fn=true for arrow keys, which would break arrow bindings.
local ALL_MODS = { "cmd", "ctrl", "alt", "shift" }

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

local TERMINAL_APPS = { Ghostty = true, ["iTerm2"] = true }

M.tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if replayEvent then
    replayEvent = nil
    return false  -- let the replayed keystroke pass through
  end

  local app = hs.application.frontmostApplication()
  if not app or not TERMINAL_APPS[app:name()] then return false end

  local session = frontmostSession()
  if not session then return false end

  local flags = event:getFlags()
  local char  = hs.keycodes.map[event:getKeyCode()]

  for _, binding in ipairs(bindings) do
    local mods, key, action = binding[1], binding[2], binding[3]
    if char == key and modsMatch(flags, mods) then
      action(session, mods, key)
      return true  -- consumed
    end
  end

  return false  -- pass through
end)

M.tap:start()

return M
