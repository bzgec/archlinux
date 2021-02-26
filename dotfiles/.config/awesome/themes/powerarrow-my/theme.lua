--[[

     Powerarrow Awesome WM theme
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local math, string, os = math, string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-my"
theme.icon_dir                                  = theme.dir .. "/icons"
theme.wallpaper                                 = theme.dir .. "/starwars.jpg"
theme.font                                      = "Mononoki Nerd Font 9"
theme.taglist_font                              = "Droid Sans Bold 7"

theme.fg_normal                                 = "#DDDDFF"
--theme.fg_focus                                  = "#EA6F81"
theme.fg_focus                                  = "#ebe7e6"
theme.fg_urgent                                 = "#CC9393"
theme.bg_normal                                 = "#1A1A1A"
theme.bg_focus                                  = "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.border_width                              = dpi(2)
--theme.border_normal                             = "#3F3F3FFF"  -- Not transparent
theme.border_normal                             = "#3F3F3F00"  -- Fully transparent
--theme.border_focus                              = "#7F7F7F"
theme.border_focus                              = "#cc6600"
theme.border_marked                             = "#CC9393"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
--theme.taglist_fg_focus                          = "#282a36"
theme.taglist_fg_focus                          = theme.fg_focus
theme.tasklist_bg_normal                        = theme.bg_normal
theme.tasklist_bg_focus                         = theme.bg_focus
theme.tasklist_fg_normal                        = theme.fg_normal
theme.tasklist_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.tooltip_bg                                = theme.bg_normal
theme.tooltip_fg                                = theme.fg_normal

--theme.fg_normal                                 = "#ffffff"
--theme.fg_focus                                  = "#A77AC4"
--theme.fg_urgent                                 = "#b74822"
--theme.bg_normal                                 = "#282a36"
--theme.bg_focus                                  = "#FF79C6"
--theme.bg_urgent                                 = "#3F3F3F"
--theme.taglist_fg_focus                          = "#282a36"
--theme.tasklist_bg_focus                         = "#000000"
--theme.tasklist_fg_focus                         = "#A77AC4"
--theme.border_width                              = 2
--theme.border_normal                             = "#282a36"
--theme.border_focus                              = "#F07178"
--theme.border_marked                             = "#CC9393"
--theme.titlebar_bg_focus                         = "#3F3F3F"
--theme.titlebar_bg_normal                        = "#3F3F3F"
--theme.titlebar_bg_focus                         = theme.bg_focus
--theme.titlebar_bg_normal                        = theme.bg_normal
--theme.titlebar_fg_focus                         = theme.fg_focus
--theme.menu_height                               = 20
--theme.menu_width                                = 140

-- Dark icons
--theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
--theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
--theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
--theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
--theme.layout_tile                               = theme.dir .. "/icons/layouts/tile.png"
--theme.layout_tileleft                           = theme.dir .. "/icons/layouts/tileleft.png"
--theme.layout_tilebottom                         = theme.dir .. "/icons/layouts/tilebottom.png"
--theme.layout_tiletop                            = theme.dir .. "/icons/layouts/tiletop.png"
--theme.layout_fairv                              = theme.dir .. "/icons/layouts/fairv.png"
--theme.layout_fairh                              = theme.dir .. "/icons/layouts/fairh.png"
--theme.layout_spiral                             = theme.dir .. "/icons/layouts/spiral.png"
--theme.layout_dwindle                            = theme.dir .. "/icons/layouts/dwindle.png"
--theme.layout_max                                = theme.dir .. "/icons/layouts/max.png"
--theme.layout_fullscreen                         = theme.dir .. "/icons/layouts/fullscreen.png"
--theme.layout_magnifier                          = theme.dir .. "/icons/layouts/magnifier.png"
--theme.layout_floating                           = theme.dir .. "/icons/layouts/floating.png"

-- White icons
theme.menu_submenu_icon                         = theme.icon_dir .. "/submenu.png"
theme.awesome_icon                              = theme.icon_dir .. "/awesome.png"
theme.taglist_squares_sel                       = theme.icon_dir .. "/square_sel.png"
theme.taglist_squares_unsel                     = theme.icon_dir .. "/square_unsel.png"
theme.layout_tile                               = theme.icon_dir .. "/layouts/tilew.png"
theme.layout_tileleft                           = theme.icon_dir .. "/layouts/tileleftw.png"
theme.layout_tilebottom                         = theme.icon_dir .. "/layouts/tilebottomw.png"
theme.layout_tiletop                            = theme.icon_dir .. "/layouts/tiletopw.png"
theme.layout_fairv                              = theme.icon_dir .. "/layouts/fairvw.png"
theme.layout_fairh                              = theme.icon_dir .. "/layouts/fairhw.png"
theme.layout_spiral                             = theme.icon_dir .. "/layouts/spiralw.png"
theme.layout_dwindle                            = theme.icon_dir .. "/layouts/dwindlew.png"
theme.layout_max                                = theme.icon_dir .. "/layouts/maxw.png"
theme.layout_fullscreen                         = theme.icon_dir .. "/layouts/fullscreenw.png"
theme.layout_magnifier                          = theme.icon_dir .. "/layouts/magnifierw.png"
theme.layout_floating                           = theme.icon_dir .. "/layouts/floatingw.png"

--theme.layout_tile                               = theme.dir .. "/icons/tile.png"
--theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
--theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
--theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
--theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
--theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
--theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
--theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
--theme.layout_max                                = theme.dir .. "/icons/max.png"
--theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
--theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
--theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.icon_dir .. "/ac.png"
theme.widget_bat_000_charging                   = theme.icon_dir .. "/bat-000-charging.png"
theme.widget_bat_000                            = theme.icon_dir .. "/bat-000.png"
theme.widget_bat_020_charging                   = theme.icon_dir .. "/bat-020-charging.png"
theme.widget_bat_020                            = theme.icon_dir .. "/bat-020.png"
theme.widget_bat_040_charging                   = theme.icon_dir .. "/bat-040-charging.png"
theme.widget_bat_040                            = theme.icon_dir .. "/bat-040.png"
theme.widget_bat_060_charging                   = theme.icon_dir .. "/bat-060-charging.png"
theme.widget_bat_060                            = theme.icon_dir .. "/bat-060.png"
theme.widget_bat_080_charging                   = theme.icon_dir .. "/bat-080-charging.png"
theme.widget_bat_080                            = theme.icon_dir .. "/bat-080.png"
theme.widget_bat_100_charging                   = theme.icon_dir .. "/bat-100-charging.png"
theme.widget_bat_100                            = theme.icon_dir .. "/bat-100.png"
theme.widget_bat_charged                        = theme.icon_dir .. "/bat-charged.png"
theme.widget_mem                                = theme.icon_dir .. "/mem.png"
theme.widget_cpu                                = theme.icon_dir .. "/cpu.png"
theme.widget_temp                               = theme.icon_dir .. "/temp.png"
theme.widget_net                                = theme.icon_dir .. "/net.png"
theme.widget_hdd                                = theme.icon_dir .. "/hdd.png"
theme.widget_music                              = theme.icon_dir .. "/note.png"
theme.widget_music_on                           = theme.icon_dir .. "/note.png"
theme.widget_music_pause                        = theme.icon_dir .. "/pause.png"
theme.widget_music_stop                         = theme.icon_dir .. "/stop.png"
theme.widget_mail                               = theme.icon_dir .. "/mail.png"
theme.widget_mail_on                            = theme.icon_dir .. "/mail_on.png"
theme.widget_task                               = theme.icon_dir .. "/task.png"
theme.widget_scissors                           = theme.icon_dir .. "/scissors.png"
theme.widget_weather                            = theme.icon_dir .. "/dish.png"
theme.widget_micMuted                           = theme.icon_dir .. "/mic_muted.png"
theme.widget_micUnmuted                         = theme.icon_dir .. "/mic_unmuted.png"
theme.wifidisc                                  = theme.icon_dir .. "/wireless-disconnected.png"
theme.wififull                                  = theme.icon_dir .. "/wireless-full.png"
theme.wifihigh                                  = theme.icon_dir .. "/wireless-high.png"
theme.wifilow                                   = theme.icon_dir .. "/wireless-low.png"
theme.wifimed                                   = theme.icon_dir .. "/wireless-medium.png"
theme.wifinone                                  = theme.icon_dir .. "/wireless-none.png"
theme.volhigh                                   = theme.icon_dir .. "/volume-high.png"
theme.vollow                                    = theme.icon_dir .. "/volume-low.png"
theme.volmed                                    = theme.icon_dir .. "/volume-medium.png"
theme.volmutedblocked                           = theme.icon_dir .. "/volume-muted-blocked.png"
theme.volmuted                                  = theme.icon_dir .. "/volume-muted.png"
theme.voloff                                    = theme.icon_dir .. "/volume-off.png"
--theme.tasklist_plain_task_name                  = true
--theme.tasklist_disable_icon                     = true
theme.tasklist_plain_task_name                  = false
theme.tasklist_disable_icon                     = false
theme.useless_gap                               = dpi(0)
theme.titlebar_close_button_focus               = theme.icon_dir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.icon_dir .. "/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.icon_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.icon_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.icon_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.icon_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.icon_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.icon_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.icon_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.icon_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.icon_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.icon_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.icon_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.icon_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.icon_dir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.icon_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.icon_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.icon_dir .. "/titlebar/maximized_normal_inactive.png"

local markup = lain.util.markup
local separators = lain.util.separators

--local arrowColor1 = theme.bg_focus
--local arrowColor2 = "alpha"
local arrowColor1 = "#7197E7"
local arrowColor2 = "#A77AC4"
--local arrowColor1 = "#140303"
--local arrowColor2 = "#6e2c0f"
--local arrowColor2 = "#204009"
--local arrowColor2 = "#b55400"

local textMarginTop = dpi(2)

-- Textclock
local clock = awful.widget.watch(
    --"date +'%a %d %b %R'", 60,
    "date +'%H:%M:%S  %d/%m/%Y'", 0.3,
    function(widget, stdout)
        widget:set_markup(markup.font(theme.font, stdout))
    end
)
local widget_clock = wibox.widget { nil, clock, layout = wibox.layout.align.horizontal }

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "Mononoki Nerd Font 11",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})



