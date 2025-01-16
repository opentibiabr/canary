local storeBox = Action()

local JEWEL = { 11470, 3013, 3034, 3036, 3037, 3038, 3039, 3041 }
local REWARD = { 39693, 32925, 3043 }
function storeBox.onUse(cid, item, fromPosition, itemEx, toPosition)
	local randomChance = math.random(1, #REWARD)
	doPlayerAddItem(cid, REWARD[randomChance], 1)
	doPlayerSendTextMessage(cid, 22, "You found an reward!")

	local randomLoot = math.random(1, 20)
	if randomLoot == 1 then
		doPlayerSendTextMessage(cid, 22, "You found an extra item!")
		local randomChance = math.random(1, #REWARD)
		doPlayerAddItem(cid, REWARD[randomChance], 1)
	end

	local randomJewel = math.random(1, 10)
	if randomJewel == 1 then
		doPlayerSendTextMessage(cid, 22, "You found an extra item!")
		local randomChance = math.random(1, #JEWEL)
		doPlayerAddItem(cid, JEWEL[randomChance], 1)
	end

	doSendMagicEffect(getPlayerPosition(cid), 197)
	doRemoveItem(item.uid, 1)
	return true
end

storeBox:id(12057)
storeBox:register()
