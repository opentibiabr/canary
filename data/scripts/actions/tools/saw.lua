local saw = Action()

function saw.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 5901 then
		return false
	end

	target:transform(10033)
	toPosition:sendMagicEffect(CONST_ME_POFF) --Not sure if there's any magic effect when you use saw?
	return true
end

saw:id(2558)
saw:register()
