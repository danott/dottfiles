require("hs.ipc")
require("ghostty-tmux-integration")

-- Reload config
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "r", function()
  hs.reload()
end)
hs.alert.show("Hammerspoon loaded")
