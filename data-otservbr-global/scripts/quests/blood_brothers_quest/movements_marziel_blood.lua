local marzielBlood = MoveEvent()

function marzielBlood.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	local player = creature

	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission09) >= 2 then
		return false
	end

	if player:getSex() == PLAYERSEX_MALE then
		return true
	end

	if position.x ~= 32940 or position.y ~= 31458 or position.z ~= 2 then
		return true
	end

	local vial = player:getItemById(2874, true)
	if not vial or vial.type ~= 5 then
		return true
	end

	local statuePos = Position(32940, 31457, 2)
	local statue = Tile(statuePos):getItemById(8325)
	if not statue then
		return true
	end

	statue:transform(8326)
	vial:remove(1)
	player:say("AAAAH... THE SCENT OF A WOMAN... GIVE ME MORE...", TALKTYPE_MONSTER_SAY)
	Game.createMonster("Vampire Bride", Position(32938, 31458, 2))
	Game.createMonster("Vampire Bride", Position(32942, 31458, 2))

	return true
end

marzielBlood:type("stepin")
marzielBlood:id(8695)
marzielBlood:register()
