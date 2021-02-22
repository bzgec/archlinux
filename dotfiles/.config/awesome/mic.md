## Usage

[Read here.](https://github.com/lcpz/lain/wiki/Widgets#usage)

### Description

Show state of a microphone.

```lua
local mymic = lain.widget.mic({
    settings = function()
        if mic_now.state == "muted" then
            widget:set_image(theme.widget_micMuted)
        else
            widget:set_image(theme.widget_micUnmuted)
        end
    end
})
```

## Input table

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout (in seconds) | integer | 2
`settings` | User settings | function | empty function
`widget` | Widget to render | function | `wibox.widget.imagebox`

`settings` can use these strings:

* `mic_now.state`, state of a microphone (`muted`, `unmuted` or `error`);

## Output table

Variable | Meaning | Type
--- | --- | ---
`widget` | The widget | `wibox.widget.imagebox`
`update` | Update `widget` | function
