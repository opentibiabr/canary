local holeId = {
    294, 369, 370, 383, 392, 408, 409, 410, 427, 428, 430, 462, 469, 470, 482, 484, 485, 489, 924, 3135, 3136, 7933, 7938, 8170, 8286, 8285, 8284, 8281, 8280, 8279, 8277, 8276, 8567, 8585, 8596, 8595, 8249, 8250, 8251, 8252, 8253, 8254, 8255, 8256, 8592, 8972, 9606, 9625, 13190, 14461, 19519, 21536, 26020
}

local Itemsgrinder = {
    [7759] = {item_id = 34642, effect = CONST_ME_BLUE_FIREWORKS}, -- Sapphire dust
    [18416] = {item_id = 23876, effect = CONST_ME_GREENSMOKE} -- Pinch of crystal dust
    }

local holes = {
    468, 481, 483, 7932, 23712
}

local JUNGLE_GRASS = {
    2782, 3985, 19433
}
local WILD_GROWTH = {
    1499, 11099, 2101, 1775, 1447, 1446, 20670
}

local fruits = {
    2673, 2674, 2675, 2676, 2677, 2678, 2679, 2680, 2681, 2682, 2684, 2685, 5097, 8839, 8840, 8841
}

local lava = {
    Position(32808, 32336, 11),
    Position(32809, 32336, 11),
    Position(32810, 32336, 11),
    Position(32808, 32334, 11),
    Position(32807, 32334, 11),
    Position(32807, 32335, 11),
    Position(32807, 32336, 11),
    Position(32807, 32337, 11),
    Position(32806, 32337, 11),
    Position(32805, 32337, 11),
    Position(32805, 32338, 11),
    Position(32805, 32339, 11),
    Position(32806, 32339, 11),
    Position(32806, 32338, 11),
    Position(32807, 32338, 11),
    Position(32808, 32338, 11),
    Position(32808, 32337, 11),
    Position(32809, 32337, 11),
    Position(32810, 32337, 11),
    Position(32811, 32337, 11),
    Position(32811, 32338, 11),
    Position(32806, 32338, 11),
    Position(32810, 32338, 11),
    Position(32810, 32339, 11),
    Position(32809, 32339, 11),
    Position(32809, 32338, 11),
    Position(32811, 32336, 11),
    Position(32811, 32335, 11),
    Position(32810, 32335, 11),
    Position(32809, 32335, 11),
    Position(32808, 32335, 11),
    Position(32809, 32334, 11),
    Position(32809, 32333, 11),
    Position(32810, 32333, 11),
    Position(32811, 32333, 11),
    Position(32806, 32338, 11),
    Position(32810, 32334, 11),
    Position(32811, 32334, 11),
    Position(32812, 32334, 11),
    Position(32813, 32334, 11),
    Position(32814, 32334, 11),
    Position(32812, 32333, 11),
    Position(32810, 32334, 11),
    Position(32812, 32335, 11),
    Position(32813, 32335, 11),
    Position(32814, 32335, 11),
    Position(32814, 32333, 11),
    Position(32813, 32333, 11)
}

local function revertItem(position, itemId, transformId)
    local item = Tile(position):getItemById(itemId)
    if item then
        item:transform(transformId)
    end
end

local function removeRemains(toPosition)
    local item = Tile(toPosition):getItemById(2248)
    if item then
        item:remove()
    end
end

local function revertCask(position)
    local caskItem = Tile(position):getItemById(2249)
    if caskItem then
        caskItem:transform(5539)
        position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
    end
end

