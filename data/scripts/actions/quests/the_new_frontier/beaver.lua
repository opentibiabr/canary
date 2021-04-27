local theNewFrontierBeaver = Action()
function theNewFrontierBeaver.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 8002 then
		if player:getStorageValue(Storage.TheNewFrontier.Questline) == 5 and player:getStorageValue(Storage.TheNewFrontier.Beaver1) < 1 then
			Game.createMonster("thieving squirrel", toPosition)
			toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(Storage.TheNewFrontier.Beaver1, 1)
			player:setStorageValue(Storage.TheNewFrontier.Mission02, player:getStorageValue(Storage.TheNewFrontier.Mission02) + 1) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			Game.createMonster("thieving squirrel", toPosition)
			player:say("You've marked the tree, but its former inhabitant has stolen your bait! Get it before it runs away!", TALKTYPE_MONSTER_SAY)
			item:remove()
		end
	elseif target.actionid == 8003 then
		if player:getStorageValue(Storage.TheNewFrontier.Questline) == 5 and player:getStorageValue(Storage.TheNewFrontier.Beaver2) < 1 then
			for i = 1, 5 do
				pos = toPosition
				Game.createMonster("wolf", pos)
				toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			end
			Game.createMonster("war wolf", toPosition)
			toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(Storage.TheNewFrontier.Beaver2, 1)
			player:setStorageValue(Storage.TheNewFrontier.Mission02, player:getStorageValue(Storage.TheNewFrontier.Mission02) + 1) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			player:say("You have marked the tree but it seems someone marked it already! He is not happy with your actions and he brought friends!", TALKTYPE_MONSTER_SAY)
		end
	elseif target.actionid == 8004 then
		if player:getStorageValue(Storage.TheNewFrontier.Questline) == 5 and player:getStorageValue(Storage.TheNewFrontier.Beaver3) < 1 then
			for i = 1, 3 do
				pos = toPosition
				Game.createMonster("enraged squirrel", pos)
				toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			end
			player:setStorageValue(Storage.TheNewFrontier.Beaver3, 1)
			player:setStorageValue(Storage.TheNewFrontier.Mission02, player:getStorageValue(Storage.TheNewFrontier.Mission02) + 1) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			player:say("You have marked the tree, but you also angered the aquirrel family who lived on it!", TALKTYPE_MONSTER_SAY)
		end
	end
	if player:getStorageValue(Storage.TheNewFrontier.Beaver1) == 1
	and player:getStorageValue(Storage.TheNewFrontier.Beaver2) == 1
	and player:getStorageValue(Storage.TheNewFrontier.Beaver3) == 1 then
		player:setStorageValue(Storage.TheNewFrontier.Questline, 6)
	end
	return true
end

theNewFrontierBeaver:id(11100)
theNewFrontierBeaver:register()