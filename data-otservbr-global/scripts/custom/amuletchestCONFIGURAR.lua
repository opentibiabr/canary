-- Escala Relativa
-- Azar         = 400 = 40%
-- Sorte baixa  = 300 = 30%
-- Sorte média  = 200 = 20%
-- Sorte alta   = 100 = 10%
-- Sorte maxima = 030 = 3%

local rewards = {
    { id = 34158, name = "Lion Amulet", chance = 200 },              -- Sorte média
    { id = 30403, name = "Amulet of Theurgy", chance = 200 },        -- Sorte média
    { id = 30323, name = "Rainbow Necklace", chance = 300 },         -- Sorte baixa
    { id = 39233, name = "Turtle Amulet", chance = 100 },            -- Sorte alta
    { id = 30344, name = "Pendulet", chance = 200 },                 -- Sorte média
    { id = 30342, name = "Sleep Shawl", chance = 200 },              -- Sorte média
    { id = 35523, name = "Exotic Amulet", chance = 200 },            -- Sorte média
    { id = 31631, name = "The Cobra Amulet", chance = 300 },         -- Sorte baixa
    { id = 27565, name = "Foxtail Amulet", chance = 300 },           -- Sorte baixa
    { id = 7532, name = "Koshei's Ancient Amulet", chance = 400 },   -- Azar
    { id = 39180, name = "Alicorn Ring", chance = 100 },             -- Sorte alta
    { id = 39186, name = "Arboreal Ring", chance = 100 },            -- Sorte alta
    { id = 39183, name = "Arcanomancer Sigil", chance = 100 },       -- Sorte alta
    { id = 31557, name = "Blister Ring", chance = 300 },             -- Sorte baixa
    { id = 39177, name = "Spiritthorn Ring", chance = 100 },         -- Sorte alta
    { id = 3057, name = "Amulet of Loss", chance = 400 },            -- Azar
    { id = 25698, name = "Butterfly Ring", chance = 400 },           -- Azar
    { id = 32621, name = "Ring of Souls", chance = 200 },            -- Sorte média
    { id = 22768, name = "Ferumbras' Amulet", chance = 400 },        -- Azar
    { id = 11468, name = "Ornamented Brooch", chance = 400 },        -- Azar
    { id = 19357, name = "Shrunken Head Necklace", chance = 100 },   -- Sorte alta
    { id = 61143, name = "Amulet of Death", chance = 030 },          -- Sorte maxima
    { id = 61144, name = "Amulet of Fire", chance = 030 },           -- Sorte maxima  
    { id = 61145, name = "Amulet of Holy", chance = 030 },           -- Sorte maxima   
    { id = 61146, name = "Amulet of Energy", chance = 030 },         -- Sorte maxima
    { id = 61147, name = "Amulet of Earth", chance = 030 },          -- Sorte maxima
    { id = 61148, name = "Amulet of Ice", chance = 030 },            -- Sorte maxima
    { id = 61149, name = "Ring of Death", chance = 030 },            -- Sorte maxima
    { id = 61150, name = "Ring of Energy", chance = 030 },           -- Sorte maxima
    { id = 61151, name = "Ring of Holy", chance = 030 },             -- Sorte maxima
    { id = 61152, name = "Ring of Ice", chance = 030 },              -- Sorte maxima
    { id = 61153, name = "Ring of Fire", chance = 030 },             -- Sorte maxima
    { id = 61154, name = "Ring of Earth", chance = 030 },            -- Sorte maxima
}   

local falconChest = Action()
function falconChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local totalChance = 0
    for _, reward in ipairs(rewards) do
        totalChance = totalChance + reward.chance
    end

    local randChance = math.random(1, totalChance)
    local accumulatedChance = 0

    for _, reward in ipairs(rewards) do
        accumulatedChance = accumulatedChance + reward.chance
        if randChance <= accumulatedChance then
            player:addItem(reward.id, 1)
            item:remove(1)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. reward.name .. '.')
            return true
        end
    end

    return true
end

falconChest:id(61263)
falconChest:register()