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
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
-- local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local wibox = require('wibox')

local cyclefocus = require('cyclefocus')



beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

purple =  "#6C0533"
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
manjarogreen = '#4F8A7C'
cyan1= "#028090"
purple1 = "#820263"
purple2 = "#6A0136"
rich1 = "#BBDB9B"
alabaster = "#E8EBE4"
tangerine = "#F08700"
gray = "#3D5A6C"
-- Customize theme settings
beautiful.font = "Hack Bold 09"

beautiful.bg_normal = "#000000"
beautiful.bg_focus = purple2
beautiful.bg_urgent = "#901C0F"
beautiful.bg_minimize = beautiful.bg_normal
beautiful.wibar_bg = dblue
beautiful.wibar_fg = "#AAAAAA"
beautiful.bg_systray = beautiful.wibar_bg

beautiful.fg_normal = red
beautiful.fg_focus = kiligreen
beautiful.fg_urgent = "#ffffff"
beautiful.fg_minimize = "#ffffff"

beautiful.useless_gap = 0
beautiful.border_width = 3
beautiful.border_color_normal = '#000000'
beautiful.border_color_active = purple2
beautiful.border_color_marked = "#91231C"

-- widgets for wibar
-- local volbar = require("statusbar.aw-volume")
local sysbar = require("statusbar.aw-system")
local musbar = require("statusbar.aw-music-compact")
local powerbar = require("statusbar.aw-lock")
local dunstbar = require("statusbar.aw-dunst")
local updatebar = require("statusbar.aw-update")
local calendar_widget = require("statusbar.aw-calendar")
local music_widget = musbar.create_music_widget()
local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
local volbar = volume_widget{ widget_type = 'arc' }
powerbar.bg = purple

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
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
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", function() awesome.quit() end },
-- }

-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                     { "open terminal", terminal }
--                                   }
--                         })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
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

-- {{{ Wallpaper
-- if beautiful.wallpaper then
--     for s = 1, screen.count() do
--         -- gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--         if s < 2 then
--           gears.wallpaper.maximized(home .. "/.config/protraitwall.jpg", s, true)
--         else
--           gears.wallpaper.maximized(home .. "/.config/defaultwallpaper.png", s, true)
--         end
--     end
-- end
-- -- }}}

-- -- Create a vertical separator widget
-- local separator = wibox.widget {
--     orientation = 'vertical',
--     forced_width = 2,
--     color = beautiful.bg_focus,  -- Change color as needed
--     widget = wibox.widget.separator,
-- }

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
local spacer = wibox.widget {
    widget = wibox.container.place,
    halign = "center",
    systray
}

--------------------------------

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" ,"0"}, s, awful.layout.layouts[2])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }


    -- -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        }
    }

    -- Create the wibox
s.mywibox = awful.wibar {
    position = "top",
    screen   = s,
    height = 22,
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
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
	    separator,
	    -- mykeyboardlayout,
	    dunstbar,
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
	    spacer,
            s.mylayoutbox,
	    -- systray(),
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
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}

