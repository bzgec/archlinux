--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
--local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
local xrandr        = require("xrandr")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

--run_once({ "urxvtd", "unclutter -root" }) -- entries must be separated by commas

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions

local themes = {
    "blackburn",       -- 1
    "copland",         -- 2
    "dremora",         -- 3
    "holo",            -- 4
    "multicolor",      -- 5
    "powerarrow",      -- 6
    "powerarrow-dark", -- 7
    "powerarrow-blue", -- 8
    "powerarrow-my",   -- 9
    "rainbow",         -- 10
    "steamburn",       -- 11
    "vertex",          -- 12
}

local chosen_theme = themes[9]
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "alacritty"
local wallpapersCollectionPath = string.format("%s/wallpapers-collection", os.getenv("HOME"))  -- Path to wallpapers
local vi_focus     = false -- vi-like client focus - https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = true -- cycle trough all previous client or just the first -- https://github.com/lcpz/awesome-copycats/issues/274
local editor       = os.getenv("EDITOR") or "nvim"
local gui_editor   = os.getenv("GUI_EDITOR") or "gvim"
local browser      = os.getenv("BROWSER") or "brave"
local scrlocker    = "slock"

--beautiful.useless_gap = dpi(0)

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5" }
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(
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
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
--local tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- }}}

-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or dpi(16),
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})
-- hide menu when mouse leaves it
--awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function() awful.util.mymainmenu:hide() end)

