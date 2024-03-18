local bossName = "Faceless Bane"

-- reset monster HP to 100%
function healBoss(creature)
	creature:addHealth(creature:getMaxHealth())
	creature:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
	return true
end

-- summon spectres
function createSummons(pos)
	Game.createMonster("Gazer Spectre", pos)
	Game.createMonster("Ripper Spectre", pos)
	Game.createMonster("Burster Spectre", pos)
	return true
end

-- reset the monster HP and summon spectres upon death
function resetBoss(creature, deaths)
	healBoss(creature)
	createSummons(creature:getPosition())
	Game.setStorageValue(GlobalStorage.FacelessBaneDeaths, deaths + 1)
	Game.setStorageValue(GlobalStorage.FacelessBaneStepsOn, 0)
	Game.setStorageValue(GlobalStorage.FacelessBaneResetSteps, 1)
	return true
end

local facelessBaneImmunity = CreatureEvent("facelessBaneImmunity")

-- ensure that the boss stay invulnerable when the mechanic has not been executed
function facelessBaneImmunity.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if creature and creature:isMonster() and creature:getName() == bossName then
		local creatureHealthPercent = (creature:getHealth() * 100) / creature:getMaxHealth()
		local facelessBaneDeathsStorage = Game.getStorageValue(GlobalStorage.FacelessBaneDeaths)

		if creatureHealthPercent <= 20 and facelessBaneDeathsStorage < 1 then
			resetBoss(creature, facelessBaneDeathsStorage)
			return true
		end

		if Game.getStorageValue(GlobalStorage.FacelessBaneStepsOn) < 1 then
			healBoss(creature)
			return true
		else
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end
	end
	return true
end

facelessBaneImmunity:register()
