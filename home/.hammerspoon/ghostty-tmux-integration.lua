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

-- Called by the tmux client-detached hook via:
--   hs -c "require('ghostty-tmux-integration').unregisterFocus('/dev/ttys003')"
function M.unregisterFocus(tty)
  for id, info in pairs(registry) do
    if info.tty == tty then
      registry[id] = nil
      return
    end
  end
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
  -- Ghostty native: Cmd+D = Split Right, Shift+Cmd+D = Split Down
  { {"cmd"},         "d", function(i) tmux("split-window", "-h",       "-t", i.session, CWD, PCWD) end }, -- right
  { {"cmd","shift"}, "d", function(i) tmux("split-window", "-v",       "-t", i.session, CWD, PCWD) end }, -- down
  -- vim-style aliases
  { {"cmd"}, "l", function(i) tmux("split-window", "-h",       "-t", i.session, CWD, PCWD) end }, -- right
  { {"cmd"}, "h", function(i) tmux("split-window", "-h", "-b", "-t", i.session, CWD, PCWD) end }, -- left
  { {"cmd"}, "j", function(i) tmux("split-window", "-v",       "-t", i.session, CWD, PCWD) end }, -- down
  { {"cmd"}, "k", function(i) tmux("split-window", "-v", "-b", "-t", i.session, CWD, PCWD) end }, -- up

  -- Pane zoom: Ghostty "Zoom Split" = Shift+Cmd+Enter
  { {"cmd","shift"}, "return", function(i) tmux("resize-pane", "-Z", "-t", i.tty) end },

  -- Pane navigation: Ghostty "Select Split" = Opt+Cmd+Arrow
  { {"cmd","alt"}, "right", function(i) tmux("select-pane", "-t", i.session, "-R") end },
  { {"cmd","alt"}, "left",  function(i) tmux("select-pane", "-t", i.session, "-L") end },
  { {"cmd","alt"}, "down",  function(i) tmux("select-pane", "-t", i.session, "-D") end },
  { {"cmd","alt"}, "up",    function(i) tmux("select-pane", "-t", i.session, "-U") end },

  -- Pane resize: Ghostty "Move Divider" = Ctrl+Cmd+Arrow
  { {"cmd","ctrl"}, "right", function(i) tmux("resize-pane", "-t", i.session, "-R", "5") end },
  { {"cmd","ctrl"}, "left",  function(i) tmux("resize-pane", "-t", i.session, "-L", "5") end },
  { {"cmd","ctrl"}, "down",  function(i) tmux("resize-pane", "-t", i.session, "-D", "5") end },
  { {"cmd","ctrl"}, "up",    function(i) tmux("resize-pane", "-t", i.session, "-U", "5") end },
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
  local app = hs.application.frontmostApplication()
  if not app or not TERMINAL_APPS[app:name()] then return false end

  local info = frontmostTmuxInfo()
  if not info then return false end

  local flags = event:getFlags()
  local char  = hs.keycodes.map[event:getKeyCode()]

  local win = hs.window.focusedWindow()

  for _, binding in ipairs(bindings) do
    local mods, key, action = binding[1], binding[2], binding[3]
    if char == key and modsMatch(flags, mods) then
      -- Validate the session still exists before consuming the event.
      -- When tmux exits, the server shuts down before hooks can unregister,
      -- so we verify here rather than relying solely on client-detached.
      local _, ok = hs.execute(TMUX .. " has-session -t " .. info.session .. " 2>/dev/null")
      if not ok then
        registry[win:id()] = nil
        return false  -- pass through (e.g. cmd+w closes the Ghostty window)
      end
      action(info)
      return true  -- consumed
    end
  end

  return false  -- pass through
end)

M.tap:start()

return M