local cutItems = {
    [3794] = 3959,
    [3795] = 3959,
    [3796] = 3958,
    [3797] = 3958,
    [3798] = 3958,
    [3799] = 3958,
    [1614] = 2251,
    [1615] = 2251,
    [1616] = 2251,
    [1619] = 2251,
    [1650] = 2253,
    [1651] = 2253,
    [1652] = 2253,
    [1653] = 2253,
    [1658] = 2252,
    [1659] = 2252,
    [1660] = 2252,
    [1661] = 2252,
    [1666] = 2252,
    [1667] = 2252,
    [1668] = 2252,
    [1669] = 2252,
    [1670] = 2252,
    [1671] = 2252,
    [1672] = 2252,
    [1673] = 2252,
    [1674] = 2253,
    [1676] = 2252,
    [1677] = 2253,
    [1714] = 2251,
    [1715] = 2251,
    [1716] = 2251,
    [1724] = 2252,
    [1725] = 2252,
    [1726] = 2252,
    [1727] = 2252,
    [1728] = 2254,
    [1729] = 2254,
    [1730] = 2254,
    [1731] = 2254,
    [1732] = 2254,
    [1733] = 2254,
    [1735] = 2254,
    [1775] = 2250,
    [2034] = 2252,
    [4996] = 2252,
    [2116] = 2254,
    [2116] = 2254,
    [2117] = 2254,
    [2118] = 2254,
    [2119] = 2254,
    [6123] = 2254,
    [2080] = 2254,
    [2081] = 2254,
    [2082] = 2254,
    [2083] = 2254,
    [2084] = 2254,
    [2085] = 2254,
    [2093] = 2250,
    [2094] = 2250,
    [2095] = 2250,
    [2098] = 2250,
    [2099] = 2250,
    [2101] = 2250,
    [2106] = 2250,
    [2105] = 2250,
    [2562] = 2257,
    [2581] = 2258,
    [2582] = 2258,
    [2582] = 2258,
    [2583] = 2258,
    [3805] = 6267,
    [3806] = 6267,
    [3807] = 2252,
    [3808] = 2252,
    [3809] = 2252,
    [3810] = 2252,
    [3811] = 2255,
    [3812] = 6267,
    [3813] = 2252,
    [3814] = 2252,
    [3815] = 2252,
    [3816] = 2252,
    [3817] = 2252,
    [3818] = 2252,
    [3819] = 2252,
    [3820] = 2252,
    [3821] = 2255,
    [3832] = 2255,
    [3833] = 2255,
    [3834] = 2255,
    [3835] = 2255,
    [6356] = 2257,
    [6357] = 2257,
    [6358] = 2257,
    [6359] = 2257,
    [6360] = 2257,
    [6361] = 2257,
    [6363] = 2257,
    [6368] = 2250,
    [6369] = 2250,
    [6370] = 2250,
    [6371] = 2250,
    [1738] = 2250,
    [1739] = 2251,
    [1740] = 2250,
    [1741] = 2255,
    [1747] = 2250,
    [1748] = 2250,
    [1749] = 1750,
    [1750] = 2254,
    [1751] = 2254,
    [1752] = 2254,
    [1753] = 2254,
    [1770] = 2251,
    [1774] = 2250,
    [6085] = 2254,
    [7481] = 2251,
    [7482] = 2251,
    [7483] = 2251,
    [7484] = 2250,
    [7706] = 2251,
    [7707] = 2251,
    [1738] = 2250,
    [1739] = 2251,
    [6109] = 2254,
    [6110] = 2254,
    [6111] = 2254,
    [6112] = 2254,
    [7538] = 7544,
    [7539] = 7545,
    [7585] = 7586,
    [29087] = 0,
    [29088] = 0
}

function onDestroyItem(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or target == nil or type(target) ~= "userdata" or not target:isItem() then
        return false
    end

    if target:hasAttribute(ITEM_ATTRIBUTE_UNIQUEID) or target:hasAttribute(ITEM_ATTRIBUTE_ACTIONID) then
        return false
    end

    if toPosition.x == CONTAINER_POSITION then
        player:sendCancelMessage(Game.getReturnMessage(RETURNVALUE_NOTPOSSIBLE))
        return true
    end

    local destroyId = cutItems[target.itemid] or ItemType(target.itemid):getDestroyId()
    if destroyId == 0 then
        if target.itemid ~= 29087 and target.itemid ~= 29088 then
            return false
        end
    end

    local watt = ItemType(item.itemid):getAttack()
    if math.random(1, 80) <= (watt and watt > 10 and watt or 10) then
        -- Against The Spider Cult (Spider Eggs)
        if target.itemid == 7585 then
            local eggStorage = player:getStorageValue(Storage.TibiaTales.AgainstTheSpiderCult)
            if eggStorage >= 1 and eggStorage < 5 then
                player:setStorageValue(Storage.TibiaTales.AgainstTheSpiderCult, math.max(1, eggStorage) + 1)
            end

            Game.createMonster("Giant Spider", Position(33181, 31869, 12))
        end

        -- Move items outside the container
        if target:isContainer() then
            for i = target:getSize() - 1, 0, -1 do
                local containerItem = target:getItem(i)
                if containerItem then
                    containerItem:moveTo(toPosition)
                end
            end
        end

        -- Being better than cipsoft
        if target:getFluidType() ~= 0 then
            local fluid = Game.createItem(2016, target:getFluidType(), toPosition)
            if fluid ~= nil then
                fluid:decay()
            end
        end

        target:remove(1)

        local itemDestroy = Game.createItem(destroyId, 1, toPosition)
        if itemDestroy ~= nil then
            itemDestroy:decay()
        end

        -- Energy barrier na threatned dreams quest (feyrist)
        if target.itemid == 29087 or target.itemid == 29088 then
            addEvent(Game.createItem, math.random(13000, 17000), target.itemid, 1, toPosition)
        end
    end

    toPosition:sendMagicEffect(CONST_ME_POFF)
    return true
end

function onUseRope(player, item, fromPosition, target, toPosition, isHotkey)
    if toPosition.x == CONTAINER_POSITION then
        return false
    end

    local tile = Tile(toPosition)
    if tile:isRopeSpot() then
        player:teleportTo(toPosition:moveUpstairs())
        if target.itemid == 8592 then
            if player:getStorageValue(Storage.RookgaardTutorialIsland.tutorialHintsStorage) < 22 then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                "You have successfully used your rope to climb out of the hole. Congratulations! Now continue to the east.")
            end
        end
    elseif table.contains(holeId, target.itemid) then
        toPosition.z = toPosition.z + 1
        tile = Tile(toPosition)
        if tile then
            local thing = tile:getTopVisibleThing()
            if thing:isItem() and thing:getType():isMovable() then
                return thing:moveTo(toPosition:moveUpstairs())
            elseif thing:isCreature() and thing:isPlayer() then
                return thing:teleportTo(toPosition:moveUpstairs())
            end
        end

        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
    else
        return false
    end
    return true
