--------------------------------------------------------------------------------
-- Hammerspoon Configuration
-- https://www.hammerspoon.org/
--
-- Hyper key (⌃⌥⇧⌘) is defined in Karabiner-Elements
--
-- Active hotkeys:
--   Hyper + W  ->  Brave (Work profile)
--   Hyper + P  ->  Brave (Personal profile)
--   Hyper + J  ->  Brave (Jay profile)
--   Hyper + A  ->  Brave (Airbnb profile)
--   Hyper + K  ->  Kitty terminal
--   Hyper + O  ->  Obsidian
--   Hyper + I  ->  iTerm
--   Hyper + C  ->  Cursor
--   Hyper + S  ->  Slack
--------------------------------------------------------------------------------

-- Installation notes:
--
-- Download from https://github.com/Hammerspoon/hammerspoon/releases/latest
-- Run the installer
-- Set the config file path in the installer:
--    defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
-- Restart Hammerspoon.

--------------------------------------------------------------------------------

-- Reload config on save (disabled - use manual reload or Hammerspoon menu)
-- hs.loadSpoon("ReloadConfiguration")
-- spoon.ReloadConfiguration:start()

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

-- Async task runner: bypasses shell, no startup overhead
local function runAsync(executable, args, label)
  if label then hs.alert.show(label) end
  hs.task.new(executable, nil, args):start()
end

-- Sync runner: for commands that need output (uses non-login shell)
local function run(cmd, label)
  local out, ok, _typ, rc = hs.execute(cmd, false)
  out = (out or ""):gsub("%s+$", "")
  if label and label ~= "" then
    if out ~= "" then
      hs.alert.show(label .. "\n" .. out)
    else
      hs.alert.show(label)
    end
  elseif out ~= "" then
    hs.alert.show(out)
  end
  return out, ok, rc
end

--------------------------------------------------------------------------------
-- Brave Browser Profiles
--
-- Opens or focuses a Brave profile window:
--   - If Brave is running: activates app and selects profile via Profiles menu
--   - If Brave is not running: launches with --profile-directory (restores tabs)
--
-- Profile directory mapping (run this to discover yours):
--   for d in "Default" "Profile "*; do
--     f="$HOME/Library/Application Support/BraveSoftware/Brave-Browser/$d/Preferences"
--     [ -f "$f" ] && printf "%-12s -> %s\n" "$d" \
--       "$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("profile",{}).get("name",""))' "$f")"
--   done
--
-- Current mapping:
--   Default    -> Work
--   Profile 1  -> Personal
--   Profile 3  -> Airbnb
--   Profile 4  -> Jay
--------------------------------------------------------------------------------

local BRAVE = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"

local function openBraveProfile(profileName, profileDir)
  local app = hs.application.find("Brave Browser")
  if app then
    if app:isFrontmost() then
      app:selectMenuItem({"Profiles", profileName})
    else
      app:activate()
      hs.timer.doAfter(0.05, function()
        app:selectMenuItem({"Profiles", profileName})
      end)
    end
  else
    hs.task.new(BRAVE, nil, {"--profile-directory=" .. profileDir}):start()
  end
  hs.alert.show(profileName)
end

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "w", function()
  openBraveProfile("Work", "Default")
end)

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "p", function()
  openBraveProfile("Personal", "Profile 1")
end)

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "j", function()
  openBraveProfile("Jay", "Profile 4")
end)

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "a", function()
  openBraveProfile("Airbnb", "Profile 3")
end)

--------------------------------------------------------------------------------
-- Kitty Terminal
--------------------------------------------------------------------------------

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "k", function()
  runAsync("/Applications/kitty.app/Contents/MacOS/kitty", {"--single-instance", "-d", os.getenv("HOME")}, "kitty")
end)

--------------------------------------------------------------------------------
-- Obsidian
--------------------------------------------------------------------------------

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "o", function()
  hs.application.launchOrFocus("Obsidian")
  hs.alert.show("Obsidian")
end)

--------------------------------------------------------------------------------
-- iTerm
--------------------------------------------------------------------------------

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "i", function()
  hs.application.launchOrFocus("iTerm")
  hs.alert.show("iTerm")
end)

--------------------------------------------------------------------------------
-- Cursor
--------------------------------------------------------------------------------

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "c", function()
  hs.application.launchOrFocus("Cursor")
  hs.alert.show("Cursor")
end)

--------------------------------------------------------------------------------
-- Slack
--------------------------------------------------------------------------------

hs.hotkey.bind({ "ctrl", "cmd", "alt", "shift" }, "s", function()
  hs.application.launchOrFocus("Slack")
  hs.alert.show("Slack")
end)

--------------------------------------------------------------------------------
-- Show loaded message
--------------------------------------------------------------------------------

hs.alert.show("Hammerspoon config loaded")
