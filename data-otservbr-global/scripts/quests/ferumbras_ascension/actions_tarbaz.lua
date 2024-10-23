local config = {
	centerRoom = Position(33459, 32844, 11),
	BossPosition = Position(33459, 32844, 11),
	newPosition = Position(33459, 32848, 11),
}

local leverTarbaz = Action()

function leverTarbaz.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(33418, 32849, 11) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		local playersTable = {}
		if player:doCheckBossRoom("Tarbaz", Position(33446, 32833, 11), Position(33515, 32875, 12)) then
			local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
			for i = 1, #specs do
				spec = specs[i]
				if spec:isPlayer() then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Tarbaz.")
					return true
				end
			end
			Game.createMonster("Tarbaz", config.BossPosition, true, true)
			for y = 32849, 32853 do
				local playerTile = Tile(Position(33418, y, 11)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TarbazTimer, os.time() + 60 * 60 * 2 * 24)
					table.insert(playersTable, playerTile:getId())
				end
			end
			addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, Position(33446, 32833, 11), Position(33515, 32875, 12), Position(33319, 32318, 13))
			item:transform(8912)
		end
	elseif item.itemid == 8912 then
		item:transform(8911)
	end

	return true
end

leverTarbaz:uid(1027)
leverTarbaz:register()