end

function onUseShovel(player, item, fromPosition, target, toPosition, isHotkey)
    --Dawnport quest (Morris amulet task)
    local sandPosition = Position(32099, 31933, 7)
    if (toPosition == sandPosition) then
        local sandTile = Tile(sandPosition)
        local amuletId = sandTile:getItemById(22679)
        if amuletId then
            if player:getStorageValue(Storage.Quest.Dawnport.TheLostAmulet) == 1 then
                local rand = math.random(100)
                if rand <= 10 then
                    player:addItem(23750, 1)
                    player:setStorageValue(Storage.Quest.Dawnport.TheLostAmulet, 2)
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found an ancient amulet. Strange engravings cover it. Maybe Morris can make them out.")
                elseif rand <= 80 then
                    player:addItem(23766, 1)
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dig up sand and sea shells.")
                elseif rand > 95 then
                    player:addItem(3976, math.random(1, 10))
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dig up some worms. But you are confident that you'll find the amulet here, somewhere.")
                end
                toPosition:sendMagicEffect(CONST_ME_POFF)
            else
                return false
            end
        end
        return true
    end

    if table.contains(holes, target.itemid) then
        target:transform(target.itemid + 1)
        target:decay()
    elseif table.contains({231, 9059}, target.itemid) then
        local rand = math.random(100)
        if target.actionid == 100 and rand <= 20 then
            target:transform(489)
            target:decay()
        elseif rand == 1 then
            Game.createItem(2159, 1, toPosition)
        elseif rand > 95 then
            Game.createMonster("Scarab", toPosition)
        end
        toPosition:sendMagicEffect(CONST_ME_POFF)
    -- Rookgaard tutorial island
    elseif target.itemid == 351 and target.actionid == 8024 then
        player:addItem(12297, 1)
        player:say("You dig out a handful of earth from this sacred place.", TALKTYPE_MONSTER_SAY)
    elseif target.itemid == 8579 and player:getStorageValue(Storage.RookgaardTutorialIsland.tutorialHintsStorage) < 20 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
        "You dug a hole! Walk onto it as long as it is open to jump down into the forest cave."
        )
        player:setStorageValue(Storage.RookgaardTutorialIsland.tutorialHintsStorage, 19)
        Position(32070, 32266, 7):sendMagicEffect(CONST_ME_TUTORIALARROW)
        Position(32070, 32266, 7):sendMagicEffect(CONST_ME_TUTORIALSQUARE)
        target:transform(469)
        addEvent(revertItem, 30 * 1000, toPosition, 469, 8579)
    elseif target.actionid == 4654 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission49) == 1
    and player:getStorageValue(Storage.GravediggerOfDrefia.Mission50) < 1 then
        -- Gravedigger Quest
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found a piece of the scroll. You pocket it quickly.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:addItem(21250, 1)
        player:setStorageValue(Storage.GravediggerOfDrefia.Mission50, 1)
    elseif target.actionid == 4668 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) == 1
    and player:getStorageValue(Storage.GravediggerOfDrefia.Mission70) < 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A torn scroll piece emerges. Probably gnawed off by rats.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:addItem(21250, 1)
        player:setStorageValue(Storage.GravediggerOfDrefia.Mission70, 1)
    elseif target.actionid == 50118 then
        local wagonItem = Tile(Position(32717, 31492, 11)):getItemById(7131)
        if wagonItem then
            Game.createItem(8749, 1, wagonItem:getPosition())
            toPosition:sendMagicEffect(CONST_ME_POFF)
        end
    elseif target.itemid == 8749 then
        local coalItem = Tile(Position(32699, 31492, 11)):getItemById(8749)
        if coalItem then
            coalItem:remove(1)
            toPosition:sendMagicEffect(CONST_ME_POFF)

            local crucibleItem = Tile(Position(32699, 31494, 11)):getItemById(8642)
            if crucibleItem then
                crucibleItem:setActionId(50119)
            end
        end
    elseif table.contains({9632, 20230, 17672, 18586, 18580}, target.itemid) then
        if player:getStorageValue(Storage.SwampDiggingTimeout) >= os.time() then
            toPosition:sendMagicEffect(CONST_ME_POFF)
            return false
        end

        local config = {
            {from = 1, to = 39, itemId = 2817},
            {from = 40, to = 79, itemId = 2145},
            {from = 80, to = 100, itemId = 20138}
        }

        local chance = math.random(100)
        for i = 1, #config do
            local randItem = config[i]
            if chance >= randItem.from and chance <= randItem.to then
                player:addItem(randItem.itemId, 1)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dug up a " .. ItemType(randItem.itemId):getName() .. ".")
                player:setStorageValue(Storage.SwampDiggingTimeout, os.time() + 604800)
                toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
                break
            end
        end
    elseif target.itemid == 103 and target.actionid == 4205 then
        if player:getStorageValue(Storage.TibiaTales.IntoTheBonePit) ~= 1 then
            return false
        end

        local remains = Game.createItem(2248, 1, toPosition)
        if remains then
            remains:setActionId(4206)
        end
        toPosition:sendMagicEffect(CONST_ME_HITAREA)
        addEvent(removeRemains, 60000, toPosition)
    elseif target.itemid == 22674 then
        if not player:removeItem(5091, 1) then
            return false
        end

        target:transform(5731)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_POFF)
    else
        return false
    end
    return true
