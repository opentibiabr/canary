local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_WEAPONTYPE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)

function onGetFormulaValues(player, skill, attack, factor)
	local skillTotal = skill * attack
	local levelTotal = player:getLevel() / 5
	return -(((skillTotal * 0.17) + 17) + levelTotal) * 1.28, -(((skillTotal * 0.20) + 40) + levelTotal) * 1.28
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function getChainValue(creature)
	local grade = creature:revelationStageWOD("Executioner's Throw")
	if grade == 0 then
		return false
	end

	local bounces = 0
	if grade >= 3 then
		bounces = 4
	elseif grade >= 2 then
		bounces = 3
	elseif grade >= 1 then
		bounces = 2
	end

	return bounces + 1, 3, false
end

combat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getChainValue")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if not creature or not creature:isPlayer() then
		return false
	end

	local grade = creature:revelationStageWOD("Executioner's Throw")
	if grade == 0 then
		creature:sendCancelMessage("You cannot cast this spell")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local cooldown = 0
	if grade >= 3 then
		cooldown = 10
	elseif grade >= 2 then
		cooldown = 14
	elseif grade >= 1 then
		cooldown = 18
	end

	var.instantName = "Executioner's Throw"
	if combat:execute(creature, var) then
		local condition = Condition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, 261)
		condition:setTicks((cooldown * 1000) / configManager.getFloat(configKeys.RATE_SPELL_COOLDOWN))
		creature:addCondition(condition)
		return true
	end
	return false
end

spell:group("attack")
spell:id(261)
spell:name("Executioner's Throw")
spell:words("exori amp kor")
spell:level(300)
spell:mana(225)
spell:isPremium(true)
spell:range(5)
spell:needTarget(true)
spell:blockWalls(true)
spell:needWeapon(true)
spell:cooldown(1000) -- Cooldown is calculated on the casting
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:vocation("knight;true", "elite knight;true")
spell:register()
