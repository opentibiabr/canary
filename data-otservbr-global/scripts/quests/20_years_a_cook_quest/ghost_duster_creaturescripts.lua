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
					target:addCondition(condition)
				end
			end
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local accumulatedDamage = 0

function ghostDusterAttack.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if creature and creature:isMonster() then
		if primaryType == COMBAT_HEALING then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end

		if accumulatedDamage >= 5 then
			accumulatedDamage = 0
			local var = { type = 1, number = creature:getId() }
			combat:execute(creature, var)
		else
			accumulatedDamage = accumulatedDamage + math.abs(primaryDamage + secondaryDamage)
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ghostDusterAttack:register()
