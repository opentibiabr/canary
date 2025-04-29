local buckets = {
	[20053] = 20054,
	[20054] = 20053,
}

local lowerRoshamuulMixtune = Action()

function lowerRoshamuulMixtune.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	if target:getId() == buckets[item:getId()] then
		item:transform(2873, 0)
		target:transform(20169)
	end
	return true
end

lowerRoshamuulMixtune:id(20053, 20054)
lowerRoshamuulMixtune:register()
