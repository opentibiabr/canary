local dummyBox = Action()

local REWARD = { 64018, 64020, 64031 }
function dummyBox.onUse(cid, item, fromPosition, itemEx, toPosition)
	local randomChance = math.random(1, #REWARD)
	doPlayerAddItem(cid, REWARD[randomChance], 1)

	doSendMagicEffect(getPlayerPosition(cid), 73)
	doRemoveItem(item.uid, 1)

	return true
end

dummyBox:id(64049)
dummyBox:register()
