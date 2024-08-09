local areaSpell = {
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
}

local area = createCombatArea(areaSpell)

local combat = Combat()
combat:setArea(area)
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	if tile then
		local target = tile:getTopCreature()
		if target and target:isPlayer() then
			target:addHealth(math.random(2300, 3000))
		end
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local config = {
	outfit = { lookType = 242, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0 },
	time = 7000,
}

local spell = Spell("instant")

function spell.onCastSpell(creature, var, isHotkey)
	return creature:applyZoneEffect(var, combat, "boss.goshnar's-megalomania-purple")
end

spell:name("megalomania transform elemental")
spell:words("megalomania transform elemental")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
