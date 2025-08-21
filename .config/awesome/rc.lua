-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
local home = os.getenv('HOME')
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

-- --- REMOVED NAUGHTY ---
-- The naughty library has been removed to use Dunst instead.

-- Declarative object management
local ruled = require("ruled")
-- local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- local wibox = require('wibox') -- This was a duplicate require

local cyclefocus = require('cyclefocus')



beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")


purple = "#6C0533"
cyan = "#0DC8C6"
dgreen = "#263A09"
dblue = "#0D0221"
ashwhite = "#D5DCD9"
sand = "#DCDBB9"
lgreen = "#89B6AD"
yellow = '#C7D81E'
kiligreen = '#28EB33'
somegreen = '#016063'
someblue = '#003787'
red = "#DC2222"
manjarogreen = '#15B392'
cyan1 = "#028090"
purple1 = "#820263"
purple2 = "#6A0136"
rich1 = "#BBDB9B"
alabaster = "#E8EBE4"
tangerine = "#F08700"
gray = "#3D5A6C"
darkteal = '#1A3636'
lightgreen = '#88D66C'
-- Customize theme settings
beautiful.font = "Hack Bold 09"

beautiful.bg_normal = "#222222"
beautiful.bg_focus = darkteal
beautiful.bg_urgent = "#901C0F"
beautiful.bg_minimize = beautiful.bg_normal
beautiful.wibar_bg = dblue
beautiful.wibar_fg = "#AAAAAA"
beautiful.bg_systray = beautiful.wibar_bg

beautiful.fg_normal = manjarogreen
beautiful.fg_focus = lightgreen
beautiful.fg_urgent = "#ffffff"
beautiful.fg_minimize = "#ffffff"

beautiful.useless_gap = 0
beautiful.border_width = 4
beautiful.border_color_normal = '#222222'
beautiful.border_color_active = lightgreen
beautiful.border_color_marked = "#91231C"

local naughty = require("naughty")
local gears = require("gears")

-- Nord palette
local nord = {
    nord0  = "#2E3440",
    nord1  = "#3B4252",
    nord2  = "#434C5E",
    nord3  = "#4C566A",
    nord4  = "#D8DEE9",
    nord5  = "#E5E9F0",
    nord6  = "#ECEFF4",
    nord7  = "#8FBCBB",
    nord8  = "#88C0D0",
    nord9  = "#81A1C1",
    nord10 = "#5E81AC",
    nord11 = "#A3BE8C",
    nord12 = "#D08770",
    nord13 = "#EBCB8B",
    nord14 = "#BF616A",
    nord15 = "#B48EAD"
}

-- Default notification settings
naughty.config.defaults = {
    timeout      = 10, -- seconds
    margin       = 12,
    border_width = 2,
    position     = "top_right",
    ontop        = true,
}

-- Urgency-based presets (like dunst sections)
naughty.config.presets.low = {
    fg           = nord.nord4,
    bg           = nord.nord1,
    border_color = nord.nord3,
    timeout      = 5
}

naughty.config.presets.normal = {
    fg           = nord.nord6,
    bg           = nord.nord0,
    border_color = nord.nord8,
    timeout      = 10
}

naughty.config.presets.critical = {
    fg           = nord.nord6,
    bg           = nord.nord0,
    border_color = nord.nord14,
    timeout      = 0 -- stays until dismissed
}

-- Layout and style
naughty.connect_signal("request::display", function(n)
    naughty.layout.box {
        notification = n,
        type = "notification",
        border_width = 2,
        border_color = n.border_color or nord.nord3,
        shape = gears.shape.rounded_rect,
        maximum_width = 350,
        widget_template = {
            {
                {
                    {
                        markup = "<b>" .. (n.title or "") .. "</b>",
                        font   = "JetBrainsMono Nerd Font 10",
                        widget = wibox.widget.textbox
                    },
                    {
                        markup = n.message or "",
                        font   = "JetBrainsMono Nerd Font 10",
                        wrap   = "word",
                        widget = wibox.widget.textbox
                    },
                    spacing = 6,
                    layout  = wibox.layout.fixed.vertical
                },
                margins = 10,
                widget  = wibox.container.margin
            },
            id     = "background_role",
            widget = naughty.container.background
        }
    }
end)




