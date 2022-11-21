local grimValeSilver = Action()
function grimValeSilver.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 3481 or target.itemid == 3482 then
		target:transform(22074)
		item:remove()
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		toPosition:sendMagicEffect(CONST_ME_POFF)
	else
		return false
	end
	return true
end

grimValeSilver:id(22058)
grimValeSilver:register()