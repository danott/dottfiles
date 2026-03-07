-- tmux.lua
-- Hammerspoon side of the Ghostty+tmux keyboard integration.
--
-- This file works in concert with:
--   - ~/.config/tmux/ghostty-tmux-integration.conf  (registers tmux focus via hs CLI)
--
-- How it works:
--   Hammerspoon maintains a registry of Ghostty windows that have an active
--   tmux client. When a tmux client gains focus it calls registerFocus() via
--   the hs CLI. When a Ghostty window loses focus, Hammerspoon clears it from
--   the registry. On every keypress, if the focused window isn't in the
--   registry, keys pass through to Ghostty unchanged.
--
-- Install:
--   1. Run once in Hammerspoon console: hs.ipc.cliInstall()
--   2. Add to ~/.hammerspoon/init.lua: require("ghostty-tmux-integration")

local M = {}

local TMUX = "/opt/homebrew/bin/tmux"

-- Registry: { [windowId] = { tty, session } }
-- Only windows with active tmux clients appear here.
local registry = {}

-- Called by the tmux client-focus-in hook via:
--   hs -c "require('ghostty-tmux-integration').registerFocus('/dev/ttys003', 'mysession')"
function M.registerFocus(tty, session)
  local win = hs.window.focusedWindow()
  if not win then return end
  registry[win:id()] = { tty = tty, session = session }
end

-- Returns { tty, session } for the focused window if it has a tmux client,
-- otherwise nil.
local function frontmostTmuxInfo()
  local win = hs.window.focusedWindow()
  if not win then return nil end
  return registry[win:id()]
end

-- Clear registry entry when a Ghostty window loses focus.
M.windowFilter = hs.window.filter.new({ "Ghostty", "iTerm2" })
M.windowFilter:subscribe(hs.window.filter.windowUnfocused, function(win)
  registry[win:id()] = nil
end)

local function tmux(...)
  hs.task.new(TMUX, nil, {...}):start()
end

local CWD  = "-c"
local PCWD = "#{pane_current_path}"

local bindings = {
  -- Window management
  { {"cmd"},         "t", function(i) tmux("new-window",   "-t", i.session, CWD, PCWD) end },
  { {"cmd"},         "w", function(i) tmux("kill-pane",    "-t", i.session) end },
  { {"cmd"},         ",", function(i) tmux("command-prompt", "-t", i.tty, "-I", "#W", "rename-window '%%'") end },
  { {"cmd","shift"}, ",", function(i) tmux("command-prompt", "-t", i.tty, "-I", "#S", "rename-session '%%'") end },

  -- Window navigation
  { {"cmd","shift"}, "[", function(i) tmux("select-window", "-t", i.session .. ":-") end },
  { {"cmd","shift"}, "]", function(i) tmux("select-window", "-t", i.session .. ":+") end },

  -- Pane splits (new pane inherits cwd)
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

-- Exact modifier matching — bindings won't fire if extra modifiers are held.
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

local TERMINAL_APPS = { Ghostty = true, ["iTerm2"] = true }

M.tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local app = hs.application.frontmostApplication()
  if not app or not TERMINAL_APPS[app:name()] then return false end

  local info = frontmostTmuxInfo()
  if not info then return false end

  local flags = event:getFlags()
  local char  = hs.keycodes.map[event:getKeyCode()]

  for _, binding in ipairs(bindings) do
    local mods, key, action = binding[1], binding[2], binding[3]
    if char == key and modsMatch(flags, mods) then
      action(info)
      return true  -- consumed
    end
  end

  return false  -- pass through
end)

M.tap:start()

return M
