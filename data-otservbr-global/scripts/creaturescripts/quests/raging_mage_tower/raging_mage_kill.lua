local ragingMageKill = CreatureEvent("ragingMageKill")
function ragingMageKill.onKill(cid, target, damage, flags, corpse)
	if(isMonster(target)) then
		if(string.lower(getCreatureName(target)) == "raging mage") then
			 broadcastMessage("The remains of the Raging Mage are scattered on the floor of his Tower. The dimensional portal quakes.", MESSAGE_EVENT_ADVANCE)
			 doCreatureSay(target, "I WILL RETURN!! My death will just be a door to await my homecoming, my physical hull will be... my... argh...", TALKTYPE_ORANGE_1)
			 addEvent(doRemoveItem, 5 * 60 * 1000, getTileItemById({x = 33143, y = 31527, z = 2}, 11796).uid, 1)
			 addEvent(broadcastMessage, 5 * 60 * 1000, "With a great bang the dimensional portal in Zao collapsed and with it the connection to the other dimension shattered.", MESSAGE_EVENT_ADVANCE)
		end
	end
	return true
end

ragingMageKill:register()
