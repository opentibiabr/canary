local iceCharm = Action()
function iceCharm.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 1354 then
		return false
	end

	if player:getStorageValue(Storage.TheIceIslands.Questline) ~= 39 then
		return true
	end

	local obelisk1 = {x = 32138, y = 31113, z = 14}
	local obelisk2 = {x = 32119, y = 30992, z = 14}
	local obelisk3 = {x = 32180, y = 31069, z = 14}
	local obelisk4 = {x = 32210, y = 31027, z = 14}

	if toPosition.x == obelisk1.x and toPosition.y == obelisk1.y and toPosition.z == obelisk1.z then
		if player:getStorageValue(Storage.TheIceIslands.Obelisk01) < 5 then
			player:setStorageValue(Storage.TheIceIslands.Obelisk01, 5)
			player:setStorageValue(Storage.TheIceIslands.Mission12, player:getStorageValue(Storage.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk2.x and toPosition.y == obelisk2.y and toPosition.z == obelisk2.z then
		if player:getStorageValue(Storage.TheIceIslands.Obelisk02) < 5 then
			player:setStorageValue(Storage.TheIceIslands.Obelisk02, 5)
			player:setStorageValue(Storage.TheIceIslands.Mission12, player:getStorageValue(Storage.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk3.x and toPosition.y == obelisk3.y and toPosition.z == obelisk3.z then
		if player:getStorageValue(Storage.TheIceIslands.Obelisk03) < 5 then
			player:setStorageValue(Storage.TheIceIslands.Obelisk03, 5)
			player:setStorageValue(Storage.TheIceIslands.Mission12, player:getStorageValue(Storage.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk4.x and toPosition.y == obelisk4.y and toPosition.z == obelisk4.z then
		if player:getStorageValue(Storage.TheIceIslands.Obelisk04) < 5 then
			player:setStorageValue(Storage.TheIceIslands.Obelisk04, 5)
			player:setStorageValue(Storage.TheIceIslands.Mission12, player:getStorageValue(Storage.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

iceCharm:id(7289)
iceCharm:register()