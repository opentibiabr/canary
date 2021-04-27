local config = {
	centerRoom = Position(32799, 32832, 14),
	bossPosition = Position(32799, 32827, 14),
	newPosition = Position(32800, 32831, 14)
}

local monsters = {
	{cosmic = 'cosmic energy prism a', pos = Position(32801, 32827, 14)},
	{cosmic = 'cosmic energy prism b', pos = Position(32798, 32827, 14)},
	{cosmic = 'cosmic energy prism c', pos = Position(32803, 32826, 14)},
	{cosmic = 'cosmic energy prism d', pos = Position(32796, 32826, 14)}
}

local function clearForgottenLloyd()
	local spectators = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(Position(32815, 32873, 13))
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say('Time out! You were teleported out by strange forces.', TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
end

local forgottenKnowledgeLever = Action()
function forgottenKnowledgeLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(32759, 32868, 14) then
			item:transform(9826)
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
		for n = 1, #monsters do
			Game.createMonster(monsters[n].cosmic, monsters[n].pos, true, true)
		end
		Game.createMonster("lloyd", config.bossPosition, true, true)
		for y = 32868, 32872 do
			local playerTile = Tile(Position(32759, y, 14)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.ForgottenKnowledge.LloydTimer) < os.time() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.ForgottenKnowledge.LloydTimer, os.time() + 20 * 3600)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait a while, recently someone challenge Lloyd.")
					return true
				end
			end
		end
		addEvent(clearForgottenLloyd, 30 * 60 * 1000)
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

forgottenKnowledgeLever:aid(24881)
forgottenKnowledgeLever:register()