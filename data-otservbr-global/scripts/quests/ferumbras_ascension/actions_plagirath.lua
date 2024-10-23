local config = {
	centerRoom = Position(33172, 31501, 13),
	BossPosition = Position(33172, 31501, 13),
	playerPositions = {
		Position(33229, 31500, 13),
		Position(33229, 31501, 13),
		Position(33229, 31502, 13),
		Position(33229, 31503, 13),
		Position(33229, 31504, 13),
	},
	newPosition = Position(33173, 31504, 13),
}

local leverPlagirath = Action()

function leverPlagirath.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(33229, 31500, 13) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		if Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.PlagirathTimer) >= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait a while, recently someone challenge Plagirath.")
			return true
		end
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Plagirath.")
				return true
			end
		end
		Game.createMonster("Plagirath", config.BossPosition, true, true)
		for y = 31500, 31504 do
			local playerTile = Tile(Position(33229, y, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				playerTile:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.PlagirathTimer, os.time() + 60 * 60 * 24 * 2)
			end
		end
		Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.PlagirathTimer, 1)
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33159, 31491, 13), Position(33185, 31513, 13), Position(33319, 32318, 13), Storage.Quest.U10_90.FerumbrasAscension.PlagirathTimer)
		item:transform(8912)
	elseif item.itemid == 8912 then
		item:transform(8911)
	end

	return true
end

leverPlagirath:uid(1022)
leverPlagirath:register()
