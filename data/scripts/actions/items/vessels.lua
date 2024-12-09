local config = {
	[37572] = CONST_ME_GAZHARAGOTH,
	[37573] = CONST_ME_FERUMBRAS_1,
	[37574] = CONST_ME_MAD_MAGE,
	[37575] = CONST_ME_HORESTIS,
	[37576] = CONST_ME_DEVOVORGA,
}

local vessels = Action()

function vessels.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local vessel = config[item.itemid]
	if not vessel or not target:isPlayer() then
		return true
	end

	toPosition:sendMagicEffect(vessel)
	item:remove(1)
	return true
end

for index in pairs(config) do
	vessels:id(index)
end

vessels:register()
