local entrance = MoveEvent()

function entrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.DemonOak.Done) >= 1 then
		player:teleportTo(DEMON_OAK_KICK_POSITION)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if player:getLevel() < 120 then
		player:say("LEAVE LITTLE FISH, YOU ARE NOT WORTH IT!", TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_POSITION)
		player:teleportTo(DEMON_OAK_KICK_POSITION)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if (#Game.getSpectators(DEMON_OAK_POSITION, false, true, 9, 9, 6, 6) == 0) then
			if (player:getItemCount(10305) == 0) then
				if player:getStorageValue(Storage.DemonOak.Progress) < 1 then
			player:say("You need finish the demons task!", TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_KICK_POSITION)
			player:teleportTo(DEMON_OAK_KICK_POSITION)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
				end
		end

		if (player:getItemCount(8293) == 0) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"Go talk with Odralk and get the Hallowed Axe to kill The Demon Oak.")
		end

		player:removeItem(10305, 1)
		player:teleportTo(DEMON_OAK_ENTER_POSITION)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:setStorageValue(Storage.DemonOak.Progress, 1)
		player:say("I AWAITED YOU! COME HERE AND GET YOUR REWARD!",
			TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_POSITION)
	else
		player:teleportTo(DEMON_OAK_KICK_POSITION)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

entrance:type("stepin")
entrance:uid(9000)
entrance:register()
