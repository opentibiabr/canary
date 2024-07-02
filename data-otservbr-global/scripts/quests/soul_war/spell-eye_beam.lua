local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DROWNDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)

combat:setArea(createCombatArea({
	{ 1 },
	{ 1 },
	{ 3 },
}))

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	local target = tile:getTopCreature()
	if tile then
		if target then
			if target:isMonster() and target:getName() == "Poor Soul" then
				target:addHealth(-1000)
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

spell:name("greedy eye beam")
spell:words("greedy eye beam")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
