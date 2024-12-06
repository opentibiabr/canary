local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)

combat:setArea(createCombatArea({
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 3, 0 },
}))

function spellCallbackHeatOfSummer(param)
	local tile = Tile(Position(param.pos))

	if tile then
		if tile:getTopCreature() and tile:getTopCreature():isMonster() then
			if tile:getTopCreature():getName():lower():find("izcandar") then
				tile:getTopCreature():addHealth(math.random(0, 1500))
			end
		end
	end
end

function onTargetTileHeatOfSummer(cid, pos)
	local param = {}

	param.cid = cid
	param.pos = pos
	param.count = 0
	spellCallbackHeatOfSummer(param)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTileHeatOfSummer")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("heat of summer")
spell:words("###554")
spell:needDirection(true)
spell:isAggressive(false)
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
