-- Aylur-inspired Hyprland Lua config.
-- Sources: Aylur's old eww Hyprland config and Marble's Nucharm theme.

local theme = {
  wallpaper = "0f0f0f",
  bg = "151516",
  surface = "181818",
  border = "2a2a2a",
  blue = "51a4e7",
  shadow = "00000044",
}

local mod = "SUPER"
local terminal = "ghostty"
local browser = "zen"
local file_manager = "nautilus"
local launcher = "rofi -show drun"
local screenshot_dir = "$HOME/Pictures/Screenshots"
local screenshot = "$HOME/.config/hypr/shot.sh"
local float_size = { x = 1280, y = 720 }

-- Runs an arbitrary shell command through Hyprland's exec dispatcher.
local function run(command)
  return hl.dsp.exec_cmd(command)
end

-- Creates a normal key binding with the shared SUPER modifier.
local function bind(key, action)
  return hl.bind(mod .. " + " .. key, action)
end

-- Creates a shifted key binding without relying on uppercase key aliases.
local function bind_shift(key, action)
  return bind("SHIFT + " .. key, action)
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
local function bind_locked(key, command)
  return hl.bind(key, run(command), { locked = true })
end

-- Creates a repeating key binding for volume and brightness controls.
local function bind_repeat(key, command)
  return hl.bind(key, run(command), { locked = true, repeating = true })
end

-- Marks transient utility windows as floating by matching their class.
local function float_class(name, class)
  return hl.window_rule({
    name = "float-" .. name,
    match = { class = class },
    float = true,
  })
end

-- Keeps the config portable across laptop, docked, and external-only setups.
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
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
      active_border = "rgba(" .. theme.blue .. "66)",
      inactive_border = "rgb(" .. theme.border .. ")",
    },
  },
  decoration = {
    rounding = 8,
    active_opacity = 1.0,
    inactive_opacity = 0.9,
    shadow = {
      enabled = true,
      range = 8,
      render_power = 2,
      color = "rgba(" .. theme.shadow .. ")",
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      vibrancy = 0.1696,
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

hl.curve("aylur", {
  type = "bezier",
  points = { { 0.05, 0.9 }, { 0.1, 1.05 } },
})
hl.animation({ leaf = "global", enabled = true, speed = 7, bezier = "aylur" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "aylur" })
hl.animation({
  leaf = "windowsOut",
  enabled = true,
  speed = 7,
  bezier = "default",
  style = "popin 80%",
})
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.on("hyprland.start", function()
  hl.exec_cmd("mkdir -p " .. screenshot_dir)
end)

bind("Return", run(terminal))
bind("Z", run(terminal .. " -e zellij"))
bind("B", run(browser))
bind("E", run(file_manager))
bind("R", run(launcher))
bind("SPACE", run(launcher))
bind("SHIFT + R", run("hyprctl reload"))
bind("P", run("rofi -show run"))
bind_shift("l", run("hyprlock"))

bind("Q", hl.dsp.window.close())
bind_shift("f", toggle_float)
bind_shift("g", hl.dsp.window.fullscreen({ action = "toggle" }))
bind_shift("h", hl.dsp.window.fullscreen_state({
  internal = 2,
  client = 0,
  action = "toggle",
}))
bind_shift("j", hl.dsp.layout("togglesplit"))

bind("left", hl.dsp.focus({ direction = "left" }))
bind("right", hl.dsp.focus({ direction = "right" }))
bind("up", hl.dsp.focus({ direction = "up" }))
bind("down", hl.dsp.focus({ direction = "down" }))
bind("h", hl.dsp.focus({ direction = "left" }))
bind("j", hl.dsp.focus({ direction = "down" }))
bind("k", hl.dsp.focus({ direction = "up" }))
bind("l", hl.dsp.focus({ direction = "right" }))

bind("CTRL + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
bind("CTRL + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))
bind("CTRL + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
bind("CTRL + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
bind("ALT + h", hl.dsp.window.move({ x = -20, y = 0, relative = true }))
bind("ALT + j", hl.dsp.window.move({ x = 0, y = 20, relative = true }))
bind("ALT + k", hl.dsp.window.move({ x = 0, y = -20, relative = true }))
bind("ALT + l", hl.dsp.window.move({ x = 20, y = 0, relative = true }))

for i = 1, 10 do
  local key = i % 10
  bind(tostring(key), hl.dsp.focus({ workspace = i }))
  bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind("s", hl.dsp.workspace.toggle_special("scratch"))
bind_shift("s", hl.dsp.window.move({ workspace = "special:scratch" }))
bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind("mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("Print", run(screenshot .. " region"))
hl.bind("SHIFT + Print", run(screenshot .. " full"))
hl.bind("CTRL + Print", run(screenshot .. " region no-edit"))
hl.bind("CTRL + SHIFT + Print", run(screenshot .. " full no-edit"))

bind_repeat(
  "XF86AudioRaiseVolume",
  "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
)
bind_repeat("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
bind_repeat("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
bind_repeat("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
bind_repeat("XF86MonBrightnessUp", "brightnessctl -e4 -n2 set 5%+")
bind_repeat("XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-")
bind_locked("XF86AudioNext", "playerctl next")
bind_locked("XF86AudioPause", "playerctl play-pause")
bind_locked("XF86AudioPlay", "playerctl play-pause")
bind_locked("XF86AudioPrev", "playerctl previous")

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
