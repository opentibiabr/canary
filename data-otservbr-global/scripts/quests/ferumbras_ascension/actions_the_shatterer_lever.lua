local config = {
	centerRoom = Position(33406, 32418, 14),
	BossPosition = Position(33406, 32418, 14),
	playerPositions = {
		Position(33403, 32465, 13),
		Position(33404, 32465, 13),
		Position(33405, 32465, 13),
		Position(33406, 32465, 13),
		Position(33407, 32465, 13),
	},
	newPosition = Position(33398, 32414, 14),
}

local ferumbrasAscendantTheShattererLever = Action()

function ferumbrasAscendantTheShattererLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8912 then
		if player:getPosition() ~= Position(33403, 32465, 13) then
			item:transform(8911)
			return true
		end
	end
	if item.itemid == 8912 then
		local playersTable = {}
		if player:doCheckBossRoom("The Shatterer", Position(33377, 32390, 14), Position(33446, 32447, 14)) then
			local specs, spec = Game.getSpectators(config.centerRoom, false, false, 30, 30, 30, 30)
			for i = 1, #specs do
				spec = specs[i]
				if spec:isPlayer() then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with The Shatterer.")
					return true
				end
			end
			Game.createMonster("The Shatterer", config.BossPosition, true, true)
			for x = 33403, 33407 do
				local playerTile = Tile(Position(x, 32465, 13)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererTimer, os.time() + 60 * 60 * 2 * 24)
					table.insert(playersTable, playerTile:getId())
				end
			end
			addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, Position(33377, 32390, 14), Position(33446, 32447, 14), Position(33319, 32318, 13))
			item:transform(8911)
		end
	elseif item.itemid == 8911 then
		item:transform(8912)
	end

	return true
end

ferumbrasAscendantTheShattererLever:uid(1029)
ferumbrasAscendantTheShattererLever:register()
