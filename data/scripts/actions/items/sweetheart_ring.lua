local sweetheartRing = Action()

function sweetheartRing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item ~= player:getSlotItem(CONST_SLOT_RING) then
		return true
	end

	player:getPosition():sendMagicEffect(CONST_ME_HEARTS)
	return true
end

sweetheartRing:id(21955)
sweetheartRing:register()
