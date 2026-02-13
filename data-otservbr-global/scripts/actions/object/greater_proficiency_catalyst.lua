local greaterProficiencyCatalyst = Action()

function greaterProficiencyCatalyst.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not item or not item:isItem() then
		return false
	end

	if not target or not target:isItem() then
		return false
	end

    local weaponId = target:getId()
	player:addWeaponExperience(100000, weaponId)
	item:remove(1)

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

	return true
end

greaterProficiencyCatalyst:id(51589)
greaterProficiencyCatalyst:register()
