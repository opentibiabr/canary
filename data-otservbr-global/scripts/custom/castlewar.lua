local guilds = {}
woe = {
    eventName = "[Guild Crystal]",
    timeDelay = 0, -- minutes before event starts
    bcMsg = " is starting in ",
    doors = {
        {name = "Paredao", id = 499, pos = {x = 17191, y = 17152, z = 4} },
        {name = "Paredao", id = 499, pos = {x = 17192, y = 17152, z = 4} },
        {name = "Paredao", id = 499, pos = {x = 17199, y = 17152, z = 4} },
        {name = "Paredao", id = 499, pos = {x = 17200, y = 17152, z = 4} },
        {name = "Paredao", id = 499, pos = {x = 17194, y = 17143, z = 4} },
        {name = "Paredao", id = 499, pos = {x = 17195, y = 17143, z = 4} },
        {name = "Paredao", id = 499, pos = {x = 17196, y = 17143, z = 4} },
        {name = "Paredao", id = 499, pos = {x = 17197, y = 17143, z = 4} },
        
        {name = "Jogador de pedra", id = 499, pos = {x = 17193, y = 17143, z = 3}, },
        {name = "Jogador de pedra", id = 499, pos = {x = 17193, y = 17141, z = 3}, },
        {name = "Jogador de pedra", id = 499, pos = {x = 17193, y = 17139, z = 3}, },
        {name = "Jogador de pedra", id = 499, pos = {x = 17193, y = 17137, z = 3}, },
        {name = "Jogador de pedra", id = 499, pos = {x = 17198, y = 17137, z = 3}, },
        {name = "Jogador de pedra", id = 499, pos = {x = 17198, y = 17139, z = 3}, },
        {name = "Jogador de pedra", id = 499, pos = {x = 17198, y = 17141, z = 3}, },
        {name = "Jogador de pedra", id = 499, pos = {x = 17198, y = 17143, z = 3}, },
        
        {name = "Paredao", id = 499, pos = {x = 17194, y = 17142, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17195, y = 17142, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17196, y = 17142, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17197, y = 17142, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17203, y = 17144, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17204, y = 17144, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17205, y = 17144, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17188, y = 17144, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17187, y = 17144, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17186, y = 17144, z = 3} },

        {name = "Paredao", id = 499, pos = {x = 17194, y = 17138, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17195, y = 17138, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17196, y = 17138, z = 3} },
        {name = "Paredao", id = 499, pos = {x = 17197, y = 17138, z = 3} },
    },
    
    actionid = 33542, -- for the doors
    crystal = {id = 14770, name="Crystal", pos = {x = 17196, y = 17135, z = 2} },
    castle = {x = 32349, y = 32205, z = 7}, -- just has to be one of the housetiles of the castle
    days = {
        -- to enable a day for the globalevent do ["Weekday"] = time
        -- for example: ["Monday"] = 18:00,
        ['Monday'] = '17:28',
        ['Tuesday'] = '17:28',
        ['Wednesday'] = '17:28',
        ['Thursday'] = '17:28',
        ['Friday'] = '17:28',
        ['Saturday'] = '17:28',
        ['Sunday'] = '17:28',
    },

    queueEvent = function(x)
        x = x - 1
        if x > 0 then
            broadcastMessage(woe.eventName..woe.bcMsg..x..(x > 1 and " minutes!" or " minute!"), MESSAGE_EVENT_ADVANCE)
            addEvent(woe.queueEvent, x * 55 * 1000, x)
        else
            woe.startEvent()
        end
    end,

    startEvent = function()
        for k,v in pairs(woe.doors) do
            local item = Tile(v.pos):getItemById(v.id)
            if item ~= nil then
                Game.createMonster(v.name, v.pos, false, true)
            else
                print("WOE GATE POSITION INVALID OR MISSING [x:"..v.pos.x.." | y:"..v.pos.y.." | z:"..v.pos.z.."]")
            end
        end
        local c = woe.crystal
        local item = Tile(c.pos):getItemById(c.id)
        if item ~= nil then
            Game.createMonster(c.name, c.pos, false, true)
        else
            print("WOE CRYSTAL POSITION INVALID OR MISSING [x:"..c.pos.x.." | y:"..c.pos.y.." | z:"..c.pos.z.."]")
        end
        woe.eventtp = Game.createItem(1949, 1, Position(32365, 32234, 7))
		woe.eventtp:setDestination(Position(17197, 17171, 3))
        Game.broadcastMessage('The portal to Guild Crystal Event was opened inside Thais temple.', MESSAGE_STATUS_WARNING)
    end,

    done = false,

}

