local SPELL_BASE_POWER = 44

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_CLAW_WHITE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combat:setParameter(COMBAT_PARAM_USECHARGES, 1)

function onGetFormulaValues(player, skill, attack, factor)
	local damageHealing = player:calculateFlatDamageHealing()

	local damage = SPELL_BASE_POWER * (skill / 100) * (attack / 10) + damageHealing

	local min = damage - (damage / 10)
	local max = damage + (damage / 10)

	return player:getHarmonyDamage(min, max)
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(292)
spell:name("Greater Tiger Clash")
spell:words("exori nia")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_BRUTAL_STRIKE)
spell:level(18)
spell:mana(50)
spell:isPremium(true)
spell:range(1)
spell:needTarget(true)
spell:blockWalls(true)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:monkSpellType(MonkSpell_Spender)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
