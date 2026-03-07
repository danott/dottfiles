require("ghostty")
require("netnewswire")

-- Reload config
hs.hotkey.bind({ "cmd", "shift" }, "r", function()
  hs.reload()
end)
hs.alert.show("Hammerspoon loaded")
