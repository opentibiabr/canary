local config = {
	[37572] = CONST_ME_GAZHARAGOTH, -- vessel of Gaz'haragoth
	[37573] = CONST_ME_FERUMBRAS_1, -- vessel of Ferumbras
	[37574] = CONST_ME_MAD_MAGE, -- vessel of the Mad Mage
	[37575] = CONST_ME_HORESTIS, -- vessel of Horestis
	[37576] = CONST_ME_DEVOVORGA, -- vessel of Devovorga
}

local vessels = Action()

function vessels.onUse(player, item, fromPosition, itemEx, toPosition)
	local vessel = config[item.itemid]
	local tile = toPosition:getTile()
	if not vessel or not player then
		return false
	end
	if not tile:isWalkable() then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
	else
		item:remove(1)
		toPosition:sendMagicEffect(vessel)
	end
	return true
end

for index, value in pairs(config) do
	vessels:id(index)
end
vessels:allowFarUse(true)
vessels:register()