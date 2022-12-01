local grandMasterOberonImmunity = CreatureEvent("OberonImmunity")

function grandMasterOberonImmunity.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if creature and creature:isMonster() then
		creature:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	end
	return true
end

grandMasterOberonImmunity:register()
