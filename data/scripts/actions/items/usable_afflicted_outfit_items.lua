local usableAfflictedOutfitItems = Action()

function usableAfflictedOutfitItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:isPremium() then
		player:sendCancelMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
		return true
	end

	local outfitId = player:getSex() == PLAYERSEX_FEMALE and 431 or 430
	if item.itemid == 12786 then
		if not player:hasOutfit(outfitId) or player:hasOutfit(outfitId, 2) then
			return true
		end

		player:addOutfitAddon(430, 2)
		player:addOutfitAddon(431, 2)
		player:say("You gained a plague mask for your outfit.", TALKTYPE_MONSTER_SAY, false, player)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:addAchievementProgress("Beak Doctor", 2)
		item:remove()
	elseif item.itemid == 12787 then
		if not player:hasOutfit(outfitId) or player:hasOutfit(outfitId, 1) then
			return true
		end

		player:addOutfitAddon(430, 1)
		player:addOutfitAddon(431, 1)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:say("You gained a plague bell for your outfit.", TALKTYPE_MONSTER_SAY, false, player)
		player:addAchievementProgress("Beak Doctor", 2)
		item:remove()
	else
		if player:hasOutfit(outfitId) then
			return true
		end

		local requiredItemIds = { 12551, 12552, 12553, 12554, 12555, 12556 }
		for _, itemId in ipairs(requiredItemIds) do
			if player:getItemCount(itemId) < 1 then
				return true
			end
		end

		for _, itemId in ipairs(requiredItemIds) do
			player:removeItem(itemId, 1)
		end

		player:addOutfit(430)
		player:addOutfit(431)
		player:say("You have restored an outfit.", TALKTYPE_MONSTER_SAY, false, player)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

usableAfflictedOutfitItems:id(12551, 12552, 12553, 12554, 12555, 12556, 12786, 12787)
usableAfflictedOutfitItems:register()
