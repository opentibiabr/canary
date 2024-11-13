local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLPLANTS)
combat:setArea(createCombatArea(AREA_RING1_BURST3))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 7)
	local max = (level / 5) + (maglevel * 10.5)
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local grade = creature:revelationStageWOD("Twin Burst")
	if grade == 0 then
		creature:sendCancelMessage("You need to learn this spell first")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	return combat:execute(creature, var)
end

spell:group("attack", "burstsofnature")
spell:id(263)
spell:name("Terra Burst")
spell:words("exevo ulus tera")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_WRATH_OF_NATURE)
spell:level(300)
spell:mana(230)
spell:isPremium(true)
spell:isSelfTarget(true)
spell:cooldown(22 * 1000)
spell:groupCooldown(2 * 1000, 22 * 1000)
spell:needLearn(true)
spell:vocation("druid;true", "elder druid;true")
spell:register()
