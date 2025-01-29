-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font({ family = "JetBrains Mono" })
config.window_decorations = "RESIZE"
config.color_scheme = "Tokyo Night"
config.hide_tab_bar_if_only_one_tab = true
config.enable_wayland = false

if wezterm.target_triple == "aarch64-apple-darwin" then
	config.font_size = 16.0
else
	-- config.window_background_opacity = 0.95
	config.font_size = 12.0
end

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.font_rules = {
	{
		intensity = "Bold",
		font = wezterm.font({
			family = "JetBrains Mono",
			weight = "ExtraBold",
		}),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			family = "JetBrains Mono",
			weight = "ExtraBold",
			style = "Italic",
		}),
	},
	{
		italic = true,
		intensity = "Half",
		font = wezterm.font({
			family = "JetBrains Mono",
			weight = "Bold",
			style = "Italic",
		}),
	},
	{
		italic = true,
		intensity = "Normal",
		font = wezterm.font({
			family = "JetBrains Mono",
			style = "Italic",
		}),
	},
}

config.enable_kitty_keyboard = true

config.keys = {
    {
        key = "J",
        mods = "CTRL|SHIFT",
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = "K",
        mods = "CTRL|SHIFT",
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = "L",
        mods = "CTRL|SHIFT",
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = "U",
        mods = "CTRL|SHIFT",
        action = wezterm.action.DisableDefaultAssignment,
    },
}

wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
