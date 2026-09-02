-- Aylur-inspired Hyprland Lua config.
-- Sources: Aylur's old eww Hyprland config and Marble's Nucharm theme.

local theme = dofile(os.getenv("HOME") .. "/.config/hypr/theme.lua")

local mod = "SUPER"
local terminal = "ghostty"
local browser = "zen-beta"
local file_manager = "nautilus"
local launcher = "rofi -show drun"
local screenshot_dir = "$HOME/Pictures/Screenshots"
local screenshot = "hypr-shot"
local float_size = { x = 1280, y = 720 }

-- Runs an arbitrary shell command through Hyprland's exec dispatcher.
local function run(command)
  return hl.dsp.exec_cmd(command)
end

-- Launches graphical applications in transient UWSM systemd scopes.
local function app(command)
  return run("uwsm app -- " .. command)
end

-- Descriptions are consumed by the shortcut menu and desktop widget.
local function bind(key, action, description)
  return hl.bind(mod .. " + " .. key, action, { description = description })
end

local function bind_shift(key, action, description)
  return bind("SHIFT + " .. key, action, description)
end

-- Toggles floating with a usable default size for windows that filled a tile.
local function toggle_float()
  local window = hl.get_active_window()

  if window and not window.floating then
    hl.dispatch(hl.dsp.window.fullscreen_state({
      internal = 0,
      client = 0,
      action = "set",
    }))
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.resize({
      x = float_size.x,
      y = float_size.y,
      exact = true,
    }))
    hl.dispatch(hl.dsp.window.center())
  else
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  end
end

-- Creates a key binding that keeps working while the screen is locked.
local function bind_locked(key, command, description)
  return hl.bind(key, run(command), {
    description = description,
    locked = true,
  })
end

-- Creates a repeating key binding for volume and brightness controls.
local function bind_repeat(key, command, description)
  return hl.bind(key, run(command), {
    description = description,
    locked = true,
    repeating = true,
  })
end

-- Marks transient utility windows as floating by matching their class.
local function float_class(name, class)
  return hl.window_rule({
    name = "float-" .. name,
    match = { class = class },
    float = true,
  })
end

-- External displays sit to the right at native scale. The laptop panel remains
-- the leftmost display and keeps its readable fractional scale when docked.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto-right",
  scale = 1,
})
hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto-left",
  scale = 1.2,
})

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("NIXOS_OZONE_WL", "1")

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 1,
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
    col = {
      active_border = "rgb(" .. theme.blue .. ")",
      inactive_border = "rgb(" .. theme.border .. ")",
    },
  },
  decoration = {
    rounding = 8,
    active_opacity = 1.0,
    inactive_opacity = 0.97,
    shadow = {
      enabled = false,
      color = "rgba(" .. theme.shadow .. ")",
    },
    blur = {
      enabled = false,
    },
  },
  animations = {
    enabled = true,
  },
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },
  binds = {
    allow_workspace_cycles = true,
  },
  dwindle = {
    preserve_split = true,
  },
  xwayland = {
    force_zero_scaling = true,
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = false,
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

hl.curve("desktop", {
  type = "bezier",
  points = { { 0.2, 0.8 }, { 0.2, 1.0 } },
})
hl.animation({ leaf = "global", enabled = true, speed = 7, bezier = "desktop" })
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "desktop" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "desktop" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "desktop" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "desktop" })

hl.on("hyprland.start", function()
  hl.exec_cmd("mkdir -p " .. screenshot_dir)
end)

bind("Return", app(terminal), "Open terminal")
bind("Z", app(terminal .. " -e zellij"), "Open terminal workspace")
bind("B", app(browser), "Open browser")
bind("SPACE", app(launcher), "[common] Open App Launcher")
bind("E", app(file_manager), "[common] Open File Explorer")
bind("R", app(launcher), "Open application launcher")
bind("SHIFT + R", run("hyprctl reload"), "Reload Hyprland")
bind("P", app("rofi -show run"), "Run a command")
bind("V", app("clipboard-picker"), "[common] Open Clipboard History")
bind_shift("v", app("clear-clipboard-history"), "[common] Clear Clipboard History")
bind("N", run("makoctl restore"), "Restore last notification")
bind_shift("n", run("makoctl mode -t do-not-disturb"), "Toggle do not disturb")
bind_shift("l", run("loginctl lock-session"), "Lock session")
bind("SHIFT + slash", app("hypr-keybinds --menu"), "Show shortcut help")

