local setting = {
	[50139] = Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage1,
	[50140] = Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage2,
	[50141] = Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage3,
	[50142] = Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage4,
	[50143] = Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage5,
	[50144] = Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage6,
	[50145] = Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage7,
}

local stepMorguthisBlueFlames = MoveEvent()

function stepMorguthisBlueFlames.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local storage = setting[item.uid]
	if storage then
		if player:getStorageValue(storage) ~= 1 then
			player:setStorageValue(storage, 1)
		end

		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	else
		local missingStorage = false
		for i = Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage1, Storage.Quest.U7_4.TheAncientTombs.MorguthisBlueFlameStorage7 do
			if player:getStorageValue(i) ~= 1 then
				missingStorage = true
				break
			end
		end

		if missingStorage then
			player:teleportTo(fromPosition, true)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		player:teleportTo(Position(33163, 32694, 14))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.MorguthisTreasure) <= 1 then
			player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.MorguthisTreasure, 2)
		end
	end
	return true
end

stepMorguthisBlueFlames:type("stepin")

for index, value in pairs(setting) do
	stepMorguthisBlueFlames:uid(index)
end
stepMorguthisBlueFlames:uid(50146)

stepMorguthisBlueFlames:register()