--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
    function(s)
        ---- Create a tasklist widget
        --s.mytasklist = awful.widget.tasklist {
        --    screen  = s,
        --    filter  = awful.widget.tasklist.filter.currenttags,
        --    buttons = tasklist_buttons
        --}

        beautiful.at_screen_connect(s)
    end
)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(
    -- -- Take a screenshot
    -- -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    -- awful.key({ altkey }, "p", function() awful.spawn.with_shell("screenshot") end,
    --           {description = "take a screenshot", group = "Hotkeys"}),

    -- X screen locker
    awful.key({ altkey, "Control" }, "l", function () awful.spawn.with_shell(scrlocker) end,
              {description = "lock screen", group = "Hotkeys"}),

    -- Hotkeys
    awful.key({ modkey }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    --awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end,
    --          {description = "view  previous nonempty", group = "tag"}),
    --awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end,
    --          {description = "view  previous nonempty", group = "tag"}),

    -- Default client focus
    awful.key({ altkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    --awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
    --          {description = "swap with next client by index", group = "client"}),
    --awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
    --          {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, }, "y", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, }, "x", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "cycle with previous/go back", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.byidx(1)
                if client.focus then
                    client.focus:raise()
                end
            end
        end,
        {description = "go forth", group = "client"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "p",
              function ()
                  for s in screen do
                      s.mywibox.visible = not s.mywibox.visible
                      if s.mybottomwibox then
                          s.mybottomwibox.visible = not s.mybottomwibox.visible
                      end
                  end
              end,
              {description = "toggle wibox", group = "awesome"}
    ),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
              {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrement useless gaps", group = "tag"}),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
              {description = "add new tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
              {description = "rename tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
              {description = "move tag to the left", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
              {description = "move tag to the right", group = "tag"}),
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
              {description = "delete tag", group = "tag"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ altkey, "Shift"   }, "i",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ altkey, "Shift"   }, "u",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "i",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "u",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "i",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "u",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dropdown application
    awful.key({ modkey, }, "z", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "launcher"}),

    -- Widgets popups
    -- awful.key({ altkey, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
    --           {description = "show calendar", group = "widgets"}),
    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    -- awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
    --           {description = "show weather", group = "widgets"}),

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
    --awful.key({ altkey }, "m",
    --    function ()
    --        awful.spawn.with_shell(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
    --        beautiful.volume.update()
    --    end,
    --    {description = "Volume control - toggle mute", group = "Hotkeys"}),
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
    -- TODO add other controls
    -- https://www.reddit.com/r/awesomewm/comments/7wlej1/newbie_media_keys_and_audio_managment_problems/
    --awful.key({}, "XF86AudioMute", function() awful.spawn.with_shell("pactl set-sink-mute 0 toggle") end),
    --awful.key({ }, "XF86AudioNext", function () awful.spawn("cmus-remote -n") end),
    --awful.key({ }, "XF86AudioPrev", function () awful.spawn("cmus-remote -r") end),
    --awful.key({ }, "XF86AudioPlay", function () awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause") end),

    -- Brightness control:
    --   - increase - PgUp
    --   - decrease - PgDn
    --   - min      - End
    --   - max      - Home
    awful.key({ modkey, "Control" }, "Prior",
              function () awful.util.spawn("xbacklight -inc 5") end,
              {description = "Bightness control - increase (xbacklight)", group = "Hotkeys"}
    ),
    awful.key({ modkey, "Control" }, "Next",
              function () awful.util.spawn("xbacklight -dec 5") end,
              {description = "Bightness control - decrease (xbacklight)", group = "Hotkeys"}
    ),
    awful.key({ modkey, "Control" }, "End",
              function () awful.util.spawn("xbacklight -set 0") end,
              {description = "Bightness control - minimal (xbacklight)", group = "Hotkeys"}
    ),
    awful.key({ modkey, "Control" }, "Home",
              function () awful.util.spawn("xbacklight -set 100") end,
              {description = "Bightness control - maximal (xbacklight)", group = "Hotkeys"}
    ),
    awful.key({ modkey, }, "d",
                function ()
                    gears.timer {
                        timeout   = 0.1,
                        single_shot = true,
                        autostart = true,
                        callback  = function()
                            awful.util.spawn("xset dpms force off")
                        end
                    }
                end,
              {description = "Bightness control - turn off backlight (untill any key is pressed)", group = "Hotkeys"}
    ),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 5") end,
              {description = "+5%", group = "Hotkeys"}
    ),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 5") end,
              {description = "-5%", group = "Hotkeys"}
    ),

    -- MPD control
    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.spawn.with_shell("mpc toggle")
            beautiful.mpd.update()
        end,
        {description = "mpc toggle", group = "widgets"}
    ),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.spawn.with_shell("mpc stop")
            beautiful.mpd.update()
        end,
        {description = "mpc stop", group = "widgets"}
    ),
    awful.key({ altkey, "Control" }, "Left",
        function ()
            awful.spawn.with_shell("mpc prev")
            beautiful.mpd.update()
        end,
        {description = "mpc prev", group = "widgets"}
    ),
    awful.key({ altkey, "Control" }, "Right",
        function ()
            awful.spawn.with_shell("mpc next")
            beautiful.mpd.update()
        end,
        {description = "mpc next", group = "widgets"}
    ),
    awful.key({ altkey }, "0",
        function ()
            local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
            if beautiful.mpd.timer.started then
                beautiful.mpd.timer:stop()
                common.text = common.text .. lain.util.markup.bold("OFF")
            else
                beautiful.mpd.timer:start()
                common.text = common.text .. lain.util.markup.bold("ON")
            end
            naughty.notify(common)
        end,
        {description = "mpc on/off", group = "widgets"}
    ),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey, "Shift" }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
              {description = "copy terminal to gtk", group = "Hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey, "Shift" }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
              {description = "copy gtk to terminal", group = "Hotkeys"}),

    ---- User programs
    --awful.key({ modkey }, "q", function () awful.spawn(browser) end,
    --          {description = "run browser", group = "launcher"}),
    --awful.key({ modkey }, "a", function () awful.spawn(gui_editor) end,
    --          {description = "run gui editor", group = "launcher"}),

    -- Default
    --[[ Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
    --]]
    --[[ dmenu
    awful.key({ modkey }, "x", function ()
            awful.spawn.with_shell(string.format("dmenu_run -i -fn 'Monospace' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "launcher"})
    --]]
    -- alternatively use rofi, a dmenu-like application with more features
    -- check https://github.com/DaveDavenport/rofi for more details
    --[[ rofi
    awful.key({ modkey }, "x", function ()
            awful.spawn.with_shell(string.format("rofi -show %s -theme %s",
            'run', 'dmenu'))
        end,
        {description = "show rofi", group = "launcher"}),
    --]]

    -- Application launcher
    awful.key({ modkey }, "r",
              function () awful.util.spawn("rofi -show drun -show-icons") end,
              {description = "run rofi", group = "launcher"}
    ),

    -- Brave browser
    awful.key({ modkey }, "b",
              function () awful.util.spawn("brave") end,
              {description = "run browser (Brave)", group = "Applications"}
    ),

    -- pcmanfm
    awful.key({ modkey }, "e",
              function () awful.util.spawn("pcmanfm-qt") end,
              {description = "run file manager (pcmanfm-qt)", group = "Applications"}
    ),

    -- GUI code editor
    awful.key({ modkey }, "c",
              function () awful.util.spawn("codium") end,
              {description = "run GUI code editor (VSCodium)", group = "Applications"}
    ),

    -- Screenshot software
    awful.key({ modkey, "Shift" }, "s",
              function () awful.util.spawn("flameshot gui") end,
              {description = "screenshot software (flameshot)", group = "Applications"}
    ),

    -- xrandr monitor selection
    awful.key({ modkey, "Control" }, "m", function() xrandr.xrandr() end,
              {description = "Select monitor setup", group = "Hotkeys"}
    ),

    -- Switch keyboard layout
    awful.key({ modkey }, "BackSpace",
              --function () awful.widget.keyboardlayout.next_layout() end,
              function () mykeyboardlayout.next_layout() end,
              {description = "Next keyboard layout", group = "Hotkeys"}
    ),

    -- Toggle microphone state
    awful.key({ modkey, "Shift" }, "m",
              function ()
                  beautiful.mic:toggle()
              end,
              {description = "Toggle microphone (amixer)", group = "Hotkeys"}
    ),

    -- Select light or dark theme with `themeSwitcher.py`
    awful.key({ modkey, "Shift" }, "Home",
              function ()
                  awful.spawn.with_shell("~/.config/themeSwitcher.py --light")
              end,
              {description = "Switch to light theme", group = "Hotkeys"}
    ),
    awful.key({ modkey, "Shift" }, "End",
              function ()
                  awful.spawn.with_shell("~/.config/themeSwitcher.py --dark")
              end,
              {description = "Switch to dark theme", group = "Hotkeys"}
    ),

    -- Select light or dark theme with `themeSwitcher.py`
    awful.key({ altkey, "Shift"   }, "w",
                function ()
                    awful.spawn.easy_async_with_shell("~/.config/keymap/keymap.sh",
                        function(stdout, stderr, exitreason, exitcode)
                            stdout = stdout:gsub("\n[^\n]*$", "")  -- Remove last newline character
                            naughty.notify({preset=naughty.config.presets.normal, title="Changing keyboard layout", text=stdout})
                        end)
                end,
                {description = "Toggle custom keymap", group = "Hotkeys"}
    ),

    awful.key({ modkey }, "g",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
    --]]
)

clientkeys = my_table.join(
    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"}),
        --
    -- Swap
    awful.key({ modkey, "Shift" }, "h",
              function (c)
                  awful.client.swap.global_bydirection("left")
                  c:raise()
              end,
              {description = "swap with left client", group = "client"}
    ),
    awful.key({ modkey, "Shift" }, "j",
              function (c)
                  awful.client.swap.global_bydirection("down")
                  c:raise()
              end,
              {description = "swap with down client", group = "client"}
    ),
    awful.key({ modkey, "Shift" }, "k",
              function (c)
                  awful.client.swap.global_bydirection("up")
                  c:raise()
              end,
              {description = "swap with up client", group = "client"}
    ),
    awful.key({ modkey, "Shift" }, "l",
              function (c)
                  awful.client.swap.global_bydirection("right")
                  c:raise()
              end,
              {description = "swap with right client", group = "client"}
    ),

    -- Move to other screen
    -- TODO: test on multiple monitor setup (not just with 2 monitors)
    -- Code is taken from: https://github.com/awesomeWM/awesome/issues/2437
    awful.key({ modkey, "Shift" }, "y",
        function (c)
            c:move_to_screen(c.screen.index-1)
        end,
        {description = "move to screen on left", group = "screen"}
    ),
    awful.key({ modkey, "Shift" }, "x",
        function (c)
            c:move_to_screen()
        end,
        {description = "move to screen on right", group = "screen"}
    ),


    -- Resize windows
    awful.key({ modkey, "Control" }, "k",
              function (c)
                  if c.floating then
                      c:relative_move( 0, 0, 0, -10)
                  else
                      awful.client.incwfact(0.025)
                  end
              end,
              {description = "Resize Vertical -", group = "client"}
    ),
    awful.key({ modkey, "Control" }, "j",
              function (c)
                  if c.floating then
                      c:relative_move( 0, 0, 0, 10)
                  else
                      awful.client.incwfact(-0.025)
                  end
              end,
              {description = "Resize Vertical +", group = "client"}
    ),
    awful.key({ modkey, "Control" }, "h",
              function (c)
                  if c.floating then
                      c:relative_move( 0, 0, -10, 0)
                  else
                      awful.tag.incmwfact(-0.025)
                  end
              end,
              {description = "Resize Horizontal -", group = "client"}
    ),
    awful.key({ modkey, "Control" }, "l",
              function (c)
                  if c.floating then
                      c:relative_move( 0, 0,  10, 0)
                  else
                      awful.tag.incmwfact(0.025)
                  end
              end,
              {description = "Resize Horizontal +", group = "client"}
    )

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = false } },

    -- https://awesomewm.org/doc/api/libraries/awful.rules.html
    -- To get `instance` of a window use: `xprop | grep "WM_CLASS(STRING)"`
    -- First string is `instance` and the second is `class`
    -- https://www.reddit.com/r/awesomewm/comments/2kxmph/where_do_you_get_the_instance_name_of_a_client/clpwrdz?utm_source=share&utm_medium=web2x&context=3

    -- Set Firefox to always map on the first tag on screen 1.
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = awful.util.tagnames[1] }
    },
    { rule = { instance = "brave-browser" },
      properties = { tag = "1", switchtotag = true }
    },
    { rule = { instance = "vscodium" },
      properties = { tag = "2", switchtotag = true }
    },
    { rule = { instance = "kicad" },
      properties = { tag = "2", switchtotag = true }
    },
    { rule = { instance = "Steam" },
      properties = { floating = false, tag = "5", switchtotag = true }
    },
    { rule = { instance = "discord" },
      properties = { floating = false, tag = "5", switchtotag = true }
    },
    { rule = { class = "Gimp", role = "gimp-image-window" },
      properties = { maximized = true }
    },
    { rule = { instance = "snappergui" },
      properties = { floating = true }
    },
    { rule = { instance = "pavucontrol" },
      properties = { floating = true, placement = awful.placement.centered }
    },

    -- Rule to spawn terminal when wirelessStatus widget is pressed
    {
        rule = { instance = "terminal_wirelessStatus_pressed" },
        properties = {
            placement = awful.placement.centered ,
            floating = true,
            focus = true
        }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function() c:kill() end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = dpi(16)}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
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

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
--end)

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.connect_signal("focus",
    function(c)
        c.border_color = beautiful.border_focus
        c.opacity = 1
    end
)