bind("Q", hl.dsp.window.close(), "[common] Kill focused")
bind_shift("f", toggle_float, "[common] Toggled centered floating")
bind_shift("g", hl.dsp.window.fullscreen({ action = "toggle" }), "[common] Toggle fullscreen")
bind_shift("h", hl.dsp.window.fullscreen_state({
  internal = 2,
  client = 0,
  action = "toggle",
}), "Toggle maximize")
bind_shift("j", hl.dsp.layout("togglesplit"), "Toggle split direction")

bind("left", hl.dsp.focus({ direction = "left" }), "Focus left")
bind("right", hl.dsp.focus({ direction = "right" }), "Focus right")
bind("up", hl.dsp.focus({ direction = "up" }), "Focus up")
bind("down", hl.dsp.focus({ direction = "down" }), "Focus down")
bind("h", hl.dsp.focus({ direction = "left" }), "Focus left")
bind("j", hl.dsp.focus({ direction = "down" }), "Focus down")
bind("k", hl.dsp.focus({ direction = "up" }), "Focus up")
bind("l", hl.dsp.focus({ direction = "right" }), "Focus right")

bind("CTRL + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), "Shrink window horizontally")
bind("CTRL + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), "Grow window downward")
bind("CTRL + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), "Shrink window vertically")
bind("CTRL + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), "Grow window horizontally")
bind("ALT + h", hl.dsp.window.move({ x = -20, y = 0, relative = true }), "Move window left")
bind("ALT + j", hl.dsp.window.move({ x = 0, y = 20, relative = true }), "Move window down")
bind("ALT + k", hl.dsp.window.move({ x = 0, y = -20, relative = true }), "Move window up")
bind("ALT + l", hl.dsp.window.move({ x = 20, y = 0, relative = true }), "Move window right")

-- Numbered workspaces are global: selecting one focuses its monitor, while new
-- workspaces are created on the currently focused monitor.
for i = 1, 10 do
  local key = i % 10
  bind(tostring(key), hl.dsp.focus({ workspace = i }), "Focus workspace " .. i)
  bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "Move window to workspace " .. i)
end

bind("s", hl.dsp.workspace.toggle_special("scratch"), "Toggle scratch workspace")
bind_shift("s", hl.dsp.window.move({ workspace = "special:scratch" }), "Move window to scratch workspace")
bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Focus next workspace")
bind("mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Focus previous workspace")
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { description = "[common] Drag", mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { description = "[common] Resize", mouse = true })

hl.bind("Print", app(screenshot .. " region"), { description = "Capture and edit region" })
hl.bind("SHIFT + Print", app(screenshot .. " full"), { description = "Capture and edit screen" })
hl.bind("CTRL + Print", app(screenshot .. " region no-edit"), { description = "Capture region" })
hl.bind("CTRL + SHIFT + Print", app(screenshot .. " full no-edit"), { description = "Capture screen" })

bind_repeat("XF86AudioRaiseVolume", "swayosd-client --output-volume raise --max-volume 100", "Raise volume")
bind_repeat("XF86AudioLowerVolume", "swayosd-client --output-volume lower", "Lower volume")
bind_repeat("XF86AudioMute", "swayosd-client --output-volume mute-toggle", "Toggle audio mute")
bind_repeat("XF86AudioMicMute", "swayosd-client --input-volume mute-toggle", "Toggle microphone mute")
bind_repeat("XF86MonBrightnessUp", "swayosd-client --brightness raise", "Raise brightness")
bind_repeat("XF86MonBrightnessDown", "swayosd-client --brightness lower", "Lower brightness")
bind_locked("XF86AudioNext", "playerctl next", "Next track")
bind_locked("XF86AudioPause", "playerctl play-pause", "Pause or resume media")
bind_locked("XF86AudioPlay", "playerctl play-pause", "Play or pause media")
bind_locked("XF86AudioPrev", "playerctl previous", "Previous track")

float_class("rofi", "^(Rofi)$")
float_class("calculator", "^(org.gnome.Calculator)$")
float_class("nautilus", "^(org.gnome.Nautilus)$")
float_class("pavucontrol", "^(pavucontrol)$")
float_class("network", "^(nm-connection-editor)$")
float_class("settings", "^(org.gnome.Settings)$")
float_class("portal", "^(xdg-desktop-portal.*)$")

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})
