local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYPOISON)
combat:setParameter(COMBAT_PARAM_SHOOT, CONST_ANI_EARTH)

combat:setArea(createCombatArea({
	{ 0, 0, 1, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 3, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
}))

function spellCallbackAbominationWave(param)
	local tile = Tile(Position(param.pos))

	if tile then
		if tile:getTopCreature() and tile:getTopCreature():isMonster() then
			if tile:getTopCreature():getName():lower() == "plagueroot" then
				tile:getTopCreature():addHealth(math.random(0, 1500))
			end
		end
	end
end

function onTargetTileAbominationWave(cid, pos)
	local param = {}

	param.cid = cid
	param.pos = pos
	param.count = 0
	spellCallbackAbominationWave(param)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTileAbominationWave")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("plant abomination wave")
spell:words("###557")
spell:isAggressive(false)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()