-- widgets for wibar
-- local volbar = require("statusbar.aw-volume")
local activebar = require("statusbar.aw-active-time")
local sysbar = require("statusbar.aw-system")
local musbar = require("statusbar.aw-music-compact")
local powerbar = require("statusbar.aw-lock")
local dunstbar = require("statusbar.aw-dunst")
local updatebar = require("statusbar.aw-update")
local calendar_widget = require("statusbar.aw-calendar")
local music_widget = musbar.create_music_widget()
local volume_widget = require('statusbar.pactl-widget.volume')
local volbar = volume_widget { widget_type = 'arc' }
powerbar.bg = purple

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- --- MODIFIED FOR DUNST ---
-- Check if awesome encountered an error during startup and use dunstify to show it.
awesome.connect_signal("request::display_error", function(message, startup)
	local title = "Oops, an error happened" .. (startup and " during startup!" or "!")
	-- Use awful.spawn to call dunstify for displaying errors
	awful.spawn.with_shell("dunstify -u critical '" .. title .. "' '" .. message .. "'")
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor -- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Menu
-- The menu section was commented out, leaving it as is.
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.floating,
		awful.layout.suit.tile,
		awful.layout.suit.tile.left,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.tile.top,
		awful.layout.suit.fair,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.spiral,
		awful.layout.suit.spiral.dwindle,
		awful.layout.suit.max,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.magnifier,
		awful.layout.suit.corner.nw,
	})
end)
-- }}}

beautiful.wallpaper = home .. "/.config/defaultwallpaper.png"
-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper {
		screen = s,
		widget = {
			{
				image     = beautiful.wallpaper,
				upscale   = true,
				resize    = true,
				downscale = true,
				widget    = wibox.widget.imagebox,
			},
			valign = "top",
			halign = "center",
			tiled  = true,
			widget = wibox.container.tile,
		}
	}
end)
-- }}}
-- The old wallpaper section below is now redundant and can be removed.
-- if beautiful.wallpaper then ... end

local separator = wibox.widget {
	widget = wibox.widget.textbox,
	text = " ",
}
-- {{{ Wibar


-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

mytextclock = wibox.widget.textclock("%a %b %d, %H:%M:%S ", 1)

-- default
local cw = calendar_widget({
	theme = 'outrun',
	placement = 'top_right',
	start_sunday = true,
	radius = 8,
	-- with customized next/previous (see table above)
	previous_month_button = 1,
	next_month_button = 3,
})
mytextclock:connect_signal("button::press",
	function(_, _, _, button)
		if button == 1 then cw.toggle() end
	end)

local systray = wibox.widget.systray()
systray:set_base_size(20)
-- This 'spacer' is a container for your systray. This is why the systray works.
local systray_container = wibox.widget {
	widget = wibox.container.place,
	halign = "center",
	systray
}

--------------------------------

screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[2])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox {
		screen  = s,
		buttons = {
			awful.button({}, 1, function() awful.layout.inc(1) end),
			awful.button({}, 3, function() awful.layout.inc(-1) end),
			awful.button({}, 4, function() awful.layout.inc(-1) end),
			awful.button({}, 5, function() awful.layout.inc(1) end),
		}
	}

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t) t:view_only() end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
			awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
		}
	}


	-- -- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen  = s,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({}, 1, function(c)
				c:activate { context = "tasklist", action = "toggle_minimization" }
			end),
			awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
			awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
			awful.button({}, 5, function() awful.client.focus.byidx(1) end),
		}
	}

	-- Create the wibox
	s.mywibox = awful.wibar {
		position = "top",
		screen   = s,
		height   = 22,
		widget   = {
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				-- mylauncher,
				s.mytaglist,
				separator,
				s.mypromptbox,
			},
			s.mytasklist, -- Middle widget
			{    -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				separator,
				-- mykeyboardlayout,
				dunstbar,
				activebar,
				updatebar,
				separator,
				sysbar.ram_widget,
				sysbar.cpu_widget,
				sysbar.home_widget,
				separator,
				music_widget,
				separator,
				volbar,
				separator,
				systray_container, -- Use the systray container widget here
				s.mylayoutbox,
				-- systray(), -- This is correctly commented out
				separator,
				mytextclock,
				powerbar,
			},
		}
	}
end)

-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
	-- awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({}, 4, awful.tag.viewprev),
	awful.button({}, 5, awful.tag.viewnext),
})
-- }}}


