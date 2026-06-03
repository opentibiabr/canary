local ICE_FLOWER = 13842
local CHANCE_PERCENT = 10

local POSITIONS = {
	{ x = 32255, y = 31079, z = 5 },
	{ x = 32255, y = 31066, z = 5 },
	{ x = 32204, y = 31054, z = 5 },
	{ x = 32192, y = 31048, z = 5 },
	{ x = 32163, y = 31030, z = 5 },
	{ x = 32145, y = 31036, z = 5 },
	{ x = 32136, y = 31049, z = 5 },
	{ x = 32122, y = 31060, z = 5 },
	{ x = 32112, y = 31071, z = 5 },
	{ x = 32120, y = 31082, z = 5 },
	{ x = 32149, y = 31061, z = 5 },
	{ x = 32155, y = 31085, z = 5 },
	{ x = 32183, y = 31091, z = 5 },
	{ x = 32217, y = 31091, z = 5 },
}

local function createThawingItem(pos)
	local tile = Tile(pos)
	if tile then
		return Game.createItem(ICE_FLOWER, 1, pos)
	end
	return false
end

local thawingMiniWorldChange = GlobalEvent("ThawingMiniWorldChange")

function thawingMiniWorldChange.onStartup()
	local eventChance = math.random(1, 100)
	if eventChance <= CHANCE_PERCENT then
		for _, pos in ipairs(POSITIONS) do
			createThawingItem(pos)
		end

		Game.setStorageValue(GlobalStorage.WorldBoard.ThawingMiniWorldChange, 1)

		local t = os.date("*t")
		print(string.format("[%04d-%02d-%02d %02d:%02d:%02d.000] [info] [World Change] Thawing World Change event is active.", t.year, t.month, t.day, t.hour, t.min, t.sec))
	end

	return true
end

thawingMiniWorldChange:register()
