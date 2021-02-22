local stdout = "wlp4s0:-0-70"

print(stdout)
local interface, carrier, perc = stdout:match("(.*)-(%d)-(%d+)")
-- It would be better to `stdout:match()` a ":" character out and not remove with command below
interface = interface:sub(0, -2)  -- Remove last character from string ("wlp4s0:"" -> "wlp4s0")
print(interface)
print(carrier)
print(perc)
