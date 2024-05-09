local bossName = "Faceless Bane"

local function healBoss(creature)
	if creature then
		creature:addHealth(creature:getMaxHealth())
		creature:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
	end
end

local function createSummons(creature)
	if creature then
		local pos = creature:getPosition()
		Game.createMonster("Gazer Spectre", pos, true, false, creature)
		Game.createMonster("Ripper Spectre", pos, true, false, creature)
		Game.createMonster("Burster Spectre", pos, true, false, creature)
	end
end

local function resetBoss(creature, deaths)
	if creature then
		healBoss(creature)
		createSummons(creature)
		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.Deaths, deaths + 1)
		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.StepsOn, 0)
		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.ResetSteps, 1)
	end
end

local facelessBaneImmunity = CreatureEvent("facelessBaneImmunity")

function facelessBaneImmunity.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if creature and creature:isMonster() and creature:getName() == bossName then
		local creatureHealthPercent = (creature:getHealth() * 100) / creature:getMaxHealth()
		local facelessBaneDeathsStorage = Game.getStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.Deaths)

		if creatureHealthPercent <= 20 and facelessBaneDeathsStorage < 1 then
			resetBoss(creature, facelessBaneDeathsStorage)
			return true
		elseif Game.getStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.StepsOn) < 1 then
			healBoss(creature)
			return true
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

facelessBaneImmunity:register()
