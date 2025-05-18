local config = {
	[7738] = {
		storage = Storage.Quest.U8_2.ElementalSpheres.KnightBoss,
		corpse = 8139,
		charged = 2126,
		inactive = 0,
		boss = "energy overlord",
		effect = CONST_ME_BIGCLOUDS,
		summonPos = Position(33095, 32194, 13),
		positions = {
			Position(33094, 32189, 13),
			Position(33097, 32189, 13),
			Position(33099, 32191, 13),
			Position(33099, 32194, 13),
			Position(33097, 32196, 13),
			Position(33094, 32196, 13),
			Position(33092, 32194, 13),
			Position(33092, 32191, 13),
		},
	},
	[7739] = {
		storage = Storage.Quest.U8_2.ElementalSpheres.SorcererBoss,
		corpse = 8141,
		charged = 7745,
		inactive = 7743,
		boss = "fire overlord",
		effect = CONST_ME_FIREAREA,
		summonPos = Position(33199, 32103, 13),
		positions = {
			Position(33198, 32102, 13),
			Position(33201, 32102, 13),
			Position(33203, 32104, 13),
			Position(33203, 32107, 13),
			Position(33201, 32109, 13),
			Position(33198, 32109, 13),
			Position(33196, 32107, 13),
			Position(33196, 32104, 13),
		},
	},
	[7740] = {
		storage = Storage.Quest.U8_2.ElementalSpheres.PaladinBoss,
		corpse = 8140,
		charged = 7744,
		inactive = 7741,
		boss = "Ice Overlord",
		effect = CONST_ME_ICETORNADO,
		summonEffect = CONST_ME_ICEAREA,
		summonPos = Position(33286, 32102, 13),
		positions = {
			Position(33285, 32097, 13),
			Position(33288, 32097, 13),
			Position(33290, 32099, 13),
			Position(33290, 32102, 13),
			Position(33288, 32104, 13),
			Position(33285, 32104, 13),
			Position(33283, 32102, 13),
			Position(33283, 32099, 13),
		},
	},
	[7748] = {
		storage = Storage.Quest.U8_2.ElementalSpheres.DruidBoss,
		corpse = 8106,
		charged = 7746,
		inactive = 7742,
		boss = "Earth Overlord",
		effect = CONST_ME_BIGPLANTS,
		summonPos = Position(33347, 32208, 13),
		positions = {
			Position(33346, 32203, 13),
			Position(33349, 32203, 13),
			Position(33351, 32205, 13),
			Position(33351, 32208, 13),
			Position(33349, 32210, 13),
			Position(33346, 32210, 13),
			Position(33344, 32208, 13),
			Position(33344, 32205, 13),
		},
	},
}

local summonOverlord = MoveEvent()

function summonOverlord.onAddItem(moveitem, tileitem, position)
	local target = config[tileitem.itemid]
	if not target then
		return true
	end

	local cStorage = target.storage
	if target.corpse ~= moveitem.itemid or Game.getStorageValue(cStorage) == 1 then
		return true
	end

	for i = 1, #target.positions do
		if not Tile(target.positions[i]):getItemById(target.charged) then
			return true
		end
	end

	moveitem:remove()
	position:sendMagicEffect(target.effect)
	target.summonPos:sendMagicEffect(target.summonEffect or target.effect)
	Game.createMonster(target.boss, target.summonPos)
	Game.setStorageValue(cStorage, 1)
	return true
end

summonOverlord:type("additem")

for index, value in pairs(config) do
	summonOverlord:id(index)
end

summonOverlord:register()
