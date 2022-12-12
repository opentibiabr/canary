local config = {
	[940] = {targetId = 7742, transformId = 7746, effect = CONST_ME_BIGPLANTS},
	[941] = {targetId = 7743, transformId = 7745},
	[944] = {targetId = 7741, transformId = 7744, effect = CONST_ME_ICEATTACK},
	[945] = {targetId = 7737, createId = 2126}
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

for itemId, itemInfo in pairs(config) do
	elementalSpheresSouls1:id(itemId)
end

elementalSpheresSouls1:register()
