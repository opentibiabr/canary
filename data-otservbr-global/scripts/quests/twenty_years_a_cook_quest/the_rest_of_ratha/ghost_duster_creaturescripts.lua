local ghostDusterAttack = CreatureEvent("GhostDusterAttack")

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLUE_ENERGY_SPARK)
combat:setArea(createCombatArea({
	{ 0, 0, 2, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
}))

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 8000)
condition:setFormula(-0.70, 0, -0.85, 0)

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	if tile then
		local target = tile:getTopCreature()
		if target and target ~= cid then
			if target:getName():lower() == "the rest of ratha" then
				target:addHealth(-100, COMBAT_AGONYDAMAGE)
				local appliedCondition = target:getCondition(CONDITION_PARALYZE)
				if not appliedCondition then
					local amountConditionsApplied = target:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.RathaConditionsApplied)
					target:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.RathaConditionsApplied, amountConditionsApplied > 2 and 1 or amountConditionsApplied + 1)
					target:addCondition(condition)
				end
			end
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function ghostDusterAttack.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if creature and creature:isMonster() then
		if primaryType == COMBAT_HEALING then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end

		local accumulatedDamage = creature:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.GhostDusterDamage)

		accumulatedDamage = accumulatedDamage + math.abs(primaryDamage + secondaryDamage)

		if accumulatedDamage >= 300 then
			accumulatedDamage = 0
			local var = { type = 1, number = creature:getId() }
			combat:execute(creature, var)
		end

		creature:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.GhostDusterDamage, accumulatedDamage)
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ghostDusterAttack:register()
