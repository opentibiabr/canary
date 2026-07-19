-- Ordered expedition library loader (not under scripts/, so not auto-scanned).
local base = DATA_DIRECTORY .. "/lib/expeditions/"
local files = {
	"01_json.lua",
	"02_config.lua",
	"03_instance.lua",
	"04_waves.lua",
	"05_ai.lua",
	"06_protocol.lua",
	"07_manager.lua",
}

for _, file in ipairs(files) do
	dofile(base .. file)
end
