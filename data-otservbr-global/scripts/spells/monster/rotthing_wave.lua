local combat1 = Combat()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYDAMAGE)
combat1:setFormula(COMBAT_FORMULA_DAMAGE, 0, 700, 900, 0)

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
combat2:setFormula(COMBAT_FORMULA_DAMAGE, 0, 800, 1200, 0)

arr = {
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 3, 0, 0 },
}

arr1 = {
	{ 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 3, 0, 0, 0 },
}

local area = createCombatArea(arr)
combat1:setArea(createCombatArea(arr))
combat2:setArea(createCombatArea(arr1))

local spell = Spell("instant")

local combats = { combat1, combat2 }

function spell.onCastSpell(creature, var)
	for _, combat in pairs(combats) do
		combat:execute(creature, var)
	end
	return true
end

spell:name("rotthingwave")
spell:words("#776373")
spell:needLearn(true)
spell:needDirection(true)
spell:register()
