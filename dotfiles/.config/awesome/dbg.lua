
n = require("naughty"); n.notify({preset=n.config.presets.normal, title="debug", text="stdout: "..stdout})
-- Opens a file in append mode
file = io.open("/home/bzgec/tmp.txt", "a")

-- sets the default output file as test.lua
io.output(file)

-- appends a word test to the last line of the file
io.write("stdout: "..stdout.."\n")
io.write("exit_code: "..exit_code.."\n")

-- closes the open file
io.close(file)






        -- helpers.async('sensors', function(f)
        --     for t in f:gmatch("[^\n]+") do
        --         -- Grep a line with: "Tctl:         +37.4°C"
        --         if string.find(t, "Tctl") then
        --             -- Filter out only the 37.4
        --             coretemp_now = math.ceil(t:match('.%+(.*)°C'))
        --         end
        --     end
        --     -- coretemp_now = math.ceil(temp_now[tempfile]) or "N/A"
        --     -- coretemp_now = 33 or "N/A"
        --     widget = temp.widget
        --     settings()
        -- end)
