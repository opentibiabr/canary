local monsters = {
    [1] = { pos = Position(32980, 31664, 13) },
    [2] = { pos = Position(32975, 31664, 13) },
}

local function functionBack(position, oldpos)
    local guardian = Tile(position):getTopCreature()
    if not guardian then return false end

    local bool, oldGuardianPos, healthDifference = false, nil, 0
    local spectators = Game.getSpectators(Position(32977, 31662, 14), false, false, 15, 15, 15, 15)
    for _, spectator in pairs(spectators) do
        if spectator:getName():lower() == "the freezing time guardian" or spectator:getName():lower() == "the blazing time guardian" then
            oldGuardianPos = spectator:getPosition()
            bool = true
        end
    end

    if not bool then
        guardian:remove()
        return true
    end

    for _, spec in pairs(Game.getSpectators(Position(32977, 31662, 14), false, false, 15, 15, 15, 15)) do
        if spec:isMonster() and (spec:getName():lower() == "the freezing time guardian" or spec:getName():lower() == "the blazing time guardian") then
            spec:teleportTo(position)
            healthDifference = guardian:getHealth() - spec:getHealth()
        end
    end

    guardian:addHealth(-healthDifference)
    guardian:teleportTo(oldGuardianPos)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    local index = math.random(1, #monsters)
    local casterPos = creature:getPosition()
    if casterPos.z ~= 14 then
        return true
    end

    local position = monsters[index].pos
    local form = Tile(position):getTopCreature()
    if not form then return false end

    creature:teleportTo(position)
    local healthDifference = form:getHealth() - creature:getHealth()
    form:addHealth(-healthDifference)
    form:teleportTo(casterPos)

    addEvent(functionBack, 30 * 1000, position, casterPos)
    return true
end

spell:name("time guardian")
spell:words("###440")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()