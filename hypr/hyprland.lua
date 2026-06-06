require("modules.binds")

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.config({
	input = {
		kb_layout = "de",
	},
})

-- exec once
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
end)
