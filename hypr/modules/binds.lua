-- BINDS
local terminal = "kitty"
local browser = "firefox"
local launcher = "rofi -show drun"

hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + F", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + D", hl.dsp.exec_cmd(launcher))

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exit())

for i = 1, 9 do
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
	hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end