-- Taskwarrior
--local task = wibox.widget.imagebox(theme.widget_task)
--lain.widget.contrib.task.attach(task, {
    -- do not colorize output
--    show_cmd = "task | sed -r 's/\\x1B\\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g'"
--})
--task:buttons(gears.table.join(awful.button({}, 1, lain.widget.contrib.task.prompt)))



-- Mail IMAP check
local mailicon = wibox.widget.imagebox(theme.widget_mail)
--[[ commented because it needs to be set before use
mailicon:buttons(my_table.join(awful.button({ }, 1, function () awful.spawn(mail) end)))
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            widget:set_text(" " .. mailcount .. " ")
            mailicon:set_image(theme.widget_mail_on)
        else
            widget:set_text("")
            mailicon:set_image(theme.widget_mail)
        end
    end
})
--]]

-- MPD
local musicplr = "urxvt -title Music -g 130x34-320+16 -e ncmpcpp"
local mpdicon = wibox.widget.imagebox(theme.widget_music)
mpdicon:buttons(my_table.join(
    awful.button({ modkey }, 1, function () awful.spawn.with_shell(musicplr) end),
    --[[awful.button({ }, 1, function ()
        awful.spawn.with_shell("mpc prev")
        theme.mpd.update()
    end),
    --]]
    awful.button({ }, 2, function ()
        awful.spawn.with_shell("mpc toggle")
        theme.mpd.update()
    end),
    awful.button({ modkey }, 3, function () awful.spawn.with_shell("pkill ncmpcpp") end),
    awful.button({ }, 3, function ()
        awful.spawn.with_shell("mpc stop")
        theme.mpd.update()
    end)))
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title  = mpd_now.title  .. " "
            mpdicon:set_image(theme.widget_music_on)
            widget:set_markup(markup.font(theme.font, markup("#FFFFFF", artist) .. " " .. title))
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.font(theme.font, " mpd paused "))
            mpdicon:set_image(theme.widget_music_pause)
        else
            widget:set_text("")
            mpdicon:set_image(theme.widget_music)
        end
    end
})
local widget_mpd = wibox.widget { mpdicon, theme.mpd.widget, layout = wibox.layout.align.horizontal }

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})
local widget_mem = wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})
local widget_cpu = wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }

