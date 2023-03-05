function onTargetCreature(creature, target)
	local player = creature:getPlayer()
	local min = ((player:getLevel() / 5) + (player:getMagicLevel() * 5.7) + 26)
	local max = ((player:getLevel() / 5) + (player:getMagicLevel() * 10.43) + 62)

	local bosses = {"leiden", "ravennous hunger", "dorokoll the mystic", "eshtaba the conjurer", "eliz the unyielding", "mezlon the defiler", "malkhar deathbringer", "containment crystal"}
	local master = target:getMaster()
	if target:isMonster() and not master or master and master:isMonster() then
		if (not table.contains(bosses, target:getName():lower())) then
			return true
		end
	end

	doTargetCombatHealth(creature, target, COMBAT_HEALING, min, max, CONST_ME_NONE, ORIGIN_SPELL, "Mass Healing")
	return true
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))
onTargetCreatureWOD = loadstring(string.dump(onTargetCreature))
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local combatWOD = Combat()
combatWOD:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combatWOD:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combatWOD:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combatWOD:setArea(createCombatArea(AREA_CIRCLE5X5))

combatWOD:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreatureWOD")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if (creature and creature:getPlayer()) then
		if (WheelOfDestinySystem.getPlayerSpellAdditionalArea(creature:getPlayer(), "Mass Healing")) then
			return combatWOD:execute(creature, var)
		end
	end
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
