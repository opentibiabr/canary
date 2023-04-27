
local theDreadMaidenHealth = CreatureEvent("theDreadMaidenHealth")

function theDreadMaidenHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if primaryType == COMBAT_DEATHDAMAGE or secondaryType == COMBAT_DEATHDAMAGE then
		primaryType = COMBAT_HEALING
		primaryDamage = (primaryDamage + secondaryDamage)
		secondaryType = COMBAT_NONE
		secondaryDamage = 0
	end
	if primaryType ~= COMBAT_HEALING then
		local storage = creature:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheDreadMaiden.Souls)
		local percentage = (storage + 1) * 3
		primaryDamage = primaryDamage * (math.min(150, percentage) / 100)
		secondaryDamage = secondaryDamage * (math.min(150, percentage) / 100)
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
theDreadMaidenHealth:register()

