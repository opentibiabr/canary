local arrayArea = {
	{ 0, -4 },
	{ -1, -3 },
	{ 0, -3 },
	{ 1, -3 },
	{ -2, -2 },
	{ -1, -2 },
	{ 0, -2 },
	{ 1, -2 },
	{ 2, -2 },
	{ 3, -1 },
	{ -2, -1 },
	{ -1, -1 },
	{ 0, -1 },
	{ 1, -1 },
	{ 2, -1 },
	{ 3, -1 },
	{ -4, 0 },
	{ -3, 0 },
	{ -2, 0 },
	{ -1, 0 },
	{ 0, 0 },
	{ 1, 0 },
	{ 2, 0 },
	{ 3, 0 },
	{ 4, 0 },
	{ -3, 1 },
	{ -2, 1 },
	{ -1, 1 },
	{ 0, 1 },
	{ 1, 1 },
	{ 2, 1 },
	{ 3, 1 },
	{ -2, 2 },
	{ -1, 2 },
	{ 0, 2 },
	{ 1, 2 },
	{ 2, 2 },
	{ -1, 3 },
	{ 0, 3 },
	{ 1, 3 },
	{ 0, 4 },
}

local area = createCombatArea(arrayArea)

local function spellDamage(id, centerpos, target)
	local damage = math.random(1000, 2000)
	local target = Creature(target)
	local monster = Monster(id)

	if not target and monster then
		centerpos = monster:getPosition()
	elseif target then
		centerpos = target:getPosition()
	end

	for _, pos in pairs(arrayArea) do
		local newpos = Position(centerpos.x + pos[1], centerpos.y + pos[2], centerpos.z)
		if newpos then
			local creature = Tile(newpos):getTopCreature()
			if creature then
				doTargetCombatHealth(0, creature, COMBAT_ENERGYDAMAGE, -1000, -2000, CONST_ME_ENERGYHIT)
			end
			newpos:sendMagicEffect(CONST_ME_ENERGYHIT)
		end
	end
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGYBALL)

local looktype = createConditionObject(CONDITION_OUTFIT)
setConditionParam(looktype, CONDITION_PARAM_TICKS, 5000)
addOutfitCondition(looktype, { lookType = 290 })

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local target = creature:getTarget()

	if target:isPlayer() then
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel a powerfull eletric charge building up!")
		doAddCondition(target, looktype)
	end

	addEvent(spellDamage, 5 * 1000, creature:getId(), creature:getPosition(), target and target:getId() or 0)

	return combat:execute(creature, var)
end

spell:name("maxxenius energy elemental")
spell:words("###552")
spell:needDirection(true)
spell:isAggressive(false)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()
