--[[

        Licensed under GNU General Public License v2
        * (c) 2021, bzgec


# Microphone state widget/watcher

This widget can be used to display the current microphone status.

## Requirements

- `amixer` - this command is used to get and toggle microphone state

## Usage

- Download [volume.lua](https://awesomewm.org/recipes/volume.lua) file and put it into awesome's
  folder (like `~/.config/awesome/widgets/volume.lua`)

- Add widget to `theme.lua`:

```lua
local widgets = {
    volume = require("widgets/volume"),
}
theme.volume = widgets.volume({
    timeout = 10,
    settings = function(self)
        if self.state == "muted" then
            self.widget:set_image(theme.widget_micMuted)
        else
            self.widget:set_image(theme.widget_micUnmuted)
        end
    end
})
local widget_mic = wibox.widget { theme.volume.widget, layout = wibox.layout.align.horizontal }
```

- Create a shortcut to toggle microphone state (add to `rc.lua`):

```lua
-- Toggle microphone state
awful.key({ modkey, "Shift" }, "m",
          function ()
              beautiful.volume:toggle()
          end,
          {description = "Toggle microphone (amixer)", group = "Hotkeys"}
),
```

- You can also add a command to mute the microphone state on boot. Add this to your `rc.lua`:

```lua
-- Mute microphone on boot
beautiful.volume:mute()
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
        awful.spawn.easy_async({"pacmd", "set-sink-mute", "0", "1"},
            function()
                self:update()
            end
        )
    end

    function volume:unmute()
        awful.spawn.easy_async({"pacmd", "set-sink-mute", "0", "0"},
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

        awful.spawn.easy_async({"pacmd", "set-sink-mute", "0", newMutedState},
            function()
                self:update()
            end
        )
    end

    function volume:inc()
        if self.perc < self.maxPerc then
            awful.spawn.easy_async({"pactl", "set-sink-volume", "0", "+1%"},
                function()
                    self:update()
                end
            )
        end
    end

    function volume:dec()
        awful.spawn.easy_async({"pactl", "set-sink-volume", "0", "-1%"},
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
        {"bash", "-c", "pacmd list-sinks | awk '{if ($0 ~ /front-left:/) perc=$5; if ($0 ~ /muted/) muted=$2}{if (perc && muted) print perc, muted;muted=\"\"}'"},
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
