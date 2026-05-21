function createProficiencyCatalyst(itemId, experience)
	local catalyst = Action()

	function catalyst.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		if not item or not item:isItem() then
			return false
		end

		if not target or not target:isItem() then
			return false
		end

		local weaponId = target:getId()
		local itemType = ItemType(weaponId)
		if not itemType:isWeapon() then
			player:sendCancelMessage("You can only use this on weapons.")
			return true
		end

		local success = player:addWeaponExperience(experience, weaponId)
		if success then
			item:remove(1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		else
			player:sendCancelMessage("Failed to apply proficiency experience.")
		end
		return true
	end

	catalyst:id(itemId)
	catalyst:register()
end