local castlewar = CreatureEvent("CastleWar")
function castlewar.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    local isGuild = false
    local damage = primaryDamage + secondaryDamage
    if woe.done then
        return
    end
    if creature and creature:getName() ~= 'Crystal' then
        return
    end

    if not attacker then
        return
    end

    if attacker:isPlayer() == false then
        if attacker:getMaster() == false then
            return
        end
        attacker = attacker:getMaster()
    end

    if attacker:getGuild() == nil then
        return
    end

    for k,v in pairs(guilds) do
        if v[1] == attacker:getGuild():getId() then
            v = {v[1], v[2] + damage}
            isGuild = true
            break
        end
    end


    if not isGuild then
        guilds[#guilds+1] = {attacker:getGuild():getId(), damage}
    end

    if creature:getHealth() - damage <= 0 then
        local createTeleport = Game.createItem(1949, 1, Position(17196, 17135, 2))
		createTeleport:setDestination(Position(32369, 32241, 7))

        table.sort(guilds, function(a,b) return a[2] > b[2] end)
        db.query("CREATE TABLE IF NOT EXISTS `castle` (`guild_id` int(11) NOT NULL, guild_name varchar(255) NOT NULL) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;")
        db.query("DELETE FROM `castle`")
        if guilds[1][1] ~= nil then
            db.asyncStoreQuery("SELECT `id`, `name`, `ownerid` FROM `guilds` WHERE `id` = " .. guilds[1][1] .. " LIMIT 1",
            function(info)
                    local id = result.getString(info, "id")
                    local name = result.getString(info, "name")
                    broadcastMessage(woe.eventName.." has ended. Congratulations to ".. name .." for claiming ownership of the castle!", MESSAGE_EVENT_ADVANCE)
                    local owner = result.getString(info, "ownerid")
                    db.query("INSERT INTO `castle` VALUES (".. id ..", '".. name .."')")
                    Tile(woe.castle):getHouse():setHouseOwner(owner)
                end
            )
        end
        guilds = {}
        for k,v in pairs(woe.doors) do
            if Creature(v.name) ~= nil then
                Creature(v.name):remove()
            end
        
        end
    end

    return primaryDamage, primaryType, -secondaryDamage, secondaryType
end
castlewar:register()


local castlewarglobal = GlobalEvent("CastleWarGlobal")

function castlewarglobal.onTime(interval)
    if os.date("%H:%M") == woe.days[os.date("%A")] then
        woe.queueEvent(woe.timeDelay+1)
    end
end

castlewarglobal:time("18:00:00")
castlewarglobal:register()

local castlewartalk = TalkAction("!woe")
function castlewartalk.onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end
    
    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end
    
    woe.queueEvent(woe.timeDelay+1)

    return false
end

castlewartalk:separator(" ")
castlewartalk:groupType("god")
castlewartalk:register()
local castlewartalk = TalkAction("!woec")
function castlewartalk.onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end
    
    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end
    
    for k,v in pairs(woe.doors) do
        if Creature(v.name) ~= nil then
            Creature(v.name):remove()
        end
    end
    Creature(woe.crystal):remove()

    return false
end

castlewartalk:separator(" ")
castlewartalk:groupType("god")
castlewartalk:register()