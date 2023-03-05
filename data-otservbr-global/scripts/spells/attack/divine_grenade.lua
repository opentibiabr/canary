local combatGrenade = Combat()
combatGrenade:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combatGrenade:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYDAMAGE)
combatGrenade:setArea(createCombatArea(AREA_CIRCLE2X2))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 4)
	local max = (level / 5) + (maglevel * 6)
    local multiplier = 1.0
    local grade = player:upgradeSpellsWORD("Divine Grenade")
    if (grade >= 3) then
        multiplier = 2.0
    elseif (grade >= 2) then
        multiplier = 1.6
    elseif (grade >= 1) then
        multiplier = 1.3
    end
    min = min * multiplier
    max = max * multiplier
	return -min, -max
end

combatGrenade:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local explodeGrenade = function(x, y, z, id, cid)
    local position = Position(x, y, z)
    if not(position) then
        return
    end

    local tile = Tile(position)
    if not(tile) then
        return
    end

    local item = tile:getItemById(id)
    if not(item) then
        return
    end

    item:remove()
    local player = Player(cid)
    if not(player) then
        return
    end

    local var = {}
    var.instantName = "Divine Grenade Explode"
    var.runeName = ""
    var.type = 2 -- VARIANT_POSITION
    var.pos = position
    combatGrenade:execute(player, var)
end

local combatCast = Combat()
combatCast:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_HOLY)

function onTargetCreature(creature, target)
    if not(creature) or not(target) or not(creature:isPlayer()) then 
        return false
    end

    local grenadeId = 2160
    local position = target:getPosition()
    local item = Game.createItem(grenadeId, 1, position)
    if (item) then
        addEvent(explodeGrenade, 3000, position.x, position.y, position.z, grenadeId, creature:getId())
    end

	return true
end
combatCast:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    if not(creature) or not(creature:isPlayer()) then
        return false
    end
    local grade = creature:upgradeSpellsWORD("Divine Grenade")
    if (grade == 0) then
        creature:sendCancelMessage("You cannot cast this spell")
        creature:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local cooldown = 0
    if (grade >= 3) then
        cooldown = 14
    elseif (grade >= 2) then
        cooldown = 20
    elseif (grade >= 1) then
        cooldown = 26
    end

    var.instantName = "Divine Grenade Cast"
    if (combatCast:execute(creature, var)) then
        local condition = Condition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, 258)
        condition:setTicks((cooldown * 1000)/configManager.getFloat(configKeys.RATE_SPELL_COOLDOWN))
        creature:addCondition(condition)
        return true
    end
	return false
end

spell:group("attack")
spell:id(258)
spell:name("Divine Grenade")
spell:words("exevo tempo mas san")
spell:level(1)
spell:mana(160)
spell:isPremium(true)
spell:range(7)
spell:needTarget(true)
spell:blockWalls(true)
spell:cooldown(1000) -- Cooldown is calculated on the casting
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:vocation("paladin;true", "royal paladin;true")
spell:register()