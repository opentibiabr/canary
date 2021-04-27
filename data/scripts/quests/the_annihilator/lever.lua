local setting = {
	-- At what level can do the quest?
	requiredLevel = 100,
	-- Can it be done daily? true = yes, false = no
	daily = true,
	-- Do not change from here down
	centerDemonRoomPosition = {x = 33221, y = 31659, z = 13},
	demonsPositions = {
		{x = 33219, y = 31657, z = 13},
		{x = 33221, y = 31657, z = 13},
		{x = 33223, y = 31659, z = 13},
		{x = 33224, y = 31659, z = 13},
		{x = 33220, y = 31661, z = 13},
		{x = 33222, y = 31661, z = 13}
	},
	playersPositions = {
		{fromPos = {x = 33225, y = 31671, z = 13}, toPos = {x = 33222, y = 31659, z = 13}},
		{fromPos = {x = 33224, y = 31671, z = 13}, toPos = {x = 33221, y = 31659, z = 13}},
		{fromPos = {x = 33223, y = 31671, z = 13}, toPos = {x = 33220, y = 31659, z = 13}},
		{fromPos = {x = 33222, y = 31671, z = 13}, toPos = {x = 33219, y = 31659, z = 13}},
	}
}

local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		-- Checks if you have the 4 players and if they have the required level
		for i = 1, #setting.playersPositions do
			local creature = Tile(setting.playersPositions[i].fromPos):getTopCreature()
			if not creature then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Four players are required to start the quest.")
				return true
			end
			if creature and creature:getLevel() < setting.requiredLevel then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level ".. setting.requiredLevel .." or higher.")
				return true
			end
		end

		-- Checks if there are still players inside the room, if so, return true
		if Position.hasPlayer(setting.centerDemonRoomPosition, 4, 4) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
			return true
		end

		-- Create monsters
		for i = 1, #setting.demonsPositions do
			Game.createMonster("Angry Demon", setting.demonsPositions[i])
		end

		-- Get players from the tiles "playersPositions" and teleport to the demons room if all of the above requirements are met
		for i = 1, #setting.playersPositions do
			local creature = Tile(setting.playersPositions[i].fromPos):getTopCreature()
			if creature and creature:isPlayer() then
				creature:teleportTo(setting.playersPositions[i].toPos)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			else
				return false
			end
		end
		item:transform(1946)
	elseif item.itemid == 1946 then
		-- If it has "daily = true" then it will execute this function
		if setting.daily then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			return true
		end
		-- Not be able to push the lever back if someone is still inside the monsters room
		if Position.hasPlayer(setting.centerDemonRoomPosition, 4, 4) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the quest room.")
			return true
		end
		-- Removes all monsters so that the next team can enter
		if Position.removeMonster(setting.centerDemonRoomPosition, 4, 4) then
			return true
		end
		item:transform(1945)
	end
	return true
end

lever:uid(30025)
lever:register()
