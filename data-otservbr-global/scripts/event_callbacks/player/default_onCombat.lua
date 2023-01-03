local ec = EventCallback

function ec.onCombat(player, target, item, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not item or not target then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if ItemType(item:getId()):getWeaponType() == WEAPON_AMMO then
		if table.contains({ITEM_OLD_DIAMOND_ARROW, ITEM_DIAMOND_ARROW}, item:getId()) then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		else
			item = player:getSlotItem(CONST_SLOT_LEFT)
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ec:register(--[[0]])
