local function outExplode()
	local spectators = Game.getSpectators(Position(32234, 31285, 14), false, true, 10, 10, 10, 10)
	for _, spectator in ipairs(spectators) do
		if spectator:isPlayer() then
			spectator:teleportTo(Position(32234, 31280, 14))
		elseif spectator:isMonster() and spectator:getName() == "Charging Outburst" then
			spectator:teleportTo(Position(32234, 31279, 14))
		end
	end
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)

local spellArea = {
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

local area = createCombatArea(spellArea)
combat:setArea(area)

local function delayedCastSpell(creature, var)
	if not creature then
		return
	end
	return combat:execute(creature, Variant(creature:getPosition()))
end

function removeOutburst(cid)
	local creature = Creature(cid)
	if not creature then
		return false
	end
	creature:remove()
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	outExplode()
	delayedCastSpell(creature, var)
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.OutburstChargingKilled, 1)
	addEvent(removeOutburst, 1000, creature.uid)

	local monster = Game.createMonster("Outburst", Position(32234, 31284, 14), false, true)
	if monster then
		local outburstHealth = Game.getStorageValue(GlobalStorage.HeartOfDestruction.OutburstHealth) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.OutburstHealth) or 0
		monster:addHealth(-monster:getHealth() + outburstHealth, COMBAT_PHYSICALDAMAGE)
	end
	return true
end

spell:name("outburst explode")
spell:words("###449")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
