local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)

local monsters = {
	"minotaur cult prophet",
	"minotaur cult follower",
	"minotaur cult zealot",
}

local healingValue = math.random(200, 350)

function onTargetTile(creature, pos)
	local tile = Tile(pos)
	if tile then
		local target = tile:getTopCreature()
		if target and target ~= creature then
			if table.contains(monsters, target:getName():lower()) then
				target:addHealth(healingValue)
			end
		end
	end
	return true
end

combat:setArea(createCombatArea(AREA_CIRCLE3X3))
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	creature:addHealth(healingValue) -- otherwise minotaur cult didnt heal itself, only allies
	return combat:execute(creature, variant)
end

spell:name("Minotaur Cult Prophet Mass Healing")
spell:words("##488")
spell:blockWalls(true)
spell:needLearn(true)
spell:isAggressive(false)
spell:register()
