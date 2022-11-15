local hungerSummonDelay = false

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_NONE)

local area = createCombatArea(AREA_CIRCLE2X2)
combat:setArea(area)

local function removeDelay()
	hungerSummonDelay = false
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)

	if hungerSummonDelay == false then
		if hungerSummon < 3 then
			Game.createMonster("Greed", {x=creature:getPosition().x+math.random(-1, 1), y=creature:getPosition().y+math.random(-1, 1), z=creature:getPosition().z}, false, true)
			hungerSummon = hungerSummon + 1

			hungerSummonDelay = true
			addEvent(removeDelay, 15000)
		end
	end

	return combat:execute(creature, var)
end

spell:name("hunger summon")
spell:words("###420")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()