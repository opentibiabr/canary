local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WATERSPLASH)
combat:setArea(createCombatArea({
{0, 1, 0},
{1, 3, 1},
{0, 1, 0}}))

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WATERSPLASH)
combat2:setArea(createCombatArea({
{0, 1, 1, 1, 0},
{1, 1, 0, 1, 1},
{1, 0, 2, 0, 1},
{1, 1, 0, 1, 1},
{0, 1, 1, 1, 0}}))

local combat3 = Combat()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WATERSPLASH)
combat3:setArea(createCombatArea({
{0, 0, 0, 1, 1, 1, 0, 0, 0},
{0, 0, 1, 1, 1, 1, 1, 0, 0},
{0, 1, 1, 0, 0, 0, 1, 1, 0},
{1, 1, 0, 0, 0, 0, 0, 1, 1},
{1, 1, 0, 0, 2, 0, 0, 1, 1},
{1, 1, 0, 0, 0, 0, 0, 1, 1},
{0, 1, 1, 0, 0, 0, 1, 1, 0},
{0, 0, 1, 1, 1, 1, 1, 0, 0},
{0, 0, 0, 1, 1, 1, 0, 0, 0}}))


local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    addEvent(runSpell, 1000, creature:getId(), combat, var)
    addEvent(runSpell, 2000, creature:getId(), combat2, var)
    addEvent(runSpell, 3000, creature:getId(), combat3, var)
	return true
end

function runSpell(cid, combat, var)
    local creature = Creature(cid)
    if creature then
        combat:execute(creature, var)
    end
end

spell:name("foamsplash")
spell:words("###491")
spell:blockWalls(true)
spell:needDirection(false)
spell:needLearn(true)
spell:register()