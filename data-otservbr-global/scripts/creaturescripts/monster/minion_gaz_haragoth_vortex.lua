local function removeTeleport(position)
    local teleportItem = Tile(position):getItemById(20121)
    if teleportItem then
        teleportItem:remove()
    end
end

local minionDeath = CreatureEvent("MinionGazDeath")

function minionDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
    local targetMonster = creature:getMonster()
    if not targetMonster then
        return true
    end

    local deathPosition = creature:getPosition()
    local item = Game.createItem(20121, 1, deathPosition)

    item:setActionId(33542)

    addEvent(removeTeleport, 1 * 60 * 1000, deathPosition)

    return true
end

minionDeath:register()
