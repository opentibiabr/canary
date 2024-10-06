local combat = Combat()

arr = {
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0 },
}

local area = createCombatArea(arr)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
combat:setArea(area)

function onTargetTile(creature, pos)
	local tile = Tile(pos)

	if not tile then
		return true
	end

	local target = tile:getTopCreature()

	if not target then
		return true
	end

	if target:isMonster() and target:getName():lower() == "locked door" then
		target:addHealth(-250, COMBAT_AGONYDAMAGE)
	elseif target:isPlayer() then
		local icon = target:getIcon("fryclops")
		if icon and icon.count > 0 then
			local newCount = icon.count - TwentyYearsACookQuest.Fryclops.BeamPoints
			if newCount > 0 then
				target:setIcon("fryclops", CreatureIconCategory_Quests, CreatureIconQuests_GreenBall, newCount)
			else
				target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You ran out of points!")
				target:teleportTo(TwentyYearsACookQuest.Fryclops.Exit)
			end
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("fryclops beam")
spell:words("###545")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