end

function onUsePick(player, item, fromPosition, target, toPosition, isHotkey)
    local stonePos = Position(32648, 32134, 10)
    if (toPosition == stonePos) then
        local tile = Tile(stonePos)
        local stone = tile:getItemById(1285)
        if stone then
            stone:remove(1)
            toPosition:sendMagicEffect(CONST_ME_POFF)
            addEvent(function()
                Game.createItem(1285, 1, stonePos)
            end, 20000)
            return true
        end
    end
	
	-- The Rookie Guard Quest - Mission 09: Rock 'n Troll
	-- Path: data\scripts\actions\quests\the_rookie_guard\mission09_rock_troll.lua
	-- Damage tunnel pillars
	if player:getStorageValue(Storage.TheRookieGuard.Mission09) ~= -1 and target.itemid == 3511 then
		return onUsePickAtTunnelPillar(player, item, fromPosition, target, toPosition)
	end
	
    --Dawnport some cracks down
    local crackPosition = Position(32099, 31930, 7)
    if (toPosition == crackPosition) then
        local tile = Tile(crackPosition)
        local crack = tile:getItemById(6299)
        if crack then
            player:teleportTo({x = 32099, y = 31930, z = 8})
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            return true
        end
    end

    if table.contains({354, 355}, target.itemid) and target.actionid == 101 then
        target:transform(392)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_POFF)
    elseif target.itemid == 11227 then
        -- shiny stone refining
        local chance = math.random(1, 100)
        if chance == 1 then
            player:addItem(2160, 1) -- 1% chance of getting crystal coin
        elseif chance <= 6 then
            player:addItem(2148, 1) -- 5% chance of getting gold coin
        elseif chance <= 51 then
            player:addItem(2152, 1) -- 45% chance of getting platinum coin
        else
            player:addItem(2145, 1) -- 49% chance of getting small diamond
        end
        target:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
        target:remove(1)
    elseif target.itemid == 11227 then
        target:remove(1)
        toPosition:sendMagicEffect(CONST_ME_POFF)
        player:addItem(2152, 10)
    elseif target.itemid == 7200 then
        target:transform(7236)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_HITAREA)
    elseif target.itemid == 468 then
        target:transform(469)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_HITAREA)
    elseif target.itemid == 6299 and target.actionid > 0 then
        target:transform(482)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_HITAREA)
    elseif target.itemid == 23712 then
        target:transform(23713)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_HITAREA)
    elseif target.itemid == 481 then
        target:transform(482)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_HITAREA)
    elseif target.itemid == 483 then
        target:transform(484)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_HITAREA)
    elseif target.itemid == 7932 then
        target:transform(7933)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_HITAREA)
    elseif target.itemid == 8634 then
        -- Sea of light quest
        if player:getStorageValue(Storage.SeaOfLight.Questline) ~= 4 then
            return false
        end

        if toPosition == Position(33031, 31758, 8) then
            if math.random(100) <= 30 then
                if player:getStorageValue(Storage.SeaOfLight.Questline) == 4 then
                    player:addItem(10614, 1)
                    player:setStorageValue(Storage.SeaOfLight.Questline, player:getStorageValue(Storage.SeaOfLight.Questline) + 1)
                    player:say("*crush*", TALKTYPE_MONSTER_SAY)
                end
            else
                player:getPosition():sendMagicEffect(CONST_ME_POFF)
            end
        end
    elseif target.itemid == 24731 then
        -- Grimvale quest
        if player:getStorageValue(Storage.Grimvale.SilverVein) < os.time() then
            local chance = math.random(1, 10)
            if chance >= 5 then
                player:sendTextMessage(
                MESSAGE_EVENT_ADVANCE,
                "Even after a thorough and frustrating \z
                search you could not find enough liquified silver in this vein to fill a flask."
                )
            elseif chance <= 4 then
                player:sendTextMessage(
                MESSAGE_EVENT_ADVANCE,
                "Carefully you gather some of the liquified \z
                silver from this vein in a small flask. You now feel strangely affected to the moon."
                )
                player:addItem(24714)
                target:transform(4475)
                addEvent(revertItem, 10 * 60 * 1000, toPosition, 4475, 24731)
            end
            player:setStorageValue(Storage.Grimvale.SilverVein, os.time() + 2 * 60)
        else
            player:sendTextMessage(
            MESSAGE_EVENT_ADVANCE,"You are still exhausted from earlier attempts. \z
                Getting liquid silver out of the mountain needs concentration and a steady hand.")
        end
    elseif target.itemid == 3621 and target.actionid == 12026 then
        --The Ice Islands Quest, Nibelor 1: Breaking the Ice
        local missionProgress = player:getStorageValue(Storage.TheIceIslands.Mission02)
        local pickAmount = player:getStorageValue(Storage.TheIceIslands.PickAmount)
        if missionProgress < 1 or pickAmount >= 3 or player:getStorageValue(Storage.TheIceIslands.Questline) ~= 3 then
            return false
        end

        player:setStorageValue(Storage.TheIceIslands.PickAmount, math.max(0, pickAmount) + 1)
        -- Questlog The Ice Islands Quest, Nibelor 1: Breaking the Ice
        player:setStorageValue(Storage.TheIceIslands.Mission02, missionProgress + 1)

        if pickAmount >= 2 then
            player:setStorageValue(Storage.TheIceIslands.Questline, 4)
            -- Questlog The Ice Islands Quest, Nibelor 1: Breaking the Ice
            player:setStorageValue(Storage.TheIceIslands.Mission02, 4)
        end

        local crackItem = Tile(toPosition):getItemById(7185)
        if crackItem then
            crackItem:transform(7186)
            addEvent(revertItem, 60 * 1000, toPosition, 7186, 7185)
        end

        local chakoyas = {"chakoya toolshaper", "chakoya tribewarden", "chakoya windcaller"}
        Game.createMonster(chakoyas[math.random(#chakoyas)], toPosition)
        toPosition:sendMagicEffect(CONST_ME_TELEPORT)
    elseif target.itemid == 1304 then
        -- The Pits of Inferno Quest
        if toPosition == Position(32808, 32334, 11) then
            for i = 1, #lava do
                Game.createItem(5815, 1, lava[i])
            end
            target:transform(2256)
            toPosition:sendMagicEffect(CONST_ME_SMOKE)
        elseif target.actionid == 50058 then
            -- naginata quest
            local stoneStorage = Game.getStorageValue(GlobalStorage.NaginataStone)
            if stoneStorage ~= 5 then
                Game.setStorageValue(GlobalStorage.NaginataStone, math.max(0, stoneStorage) + 1)
            elseif stoneStorage == 5 then
                target:remove(1)
                Game.setStorageValue(GlobalStorage.NaginataStone)
            end
            toPosition:sendMagicEffect(CONST_ME_POFF)
            doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -31, -39, CONST_ME_NONE)
        end
    elseif target.itemid == 9025 and target.actionid == 101 then
        -- The Banshee Quest
        target:transform(392)
        target:decay()
        toPosition:sendMagicEffect(CONST_ME_POFF)
    elseif target.actionid == 50090 then
        -- The Hidden City of Beregar Quest
        if player:getStorageValue(Storage.hiddenCityOfBeregar.WayToBeregar) == 1 then
            player:teleportTo(Position(32566, 31338, 10))
        end
    elseif target.actionid == 50114 then
        if Tile(Position(32617, 31513, 9)):getItemById(1027) and Tile(Position(32617, 31514, 9)):getItemById(1205) then
            local rubbleItem = Tile(Position(32619, 31514, 9)):getItemById(5709)
            if rubbleItem then
                rubbleItem:remove(1)
            end
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
            "You can't remove this pile since it's currently holding up the tunnel.")
        end
    elseif target.actionid == 50127 then
        -- Pythius The Rotten (Firewalker Boots)
        if player:getStorageValue(Storage.QuestChests.FirewalkerBoots) == 1 then
            return false
        end
        target:remove(1)

        local stoneItem = Tile(toPosition):getItemById(1304)
        if stoneItem then
            stoneItem:remove(1)
        end

        iterateArea(function(position)
            local groundItem = Tile(position):getGround()
            if groundItem and groundItem.itemid == 598 then
                groundItem:transform(5815)
            end
        end, Position(32550, 31373, 15), Position(32551, 31379, 15))

        iterateArea(function(position)
            position:sendMagicEffect(CONST_ME_POFF)
        end, Position(32551, 31374, 15), Position(32551, 31379, 15) )

        local portal = Game.createItem(1387, 1, Position(32551, 31376, 15))
        if portal then
            portal:setActionId(50126)
        end
    elseif target.actionid == 50091 then
        -- The Asure
        player:teleportTo(Position(32960, 32676, 4))
    elseif target.itemid == 12296 then
        -- Wrath of the emperor quest
        player:addItem(12295, 1)
        player:say("The cracked part of the table lets you cut out a large chunk of wood with your pick.",
            TALKTYPE_MONSTER_SAY )
    elseif target.itemid == 22671 then
        target:transform(392)
        target:decay()
    elseif target.itemid == 3706 then
        -- Jack to the Future Quest
        if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Statue) ~= 1 then
            return false
        end

        if toPosition == Position(33277, 31754, 7) then
            if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Statue) == 1 then
                target:transform(3701)
                toPosition:sendMagicEffect(CONST_ME_POFF)
                player:addItem(11343, 1)
                player:setStorageValue(Storage.TibiaTales.JackFutureQuest.Statue, 2)
                player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) + 1)
                addEvent(revertItem, 2 * 60 * 1000, {x = 33277, y = 31754, z = 7}, 3701, 3706)
            end
        end
    else
        return false
    end
    if (target ~= nil) and target:isItem() and (target:getId() == 22469) then
        --Lower Roshamuul
        if math.random(100) > 50 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Crushing the stone produces some fine gravel.")
            target:transform(22467)
            target:decay()
        else
            Game.createMonster("Frazzlemaw", toPosition)
            player:sendTextMessage(
            MESSAGE_EVENT_ADVANCE,
            "Crushing the stone yields nothing but slightly finer, yet still unusable rubber."
            )
            target:transform(22468)
            target:decay()
        end
        return true
    end
    return true
