function onTargetCreature(creature, target)
	local player = creature:getPlayer()
	local min = ((player:getLevel() / 5) + (player:getMagicLevel() * 5.7) + 26)
	local max = ((player:getLevel() / 5) + (player:getMagicLevel() * 10.43) + 62)

	local bosses = {"leiden", "ravennous hunger", "dorokoll the mystic", "eshtaba the conjurer", "eliz the unyielding", "mezlon the defiler", "malkhar deathbringer", "containment crystal"}
	local master = target:getMaster()
	if target:isMonster() and not master or master and master:isMonster() then
		if (not isInArray(bosses, target:getName():lower())) then
			return true
		end
	end

	doTargetCombatHealth(0, target, COMBAT_HEALING, min, max, CONST_ME_NONE)
	return true
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end


spell:name("Mass Healing")
spell:words("exura gran mas res")
spell:group("healing")
spell:vocation("druid;true", "elder druid;true")
spell:id(82)
spell:cooldown(2 * 1000)
spell:groupCooldown(1 * 1000)
spell:level(36)
spell:mana(150)
spell:isAggressive(false)
spell:isPremium(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
