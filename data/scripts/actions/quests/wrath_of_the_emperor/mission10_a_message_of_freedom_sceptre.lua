local boss = {
	[3193] = "fury of the emperor",
	[3194] = "wrath of the emperor",
	[3195] = "scorn of the emperor",
	[3196] = "spite of the emperor",
}

local wrathEmperorMiss10Message = Action()
function wrathEmperorMiss10Message.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if boss[target.uid] and target.itemid == 12383 then
		target:transform(11753)
		Game.createMonster(boss[target.uid], {x = toPosition.x + 4, y = toPosition.y, z = toPosition.z})
		Game.setStorageValue(target.uid - 4, 1)
	elseif target.itemid == 12317 then
		if toPosition.x > 33034 and toPosition.x < 33071 and
			toPosition.y > 31079 and toPosition.y < 31102 then
			if player:getStorageValue(Storage.WrathoftheEmperor.BossStatus) == 1 then
				player:setStorageValue(Storage.WrathoftheEmperor.BossStatus, 2)
				player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 3) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:say("The sceptre is almost torn from your hand as you banish the presence of the emperor.", TALKTYPE_MONSTER_SAY)
			end
		elseif toPosition.x > 33080 and toPosition.x < 33111 and
			toPosition.y > 31079 and toPosition.y < 31100 then
			if player:getStorageValue(Storage.WrathoftheEmperor.BossStatus) == 2 then
				player:setStorageValue(Storage.WrathoftheEmperor.BossStatus, 3)
				player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 4) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:say("The sceptre is almost torn from your hand as you banish the presence of the emperor.", TALKTYPE_MONSTER_SAY)
			end
		elseif toPosition.x > 33078 and toPosition.x < 33112 and
			toPosition.y > 31106 and toPosition.y < 31127 then
			if player:getStorageValue(Storage.WrathoftheEmperor.BossStatus) == 3 then
				player:setStorageValue(Storage.WrathoftheEmperor.BossStatus, 4)
				player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 5) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:say("The sceptre is almost torn from your hand as you banish the presence of the emperor.", TALKTYPE_MONSTER_SAY)
			end
		elseif toPosition.x > 33035 and toPosition.x < 33069 and
			toPosition.y > 31107 and toPosition.y < 31127 then
			if player:getStorageValue(Storage.WrathoftheEmperor.BossStatus) == 4 then
				player:setStorageValue(Storage.WrathoftheEmperor.BossStatus, 5)
				player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 6) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:say("The sceptre is almost torn from your hand as you banish the presence of the emperor.", TALKTYPE_MONSTER_SAY)
				local destination = Position(33072, 31151, 15)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(destination)
				destination:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	elseif target.itemid == 12385 then
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 31 then
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 32)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission11, 2) --Questlog, Wrath of the Emperor "Mission 11: Payback Time"
		end
			player:say("NOOOoooooooo...!", TALKTYPE_MONSTER_SAY, false, player, toPosition)
			player:say("This should have dealt the deathblow to the snake things' ambitions.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

wrathEmperorMiss10Message:id(12318)
wrathEmperorMiss10Message:register()