end

function onUseMachete(player, item, fromPosition, target, toPosition, isHotkey)
    if table.contains(JUNGLE_GRASS, target.itemid) then
        target:transform(target.itemid == 19433 and 19431 or target.itemid - 1)
        target:decay()
        return true
    end

    if table.contains(WILD_GROWTH, target.itemid) then
        toPosition:sendMagicEffect(CONST_ME_POFF)
        target:remove()
        return true
    end

    return onDestroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end

function onUseCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
    if not table.contains({2416, 10515}, item.itemid) then
        return false
    end

    if target.uid == 3071 then
        -- In service of yalahar quest
        if player:getStorageValue(Storage.InServiceofYalahar.SewerPipe01) < 1 then
            doSetMonsterOutfit(player, "skeleton", 3 * 1000)
            fromPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
            player:setStorageValue(Storage.InServiceofYalahar.SewerPipe01, 1)
            -- StorageValue for Questlog "Mission 01: Something Rotten"
            player:setStorageValue(Storage.InServiceofYalahar.Mission01,
                    player:getStorageValue(Storage.InServiceofYalahar.Mission01) + 1)
            local position = player:getPosition()
            for x = -1, 1 do
                for y = -1, 1 do
                    position = position + Position(x, y, 0)
                    position:sendMagicEffect(CONST_ME_YELLOWENERGY)
                end
            end
        end
    elseif target.uid == 3072 then
        if player:getStorageValue(Storage.InServiceofYalahar.SewerPipe02) < 1 then
            player:setStorageValue(Storage.InServiceofYalahar.SewerPipe02, 1)
            -- StorageValue for Questlog "Mission 01: Something Rotten"
            player:setStorageValue(Storage.InServiceofYalahar.Mission01,
                    player:getStorageValue(Storage.InServiceofYalahar.Mission01) + 1)
            local position = player:getPosition()
            for x = -1, 1 do
                for y = -1, 1 do
                    if math.random(2) == 2 then
                        position = position + Position(x, y, 0)
                        Game.createMonster("rat", position)
                        position:sendMagicEffect(CONST_ME_TELEPORT)
                    end
                end
            end
        end
    elseif target.uid == 3073 then
        if player:getStorageValue(Storage.InServiceofYalahar.SewerPipe03) < 1 then
            player:say("You have used the crowbar on a grate.", TALKTYPE_MONSTER_SAY)
            player:setStorageValue(Storage.InServiceofYalahar.SewerPipe03, 1)
            -- StorageValue for Questlog "Mission 01: Something Rotten"
            player:setStorageValue(Storage.InServiceofYalahar.Mission01,
                    player:getStorageValue(Storage.InServiceofYalahar.Mission01) + 1)
        end
    elseif target.uid == 3074 then
        if player:getStorageValue(Storage.InServiceofYalahar.SewerPipe04) < 1 then
            doSetMonsterOutfit(player, "bog raider", 5 * 1000)
            player:say("You have used the crowbar on a knot.", TALKTYPE_MONSTER_SAY)
            player:setStorageValue(Storage.InServiceofYalahar.SewerPipe04, 1)
            -- StorageValue for Questlog "Mission 01: Something Rotten"
            player:setStorageValue(Storage.InServiceofYalahar.Mission01,
                    player:getStorageValue(Storage.InServiceofYalahar.Mission01) + 1)
        end
    elseif target.actionid == 100 then
        if target.itemid == 2593 then
            -- Postman quest
            if player:getStorageValue(Storage.Postman.Mission02) == 1 then
                player:setStorageValue(Storage.Postman.Mission02, 2)
                toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
            end
        elseif target.itemid == 5539 then
            -- The ape city - mission 7
            local apeCityStorage = player:getStorageValue(Storage.TheApeCity.Casks)
            if apeCityStorage < 3 then
                player:setStorageValue(Storage.TheApeCity.Casks, math.max(0, apeCityStorage) + 1)
                target:transform(2249)
                toPosition:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
                addEvent(revertCask, 3 * 60 * 1000, toPosition)
            end
        end
    elseif target.actionid == 12566 and player:getStorageValue(Storage.secretService.TBIMission06) == 1 then
        -- Secret service quest
        local yellPosition = Position(32204, 31157, 8)
        -- Amazon lookType
        if player:getOutfit().lookType == 137 then
            player:setStorageValue(Storage.secretService.TBIMission06, 2)
            Game.createMonster("barbarian skullhunter", yellPosition)
            player:say("Nooooo! What have you done??", TALKTYPE_MONSTER_SAY, false, 0, yellPosition)
            yellPosition.y = yellPosition.y - 1
            Game.createMonster("barbarian skullhunter", yellPosition)
        end
    else
        return false
    end
    return true