client.connect_signal("unfocus",
    function(c)
        c.border_color = beautiful.border_normal
        c.opacity = 0.9
    end
)

-- Show titlebar only for floating windows
client.connect_signal("property::floating",
    function(c)
        if c.maximized or c.fullscreen then
            awful.titlebar.hide(c)
        elseif c.floating then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
)

----------------------------------------------------------------------------------------------------
-- Custom widget functions
----------------------------------------------------------------------------------------------------
-- wirelessStatus widget pressed function - open terminal and start `nmtui`
beautiful.wirelessStatus.pressed = function(self, button)
    if button == 1 then  -- left mouse click
        awful.spawn(terminal.." --class terminal_wirelessStatus_pressed -e nmtui")
    end
end

----------------------------------------------------------------------------------------------------
-- Autostart Applications
----------------------------------------------------------------------------------------------------
function checkIfAppIsRunning(app, appStartCmd, restartAppFlag)
    local cmd_getNumbOfActiveApps = string.format("pgrep -f -c %s", app)
    local cmd_getActiveAppPID = string.format("pgrep -f -o %s", app)

    awful.spawn.easy_async_with_shell(cmd_getNumbOfActiveApps,
        function(out)
            if(tonumber(out) == 0 or out == "") then
                -- App not active -> start it
                awful.spawn.with_shell(appStartCmd)
            else
                -- App is running
                if restartAppFlag == true then
                    -- Kill old app and start a new one
                    -- First get PID of running app
                    awful.spawn.easy_async_with_shell(cmd_getActiveAppPID,
                        function(out)
                            -- Kill old program
                            -- We could do it with `awful.spawn.with_shell()`
                            -- but then later we would start a new app before the previously
                            -- running app closed correctly
                            awful.easy_async_with_shell.with_shell("kill "..out,
                                function(out)
                                    -- Don't care for output, just wait a bit in order for
                                    -- program to close before starting a new one
                                    awful.spawn.with_shell(appStartCmd)
                                end
                            )
                        end
                    )
                end
            end
        end
    )
