local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setArea(createCombatArea(AREA_BALANCED_BRAWL))

local challengeTime = 16 * 1000

function onTargetCreature_BalancedBrawl(creature, target)
	if target and target:isMonster() then
		target:changeTargetDistance(1, challengeTime)
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature_BalancedBrawl")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Balanced Brawl")
spell:words("exori mas res")
spell:group("support")
spell:vocation("monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_CHALLENGE)
spell:id(280)
spell:cooldown(10 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(175)
spell:mana(80)
spell:needTarget(false)
spell:needDirection(true)
spell:blockWalls(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
