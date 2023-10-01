local archangelSpell = GlobalEvent("ArchangelSpell")
local bossName = "Archangel"  

local function createCombatArea(fromPos, toPos)
    local combatArea = {}
    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            for z = fromPos.z, toPos.z do
                table.insert(combatArea, Position(x, y, z))
            end
        end
    end
    return combatArea
end

function archangelSpell.onThink()
    local boss = Creature(bossName)
    if not boss then
        return true  
    end

    local itemID = 746
    local fromPos = {x = 31889, y = 31805, z = 9} 
    local toPos = {x = 31904, y = 31821, z = 9}  

    
    local combatArea = createCombatArea(fromPos, toPos)
    local itemPos = {x = math.random(fromPos.x, toPos.x), y = math.random(fromPos.y, toPos.y), z = fromPos.z}
    local tile = Tile(itemPos)
    if tile and tile:getItemCount() == 0 then
        local item = Game.createItem(itemID, 1, itemPos)
        if item then
            addEvent(function()
                item:remove()

                for _, pos in ipairs(combatArea) do
                    local tile = Tile(pos)
                    if tile then
                        local creatures = tile:getCreatures()
                        if creatures then
                            for _, creature in ipairs(creatures) do
                                if creature:isPlayer() then
                                    local safePos = false
                                    for _, safeTilePos in ipairs(createCombatArea(Position(itemPos.x - 1, itemPos.y - 1, itemPos.z), Position(itemPos.x + 1, itemPos.y + 1, itemPos.z))) do
                                        if pos == safeTilePos then
                                            safePos = true
                                            break
                                        end
                                    end
                                    if not safePos then
                                        creature:addHealth(-2000, -1, true, COMBAT_FIREDAMAGE)
                                    end
                                end
                            end
                        end
                        pos:sendMagicEffect(1)
                    end
                end
            end, 15000) 
        end
    end

    return true
end

archangelSpell:interval(8000) 
archangelSpell:register()