-- local scratchpads = {}  -- Table to hold scratchpad clients
--
-- -- Function to toggle a window in and out of the scratchpad
-- function toggle_scratchpad(c)
--     -- If the window is not already in the scratchpad, move it there
--     if not scratchpads[c.window] then
--         -- Add the client to the scratchpad and minimize it
--         scratchpads[c.window] = c
--         c.hidden = true  -- Hide the window
--     else
--         -- If the client is already in the scratchpad, unminimize it and move it to the current tag
--         c.hidden = false  -- Show the window
--         c:move_to_tag(c.screen.selected_tag)  -- Move it to the currently selected tag
--         client.focus = c  -- Focus the window
--         c:raise()  -- Bring it to the front
--         scratchpads[c.window] = nil  -- Remove it from scratchpad tracking
--     end
-- end
--

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", function()
        naughty.notify({ title = "Debug", text = "Restarting AwesomeWM" })
        awesome.restart()
    end,
    {description = "reload awesome", group = "awesome"}),
    -- awful.key({ modkey, "Shift"   }, "c", awesome.quit,
              -- {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- awful.key({ modkey, }, "Return", function () awful.spawn("kitty") end,
              -- {description = "open kitty terminal", group = "launcher"}),
    -- awful.key({ modkey, "Shift" }, "Return", function () awful.spawn(terminal) end,
              -- {description = "open a terminal", group = "launcher"}),
    -- awful.key({ modkey }, "d", function() awful.spawn("dmenu_run") end,
              -- {description = "Run dmenu", group = "launcher"}),
    -- awful.key({ modkey }, "b", function() awful.spawn("brave") end,
              -- {description = "Brave browser", group = "launcher"}),
    -- awful.key({ modkey }, "m", function() awful.spawn("mpc_control -t") end,
              -- {description = "Music launcher", group = "launcher"}),
    -- awful.key({ modkey,"Shift" }, "m", function() awful.spawn("dmenu-wrapper-music") end,
              -- {description = "Music mode selection", group = "launcher"}),
    -- awful.key({ modkey }, "y", function() awful.spawn("ytsearch") end,
              -- {description = "dmenu youtube search", group = "launcher"}),
    -- awful.key({ modkey }, "g", function() awful.spawn("gsearch") end,
              -- {description = "dmenu google selection", group = "launcher"}),
    -- awful.key({ modkey }, "p", function() awful.spawn("rofi-pass") end,
              -- {description = "Rofi password manager", group = "launcher"}),
    -- awful.key({ modkey, "Shift" }, "d", function ()

	      -- {description = "run rofi with all modes", group = "launcher"})
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"})
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
  -- modkey+Tab: cycle through all clients.
awful.key({ modkey }, "Tab", function(c)
    cyclefocus.cycle({modifier="Super_L"})
end),
-- modkey+Shift+Tab: backwards
awful.key({ modkey, "Shift" }, "Tab", function(c)
    cyclefocus.cycle({modifier="Super_L"})
end),
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),
    awful.key({ modkey, }, "n", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Shift" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
	awful.key({ modkey,  "Shift"         }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    -- awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              -- {description = "select previous", group = "layout"}),

    awful.key({ modkey }, "space",
        function ()
            if client.focus then
                client.focus:swap(awful.client.getmaster())
            end
        end,
        {description = "move focused window to master", group = "client"}),
    -- awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              -- {description = "select previous", group = "layout"}),

    -- Add keybindings for increasing and decreasing height factor
    awful.key({ modkey, "Control" }, "k",     function () awful.client.incwfact( 0.05)        end,
              {description = "increase client height factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "j",     function () awful.client.incwfact(-0.05)        end,
              {description = "decrease client height factor", group = "layout"}),

})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
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
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
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
        on_press    = function (index)
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
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "]",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "[",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, ";",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "-",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
	    maximized = false,
	    size_hints_honor = false,
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up"         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true,  maximized = false, sticky = true}
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false      }
    }

    ruled.client.append_rule {
	id = "Picture in picture",
        rule       = { name = "Picture in picture"},
        properties = { floating = true, above = true,  maximized = false, sticky = true}
    }

    -- ruled.client.append_rule {
	-- id = "Brave",
    --     rule       = { name = "Brave"},
    --     properties = {tag = ""}
    -- }
--         -- Specific rule for LibreOffice
--     ruled.client.append_rule {
--         id         = "libreoffice",
--         rule       = { name = "libreoffice" },
--         properties = { maximized = false}
--     }
end)
-- }}}


-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
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
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:activate { context = "mouse_enter", raise = false }
-- end)

-- Autostart
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart'
    )

-- Screenshot
local naughty = require("naughty")
-- Screenshot functions
-- Screenshot functions
local function get_timestamp()
    return os.date("%Y-%m-%d_%H-%M-%S")
end

local function take_screenshot_region()
         naughty.notify({
            preset = naughty.config.presets.normal,
            title = "   Select the region",
            timeout = 5
        })
    local filename = os.getenv("HOME") .. "/Pictures/Screenshots/screenshot_" .. get_timestamp() .. ".png"
    local cmd = "maim -s " .. filename

    awful.spawn.easy_async(cmd, function()
        -- Notify after screenshot is taken
        naughty.notify({
            preset = naughty.config.presets.normal,
            title = "  Screenshot taken",
            text = "  Saved as " .. filename,
            timeout = 5
        })
    end)
end

local function take_screenshot_full()
    local filename = os.getenv("HOME") .. "/Pictures/Screenshots/screenshot_" .. get_timestamp() .. ".png"
    local cmd = "maim -u " .. filename

    awful.spawn.easy_async(cmd, function()
        -- Notify after screenshot is taken
        naughty.notify({
            preset = naughty.config.presets.normal,
            title = "  Full-Screen Screenshot",
            text = "  Saved as " .. filename,
            timeout = 5
        })
    end)
end

-- Screenshot
globalkeys = gears.table.join(
    globalkeys,
    awful.key({ "Mod4", "Shift" }, "Print", take_screenshot_region,
              {description = "take screenshot of selected region", group = "screen"}),
    awful.key({ "Mod4"}, "Print", take_screenshot_full,
              {description = "take full screenshot", group = "screen"})
)

root.keys(globalkeys)


-- Screenkey

globalkeys = gears.table.join(
    globalkeys,
    awful.key({ modkey, "Shift" }, "=", function()
        awful.spawn.easy_async_with_shell("pgrep screenkey", function(stdout)
            if stdout == "" then
                awful.spawn.with_shell("screenkey -t 1 -s small --font 'monospace' --font-color 'red' --opacity 0.6 --position bottom & notify-send 'Screenkey' 'Screenkey activated'")
            else
                awful.spawn.with_shell("pkill screenkey && notify-send 'Screenkey' 'Screenkey deactivated'")
            end
        end)
    end, {description = "toggle screenkey", group = "custom"})
)

-- Apply the keybindings
root.keys(globalkeys)

awful.spawn.with_shell(home .."/.config/awesome/autorun.sh")
awful.spawn.with_shell(home .."/.config/awesome/customlock.sh")
awful.spawn.with_shell(home .."/.config/screenlayout.sh")
