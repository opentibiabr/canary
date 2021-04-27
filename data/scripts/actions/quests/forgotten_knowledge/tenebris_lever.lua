local config = {
	centerRoom = Position(32912, 31599, 14),
	bossPosition = Position(32912, 31599, 14),
	newPosition = Position(32911, 31603, 14)
}

local function clearTenebris()
	local spectators = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(Position(32902, 31629, 14))
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say('Time out! You were teleported out by strange forces.', TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
end

local forgottenKnowledgeTenebris = Action()
function forgottenKnowledgeTenebris.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(32902, 31623, 14) then
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Lloyd.")
				return true
			end
		end
		for d = 1, 6 do
			Game.createMonster('shadow tentacle', Position(math.random(32909, 32914), math.random(31596, 31601), 14), true, true)
		end
		Game.createMonster("lady tenebris", config.bossPosition, true, true)
		for y = 31623, 31627 do
			local playerTile = Tile(Position(32902, y, 14)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.ForgottenKnowledge.LadyTenebrisTimer) < os.time() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.ForgottenKnowledge.LadyTenebrisTimer, os.time() + 20 * 3600)
					playerTile:say('You have 20 minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.', TALKTYPE_MONSTER_SAY)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait a while, recently someone challenge Lady Tenebris.")
					return true
				end
			end
		end
		addEvent(clearTenebris, 20 * 60 * 1000, Position(32902, 31589, 14), Position(32922, 31589, 14), Position(32924, 31610, 14))
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

forgottenKnowledgeTenebris:aid(24878)
forgottenKnowledgeTenebris:register()