-- {{{ Key bindings

-- MODIFICATION: Initialize globalkeys as an empty table first.
local globalkeys = {}

-- General Awesome keys
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, }, "s", hotkeys_popup.show_help,
		{ description = "show help", group = "awesome" }),
	-- awful.key({ modkey, }, "w", function() mymainmenu:show() end,
	-- { description = "show main menu", group = "awesome" }),
	awful.key({ modkey, "Control" }, "r", function()
			-- --- MODIFIED FOR DUNST ---
			awful.spawn.with_shell('dunstify -u normal -t 2000 "AwesomeWM" "Reloading configuration..."')
			awesome.restart()
		end,
		{ description = "reload awesome", group = "awesome" }),
	awful.key({ modkey }, "x",
		function()
			awful.prompt.run {
				prompt       = "Run Lua code: ",
				textbox      = awful.screen.focused().mypromptbox.widget,
				-- MODIFICATION: exe_callback is deprecated for this use case.
				-- The prompt handles Lua evaluation automatically.
				history_path = awful.util.get_cache_dir() .. "/history_eval"
			}
		end,
		{ description = "lua execute prompt", group = "awesome" }),
	awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
		{ description = "run prompt", group = "launcher" })
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, }, "Left", awful.tag.viewprev,
		{ description = "view previous", group = "tag" }),
	awful.key({ modkey, }, "Right", awful.tag.viewnext,
		{ description = "view next", group = "tag" }),
	awful.key({ modkey, }, "Escape", awful.tag.history.restore,
		{ description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, }, "j",
		function()
			awful.client.focus.byidx(1)
		end,
		{ description = "focus next by index", group = "client" }
	),
	awful.key({ modkey, }, "k",
		function()
			awful.client.focus.byidx(-1)
		end,
		{ description = "focus previous by index", group = "client" }
	),
	-- modkey+Tab: cycle through all clients.
	awful.key({ modkey }, "Tab", function(c)
		cyclefocus.cycle({ modifier = "Super_L" })
	end),
	-- modkey+Shift+Tab: backwards
	awful.key({ modkey, "Shift" }, "Tab", function(c)
		cyclefocus.cycle({ modifier = "Super_L" })
	end),
	awful.key({ modkey, }, "n", function() awful.screen.focus_relative(1) end,
		{ description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "n", function() awful.screen.focus_relative(-1) end,
		{ description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey, "Shift" }, "n",
		function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:activate { raise = true, context = "key.unminimize" }
			end
		end,
		{ description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
		{ description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
		{ description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }),
	awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
		{ description = "increase master width factor", group = "layout" }),
	awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
		{ description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
		{ description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
		{ description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
		{ description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
		{ description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(1) end,
		{ description = "select next", group = "layout" }),
	awful.key({ modkey }, "space",
		function()
			if client.focus then
				client.focus:swap(awful.client.getmaster())
			end
		end,
		{ description = "move focused window to master", group = "client" }),
	awful.key({ modkey, "Control" }, "k", function() awful.client.incwfact(0.05) end,
		{ description = "increase client height factor", group = "layout" }),
	awful.key({ modkey, "Control" }, "j", function() awful.client.incwfact(-0.05) end,
		{ description = "decrease client height factor", group = "layout" }),

})


awful.keyboard.append_global_keybindings({
	awful.key {
		modifiers   = { modkey },
		keygroup    = "numrow",
		description = "only view tag",
		group       = "tag",
		on_press    = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	},
	awful.key {
		modifiers   = { modkey, "Control" },
		keygroup    = "numrow",
		description = "toggle tag",
		group       = "tag",
		on_press    = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	},
	awful.key {
		modifiers   = { modkey, "Shift" },
		keygroup    = "numrow",
		description = "move focused client to tag",
		group       = "tag",
		on_press    = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	},
	awful.key {
		modifiers   = { modkey, "Control", "Shift" },
		keygroup    = "numrow",
		description = "toggle focused client on tag",
		group       = "tag",
		on_press    = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	},
	awful.key {
		modifiers   = { modkey },
		keygroup    = "numpad",
		description = "select layout directly",
		group       = "layout",
		on_press    = function(index)
			local t = awful.screen.focused().selected_tag
			if t then
				t.layout = t.layouts[index] or t.layout
			end
		end,
	}
})

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate { context = "mouse_click" }
		end),
		awful.button({ modkey }, 1, function(c)
			c:activate { context = "mouse_click", action = "mouse_move" }
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate { context = "mouse_click", action = "mouse_resize" }
		end),
	})
end)

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({ modkey, }, "f",
			function(c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end,
			{ description = "toggle fullscreen", group = "client" }),
		awful.key({ modkey, "Shift" }, "q", function(c) c:kill() end,
			{ description = "close", group = "client" }),
		awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
			{ description = "toggle floating", group = "client" }),
		awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
			{ description = "move to master", group = "client" }),
		awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
			{ description = "move to screen", group = "client" }),
		awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
			{ description = "toggle keep on top", group = "client" }),
		awful.key({ modkey, }, "]",
			function(c)
				-- The client currently has the input focus, so it cannot be
				-- minimized, since minimized clients can't have the focus.
				c.minimized = true
			end,
			{ description = "minimize", group = "client" }),
		awful.key({ modkey, }, "[",
			function(c)
				c.maximized = not c.maximized
				c:raise()
			end,
			{ description = "(un)maximize", group = "client" }),
		awful.key({ modkey, "Control" }, ";",
			function(c)
				c.maximized_vertical = not c.maximized_vertical
				c:raise()
			end,
			{ description = "(un)maximize vertically", group = "client" }),
		awful.key({ modkey, "Shift" }, "-",
			function(c)
				c.maximized_horizontal = not c.maximized_horizontal
				c:raise()
			end,
			{ description = "(un)maximize horizontally", group = "client" }),
	})
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
	-- All clients will match this rule.
	ruled.client.append_rule {
		id         = "global",
		rule       = {},
		properties = {
			focus            = awful.client.focus.filter,
			raise            = true,
			screen           = awful.screen.preferred,
			placement        = awful.placement.no_overlap + awful.placement.no_offscreen,
			maximized        = false,
			size_hints_honor = false,
		}
	}

	-- Floating clients.
	ruled.client.append_rule {
		id         = "floating",
		rule_any   = {
			instance = { "copyq", "pinentry" },
			class    = {
				"Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
				"Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name     = {
				"Event Tester", -- xev.
			},
			role     = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
			}
		},
		properties = { floating = true, maximized = false, sticky = true }
	}

	-- Add titlebars to normal clients and dialogs
	ruled.client.append_rule {
		id         = "titlebars",
		rule_any   = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = false }
	}

	ruled.client.append_rule {
		id         = "Picture in picture",
		rule       = { name = "Picture in picture" },
		properties = { floating = true, above = true, maximized = false, sticky = true }
	}

