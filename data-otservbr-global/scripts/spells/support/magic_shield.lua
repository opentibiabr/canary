local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local condition = Condition(CONDITION_MANASHIELD)
	condition:setParameter(CONDITION_PARAM_TICKS, 180000)
	local player = creature:getPlayer()
	local hasMSCapacityFlat = false
	local hasMSCapacityPercent = false
	local haveBoth = false
	if player then
		if player:getMagicShieldCapacityFlat() ~= 0 then
			hasMSCapacityFlat = true
		end

		if player:getMagicShieldCapacityPercent() ~= 0 then
			hasMSCapacityPercent = true
		end

		if hasMSCapacityFlat and hasMSCapacityPercent then
			haveBoth = true
		end

		if haveBoth then
			local MSTotal = math.min(player:getMaxMana(), 300 + 7.6 * player:getLevel() + 7 * player:getMagicLevel())
			local extraPercentage =  (player:getMagicShieldCapacityPercent() * 0.01) * MSTotal
			condition:setParameter(CONDITION_PARAM_MANASHIELD, (math.min(player:getMaxMana(), 300 + 7.6 * player:getLevel() + 7 * player:getMagicLevel())) + extraPercentage + player:getMagicShieldCapacityFlat())
		else
			if hasMSCapacityFlat then
				condition:setParameter(CONDITION_PARAM_MANASHIELD, (math.min(player:getMaxMana(), 300 + 7.6 * player:getLevel() + 7 * player:getMagicLevel())) + player:getMagicShieldCapacityFlat())
			elseif hasMSCapacityPercent then
				local MSTotal = math.min(player:getMaxMana(), 300 + 7.6 * player:getLevel() + 7 * player:getMagicLevel())
				local extraPercentage =  (player:getMagicShieldCapacityPercent() * 0.01) * MSTotal
				print(extraPercentage)
				condition:setParameter(CONDITION_PARAM_MANASHIELD, (math.min(player:getMaxMana(), 300 + 7.6 * player:getLevel() + 7 * player:getMagicLevel())) + extraPercentage)
			else 
				condition:setParameter(CONDITION_PARAM_MANASHIELD, math.min(player:getMaxMana(), 300 + 7.6 * player:getLevel() + 7 * player:getMagicLevel()))
			end
		end
	end
	creature:addCondition(condition)
	return combat:execute(creature, var)
end

spell:name("Magic Shield")
spell:words("utamo vita")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_MAGIC_SHIELD)
spell:id(44)
spell:cooldown(14 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(14)
spell:mana(50)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()