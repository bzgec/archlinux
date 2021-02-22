
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
