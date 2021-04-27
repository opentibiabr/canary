local fishTank = Action()

function fishTank.onUse(cid, item, fromPosition, itemEx, toPosition)
	item:getPosition():sendMagicEffect(175)
	return true
end

fishTank:id(26347)
fishTank:register()