-- Coretemp (lain, average)
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})
--]]
local widget_temp = wibox.widget { tempicon, temp.widget, layout = wibox.layout.align.horizontal }

--[[ Weather
https://openweathermap.org/
Type in the name of your city
Copy/paste the city code in the URL to this file in city_id
--]]
local weathericon = wibox.widget.imagebox(theme.widget_weather)
theme.weather = lain.widget.weather({
    city_id = 3196359, -- placeholder (Ljubljana)
    --city_id = 3202781, -- placeholder (Celje)
    notification_preset = { font = "Mononoki Nerd Font 11", fg = theme.fg_normal },
    weather_na_markup = markup.fontfg(theme.font, "#ffffff", "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, "#ffffff", descr .. " @ " .. units .. "°C "))
    end
})
local widget_weather = wibox.widget { weathericon, theme.weather.widget, layout = wibox.layout.align.horizontal }

--[[ / fs
local fsicon = wibox.widget.imagebox(theme.widget_hdd)
theme.fs = lain.widget.fs({
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Noto Sans Mono Medium 10" },
    settings = function()
        local fsp = string.format(" %3.2f %s ", fs_now["/"].free, fs_now["/"].units)
        widget:set_markup(markup.font(theme.font, fsp))
    end
})
--]]

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_bat_000)
theme.bat = lain.widget.bat({
    timeout = 30,
    settings = function()
        local index, perc = "widget_bat_", tonumber(bat_now.perc) or 0
        local batStatusString = "N/A"

        if perc <= 7 then
            index = index .. "000"
        elseif perc <= 20 then
            index = index .. "020"
        elseif perc <= 40 then
            index = index .. "040"
        elseif perc <= 60 then
            index = index .. "060"
        elseif perc <= 80 then
            index = index .. "080"
        elseif perc <= 100 then
            index = index .. "100"
        end

        if bat_now.ac_status == 1 then
            index = index .. "_charging"
            batStatusString = string.format("%s%%", perc)
        else
            batStatusString = string.format("%s%%, %s", perc, bat_now.time)
        end

        baticon:set_image(theme[index])
        widget:set_markup(markup.font(theme.font, batStatusString))

        --if bat_now.status and bat_now.status ~= "N/A" then
        --    if bat_now.ac_status == 1 then
        --        widget:set_markup(markup.font(theme.font, " AC "))
        --        baticon:set_image(theme.widget_ac)
        --        return
        --    elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
        --        baticon:set_image(theme.widget_battery_empty)
        --    elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
        --        baticon:set_image(theme.widget_battery_low)
        --    else
        --        baticon:set_image(theme.widget_battery)
        --    end
        --    widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        --else
        --    widget:set_markup()
        --    baticon:set_image(theme.widget_ac)
        --end
    end
})
local widget_bat = wibox.widget { baticon, theme.bat.widget, layout = wibox.layout.align.horizontal }

