local config = {
	centerRoom = Position(32977, 31662, 14),
	newPosition = Position(32977, 31667, 14)
}

local bosses = {
	{bossPosition = Position(32977, 31662, 14), bossName = 'The Time Guardian'},
	{bossPosition = Position(32975, 31664, 13), bossName = 'The Freezing Time Guardian'},
	{bossPosition = Position(32980, 31664, 13), bossName = 'The Blazing Time Guardian'}
}

local forgottenKnowledgeGuardianLever = Action()
function forgottenKnowledgeGuardianLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33010, 31660, 14) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with The Time Guardian.")
				return true
			end
		end
		for q = 1,#bosses do
			Game.createMonster(bosses[q].bossName, bosses[q].bossPosition, true, true)
		end
		for y = 31660, 31664 do
			local playerTile = Tile(Position(33010, y, 14)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.ForgottenKnowledge.TimeGuardianTimer) < os.time() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.ForgottenKnowledge.TimeGuardianTimer, os.time() + 20 * 3600)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait a while, recently someone challenge The Time Guardian.")
					return true
				end
			end
		end
		addEvent(clearForgotten, 30 * 60 * 1000, Position(32967, 31654, 13), Position(32989, 31677, 14), Position(32870, 32724, 14))
		item:transform(9826)
		elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

forgottenKnowledgeGuardianLever:aid(24883)
forgottenKnowledgeGuardianLever:register()