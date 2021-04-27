local wrathEmperorMiss9Sleeping = Action()
function wrathEmperorMiss9Sleeping.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.WrathoftheEmperor.InterdimensionalPotion) == 1 then
		return true
	end

	player:setStorageValue(Storage.WrathoftheEmperor.InterdimensionalPotion, 1)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	item:remove()
	return true
end

wrathEmperorMiss9Sleeping:id(12328)
wrathEmperorMiss9Sleeping:register()