local deathEvent = CreatureEvent("RagingMageDeath")

function deathEvent.onDeath(creature)
	broadcastMessage("The remains of the Raging Mage are scattered on the floor of his Tower. The dimensional portal quakes.", MESSAGE_EVENT_ADVANCE)
	doCreatureSay(creature, "I WILL RETURN!! My death will just be a door to await my homecoming, my physical hull will be... my... argh...", TALKTYPE_MONSTER_SAY)

	addEvent(function()
		broadcastMessage("With a great bang the dimensional portal in Zao collapsed and with it the connection to the other dimension shattered.", MESSAGE_EVENT_ADVANCE)
		local tile = Tile(Position({ x = 33143, y = 31527, z = 2 }))
		if tile then
			local item = tile:getItemById(11796)
			if item then
				item:remove(1)
			end
		end
	end, 5 * 60 * 1000)
	return true
end

deathEvent:register()
