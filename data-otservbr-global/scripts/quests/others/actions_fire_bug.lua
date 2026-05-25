local function revert(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local function revertAshes()
	local tile = Tile(Position(32849, 32233, 9))
	local item = tile:getItemById(1949)
	if tile and item then
		item:remove()
		local ashes = Game.createItem(3134, 1, Position(32849, 32233, 9))
		ashes:setAttribute(ITEM_ATTRIBUTE_UNIQUEID, 2243)
	end
end

local positions = {
	Position(32848, 32230, 9),
	Position(32849, 32230, 9),
	Position(32847, 32231, 9),
	Position(32848, 32231, 9),
	Position(32849, 32231, 9),
	Position(32850, 32231, 9),
	Position(32848, 32232, 9),
	Position(32849, 32232, 9),
}

local othersFireBug = Action()
function othersFireBug.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Blood Brothers Mission - Boreth
	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission07) == 1 then
		if toPosition == Position(32939, 31476, 2) then
			if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant1) ~= 1 then
				player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant1, 1)
				toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			end
		elseif toPosition == Position(32940, 31476, 2) then
			if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant2) ~= 1 then
				player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant2, 1)
				toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
				local statuePos = Position(32940, 31475, 2)
				local statue = Tile(statuePos):getItemById(8325)
				if statue then
					statue:transform(8326)
					player:say("WHAT DO YOU THINK YOU ARE DOING TO MY PLANTS INTRUDER? YOU WILL DREADLY REGRET THIS MORTAL.", TALKTYPE_MONSTER_SAY)
				end
			end
		elseif toPosition == Position(32941, 31476, 2) then
			if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant3) ~= 1 then
				player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant3, 1)
				toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			end
		end

		if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant1) == 1 and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant2) == 1 and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant3) == 1 then
			local fromPos = Position(32936, 31474, 2)
			local toPos = Position(32944, 31482, 2)
			local teleportDestination = Position(32940, 31478, 1)

			local spectators = Game.getSpectators(fromPos, false, false, toPos.x - fromPos.x, toPos.x - fromPos.x, toPos.y - fromPos.y, toPos.y - fromPos.y)

			for _, spectator in ipairs(spectators) do
				if spectator:isPlayer() then
					spectator:teleportTo(teleportDestination)
					spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end

			Game.createMonster("Boreth", Position(32940, 31476, 1))
			Game.createMonster("plaguethrower", Position(32938, 31476, 1))
			Game.createMonster("plaguethrower", Position(32942, 31476, 1))
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant1, 0)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant2, 0)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Plant3, 0)
			player:say("I WARNED YOU.", TALKTYPE_MONSTER_SAY)
		end

		return true
	end

	if target.actionid == 54387 and target.itemid == 22875 then
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.BasinCounter) >= 8 or player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.BoneFlute) < 1 then
			return false
		end
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.BasinCounter) < 0 then
			player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.BasinCounter, 0)
		end
		if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.BasinCounter) == 7 then
			player:say("You ascended the last basin.", TALKTYPE_MONSTER_SAY)
			item:remove()
			player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.MonsterDoor, 1)
		end
		target:transform(22876)
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.BasinCounter, player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.BasinCounter) + 1)
		toPosition:sendMagicEffect(CONST_ME_FIREAREA)
		addEvent(revert, 2 * 60 * 1000, toPosition, 22876, 22875)
		return true
	elseif target.uid == 2243 then
		local tile = Tile(Position(32849, 32233, 9))
		local item = tile:getItemById(3134)
		local createTeleport = Game.createItem(1949, 1, Position(32849, 32233, 9))
		for k, v in pairs(positions) do
			v:sendMagicEffect(CONST_ME_YELLOW_RINGS)
		end
		item:remove()
		addEvent(revertAshes, 5 * 60 * 1000) -- 5 minutes
		createTeleport:setDestination(Position(32857, 32234, 11))
		return true
	elseif target.uid == 2273 then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.RaysMission2) == 1 then
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.RaysMission2, 2)
			toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			return true
		else
			return false
		end
	elseif target.actionid == 50119 then
		target:transform(7813)
		return true
	end

	local random = math.random(10)
	if random >= 4 then --success 6% chance
		if target.itemid == 182 then --Destroy spider webs/North - South
			toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			target:transform(188)
			target:decay()
			return true
		elseif target.itemid == 183 then --Destroy spider webs/EAST- West
			toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			target:transform(189)
			target:decay()
			return true
		elseif target.itemid == 5465 then --Burn Sugar Cane
			toPosition:sendMagicEffect(CONST_ME_FIREAREA)
			target:transform(5464)
			target:decay(5463)
			return true
		elseif target.itemid == 2114 then --Light Up empty coal basins
			toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			target:transform(2113)
			return true
		elseif target.position == Position(32893, 32012, 6) then -- Secret Service Quest
			if player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission01) == 1 then
				local fire = Game.createItem(2118, 1, Position(32893, 32012, 6))
				player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission01, 2)
				addEvent(function()
					if fire and item:isItem() then
						item:remove()
					end
				end, 7 * 60 * 1000)
			end
		end
		return true
	elseif random == 2 then --it remove the fire bug 2% chance
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	elseif random == 1 then --it explode on the user 1% chance
		doTargetCombatHealth(0, player, COMBAT_FIREDAMAGE, -5, -5, CONST_ME_HITBYFIRE)
		player:say("OUCH!", TALKTYPE_MONSTER_SAY)
		item:remove(1)
		return true
	else
		toPosition:sendMagicEffect(CONST_ME_POFF) --it fails, but dont get removed 3% chance
		return true
	end
	return false
end

othersFireBug:id(5467)
othersFireBug:register()
