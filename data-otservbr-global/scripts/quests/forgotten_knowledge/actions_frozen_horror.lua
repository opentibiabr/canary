local config = {
	centerRoom = Position(32269, 31091, 14),
	BossPosition = Position(32269, 31091, 14),
	newPosition = Position(32271, 31097, 14),
}

local monsters = {
	{ monster = "icicle", pos = Position(32266, 31084, 14) },
	{ monster = "icicle", pos = Position(32272, 31084, 14) },
	{ monster = "dragon egg", pos = Position(32269, 31084, 14) },
	{ monster = "melting frozen horror", pos = Position(32267, 31071, 14) },
}

local leverMeltingFrozenHorror = Action()

function leverMeltingFrozenHorror.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(32302, 31088, 14) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		if Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.HorrorTimer) >= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait a while, recently someone challenge Frozen Horror.")
			return true
		end
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Frozen Horror.")
				return true
			end
		end
		for n = 1, #monsters do
			Game.createMonster(monsters[n].monster, monsters[n].pos, true, true)
		end
		Game.createMonster("solid frozen horror", config.BossPosition, true, true)
		for y = 31088, 31092 do
			local playerTile = Tile(Position(32302, y, 14)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				playerTile:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.HorrorTimer, os.stime() + 20 * 60 * 60)
			end
		end
		Game.setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.HorrorTimer, 1)
		addEvent(clearForgotten, 30 * 60 * 1000, Position(32264, 31070, 14), Position(32284, 31104, 14), Position(32319, 31091, 14), Storage.Quest.U11_02.ForgottenKnowledge.HorrorTimer)
		item:transform(8912)
	elseif item.itemid == 8912 then
		item:transform(8911)
	end
	return true
end

leverMeltingFrozenHorror:position(Position(32302, 31087, 14))
leverMeltingFrozenHorror:register()
