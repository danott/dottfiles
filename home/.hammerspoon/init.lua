-- Check if the focused window title contains the tmux marker (▦)
-- Customize the title format in ~/.tmux.conf set-titles-string, just keep the ▦
local function inTmux()
  local win = hs.window.focusedWindow()
  if not win then return false end
  local title = win:title() or ""
  return title:find("▦") ~= nil
end

-- Hotkeys only active when Ghostty is focused
local ghosttyKeys = {}

local function bind(mods, key, tmuxKey, fallthrough)
  local hk
  hk = hs.hotkey.new(mods, key, function()
    if inTmux() then
      local app = hs.application.frontmostApplication()
      hs.eventtap.keyStroke({ "ctrl" }, "t", 0, app)
      hs.eventtap.keyStroke({}, tmuxKey, 0, app)
    elseif fallthrough then
      hk:disable()
      hs.eventtap.keyStroke(mods, key)
      hs.timer.doAfter(0.05, function() hk:enable() end)
    end
  end)
  table.insert(ghosttyKeys, hk)
end

bind({ "cmd" }, "t", "c", true)
bind({ "cmd" }, "h", "h", true)
bind({ "cmd" }, "j", "j", true)
bind({ "cmd" }, "k", "k", true)
bind({ "cmd" }, "l", "l", true)
bind({ "cmd" }, "[", "p", true)
bind({ "cmd" }, "]", "n", true)
bind({ "cmd" }, ",", ",", true)
bind({ "cmd" }, "w", "x", true)
-- cmd+shift+, → rename tmux session (ctrl-t $)
local renameSession
renameSession = hs.hotkey.new({ "cmd", "shift" }, ",", function()
  if inTmux() then
    local app = hs.application.frontmostApplication()
    hs.eventtap.keyStroke({ "ctrl" }, "t", 0, app)
    hs.eventtap.keyStroke({ "shift" }, "4", 0, app)
  elseif true then
    renameSession:disable()
    hs.eventtap.keyStroke({ "cmd", "shift" }, ",")
    hs.timer.doAfter(0.05, function() renameSession:enable() end)
  end
end)
table.insert(ghosttyKeys, renameSession)

for i = 1, 9 do
  bind({ "cmd" }, tostring(i), tostring(i))
end

local function enableKeys()
  for _, hk in ipairs(ghosttyKeys) do hk:enable() end
end

local function disableKeys()
  for _, hk in ipairs(ghosttyKeys) do hk:disable() end
end

-- Activate on Ghostty focus, deactivate on anything else
local watcher = hs.application.watcher.new(function(name, event)
  if name == "Ghostty" then
    if event == hs.application.watcher.activated then
      enableKeys()
    elseif event == hs.application.watcher.deactivated then
      disableKeys()
    end
  end
end)
watcher:start()

-- Enable immediately if Ghostty is already focused
if hs.application.frontmostApplication():name() == "Ghostty" then
  enableKeys()
end

-- Reload config
hs.hotkey.bind({ "cmd", "shift" }, "r", function()
  hs.reload()
end)
hs.alert.show("Hammerspoon loaded")
