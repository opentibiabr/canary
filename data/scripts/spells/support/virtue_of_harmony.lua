local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLOW_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, AttrSubId_VirtueOfJustice)
	return combat:execute(player, variant)
end

spell:name("Virtue of Harmony")
spell:words("utori virtu")
spell:group("support", "stance")
spell:vocation("monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_PROTECTOR)
spell:id(274)
spell:stance("standard")
spell:cooldown(10 * 1000)
spell:groupCooldown(2 * 1000, 10 * 1000)
spell:level(20)
spell:mana(210)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)

spell:register()