-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.volmutedblocked)
        elseif volume_now.level == 0 then
            volicon:set_image(theme.volmuted)
        elseif volume_now.level <= 5 then
            volicon:set_image(theme.voloff)
        elseif volume_now.level <= 25 then
            volicon:set_image(theme.vollow)
        elseif volume_now.level <= 75 then
            volicon:set_image(theme.volmed)
        else
            volicon:set_image(theme.volhigh)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
    end
})
local widget_vol = wibox.widget { volicon, theme.volume.widget, layout = wibox.layout.align.horizontal }

-- Microphone
theme.mic = lain.widget.mic({
    settings = function()
        if mic_now.state == "muted" then
            widget:set_image(theme.widget_micMuted)
        else
            widget:set_image(theme.widget_micUnmuted)
        end
    end
})
local widget_mic = wibox.widget { nil, theme.mic.widget, layout = wibox.layout.align.horizontal }

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#FEFEFE", " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " "))
        --widget:set_markup(markup.font(theme.font,
        --                  markup("#7AC82E", " " .. string.format("%06.1f", net_now.received))
        --                  .. " " ..
        --                  markup("#46A8C3", " " .. string.format("%06.1f", net_now.sent) .. " ")))
    end
})
local widget_net = wibox.widget { nil, neticon, net.widget, layout = wibox.layout.align.horizontal }

-- Wireless Quality link (converted quality link to percentages) and status
theme.wirelessStatus = lain.widget.wirelessStatus({
    notification_preset = { font = "Mononoki Nerd Font 10", fg = theme.fg_normal },

    settings = function()
        if wirelessStatus_now.status == "1" or wirelessStatus_now.status == "" then
            widget:set_image(theme.wifidisc)
        else
            if wirelessStatus_now.perc <= 5 then
                widget:set_image(theme.wifinone)
            elseif wirelessStatus_now.perc <= 25 then
                widget:set_image(theme.wifilow)
            elseif wirelessStatus_now.perc <= 50 then
                widget:set_image(theme.wifimed)
            elseif wirelessStatus_now.perc <= 75 then
                widget:set_image(theme.wifihigh)
            else
                widget:set_image(theme.wififull)
            end
        end
    end,
})
local widget_wirelessStatus = wibox.widget { nil, theme.wirelessStatus.widget, layout = wibox.layout.align.horizontal }

