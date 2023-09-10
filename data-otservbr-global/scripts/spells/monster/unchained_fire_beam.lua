local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)

local beam = {
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 1, 0 },
	{ 0, 3, 0 },
}

combat:setArea(createCombatArea(beam))

local spell = Spell("instant")

function onTargetTile(creature, pos)
	local tile = Tile(pos)
	if not tile then
		return
	end
	if tile:getTopCreature() and tile:getTopCreature():isMonster() then
		if tile:getTopCreature():getName():lower() == "magma bubble" then
			tile:getTopCreature():addHealth(math.random(2000, 5000))
		end
	end
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("unchained fire beam")
spell:words("###6034")
spell:needLearn(true)
spell:cooldown("2000")
spell:needDirection(true)
spell:isSelfTarget(true)
spell:register()
