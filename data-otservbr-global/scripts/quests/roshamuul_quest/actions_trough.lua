local lowerRoshamuulTrough = Action()

function lowerRoshamuulTrough.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	if target:getId() == 20216 then
		item:transform(2873, 0)
		toPosition:sendMagicEffect(10)
		player:setStorageValue(Storage.Quest.U10_30.RoshamuulQuest.Roshamuul_Mortar_Thrown, math.max(0, player:getStorageValue(Storage.Quest.U10_30.RoshamuulQuest.Roshamuul_Mortar_Thrown)) + 1)
	end
	return true
end

lowerRoshamuulTrough:id(20170)
lowerRoshamuulTrough:register()
