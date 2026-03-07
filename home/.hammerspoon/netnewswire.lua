local textInputRoles = {
  AXTextField = true,
  AXTextArea = true,
  AXComboBox = true,
  AXSearchField = true,
}

local function isTextInputFocused()
  local ok, element = pcall(function()
    return hs.axuielement.systemWideElement():attributeValue("AXFocusedUIElement")
  end)
  if not ok or not element then return false end
  local ok2, role = pcall(function()
    return element:attributeValue("AXRole")
  end)
  if not ok2 then return false end
  return textInputRoles[role] == true
end

local keyMap = {
  [hs.keycodes.map["h"]] = hs.keycodes.map["left"],
  [hs.keycodes.map["j"]] = hs.keycodes.map["down"],
  [hs.keycodes.map["k"]] = hs.keycodes.map["up"],
  [hs.keycodes.map["l"]] = hs.keycodes.map["right"],
}

local function isNetNewsWire()
  local app = hs.application.frontmostApplication()
  return app and app:name() == "NetNewsWire"
end

-- Tap is always running; handler checks frontmost app at keypress time.
-- This avoids start/stop race conditions during cmd+tab switching.
local tap = hs.eventtap.new(
  { hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp },
  function(event)
    if not isNetNewsWire() then return false end
    local keycode = event:getKeyCode()
    local arrowCode = keyMap[keycode]
    local flags = event:getFlags()
    local hasModifiers = flags.cmd or flags.alt or flags.ctrl or flags.shift
    if arrowCode and not hasModifiers and not isTextInputFocused() then
      event:setKeyCode(arrowCode)
    end
    return false
  end
)
tap:start()
