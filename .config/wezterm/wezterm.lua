local wezterm = require "wezterm"
local config = {}

config.theme_name = "Gruvbox dark, hard (base16)"

-- tmux
config.keys = {
	{
		mods = "ALT",
		key = "t",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "ALT",
		key = "q",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		mods = "ALT|SHIFT",
		key = "j",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "ALT|SHIFT",
		key = "k",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "ALT|SHIFT",
		key = "Return",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "ALT",
		key = "Return",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "ALT",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "ALT",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "ALT",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "ALT",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "ALT",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "ALT",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "ALT",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "ALT",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
  {
    key = "i",
    mods = "ALT",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "o",
    mods = "ALT",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "v",
    mods = "ALT",
    action = wezterm.action({ PasteFrom = "Clipboard" }),
  },
  {
    key = "c",
    mods = "ALT",
    action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
  },
}


local fname = "FantasqueSansM Nerd Font"

return {
  keys = config.keys,
  color_scheme = config.theme_name,
  font = wezterm.font(fname, {weight="Medium", stretch="Normal", style="Normal"}),
  font_rules = {
    {
      italic = true,
      font = wezterm.font(fname, {weight="Medium", stretch="Normal", style="Italic"}), 
    },
    {
      intensity = "Bold",
      font = wezterm.font(fname, {weight="Bold", stretch="Normal", style="Normal"}),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font(fname, {weight="Bold", stretch="Normal", style="Italic"})
    },
  },

  enable_wayland = true,
  window_decorations = "NONE", 
  enable_tab_bar = true,
  font_size = 14.0,
  front_end = "OpenGL",

  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  tab_and_split_indices_are_zero_based = false,

	automatically_reload_config = true,
	inactive_pane_hsb = { saturation = 0.8, brightness = 0.6 },
	window_background_opacity = 1,
	window_close_confirmation = "NeverPrompt",
  warn_about_missing_glyphs = false,
  colors = {
    tab_bar = {
      background = "#1d2021",

      active_tab = {
        bg_color = "#32302f",
        fg_color = "#d4be98",
        intensity = "Bold",
      },

      inactive_tab = {
        bg_color = "#1d2021",
        fg_color = "#d4be98",
      },

      new_tab = {
        bg_color = "#1d2021",
        fg_color = "#d4be98",
      },

    },
  }
}
