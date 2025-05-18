local partyHat = Action()

function partyHat.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local headSlotItem = player:getSlotItem(CONST_SLOT_HEAD)
	if not headSlotItem or item.uid ~= headSlotItem:getUniqueId() then
		return false
	end

	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
	player:addAchievementProgress("Party Animal", 200)
	return true
end

partyHat:id(6578)
partyHat:register()
