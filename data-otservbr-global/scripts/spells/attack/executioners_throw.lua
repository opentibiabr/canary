local combatBounce = Combat()
combatBounce:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatBounce:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
--combatBounce:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_WEAPONTYPE)
combatBounce:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combatBounce:setParameter(COMBAT_PARAM_USECHARGES, 1)

function onGetFormulaValues(player, skill, attack, factor)
	local skillTotal = skill * attack
	local levelTotal = player:getLevel() / 5
	return -(((skillTotal * 0.17) + 17) + (levelTotal)) * 1.28, -(((skillTotal * 0.20) + 40) + (levelTotal)) * 1.28
end
combatBounce:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local combatCast = Combat()
combatCast:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_WEAPONTYPE)
function onTargetCreature(creature, target)
    if not(creature) or not(target) or not(creature:isPlayer()) then 
        return false
    end

    local grade = creature:upgradeSpellsWORD("Executioner's Throw")
    if (grade == 0) then
        return false
    end
    local bounces = 0
    if (grade >= 3) then
        bounces = 4
    elseif (grade >= 2) then
        bounces = 3
    elseif (grade >= 1) then
        bounces = 2
    end

    local weaponType = WEAPON_AXE
    local effect = CONST_ANI_WHIRLWINDAXE
    local item = creature:getSlotItem(CONST_SLOT_RIGHT)
    if (item) then
        local itemType = ItemType(item:getId())
        if (itemType) then
            weaponType = itemType:getWeaponType()
        end
    end
    if (weaponType == WEAPON_SWORD) then
        effect = CONST_ANI_WHIRLWINDSWORD
    elseif (weaponType == WEAPON_CLUB) then
        effect = CONST_ANI_WHIRLWINDCLUB
    end

    local position = creature:getPosition()
    local targetPosition = target:getPosition()

    local targetId = target:getId()
    local var = {}
    var.instantName = "Executioner's Throw"
    var.runeName = ""
    var.type = 1 -- VARIANT_NUMBER
    var.number = targetId
    combatBounce:execute(creature, var)
    position:sendDistanceEffect(targetPosition, effect)
    position = targetPosition
    local spectators = Game.getSpectators(targetPosition, false, false, 5, 5, 5, 5)
    for _, spectator in ipairs(spectators) do
        if (bounces == 0) then
            return true
        elseif (spectator and spectator:getId() ~= targetId and spectator:isMonster()) then
            var.number = spectator:getId()
            local spectatorPosition = spectator:getPosition()
            if (combatBounce:execute(creature, var)) then
                position:sendDistanceEffect(spectatorPosition, effect)
                position = spectatorPosition
                bounces = bounces - 1
            end
        end
    end

	return true
end
combatCast:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    if not(creature) or not(creature:isPlayer()) then
        return false
    end

    local grade = creature:upgradeSpellsWORD("Executioner's Throw")
    if (grade == 0) then
        creature:sendCancelMessage("You cannot cast this spell")
        creature:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
    local cooldown = 0
    if (grade >= 3) then
        cooldown = 10
    elseif (grade >= 2) then
        cooldown = 14
    elseif (grade >= 1) then
        cooldown = 18
    end

    var.instantName = "Executioner's Throw Cast"
    if (combatCast:execute(creature, var)) then
        local condition = Condition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, 261)
        condition:setTicks((cooldown * 1000)/configManager.getFloat(configKeys.RATE_SPELL_COOLDOWN))
        creature:addCondition(condition)
        return true
    end
	return false
end

spell:group("attack")
spell:id(261)
spell:name("Executioner's Throw")
spell:words("exori amp kor")
spell:level(1)
spell:mana(225)
spell:isPremium(true)
spell:range(5)
spell:needTarget(true)
spell:blockWalls(true)
spell:needWeapon(true)
spell:cooldown(1000) -- Cooldown is calculated on the casting
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:vocation("knight;true", "elite knight;true")
spell:register()