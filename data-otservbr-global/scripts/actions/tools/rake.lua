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
	end
	return true
end

rake:id(3452)
rake:register()
