local config = {
	bossPosition = Position(33357, 31182, 10),
	newPosition = Position(33359, 31186, 10),
	soulPosition = Position(33359, 31182, 12)
}

local monsters = {
	{position = Position(33352, 31187, 10)},
	{position = Position(33363, 31187, 10)},
	{position = Position(33353, 31176, 10)},
	{position = Position(33363, 31176, 10)}
}

local forgottenKnowledgeDragonking = Action()
function forgottenKnowledgeDragonking.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33391, 31178, 10) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		for v = 10, 12 do
			local specs, spec = Game.getSpectators(Position(33357, 31182, v), false, false, 15, 15, 15, 15)
			for i = 1, #specs do
				spec = specs[i]
				if spec:isPlayer() then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Dragonking Zyrtarch.")
					return true
				end
			end
		end
		for d = 1, #monsters do
			Game.createMonster('soulcatcher', monsters[d].position, true, true)
		end
		Game.createMonster("dragonking zyrtarch", config.bossPosition, true, true)
		Game.createMonster("soul of dragonking zyrtarch", config.soulPosition, true, true)
		for y = 31178, 31182 do
			local playerTile = Tile(Position(33391, y, 10)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				if playerTile:getStorageValue(Storage.ForgottenKnowledge.DragonkingTimer) < os.time() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.ForgottenKnowledge.DragonkingTimer, os.time() + 20 * 3600)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait a while, recently someone challenge Frozen Horror.")
					return true
				end
			end
		end
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33348, 31172, 10), Position(33368, 31190, 12), Position(33407, 31172, 10))
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

forgottenKnowledgeDragonking:aid(24880)
forgottenKnowledgeDragonking:register()