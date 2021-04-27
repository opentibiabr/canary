local function revertKeeperstorage()
	Game.setStorageValue(Storage.WrathoftheEmperor.Mission03, 0)
end

local wrathEmperorMiss3Keeper = Action()
function wrathEmperorMiss3Keeper.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 12320 and target.actionid == 8026 then
		if Game.getStorageValue(Storage.WrathoftheEmperor.Mission03) < 5 then
			Game.setStorageValue(Storage.WrathoftheEmperor.Mission03, math.max(0, Game.getStorageValue(Storage.WrathoftheEmperor.Mission03)) + 1)
			player:say("The plant twines and twiggles even more than before, it almost looks as it would scream great pain.", TALKTYPE_MONSTER_SAY)
		elseif Game.getStorageValue(Storage.WrathoftheEmperor.Mission03) == 5 then
			Game.setStorageValue(Storage.WrathoftheEmperor.Mission03, 6)
			toPosition:sendMagicEffect(CONST_ME_YELLOW_RINGS)
			Game.createMonster('the keeper', {x = 33171, y = 31058, z = 11})
			Position({x = 33171, y = 31058, z = 11}):sendMagicEffect(CONST_ME_TELEPORT)
			addEvent(revertKeeperstorage, 60 * 1000)
		end
	elseif item.itemid == 12316 then
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 7 then
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 8)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission03, 2) --Questlog, Wrath of the Emperor "Mission 03: The Keeper"
			player:addItem(12323, 1)
		end
	end
	return true
end

wrathEmperorMiss3Keeper:id(12316,12320)
wrathEmperorMiss3Keeper:register()