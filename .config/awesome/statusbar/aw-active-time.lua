local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Emoji stopwatch icon with larger size
local active_time_icon = wibox.widget {
    markup = '<span font="monospace 12"> </span>',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

-- On left-click, show active-time status using notify-send (Dunst)
active_time_icon:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.easy_async_with_shell("active-time status", function(stdout)
            local time = stdout:gsub("\n", "")
            awful.spawn.with_shell("notify-send 'Active Time Today' '" .. time .. "'")
        end)
    end)
))

return active_time_icon
