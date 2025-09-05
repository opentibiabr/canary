local event = CreatureEvent("WormlingDeath")

local explode = Combat()
explode:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYPOISON)
local area = createCombatArea(AREA_SQUARE1X1)
explode:setArea(area)

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	local target = tile:getTopCreature()

	if tile then
		if target and target:isPlayer() then
			doTargetCombatHealth(0, target, COMBAT_EARTHDAMAGE, -750, -750)
		end
	end
end

explode:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function event.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	local centerPos = creature:getPosition()

	local var = { type = 1, number = creature:getId() }

	explode:execute(creature, var)

	return true
end

event:register()
