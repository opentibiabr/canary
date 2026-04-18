local spell = Spell("instant")

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)

function onTargetCreature(creature, target)
	if not target:isPlayer() then
		return true
	end

	local icon = target:getIcon("fryclops")
	if icon and icon.count > 0 then
		local newCount = icon.count - TwentyYearsACookQuest.Fryclops.MeleePoints
		if newCount > 0 then
			target:setIcon("fryclops", CreatureIconCategory_Quests, CreatureIconQuests_GreenBall, newCount)
		else
			target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You ran out of points!")
			target:teleportTo(TwentyYearsACookQuest.Fryclops.Exit)
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("fryclops melee")
spell:words("###544")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needTarget(true)
spell:register()
