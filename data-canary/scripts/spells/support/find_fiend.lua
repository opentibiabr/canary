local LEVEL_LOWER = 1
local LEVEL_SAME = 2
local LEVEL_HIGHER = 3

local DISTANCE_BESIDE = 1
local DISTANCE_CLOSE = 2
local DISTANCE_FAR = 3
local DISTANCE_VERYFAR = 4

local directions = {
    [DIRECTION_NORTH] = "north",
    [DIRECTION_SOUTH] = "south",
    [DIRECTION_EAST] = "east",
    [DIRECTION_WEST] = "west",
    [DIRECTION_NORTHEAST] = "north-east",
    [DIRECTION_NORTHWEST] = "north-west",
    [DIRECTION_SOUTHEAST] = "south-east",
    [DIRECTION_SOUTHWEST] = "south-west"
}

local messages = {
    [DISTANCE_BESIDE] = {
        [LEVEL_LOWER] = "is below you",
        [LEVEL_SAME] = "is standing next to you",
        [LEVEL_HIGHER] = "is above you"
    },
    [DISTANCE_CLOSE] = {
        [LEVEL_LOWER] = "is on a lower level to the",
        [LEVEL_SAME] = "is to the",
        [LEVEL_HIGHER] = "is on a higher level to the"
    },
    [DISTANCE_FAR] = "is far to the",
    [DISTANCE_VERYFAR] = "is very far to the"
}

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
    local targetId = ForgeMonster:pickClosestFiendish(creature)
    if not targetId then
        creature:sendCancelMessage("No creatures around")
        creature:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end
    local target = Creature(targetId)
    if not target then
        creature:sendCancelMessage("No creatures around")
        creature:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local targetPosition = target:getPosition()
    local creaturePosition = creature:getPosition()
    local positionDifference = {
        x = creaturePosition.x - targetPosition.x,
        y = creaturePosition.y - targetPosition.y,
        z = creaturePosition.z - targetPosition.z
    }

    local maxPositionDifference, direction = math.max(math.abs(positionDifference.x), math.abs(positionDifference.y))
    if maxPositionDifference >= 5 then
        local positionTangent = positionDifference.x ~= 0 and positionDifference.y / positionDifference.x or 10
        if math.abs(positionTangent) < 0.4142 then
            direction = positionDifference.x > 0 and DIRECTION_WEST or DIRECTION_EAST
        elseif math.abs(positionTangent) < 2.4142 then
            direction = positionTangent > 0 and
                            (positionDifference.y > 0 and DIRECTION_NORTHWEST or DIRECTION_SOUTHEAST) or
                            positionDifference.x > 0 and DIRECTION_SOUTHWEST or DIRECTION_NORTHEAST
        else
            direction = positionDifference.y > 0 and DIRECTION_NORTH or DIRECTION_SOUTH
        end
    end

    local level = positionDifference.z > 0 and LEVEL_HIGHER or positionDifference.z < 0 and LEVEL_LOWER or LEVEL_SAME
    local distance = maxPositionDifference < 5 and DISTANCE_BESIDE or maxPositionDifference < 101 and DISTANCE_CLOSE or
                         maxPositionDifference < 275 and DISTANCE_FAR or DISTANCE_VERYFAR
    local message = messages[distance][level] or messages[distance]
    if distance ~= DISTANCE_BESIDE then
        message = message .. " " .. directions[direction]
    end

    local type = target:getType()
    local stringLevel = 'Unknown'
    if type then
        local bestiaryKillsAmount = type:BestiarytoKill()
        if bestiaryKillsAmount >= 5 and bestiaryKillsAmount <= 25 then
            stringLevel = 'Harmless'
        elseif bestiaryKillsAmount <= 250 then
            stringLevel = 'Trivial'
        elseif bestiaryKillsAmount <= 500 then
            stringLevel = 'Easy'
        elseif bestiaryKillsAmount <= 1000 then
            stringLevel = 'Medium'
        elseif bestiaryKillsAmount <= 2500 then
            stringLevel = 'Hard'
        elseif bestiaryKillsAmount <= 5000 then
            stringLevel = 'Challenging'
        end
    end

    message = string.format("The monster " .. message .. ". Be prepared to find a creature of difficulty level \"" ..
                                stringLevel .. "\".")
    local timeLeft = math.floor((target:getTimeToChangeFiendish() - os.time()) / 60)
    if (timeLeft <= 15) then
        message = string.format(message .. " " .. ForgeMonster:getTimeLeftToChangeMonster(target))
    end

    creature:sendTextMessage(MESSAGE_INFO_DESCR, message)
    creaturePosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
    return true
end

spell:name("Find Fiend")
spell:words("exiva moe res")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "knight;true", "elite knight;true", "paladin;true",
    "royal paladin;true", "sorcerer;true", "master sorcerer;true")
spell:id(20)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(25)
spell:mana(20)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
