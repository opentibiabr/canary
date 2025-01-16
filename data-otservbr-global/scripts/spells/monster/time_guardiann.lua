local monsters = {
    [1] = { pos = Position(32810, 32664, 14) },
    [2] = { pos = Position(32815, 32664, 14) },
}

local function functionBack(position, oldpos)
    local guardian = Tile(position) and Tile(position):getTopCreature()
    if not guardian then return false end

    local bool, diference, health = false, 0, 0
    local spectators = Game.getSpectators(Position(32813, 32664, 14), false, false, 15, 15, 15, 15)

    for _, spectator in ipairs(spectators) do
        if spectator:getName():lower() == "the blazing time guardian" or spectator:getName():lower() == "the freezing time guardian" then
            oldpos = spectator:getPosition()
            bool = true
        end
    end

    if not bool then
        guardian:remove()
        return true
    end

    for _, spec in ipairs(Game.getSpectators(Position(32813, 32664, 14), false, false, 15, 15, 15, 15)) do
        if spec:isMonster() and (spec:getName():lower() == "the blazing time guardian" or spec:getName():lower() == "the freezing time guardian") then
            spec:teleportTo(position)
            health = spec:getHealth()
            diference = guardian:getHealth() - health
        end
    end

    guardian:addHealth(-diference)
    guardian:teleportTo(oldpos)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
    local index = math.random(1, #monsters)
    local casterPos = creature:getPosition()
    if casterPos.z ~= 14 then
        return true
    end

    local position = monsters[index].pos
    local form = Tile(position) and Tile(position):getTopCreature()
    if not form then return false end

    creature:teleportTo(position)
    local diference = form:getHealth() - creature:getHealth()
    form:addHealth(-diference)
    form:teleportTo(casterPos)

    addEvent(functionBack, 30 * 1000, position, casterPos)
    return true
end

spell:name("time guardiann")
spell:words("###441")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()