local grimValeSilver = Action()
function grimValeSilver.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 2578 or target.itemid == 2579 then
		target:transform(24730)
		item:remove()
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		toPosition:sendMagicEffect(CONST_ME_POFF)
	else
		return false
	end
	return true
end

grimValeSilver:id(24714)
grimValeSilver:register()