-- Separators
local arrow = separators.arrow_left

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })
   --s.quake = lain.util.quake({ app = "termite", height = 0.50, argname = "--name %s" })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- All tags open with layout 1
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s,
                                         awful.widget.tasklist.filter.currenttags,
                                         awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(16), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mykeyboardlayout,


            -- using separators
           -- wibox.container.background(wibox.container.margin(wibox.widget { mailicon, mail and mail.widget, layout = wibox.layout.align.horizontal }, 4, 7), "#343434"),
            arrow("alpha", arrowColor1),
            --wibox.container.background(wibox.container.margin(widget_net, dpi(3), dpi(3)), arrowColor1),
            wibox.container.background(wibox.container.margin(neticon, dpi(3), dpi(0), dpi(0)), arrowColor1),
            wibox.container.background(wibox.container.margin(net.widget, dpi(0), dpi(3), textMarginTop), arrowColor1),
            arrow(arrowColor1, arrowColor2),
            wibox.container.background(wibox.container.margin(widget_mpd, dpi(3), dpi(3)), arrowColor2),
            arrow(arrowColor2, arrowColor1),
            --wibox.container.background(wibox.container.margin(widget_mem, dpi(3), dpi(3)), arrowColor1),
            wibox.container.background(wibox.container.margin(memicon, dpi(3), dpi(0), dpi(0)), arrowColor1),
            wibox.container.background(wibox.container.margin(mem.widget, dpi(0), dpi(3), textMarginTop), arrowColor1),
            arrow(arrowColor1, arrowColor2),
            -- TODO: add GPU status
            arrow(arrowColor2, arrowColor1),
            --wibox.container.background(wibox.container.margin(widget_cpu, dpi(3), dpi(3)), arrowColor1),
            wibox.container.background(wibox.container.margin(cpuicon, dpi(3), dpi(0), dpi(0)), arrowColor1),
            wibox.container.background(wibox.container.margin(cpu.widget, dpi(0), dpi(3), textMarginTop), arrowColor1),
            arrow(arrowColor1, arrowColor2),
            --wibox.container.background(wibox.container.margin(widget_temp, dpi(3), dpi(3)), arrowColor2),
            wibox.container.background(wibox.container.margin(tempicon, dpi(3), dpi(0), dpi(0)), arrowColor2),
            wibox.container.background(wibox.container.margin(temp.widget, dpi(0), dpi(3), textMarginTop), arrowColor2),
            arrow(arrowColor2, arrowColor1),
            --wibox.container.background(wibox.container.margin(widget_weather, dpi(3), dpi(3)), arrowColor1),
            wibox.container.background(wibox.container.margin(weathericon, dpi(3), dpi(0), dpi(0)), arrowColor1),
            wibox.container.background(wibox.container.margin(theme.weather.widget, dpi(0), dpi(3), textMarginTop), arrowColor1),
            arrow(arrowColor1, arrowColor2),
            --wibox.container.background(wibox.container.margin(widget_bat, dpi(3), dpi(3)), arrowColor2),
            wibox.container.background(wibox.container.margin(baticon, dpi(3), dpi(3), dpi(0)), arrowColor2),
            wibox.container.background(wibox.container.margin(theme.bat.widget, dpi(0), dpi(3), textMarginTop), arrowColor2),
            arrow(arrowColor2, arrowColor1),
            wibox.container.background(wibox.container.margin(widget_wirelessStatus, dpi(3), dpi(3)), arrowColor1),
            arrow(arrowColor1, arrowColor2),
            wibox.container.background(wibox.container.margin(widget_mic, dpi(3), dpi(3)), arrowColor2),
            arrow(arrowColor2, arrowColor1),
            --wibox.container.background(wibox.container.margin(widget_vol, dpi(3), dpi(3), dpi(4)), arrowColor1),
            wibox.container.background(wibox.container.margin(volicon, dpi(3), dpi(0), dpi(0)), arrowColor1),
            wibox.container.background(wibox.container.margin(theme.volume.widget, dpi(0), dpi(3), textMarginTop), arrowColor1),
            arrow(arrowColor1, arrowColor2),
            wibox.container.background(wibox.container.margin(widget_clock, dpi(4), dpi(8), textMarginTop), arrowColor2),
            arrow(arrowColor2, "alpha"),
            --]]
            s.mylayoutbox,
        },
    }
end

-- Update battery status on startup
function theme.onStartup()
    theme.bat.update()
            n = require("naughty"); n.notify({preset=n.config.presets.normal, title="debug", text="ON STARTUP"})
    theme.bat.update()
    theme.bat.update()
    theme.bat.update()
    theme.bat.update()
end
--beautiful.bat:emit_signal("timeout")

return theme
