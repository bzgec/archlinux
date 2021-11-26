--[[

        Licensed under GNU General Public License v2
        * (c) 2021, bzgec


# Volume widget/watcher

This widget can be used to display the current volume percentage and mute status.

## Requirements

- `pactl` - this command is used to set and get volume/mute status

## Usage

- Download [volume.lua](https://awesomewm.org/recipes/volume.lua) file and put it into awesome's
  folder (like `~/.config/awesome/widgets/volume.lua`)

- Add widget to `theme.lua`:

```lua
local widgets = {
    volume = require("widgets/volume"),
}

-- Volume
theme.volume = widgets.volume({
    timeout = 10,
    maxPerc = 150,
    textboxPressCmd = "pavucontrol",
    settings = function(self)
        if self.muted == "..." or self.muted == "error" then
            self.widget.imagebox:set_image(theme.volmutedblocked)
        elseif self.muted == "yes" then
            self.widget.imagebox:set_image(theme.volmutedblocked)
        elseif self.perc == 0 then
            self.widget.imagebox:set_image(theme.volmuted)
        elseif self.perc <= 5 then
            self.widget.imagebox:set_image(theme.voloff)
        elseif self.perc <= 25 then
            self.widget.imagebox:set_image(theme.vollow)
        elseif self.perc <= 75 then
            self.widget.imagebox:set_image(theme.volmed)
        else
            self.widget.imagebox:set_image(theme.volhigh)
        end

        self.widget.textbox:set_markup(markup.font(theme.font, " " .. self.perc .. "%"))
    end
})
local widget_volume = wibox.widget { theme.volume.widget.imagebox, nil, layout = wibox.layout.align.horizontal }
```

- Create a shortcut to mute/unmute volume (add to `rc.lua`):

```lua
-- PulseAudio volume control
--   - increase - PgUp
--   - decrease - PgDn
--   - mute     - End
--   - unmute   - Home
awful.key({ modkey }, "Prior",
          function ()
              beautiful.volume:inc()
          end,
          {description = "Volume control - increase (pactl)", group = "Hotkeys"}
),
awful.key({ modkey }, "Next",
          function ()
              beautiful.volume:dec()
          end,
          {description = "Volume control - decrease (pactl)", group = "Hotkeys"}
),
awful.key({ modkey }, "Home",
          function ()
              beautiful.volume:unmute()
          end,
          {description = "Volume control - unmute (pactl)", group = "Hotkeys"}
),
awful.key({ modkey }, "End",
          function ()
              beautiful.volume:mute()
          end,
          {description = "Volume control - mute (pactl)", group = "Hotkeys"}
),
awful.key({ }, "XF86AudioRaiseVolume",
          function ()
              beautiful.volume:inc()
          end,
          {description = "+1%", group = "Hotkeys"}
),
awful.key({ }, "XF86AudioLowerVolume",
          function ()
              beautiful.volume:dec()
          end,
          {description = "-1%", group = "Hotkeys"}
),
```

--]]


local awful   = require("awful")
local naughty = require("naughty")
local gears   = require("gears")
local wibox   = require("wibox")

local function factory(args)
    local args = args or {}

    local volume = {
        widget   = {
            textbox = wibox.widget.textbox(),
            imagebox = wibox.widget.imagebox(),
        },
        settings = args.settings or function(self) end,
        timeout  = args.timeout or 10,
        timer    = gears.timer,
        perc     = 2021,
        muted    = "...",
        maxPerc  = 150,
        textboxPressCmd  = args.textboxPressCmd or "pavucontrol",
    }

    function volume:mute()
        awful.spawn.easy_async({"pactl", "set-sink-mute", "@DEFAULT_SINK@", "1"},
            function()
                self:update()
            end
        )
    end

    function volume:unmute()
        awful.spawn.easy_async({"pactl", "set-sink-mute", "@DEFAULT_SINK@", "0"},
            function()
                self:update()
            end
        )
    end

    function volume:toggle()
        local newMutedState = ""
        if self.muted == "yes" then
            newMutedState = "0"
        else
            newMutedState = "1"
        end

        awful.spawn.easy_async({"pactl", "set-sink-mute", "@DEFAULT_SINK@", newMutedState},
            function()
                self:update()
            end
        )
    end

    function volume:inc()
        if self.perc < self.maxPerc then
            awful.spawn.easy_async({"pactl", "set-sink-volume", "@DEFAULT_SINK@", "+1%"},
                function()
                    self:update()
                end
            )
        end
    end

    function volume:dec()
        awful.spawn.easy_async({"pactl", "set-sink-volume", "@DEFAULT_SINK@", "-1%"},
            function()
                self:update()
            end
        )
    end

    function volume:pressed(button)
        if button == 1 then
            self:toggle()
            -- self:mute()
        end
    end

    function volume:update()
        -- Check that timer has started
        if self.timer.started then
            self.timer:emit_signal("timeout")
        end
    end

    volume, volume.timer = awful.widget.watch(
        {"bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -1 && pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'"},
        volume.timeout,
        function(self, stdout, stderr, exitreason, exitcode)
            if exitcode ~= 0 then
                self.perc = 2021
                self.muted = "error"
            else
                local i = 0
                for w in string.gmatch(stdout, "%w+") do
                    if i == 0 then
                        self.perc = tonumber(w)
                    elseif i == 1 then
                        self.muted = w
                    else
                        self.perc = 2021
                        self.muted = "error"
                    end

                    i = i + 1
                end
            end

            -- Call user/theme defined function
            self:settings()
        end,
        volume  -- base_widget (passed in callback function as first parameter)
    )

    -- add mouse click
    volume.widget.imagebox:connect_signal("button::press", function(c, _, _, button)
        volume:pressed(button)
    end)

    volume.widget.textbox:connect_signal("button::press", function(c, _, _, button)
        awful.spawn.with_shell(volume.textboxPressCmd,
            function()
                self:update()
            end
        )
    end)


    return volume
end

return factory
