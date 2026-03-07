-- Check if the focused window title contains the tmux marker (▦)
-- Customize the title format in ~/.tmux.conf set-titles-string, just keep the ▦
local function inTmux()
  local win = hs.window.focusedWindow()
  if not win then return false end
  local title = win:title() or ""
  return title:find("▦") ~= nil
end

local function isGhostty()
  local app = hs.application.frontmostApplication()
  return app and app:name() == "Ghostty"
end

-- Hotkeys are always enabled; handlers check frontmost app at keypress time.
-- This avoids enable/disable race conditions during cmd+tab switching.
local function bind(mods, key, tmuxKey, fallthrough)
  local hk
  hk = hs.hotkey.bind(mods, key, function()
    if not isGhostty() then
      hk:disable()
      hs.eventtap.keyStroke(mods, key)
      hs.timer.doAfter(0.05, function() hk:enable() end)
    elseif inTmux() then
      local app = hs.application.frontmostApplication()
      hs.eventtap.keyStroke({ "ctrl" }, "t", 0, app)
      hs.eventtap.keyStroke({}, tmuxKey, 0, app)
    elseif fallthrough then
      hk:disable()
      hs.eventtap.keyStroke(mods, key)
      hs.timer.doAfter(0.05, function() hk:enable() end)
    end
  end)
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
renameSession = hs.hotkey.bind({ "cmd", "shift" }, ",", function()
  if not isGhostty() then
    renameSession:disable()
    hs.eventtap.keyStroke({ "cmd", "shift" }, ",")
    hs.timer.doAfter(0.05, function() renameSession:enable() end)
  elseif inTmux() then
    local app = hs.application.frontmostApplication()
    hs.eventtap.keyStroke({ "ctrl" }, "t", 0, app)
    hs.eventtap.keyStroke({ "shift" }, "4", 0, app)
  else
    renameSession:disable()
    hs.eventtap.keyStroke({ "cmd", "shift" }, ",")
    hs.timer.doAfter(0.05, function() renameSession:enable() end)
  end
end)

for i = 1, 9 do
  bind({ "cmd" }, tostring(i), tostring(i))
end