end

awesome.connect_signal(
    'startup',
    function(args)
        --awful.spawn.with_shell("picom")
        --awful.spawn.with_shell("nitrogen --restore")
        --awful.spawn.with_shell("nitrogen --set-zoom-fill --random /usr/share/backgrounds")
        awful.spawn.with_shell(string.format("nitrogen --set-zoom-fill --random %s", wallpapersCollectionPath))
        -- awful.spawn.with_shell("xss-lock -- ~/.config/lock.sh &")

        -- Mute microphone on boot
        beautiful.mic:mute()

        -- Set Colemak keyboard layout
        awful.spawn.easy_async_with_shell("~/.config/keymap/keymap.sh si_colemak",
            function(stdout, stderr, exitreason, exitcode)
                stdout = stdout:gsub("\n[^\n]*$", "")  -- Remove last newline character
                naughty.notify({preset=naughty.config.presets.normal, title="Changing keyboard layout", text=stdout})
            end)


        -- checkIfAppIsRunning("picom", "picom", true)
        checkIfAppIsRunning("redshift-gtk", "redshift-gtk -P", false)
        checkIfAppIsRunning("optimus-manager-qt", "optimus-manager-qt", false)
        checkIfAppIsRunning("udiskie", "udiskie", false)  -- automount USB disks

    end
)

-- possible workaround for tag preservation when switching back to default screen:
-- https://github.com/lcpz/awesome-copycats/issues/251
-- }}}
