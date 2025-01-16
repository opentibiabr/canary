local wallsCustom = {
	[1] = {
		cor = "white",
		itemId = 64006,
	},
	[2] = {
		cor = "orange",
		itemId = 64007,
	},
	[3] = {
		cor = "purple",
		itemId = 64008,
	},
	[4] = {
		cor = "black",
		itemId = 64009,
	},
	[5] = {
		cor = "light green",
		itemId = 64010,
	},
	[6] = {
		cor = "green with blue",
		itemId = 64011,
	},
	[7] = {
		cor = "red with black",
		itemId = 64012,
	},
}

function playerHaveCustomWall(player, wallKey)
	local playerKV = player:kv()
	local kvString = "custommagicwall." .. wallKey .. ".purchased"
	if playerKV:get(kvString) == 1 then
		return true
	end

	return false
end

function GetNotOwnedWalls(player)
	local playerKV = player:kv()
	local notOwnedWalls = {}
	for index, value in pairs(wallsCustom) do
		local kvString = "custommagicwall." .. index .. ".purchased"
		if playerKV:get(kvString) ~= 1 then
			table.insert(notOwnedWalls, value)
		end
	end
	return notOwnedWalls
end

function GetCustomMagicWallByStorage(storage)
	local mw = wallsCustom[storage]
	if mw then
		return mw
	end
end

function GetWallsCustom()
	return wallsCustom
end
