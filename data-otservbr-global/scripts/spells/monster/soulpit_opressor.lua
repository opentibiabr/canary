-- ROOT
local combatRoot = Combat()
combatRoot:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ROOTS)

local area = createCombatArea(AREA_WAVE11)
combatRoot:setArea(area)

local condition = Condition(CONDITION_ROOTED)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
combatRoot:addCondition(condition)

-- FEAR

local combatFear = Combat()
combatFear:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLUE_GHOST)

local condition = Condition(CONDITION_FEARED)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
combatFear:addCondition(condition)

local spell = Spell("instant")

local combats = { combatRoot, combatFear }

local zone = Zone("soulpit")

function spell.onCastSpell(creature, var)
	if creature:getForgeStack() ~= 40 or not zone:isInZone(creature:getPosition()) then
		return true
	end

	for _, combat in pairs(combats) do
		combat:execute(creature, var)
	end
	return true
end

spell:name("soulpit opressor")
spell:words("###938")
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