end

function onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
    if target.itemid == 388 then
        --The ice islands quest
        if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
            if player:getStorageValue(Storage.TheIceIslands.SulphurLava) < 1 then
                -- Fine sulphur
                player:addItem(7247, 1)
                player:setStorageValue(Storage.TheIceIslands.SulphurLava, 1)
                toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
                player:say("You retrive a fine sulphur from a lava hole.", TALKTYPE_MONSTER_SAY)
            end
        end
    elseif target.itemid == 4184 then
        --The ice islands quest
        if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
            if player:getStorageValue(Storage.TheIceIslands.SporesMushroom) < 1 then
                player:addItem(7251, 1)
                player:setStorageValue(Storage.TheIceIslands.SporesMushroom, 1)
                toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
                player:say("You retrive spores from a mushroom.", TALKTYPE_MONSTER_SAY)
            end
        end
    elseif target.itemid == 8573 or target.itemid == 388 then
        -- What a foolish quest - mission 8 (sulphur)
        if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) ~= 21
                or player:getStorageValue(Storage.WhatAFoolishQuest.InflammableSulphur) == 1 then
            return false
        end

        player:setStorageValue(Storage.WhatAFoolishQuest.InflammableSulphur, 1)
        -- Easily inflammable sulphur
        player:addItem(8204, 1)
        toPosition:sendMagicEffect(CONST_ME_YELLOW_RINGS)
    else
        return false
    end
    return true
