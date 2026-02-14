local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local player = creature:getPlayer()
	if player and combat:execute(creature, variant) then
		player:fillHarmony()
		return true
	end
	return false
end

spell:name("Focus Harmony")
spell:words("utevo nia")
spell:group("support")
spell:vocation("monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_ULTIMATE_LIGHT)
spell:id(279)
spell:cooldown(2 * 60 * 1000) -- 2 minutes
spell:groupCooldown(2 * 1000)
spell:level(275)
spell:mana(500)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(true)
spell:register()
