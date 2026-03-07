-- tmux.lua
-- App-scoped tmux hotkeys for terminal emulators.
-- Require from init.lua: require("tmux")
--
-- Keys are only consumed when:
--   1. A terminal emulator is frontmost
--   2. A tmux server is running (otherwise keys fall through to the app)

local M = {}

local TMUX = "/opt/homebrew/bin/tmux"

-- Add any terminal emulators you use here.
local TERMINAL_APPS = {
  "Ghostty",
}

local function isTerminal()
  local app = hs.application.frontmostApplication()
  if not app then return false end
  local name = app:name()
  for _, n in ipairs(TERMINAL_APPS) do
    if name == n then return true end
  end
  return false
end

local function tmuxRunning()
  local _, ok = hs.execute(TMUX .. " list-sessions 2>/dev/null")
  return ok
end

local function tmux(...)
  hs.task.new(TMUX, nil, {...}):start()
end

-- Bindings table: { mods, key, action }
-- mods must match exactly — no extra modifiers.
local bindings = {
  -- Window management
  { {"cmd"},         "t", function() tmux("new-window") end },
  { {"cmd"},         "w", function() tmux("kill-pane") end },
  { {"cmd"},         ",", function() tmux("command-prompt", "-I", "#W", "rename-window '%%'") end },
  { {"cmd","shift"}, ",", function() tmux("command-prompt", "-I", "#S", "rename-session '%%'") end },

  -- Window navigation
  { {"cmd"}, "[", function() tmux("select-window", "-t", ":-") end },
  { {"cmd"}, "]", function() tmux("select-window", "-t", ":+") end },

  -- Pane splits
  { {"cmd"}, "l", function() tmux("split-window", "-h")       end }, -- right
  { {"cmd"}, "h", function() tmux("split-window", "-h", "-b") end }, -- left
  { {"cmd"}, "j", function() tmux("split-window", "-v")       end }, -- down
  { {"cmd"}, "k", function() tmux("split-window", "-v", "-b") end }, -- up
}

-- Window selection by index (cmd+1 through cmd+9)
for i = 1, 9 do
  local idx = tostring(i)
  table.insert(bindings, { {"cmd"}, idx, function() tmux("select-window", "-t", ":" .. idx) end })
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
  if not tmuxRunning() then return false end

  local flags = event:getFlags()
  local char  = hs.keycodes.map[event:getKeyCode()]

  for _, binding in ipairs(bindings) do
    local mods, key, action = binding[1], binding[2], binding[3]
    if char == key and modsMatch(flags, mods) then
      action()
      return true  -- consume the event
    end
  end

  return false  -- pass through
end)

M.tap:start()

return M
