local lowerRoshamuulMortar = Action()
function lowerRoshamuulMortar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	if (target:getId() == 2873) and (target:getFluidType() == 1) then
		item:transform(2873, 0)
		target:transform(20170)
	end
	return true
end

lowerRoshamuulMortar:id(20169)
lowerRoshamuulMortar:register()
