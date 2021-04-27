local config = {
	[8298] = {targetId = 8572, transformId = 8576, effect = CONST_ME_BIGPLANTS},
	[8299] = {targetId = 8573, transformId = 8575},
	[8302] = {targetId = 8571, transformId = 8574, effect = CONST_ME_ICEATTACK},
	[8303] = {targetId = 8567, createId = 1495}
}

local elementalSpheresSouls1 = Action()
function elementalSpheresSouls1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local soil = config[item.itemid]
	if not soil then
		return true
	end

	if soil.targetId ~= target.itemid then
		return true
	end

	if soil.transformId then
		target:transform(soil.transformId)
		target:decay()
	elseif soil.createId then
		local newItem = Game.createItem(soil.createId, 1, toPosition)
		if newItem then
			newItem:decay()
		end
	end

	if soil.effect then
		toPosition:sendMagicEffect(soil.effect)
	end

	item:transform(item.itemid, item.type - 1)
	return true
end

elementalSpheresSouls1:id(8298,8299,8302,8303)
elementalSpheresSouls1:register()
