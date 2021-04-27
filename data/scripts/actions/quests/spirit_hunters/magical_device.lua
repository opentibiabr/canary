 local spiritMagical = Action()
 function spiritMagical.onUse(cid, item, fromPosition, itemEx, toPosition)
	local player = Player(cid)
	if item:getId() == 12670 then
		if itemEx.itemid == 8059 then
			if player:getStorageValue(Storage.SpiritHunters.Mission01 == 1) then
				qStorage = player:getStorageValue(Storage.SpiritHunters.TombUse)
				if qStorage < 3 then
					position = player:getPosition()
					player:say('An incredibly slimy substance oozes out of every crack in the old gravestone. It seems to attack you.', TALKTYPE_MONSTER_SAY)
					player:setStorageValue(Storage.SpiritHunters.TombUse, qStorage+1)
					Game.createMonster('Squidgy Slime', Position(position.x+1, position.y, position.z), false, false)
				elseif qStorage == 4 then
					player:say('You have used items in gravestone.', TALKTYPE_MONSTER_SAY)
				end
			end
		end
	elseif item:getId() == 12671 then
		if itemEx.itemid == 5993 then -- ghost
			player:say("As you open the device a bright light pours out of its interior and drags all remaining energy of the ghost into it.", TALKTYPE_MONSTER_SAY)
			if player:getStorageValue(Storage.SpiritHunters.CharmUse) < 1 then
				player:setStorageValue(Storage.SpiritHunters.CharmUse, 1)
			else
				player:setStorageValue(Storage.SpiritHunters.GhostUse, player:getStorageValue(Storage.SpiritHunters.GhostUse) + 1)
			end
			itemEx:transform(itemEx:getType():getDecayId())
			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		elseif itemEx.itemid == 12631 or itemEx.itemid == 12632 then -- souleater
			player:say("As you open the device a bright light pours out of its interior and drags all remaining energy of the souleater into it.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.SpiritHunters.SouleaterUse, player:getStorageValue(Storage.SpiritHunters.SouleaterUse) + 1)
			itemEx:transform(itemEx:getType():getDecayId())
			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		elseif itemEx.itemid == 9915 or itemEx.itemid == 9916 then --nightstalker
			player:say("As you open the device a bright light pours out of its interior and drags all remaining energy of the nightstalker into it.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.SpiritHunters.NightstalkerUse, player:getStorageValue(Storage.SpiritHunters.NightstalkerUse) + 1)
			itemEx:transform(itemEx:getType():getDecayId())
			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		end
	end
 end

 spiritMagical:id(12670,12671)
 spiritMagical:register()