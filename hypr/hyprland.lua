require("modules.binds")

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.config({
	input = {
		kb_layout = "de",
	},
	general = {
		border_size = 3,
		col = {
			active_border = "rgba(1eafc4dd)",
			inactive_border = "rgba(1eafc466)",
		},
	},
	decoration = {
		rounding = 12,
	},
})

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
end)
