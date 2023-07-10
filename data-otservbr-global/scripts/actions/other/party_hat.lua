local partyHat = Action()

function partyHat.onUse(player, item, fromPosition, target, toPosition, isHotkey)
local slot = player:getSlotItem(CONST_SLOT_HEAD)
	if slot and item.uid == slot.uid then
		player:addAchievementProgress('Party Animal', 200)
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		return true
	end
	return false
end

partyHat:id(6578)
partyHat:register()
