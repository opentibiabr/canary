local teleportHeart = MoveEvent()

local vortexTeleports = {
    [14321] = { pos = Position(32149, 31359, 14) }, -- Charger TP 1
    [14322] = { pos = Position(32092, 31330, 12) }, -- Charger Exit
    [14324] = { pos = Position(32104, 31329, 12) }, -- Anomaly Exit
    [14325] = { pos = Position(32216, 31380, 14) }, -- Main Room
    [14340] = { pos = Position(32159, 31329, 11) }, -- Main Room Exit
    [14341] = { pos = Position(32078, 31320, 13) }, -- Cracklers Exit
    [14343] = { pos = Position(32088, 31321, 13) }, -- Rupture Exit
    [14345] = { pos = Position(32230, 31358, 11) }, -- Realityquake Exit
    [14347] = { pos = Position(32225, 31347, 11) }, -- Unstable Sparks Exit
    [14348] = { pos = Position(32218, 31375, 14) }, -- Eradicator Exit (Main Room)
    [14350] = { pos = Position(32208, 31372, 14) }, -- Outburst Exit (Main Room)
    [14352] = { pos = Position(32214, 31376, 14) }, -- World Devourer Exit (Main Room)
    [14354] = { pos = Position(32112, 31375, 14) }, -- World Devourer (Reward Room)

    [14323] = { -- Anomaly
        position = Position(32246, 31252, 14),
        storage = 14320,
        boss = "Anomaly"
    },
    [14342] = { -- Rupture
        position = Position(32305, 31249, 14),
        storage = 14322,
        boss = "Rupture"
    },
    [14344] = { -- Realityquake
        position = Position(32181, 31240, 14),
        storage = 14324,
        boss = "Realityquake"
    },

    [14346] = { -- Eradicator
        position = Position(32336, 31293, 14),
        storage1 = 14326,
        storage2 = 14327,
        storage3 = 14328,
        boss = "Eradicator"
    },
    [14349] = { -- Outburst
        position = Position(32204, 31290, 14),
        storage1 = 14326,
        storage2 = 14327,
        storage3 = 14328,
        boss = "Outburst"
    },

    [14351] = { special = "worldDevourerEnter" },
    [14353] = { special = "worldDevourerExit" }
}

function teleportHeart.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local data = vortexTeleports[item.actionid]

    if data.pos then
        player:teleportTo(data.pos)
    elseif data.storage then
        if player:getStorageValue(data.storage) >= 1 then
            if player:canFightBoss(data.boss) then
                player:teleportTo(data.position)
            else
                player:teleportTo(fromPosition)
                player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
            end
        else
            player:teleportTo(fromPosition)
            player:sendTextMessage(19, "You don't have access to this portal.")
        end
    elseif data.storage1 then
        if player:getStorageValue(data.storage1) >= 1 and
           player:getStorageValue(data.storage2) >= 1 and
           player:getStorageValue(data.storage3) >= 1 then
            if player:canFightBoss(data.boss) then
                player:teleportTo(data.position)
            else
                player:teleportTo(fromPosition)
                player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
            end
        else
            player:teleportTo(fromPosition)
            player:sendTextMessage(19, "You don't have access to this portal.")
        end
    elseif data.special == "worldDevourerEnter" then
        if player:getStorageValue(14330) >= 1 and player:getStorageValue(14332) >= 1 then
            if player:canFightBoss("World Devourer") then
                player:teleportTo(Position(32272, 31384, 14))
            else
                player:teleportTo(fromPosition)
                player:sendTextMessage(19, "It's too early for you to endure this challenge again.")
            end
        else
            player:teleportTo(fromPosition)
            player:sendTextMessage(19, "You don't have access to this portal.")
        end
    elseif data.special == "worldDevourerExit" then
        player:teleportTo(Position(32214, 31376, 14))
        player:setStorageValue(14334, -1)
        player:setStorageValue(14335, -1)
        player:setStorageValue(14336, -1)
        player:unregisterEvent("DevourerStorage")
    end
    return true
end

teleportHeart:type("stepin")

for aid in pairs(vortexTeleports) do
    teleportHeart:aid(aid)
end

teleportHeart:register()
