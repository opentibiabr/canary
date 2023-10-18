local combatGrenade = Combat()
combatGrenade:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combatGrenade:setArea(createCombatArea(AREA_CIRCLE2X2))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 4)
	local max = (level / 5) + (maglevel * 6)
	local grade = player:upgradeSpellsWOD("Divine Grenade")

	local multiplier = 1.0
	if grade ~= WHEEL_GRADE_NONE then
		local multiplierByGrade = { 1.3, 1.6, 2.0 }
		multiplier = multiplierByGrade[grade]
	end

	min = min * multiplier
	max = max * multiplier
	return -min, -max
end

combatGrenade:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local explodeGrenade = function(position, playerId)
	local tile = Tile(position)
	if not tile then
		return
	end

	local player = Player(playerId)
	if not player then
		return
	end

	local var = {}
	var.instantName = "Divine Grenade Explode"
	var.runeName = ""
	var.type = 2 -- VARIANT_POSITION
	var.pos = position
	combatGrenade:execute(player, var)
	player:getPosition():removeMagicEffect(CONST_ME_DIVINE_GRENADE)
end

local combatCast = Combat()
combatCast:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_HOLY)

function onTargetCreature(creature, target)
	if not creature and target and creature:isPlayer() then
		return false
	end

	local position = target:getPosition()
	addEvent(explodeGrenade, 3000, position, creature:getId())
	return true
end

combatCast:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if not (creature and creature:isPlayer()) then
		return false
	end
	local grade = creature:upgradeSpellsWOD("Divine Grenade")
	if grade == WHEEL_GRADE_NONE then
		creature:sendCancelMessage("You cannot cast this spell")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local cooldownByGrade = { 26, 20, 14 }
	local cooldown = cooldownByGrade[grade]

	var.instantName = "Divine Grenade Cast"
	if combatCast:execute(creature, var) then
		creature:getPosition():sendMagicEffect(CONST_ME_DIVINE_GRENADE)
		local condition = Condition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, 258)
		condition:setTicks((cooldown * 1000) / configManager.getFloat(configKeys.RATE_SPELL_COOLDOWN))
		creature:addCondition(condition)
		return true
	end
	return false
end

spell:group("attack")
spell:id(258)
spell:name("Divine Grenade")
spell:words("exevo tempo mas san")
spell:level(300)
spell:mana(160)
spell:isPremium(true)
spell:range(7)
spell:needTarget(true)
spell:blockWalls(true)
spell:cooldown(1000) -- Cooldown is calculated on the casting
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:vocation("paladin;true", "royal paladin;true")
spell:register()
