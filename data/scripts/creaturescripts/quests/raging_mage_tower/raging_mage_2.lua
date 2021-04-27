local ragingMage2 = CreatureEvent("RagingMage2")
function ragingMage2.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster or targetMonster:getName():lower() ~= 'raging mage' then
		return true
	end

	broadcastMessage("The remains of the Raging Mage are scattered on the floor of his Tower. \z
	The dimensional portal quakes.", MESSAGE_EVENT_ADVANCE)
	targetMonster:say("I WILL RETURN!! My death will just be a door to await my homecoming, \z
	my physical hull will be... my... argh...", TALKTYPE_MONSTER_SAY, 0, 0, Position(33142, 31529, 2))
	addEvent(function()
		local tilePos = Tile(Position(33143, 31527, 2)):getItemById(11796)
		if not tilePos then
			return true
		end
		tilePos:remove()
		broadcastMessage("With a great bang the dimensional portal in Zao collapsed and \z
		with it the connection to the other dimension shattered.", MESSAGE_EVENT_ADVANCE)
	end, 5 * 60 * 1000)
	mostDamageKiller:setStorageValue(673004, 0)
	Game.setStorageValue(775559, 0)
	return true
end

ragingMage2:register()