end)
-- }}}


-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = {
		awful.button({}, 1, function()
			c:activate { context = "titlebar", action = "mouse_move" }
		end),
		awful.button({}, 3, function()
			c:activate { context = "titlebar", action = "mouse_resize" }
		end),
	}

	awful.titlebar(c).widget = {
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout  = wibox.layout.fixed.horizontal
		},
		{ -- Middle
			{ -- Title
				halign = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end)
-- }}}

-- {{{ Notifications
-- Dunst is now used, so this section is correctly empty.
-- }}}


-- --- MODIFIED FOR DUNST ---
-- Screenshot functions now use dunstify
local function get_timestamp()
	return os.date("%Y-%m-%d_%H-%M-%S")
end

local function take_screenshot_region()
	awful.spawn.with_shell("dunstify -u low -t 5000 ' Select the region'")
	local filename = os.getenv("HOME") .. "/Pictures/Screenshots/screenshot_" .. get_timestamp() .. ".png"
	local cmd = "maim -s " .. filename

	awful.spawn.easy_async(cmd, function()
		-- Notify after screenshot is taken
		awful.spawn.with_shell("dunstify -u normal -t 5000 ' Screenshot taken' ' Saved as " .. filename .. "'")
	end)
end

local function take_screenshot_full()
	local filename = os.getenv("HOME") .. "/Pictures/Screenshots/screenshot_" .. get_timestamp() .. ".png"
	local cmd = "maim -u " .. filename

	awful.spawn.easy_async(cmd, function()
		-- Notify after screenshot is taken
		awful.spawn.with_shell("dunstify -u normal -t 5000 ' Full-Screen Screenshot' ' Saved as " .. filename .. "'")
	end)
end

-- MODIFICATION: Consolidate keybindings into the globalkeys table.
-- Screenshot
globalkeys = gears.table.join(
	globalkeys,
	awful.key({ "Mod4", "Shift" }, "Print", take_screenshot_region,
		{ description = "take screenshot of selected region", group = "screen" }),
	awful.key({ "Mod4" }, "Print", take_screenshot_full,
		{ description = "take full screenshot", group = "screen" })
)

-- Screenkey
globalkeys = gears.table.join(
	globalkeys,
	awful.key({ modkey, "Shift" }, "=", function()
		awful.spawn.easy_async_with_shell("pgrep screenkey", function(stdout)
			if stdout == "" then
				-- Using dunstify here for consistency, but notify-send works too if dunst is running
				awful.spawn.with_shell(
					"screenkey -t 1 -s small --font 'monospace' --font-color 'red' --opacity 0.6 --position bottom & dunstify 'Screenkey' 'Screenkey activated'")
			else
				awful.spawn.with_shell("pkill screenkey && dunstify 'Screenkey' 'Screenkey deactivated'")
			end
		end)
	end, { description = "toggle screenkey", group = "custom" })
)

-- MODIFICATION: Apply all global keys at once.
root.keys(globalkeys)

-- Autostart applications
-- FIX: Start the dunst notification daemon
awful.spawn.with_shell("dunst &")

awful.spawn.with_shell(
	'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
	'xrdb -merge <<< "awesome.started:true";' ..
	-- list each of your autostart commands, followed by ; inside single quotes, followed by ..
	'dex --environment Awesome --autostart'
)

awful.spawn.with_shell(home .. "/.config/awesome/autorun.sh")
awful.spawn.with_shell(home .. "/.config/awesome/customlock.sh")
awful.spawn.with_shell(home .. "/.config/awesome/active-time")
awful.spawn.with_shell(home .. "/.config/screenlayout.sh")
