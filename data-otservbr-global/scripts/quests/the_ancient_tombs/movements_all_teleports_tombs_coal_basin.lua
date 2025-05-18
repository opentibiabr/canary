local config = {
	[9033] = { flamePosition = Position(33097, 32816, 13), toPosition = Position(33093, 32824, 13) },
	[9034] = { flamePosition = Position(33293, 32742, 13), toPosition = Position(33299, 32742, 13) },
	[9035] = {
		flamePosition = Position(33073, 32590, 13),
		toPosition = Position(33080, 32588, 13),
		specificCheck = function(player)
			if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.DiphtrahsTreasure) <= 0 then
				player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.DiphtrahsTreasure, 1)
			end
		end,
	},
	[9036] = {
		flamePosition = Position(33240, 32856, 13),
		toPosition = Position(33246, 32850, 13),
		specificCheck = function(player)
			if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.MahrdisTreasure) <= 0 then
				player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.MahrdisTreasure, 1)
			end
		end,
	},
	[9037] = { flamePosition = Position(33276, 32553, 14), toPosition = Position(33271, 32553, 14) },
	[9038] = { flamePosition = Position(33234, 32692, 13), toPosition = Position(33234, 32687, 13) },
	[9039] = { flamePosition = Position(33135, 32683, 12), toPosition = Position(33130, 32683, 12) },
	[9040] = { flamePosition = Position(33162, 32831, 10), toPosition = Position(33158, 32832, 10) },
}

local tombCoalBasin = MoveEvent()

function tombCoalBasin.onAddItem(moveitem, tileitem, position)
	local targetCoalBasin = config[tileitem.uid]
	if not targetCoalBasin then
		return true
	end

	if moveitem.itemid ~= 3042 then
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	moveitem:remove()
	position:sendMagicEffect(CONST_ME_HITBYFIRE)

	local player = Tile(targetCoalBasin.flamePosition):getTopCreature()
	if player and player:isPlayer() then
		if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.DefaultStart) ~= 1 then
			player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.DefaultStart, 1)
		end

		if targetCoalBasin.specificCheck then
			targetCoalBasin.specificCheck(player)
		end

		player:teleportTo(targetCoalBasin.toPosition)
		targetCoalBasin.toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

tombCoalBasin:type("additem")
tombCoalBasin:id(2114)
tombCoalBasin:register()
