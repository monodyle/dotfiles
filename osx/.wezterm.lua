local wezterm = require "wezterm"
local action = wezterm.action

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

wezterm.on('update-right-status', function(window)
    -- "Wed Mar 3 08:14"
    local date = wezterm.strftime '%a %b %-d %H:%M '

    local bat = ''
    for _, b in ipairs(wezterm.battery_info()) do
        bat = 'Power: ' .. string.format('%.0f%%', b.state_of_charge * 100)
    end

    window:set_right_status(wezterm.format {
        { Text = bat .. ' | ' .. date },
    })
end)

-- config.color_scheme = 'rose-pine-moon'
config.window_decorations = "RESIZE"
config.font = wezterm.font("PragmataPro VF Mono Liga")
config.font_size = 18.0

config.window_padding = {
    left = 48,
    right = 48,
    top = 64,
    bottom = 24
}

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.pane_select_font_size = 36

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    {
        key = "e",
        mods = "CMD|SHIFT",
        action = action.PromptInputLine {
            description = "Enter name for this tab",
            action = wezterm.action_callback(function(window, pane, line)
              if line then
                -- Set the title of the active tab
                window:active_tab():set_title(line)
              end
            end)
        }
    },
    {
        key = "b",
        mods = "CMD",
        action = action {PaneSelect = {}}
    },
    {
        key = "{",
        mods = "SHIFT|ALT",
        action = action.MoveTabRelative(-1)
    },
    {
        key = "}",
        mods = "SHIFT|ALT",
        action = action.MoveTabRelative(1)
    },
    {
        key = "w",
        mods = "CMD",
        action = action.CloseCurrentPane {
            confirm = true
        }
    },
    {
        key = "W",
        mods = "CMD|SHIFT",
        action = action.CloseCurrentTab {
            confirm = true
        }
    },
    {
        key = "d",
        mods = "CMD",
        action = action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = "d",
        mods = "CMD|SHIFT",
        action = action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = "z",
        mods = "CMD",
        action = action.TogglePaneZoomState
    },
    {
        key = "`",
        mods = "CMD",
        action = action.ToggleAlwaysOnTop
    }
}

-- hehe

config.colors = {
    foreground = "#121212",
    background = "#f1f0e9",
    cursor_fg = "#222222",
    selection_fg = "rgba(18, 18, 18, 0.93)",
    selection_bg = "rgba(18, 18, 18, 0.094)",
    scrollbar_thumb = "rgba(222, 220, 213, 0.063)",
    split = "#252525",
    ansi = {"#393a34", "#cb7676", "#4d9375", "#b07d49", "#6394bf", "#d9739f", "#5eaab5", "#dbd7ca"},
    brights = {"#777777", "#cb7676", "#4d9375", "#b07d49", "#6394bf", "#d9739f", "#5eaab5", "#ffffff"},
    indexed = {
        [136] = "#bd976a"
    },
    compose_cursor = "#d4976c",
    copy_mode_active_highlight_bg = {
        Color = "#292929"
    },
    copy_mode_active_highlight_fg = {
        Color = "#121212"
    },
    copy_mode_inactive_highlight_bg = {
        Color = "#4d9375"
    },
    copy_mode_inactive_highlight_fg = {
        Color = "#222222"
    },
    quick_select_label_bg = {
        Color = "#4d9375"
    },
    quick_select_label_fg = {
        Color = "#222222"
    },
    quick_select_match_bg = {
        Color = "#6394bf"
    },
    quick_select_match_fg = {
        Color = "#222222"
    },
    tab_bar = {
        background = "#F1F0E9",
        inactive_tab = {
            bg_color = "#F1F0E9",
            fg_color = "#a6a5a2"
        },
        inactive_tab_hover = {
            bg_color = "#F1F0E9",
            fg_color = "rgba(57, 58, 52, 0.9)"
        },
        new_tab = {
            bg_color = "#F1F0E9",
            fg_color = "#393a34"
        },
        new_tab_hover = {
            bg_color = "#F1F0E9",
            fg_color = "#121212"
        },
        active_tab = {
            bg_color = "#F1F0E9",
            fg_color = "#121212"
        }
    }
}

config.inactive_pane_hsb = {
    saturation = 0.95,
    brightness = 0.95
}

return config
