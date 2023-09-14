local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

function onGetFormulaValues(player, level, maglevel)
	local min = (level * 2) + (maglevel * 17.5) -- 254 108 -- 508 + 1890 = 2398
	local max = (level * 2.5) + (maglevel * 20.3) 
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack", "focus")
spell:id(118)
spell:name("Eternal Winter")
spell:words("exevo gran mas frigo")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_ETERNAL_WINTER)
spell:level(60)
spell:mana(1050)
spell:isPremium(true)
spell:range(7)
spell:isSelfTarget(true)
spell:cooldown(2 * 1000)
spell:groupCooldown(1 * 1000, 4 * 1000)
spell:needLearn(false)
spell:vocation("druid;true", "elder druid;true")
spell:register()