end

function onUseScythe(player, item, fromPosition, target, toPosition, isHotkey)
    if not table.contains({2550, 10513}, item.itemid) then
        return false
    end

    if target.itemid == 5465 then
        target:transform(5464)
        target:decay()
        Game.createItem(5467, 1, toPosition)
    elseif target.itemid == 2739 then
        target:transform(2737)
        target:decay()
        Game.createItem(2694, 1, toPosition)
    -- The secret library
    elseif toPosition == Position(32177, 31925, 7) then
        player:teleportTo({x = 32515, y = 32535, z = 12})
    else
        return false
    end
    return onDestroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end

function onUseKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey)
    if not table.contains({2566, 10511, 10515}, item.itemid) then
        return false
    end

    -- The ice islands quest
    if target.itemid == 7261 then
        if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
            if player:getStorageValue(Storage.TheIceIslands.FrostbiteHerb) < 1 then
                player:addItem(7248, 1)
                player:setStorageValue(Storage.TheIceIslands.FrostbiteHerb, 1)
                toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
                player:say("You cut a leaf from a frostbite herb.", TALKTYPE_MONSTER_SAY)
            end
        end
    elseif target.itemid == 2733 then
        if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
            if player:getStorageValue(Storage.TheIceIslands.FlowerCactus) < 1 then
                player:addItem(7245, 1)
                player:setStorageValue(Storage.TheIceIslands.FlowerCactus, 1)
                target:transform(2723)
                addEvent(revertItem, 60 * 1000, toPosition, 2723, 2733)
                toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
                player:say("You cut a flower from a cactus.", TALKTYPE_MONSTER_SAY)
            end
        end
    elseif target.itemid == 4017 then
        if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
            if player:getStorageValue(Storage.TheIceIslands.FlowerBush) < 1 then
                player:addItem(7249, 1)
                player:setStorageValue(Storage.TheIceIslands.FlowerBush, 1)
                target:transform(4014)
                addEvent(revertItem, 60 * 1000, toPosition, 4014, 4017)
                toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
                player:say("You cut a flower from a bush.", TALKTYPE_MONSTER_SAY)
            end
        end
        -- What a foolish Quest (Mission 1)
    elseif target.actionid == 4200 then
        if toPosition.x == 32349 and toPosition.y == 32361 and toPosition.z == 7 then
            player:addItem(7476, 1)
            player:say(
            "The stubborn flower has ruined your knife but at least you got it.",
            TALKTYPE_MONSTER_SAY, false, player, toPosition)
            item:remove(1)
        else
            player:say("This flower is too pathetic.", TALKTYPE_MONSTER_SAY, false, player, toPosition)
        end
        -- What a foolish quest (mission 5)
    elseif target.itemid == 7480 then
        if player:getStorageValue(Storage.WhatAFoolishQuest.EmperorBeardShave) == 1 then
            player:say("God shave the emperor. Some fool already did it.", TALKTYPE_MONSTER_SAY)
            return true
        end

        player:setStorageValue(Storage.WhatAFoolishQuest.EmperorBeardShave, 1)
        player:say("This is probably the most foolish thing you've ever done!", TALKTYPE_MONSTER_SAY)
        player:addItem(7479, 1)
        Game.createMonster("dwarf guard", Position(32656, 31853, 13))
        -- What a foolish quest (mission 8)
    elseif target.itemid == 4008 then
        if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) ~= 22 or
        player:getStorageValue(Storage.WhatAFoolishQuest.SpecialLeaves) == 1 then
            return false
        end

        player:setStorageValue(Storage.WhatAFoolishQuest.SpecialLeaves, 1)
        player:addItem(8109, 1)
        toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
    elseif table.contains(fruits, target.itemid) and player:removeItem(6278, 1) then
        target:remove(1)
        player:addItem(6279, 1)
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    else
        return false
    end
    return true
end

function onGrindItem(player, item, fromPosition, target, toPosition)
	if not(target.itemid == 23942) then
		return false
	end
	for index, value in pairs(Itemsgrinder) do
		if item.itemid == index then 
			local topParent = item:getTopParent()
			if topParent.isItem and (not topParent:isItem() or topParent.itemid ~= 460) then
				local parent = item:getParent()
				if not parent:isTile() and (parent:addItem(value.item_id, 1) or topParent:addItem(value.item_id, 1)) then
					item:remove(1)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You grind a " .. ItemType(index):getName() .. " into fine, " .. ItemType(value.item_id):getName() .. ".")
					doSendMagicEffect(target:getPosition(), value.effect)
					return true
				else
					Game.createItem(value.item_id, 1, item:getPosition())
				end
			else
				Game.createItem(value.item_id, 1, item:getPosition())
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You grind a " .. ItemType(index):getName() .. " into fine, " .. ItemType(value.item_id):getName() .. ".")
			item:remove(1)
			doSendMagicEffect(target:getPosition(), value.effect)
			return
		end
	end
end