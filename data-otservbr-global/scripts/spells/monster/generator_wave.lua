local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)

combat:setArea(createCombatArea({
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 1, 1, 1, 3, 1, 1, 1 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
}))

function spellCallbackGenerator(param)
	local sqm = Tile(Position(param.pos))

	if sqm then
		local monster = sqm:getTopCreature()
		if monster and monster:getName():lower() == "maxxenius" then
			doTargetCombatHealth(0, monster, COMBAT_ENERGYDAMAGE, -999, -1999, CONST_ME_ENERGYAREA)
		end
	end
end

function onTargetTileGenerator(cid, pos)
	local param = {}

	param.cid = cid
	param.pos = pos
	param.count = 0
	spellCallbackGenerator(param)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTileGenerator")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("generator wave")
spell:words("###551")
spell:needDirection(false)
spell:isSelfTarget(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
