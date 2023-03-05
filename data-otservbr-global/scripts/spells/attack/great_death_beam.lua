
AREA_BEAM6 = {
	{1},
	{1},
	{1},
	{1},
	{3}
}

local combat1 = Combat()
combat1:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat1:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat1:setArea(createCombatArea(AREA_BEAM6))

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat2:setArea(createCombatArea(AREA_BEAM7))

local combat3 = Combat()
combat3:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat3:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat3:setArea(createCombatArea(AREA_BEAM8))

function onGetFormulaValuesWOD3(player, level, maglevel)
	local min = (level / 5) + (maglevel * 5.5)
	local max = (level / 5) + (maglevel * 9)
	return -min, -max
end

onGetFormulaValuesWOD1 = loadstring(string.dump(onGetFormulaValuesWOD3))
combat1:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValuesWOD1")
onGetFormulaValuesWOD2 = loadstring(string.dump(onGetFormulaValuesWOD3))
combat2:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValuesWOD2")
combat3:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValuesWOD3")

local spell = Spell("instant")

local exhaust = {}
function spell.onCastSpell(creature, var)
    if not(creature) or not(creature:isPlayer()) then
        return false
    end

    local grade = creature:upgradeSpellsWORD("Great Death Beam")
    if (grade == 0) then
        creature:sendCancelMessage("You cannot cast this spell")
        creature:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local cooldown = 0
    if (grade >= 3) then
        cooldown = 6
    elseif (grade >= 2) then
        cooldown = 8
    elseif (grade >= 1) then
        cooldown = 10
    end

    var.runeName = "Beam Mastery"
    local executed = false
    if (grade == 1) then
        executed = combat1:execute(creature, var)
    elseif (grade == 2) then
        executed = combat2:execute(creature, var)
    elseif (grade == 3) then
        executed = combat3:execute(creature, var)
    end
    if (executed) then
        local condition = Condition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, 260)
        condition:setTicks((cooldown * 1000))
        creature:addCondition(condition)
        return true
    end
	return false
end

spell:group("attack")
spell:id(260)
spell:name("Great Death Beam")
spell:words("exevo max mort")
spell:level(1)
spell:mana(140)
spell:isPremium(false)
spell:needDirection(true)
spell:blockWalls(true)
spell:cooldown(1000) -- Cooldown is calculated on the casting
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
