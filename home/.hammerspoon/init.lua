require("hs.ipc")
require("ghostty-tmux-integration")

-- Reload config
hs.hotkey.bind({ "cmd", "shift" }, "r", function()
  hs.reload()
end)
hs.alert.show("Hammerspoon loaded")
