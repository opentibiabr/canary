local rake = Action()

function rake.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Wrath of the Emperor Mission02
	if target.itemid == 11366 then
		player:addItem(11329, 1)
		player:say("You dig out a handful of ordinary clay.", TALKTYPE_MONSTER_SAY)
		-- The Shattered Isles Parrot ring
	elseif target.itemid == 6094 then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheGovernorDaughter) == 1 then
			toPosition:sendMagicEffect(CONST_ME_POFF)
			Game.createItem(6093, 1, Position(32422, 32770, 1))
			player:say("You have found a ring.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheGovernorDaughter, 2)
		end
		-- Threatened Dreams Mission04
	elseif player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.GrumpyStone) == 1 then
		local positions = {
			{ x = 32617, y = 31863, z = 7 },
			{ x = 32616, y = 31864, z = 7 },
			{ x = 32615, y = 31866, z = 7 },
			{ x = 32620, y = 31864, z = 7 },
			{ x = 32619, y = 31865, z = 7 },
		}
		local positionStorages = {
			[1] = Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone1,
			[2] = Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone2,
			[3] = Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone3,
			[4] = Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone4,
			[5] = Storage.Quest.U11_40.ThreatenedDreams.Mission04.Stone5,
		}
		for i, pos in ipairs(positions) do
			if toPosition.x == pos.x and toPosition.y == pos.y and toPosition.z == pos.z then
				if player:getStorageValue(positionStorages[i]) == 1 then
					return true
				end
				player:setStorageValue(positionStorages[i], 1)
				player:say("*scratch* *scratch*", TALKTYPE_MONSTER_SAY)
				return true
			end
		end
	end

	return true
end

rake:id(3452)
rake:register()
