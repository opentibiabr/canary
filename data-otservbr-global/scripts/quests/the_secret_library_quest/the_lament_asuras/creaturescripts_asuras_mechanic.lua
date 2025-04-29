local redItems = {
	3566,
	3379,
	3388,
	8039,
	8053,
	8064,
	22534,
	3381,
	7991,
	3380,
	10439,
	3564,
}

local creaturescripts_asuras_mechanic = CreatureEvent("AsurasMechanic")

function creaturescripts_asuras_mechanic.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not attacker or not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if attacker:isPlayer() then
		if creature:getName():lower() == "the diamond blossom" then
			local slot = attacker:getSlotItem(CONST_SLOT_ARMOR)
			if slot then
				for i = 1, #redItems do
					if slot.itemid == redItems[i] then
						return primaryDamage, primaryType, secondaryDamage, secondaryType
					end
				end
			end
		elseif creature:getName():lower() == "the blazing rose" then
			local slot = attacker:getSlotItem(CONST_SLOT_RIGHT)
			if slot and slot.itemid == 28494 then
				return primaryDamage, primaryType, secondaryDamage, secondaryType
			end
		elseif creature:getName():lower() == "the lily of night" then
			if attacker:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Asuras.Fragrance) > os.time() then
				return primaryDamage, primaryType, secondaryDamage, secondaryType
			end
		end
	end

	primaryDamage = 0
	secondaryDamage = 0
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creaturescripts_asuras_mechanic:register()
