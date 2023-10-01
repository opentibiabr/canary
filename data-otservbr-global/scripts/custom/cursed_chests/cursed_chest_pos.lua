
	local curseSpawn = GlobalEvent("curseSpawn")

	CURSED_CHESTS_AID = 162851

CURSED_CHESTS_SPAWNS = {
	[1] = {
		pos = Position(31721, 31895, 7),
		size = 20,
		chests = {1}
	},
	[2] = {
		pos = Position(33527, 31249, 7),
		size = 30,
		chests = {1}
	},
	[3] = {
		pos = Position(33623, 31645, 7),
		size = 30,
		chests = {1}
	},
	[4] = {
		pos = Position(33850, 31585, 7),
		size = 30,
		chests = {1}
	},
	[5] = {
		pos = Position(33626, 32398, 7),
		size = 30,
		chests = {2}
	},
	[6] = {
		pos = Position(33195, 32694, 7),
		size = 30,
		chests = {2}
	},
	[7] = {
		pos = Position(33165, 32398, 7),
		size = 30,
		chests = {1}
	},
	[8] = {
		pos = Position(32788, 32752, 7),
		size = 60,
		chests = {3}
	},
	[9] = {
		pos = Position(32409, 32498, 7),
		size = 200,
		chests = {6}
	},
	[10] = {
		pos = Position(32664, 32056, 7),
		size = 200,
		chests = {6}
	},
	[11] = {
		pos = Position(33178, 31384, 7),
		size = 40,
		chests = {2}
	},
	[12] = {
		pos = Position(32027, 31264, 7),
		size = 25,
		chests = {2}
	},
	[13] = {
		pos = Position(32801, 31205, 7),
		size = 30,
		chests = {1}
	},
	[14] = {
		pos = Position(33195, 31146, 7),
		size = 30,
		chests = {1}
	},
	[15] = {
		pos = Position(33200, 31748, 7),
		size = 30,
		chests = {1}
	},
	[16] = {
		pos = Position(33466, 31766, 8),
		size = 18,
		chests = {1}
	},
	[17] = {
		pos = Position(33564, 32379, 8),
		size = 18,
		chests = {1}
	},


}

function curseSpawn.onThink(cid, interval, lastExecution)
	for spawnId, data in ipairs(CURSED_CHESTS_SPAWNS) do
		if not data.spawned then
			local from = Position(data.pos.x - data.size, data.pos.y - data.size, data.pos.z)
			local to = Position(data.pos.x + data.size, data.pos.y + data.size, data.pos.z)
			local chestId = math.random(1, #data.chests)
			local spawnPos = Position(math.random(from.x, to.x), math.random(from.y, to.y), data.pos.z)
			local tile = Tile(spawnPos)
			local spawnTest = 0

			while spawnTest < 100 do
				if isBadTile(tile) then
					spawnPos = Position(math.random(from.x, to.x), math.random(from.y, to.y), data.pos.z)
					tile = Tile(spawnPos)
					spawnTest = spawnTest + 1
				else
					break
				end
			end

			if spawnTest < 100 then
				local rarity = nil
				for i = #CURSED_CHESTS_TIERS, 1, -1 do
					rarity = CURSED_CHESTS_TIERS[i]
					if math.random(1, 100) <= rarity.chance then
						break
					end
				end
				if rarity ~= nil then
					local chest = Game.createItem(rarity.item, 1, spawnPos)
					chest:setActionId(CURSED_CHESTS_AID)
					spawnPos:sendMagicEffect(CONST_ME_GROUNDSHAKER)
					local chestData = {}
					chestData.pos = spawnPos
					chestData.spawnId = spawnId
					chestData.wave = 0
					chestData.monsters = {}
					chestData.active = 0
					chestData.finished = false
					chestData.container = chest
					chestData.chest = CURSED_CHESTS_CONFIG[chestId]
					chestData.rarity = rarity
					CURSED_CHESTS_DATA[#CURSED_CHESTS_DATA + 1] = chestData
					data.spawned = true
				end
			end

		end
	end
	return true
end

curseSpawn:interval(1800000) 
curseSpawn:register()
