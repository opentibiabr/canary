--first team
TEAM_BATTLE_A = {
    name = 'Blue',
    color = 87,
    position = Position(32548, 33758, 7),
}
--second team               
TEAM_BATTLE_B = {
    name = 'Red',
    color = 94,
    position = Position(32631, 33758, 7),
}

local CONDITION_TEAM_A_MALE = Condition(CONDITION_OUTFIT)
CONDITION_TEAM_A_MALE:setParameter(CONDITION_PARAM_TICKS, -1)
CONDITION_TEAM_A_MALE:setOutfit({lookType = 1187, lookFeet = TEAM_BATTLE_A.color, lookLegs = TEAM_BATTLE_A.color, lookHead = TEAM_BATTLE_A.color, lookAddons = 3})

local CONDITION_TEAM_A_FEMALE = Condition(CONDITION_OUTFIT)
CONDITION_TEAM_A_FEMALE:setParameter(CONDITION_PARAM_TICKS, -1)
CONDITION_TEAM_A_FEMALE:setOutfit({lookType = 1186, lookFeet = TEAM_BATTLE_A.color, lookLegs = TEAM_BATTLE_A.color, lookHead = TEAM_BATTLE_A.color, lookAddons = 3})

local CONDITION_TEAM_B_MALE = Condition(CONDITION_OUTFIT)
CONDITION_TEAM_B_MALE:setParameter(CONDITION_PARAM_TICKS, -1)
CONDITION_TEAM_B_MALE:setOutfit({lookType = 1187, lookFeet = TEAM_BATTLE_B.color, lookLegs = TEAM_BATTLE_B.color, lookHead = TEAM_BATTLE_B.color, lookAddons = 3})

local CONDITION_TEAM_B_FEMALE = Condition(CONDITION_OUTFIT)
CONDITION_TEAM_B_FEMALE:setParameter(CONDITION_PARAM_TICKS, -1)
CONDITION_TEAM_B_FEMALE:setOutfit({lookType = 1186, lookFeet = TEAM_BATTLE_B.color, lookLegs = TEAM_BATTLE_B.color, lookHead = TEAM_BATTLE_B.color, lookAddons = 3})

function getIndex(array, v)
    for index, value in ipairs(array) do
        if v == value then
            return index
        end
    end
end

function table.clone(t)
    local t_type = type(t)
    local copy
    if t_type == 'table' then
        copy = {}
        for t_key, t_value in pairs(t) do
            copy[t_key] = t_value
        end
    else -- number, string, boolean, etc
        copy = t
    end
    return copy
end

function getTeamLevel(t)
    local v = 0
    for _, player in ipairs(t) do
        v = v + player:getLevel()
    end
    return v
end

-->[[ 
--> CONSTANTS 
--<]]
team_battle = {
    --minutes to begin event
        start_time = 2,
    --minutes to finish event
        finish_time = 10,

    --min players required for event
        min_players = 2,
    --max players allowed in event
        max_players = 500,

    --delay in minutes to broadcast event stats
        event_info = 3,
    --mininum level of player
        player_level = 10,
    --reward for winner team
        reward = {37317, 3},
    --Block players with same IP in event? [false = allow, true = don't allow]
        ip_check = false,
-->[[ 
    --> STORAGES & DATA
--<]]   
    --event's stat globalstorage
        status = 60004,
    --team a's score globalstorage
        team_a_frags = 60005,
    --team b's score globalstorage
        team_b_frags = 60006,
    --team a players
        team_a = {},
    --team b players
        team_b = {},
    --player's storages
        stor_team = 60007,
-->[[ 
    --> STRINGS (do not alter %d or %s)
--<]] 
        msg_call = 'Team Battle will begin in %s! Write "!teambattle" to join the event.',
        msg_join = '[Team Battle] %s has joined the event.',
        msg_cancel = 'Team Battle was canceled for insufficient players.',
        msg_begin = 'Team Battle has started!',
        msg_finish = 'Team Battle will finish in %d minutes...',
        msg_win = 'Team Battle has finished and team %s is the winner with %d frags! [' .. TEAM_BATTLE_A.name .. ': %d - ' .. TEAM_BATTLE_B.name .. ': %d] A tibia coin voucher has been added to the players of winner team.',
        msg_draw = 'Team Battle has ended with a draw! Both teams scored %s frags...',
        msg_kill = '[Team Battle] %s killed %s. [' .. TEAM_BATTLE_A.name .. ': %d - ' .. TEAM_BATTLE_B.name .. ': %d]',
        msg_stat = '[Team Battle] [' .. TEAM_BATTLE_A.name .. ': %d - ' .. TEAM_BATTLE_B.name .. ': %d].',
        msg_defeat = '[Team Battle] %s.',
        msg_bonus = '[Team Battle] You have been awarded with x%d %s.',
-->[[ 
    --> POSITIONS (map wait_room with PZ+NO-LOGOUT, arena with PVP+NO-LOGOUT)
--<]]
        wait_room = {from = Position(32550, 33661, 7), to = Position(32619, 33719, 7)},
        arena = {from = Position(32532, 33719, 7), to = Position(32647, 33798, 7)},
-->[[ 
    --> FUNCTIONS
--<]]           
        isEnemy = function (player, attacker)
            local enemy = attacker
            if not attacker:isPlayer() then
                return false
            end

            blue = team_battle.team_a[player:getName()]
            red = team_battle.team_b[player:getName()]
            if blue ~= nil then
                red = team_battle.team_b[attacker:getName()]
            elseif red ~= nil then
                blue = team_battle.team_b[attacker:getName()]
            end

            if (enemy:getMaster() ~= nil) and (enemy:getMaster():isPlayer() ~= nil) then
                enemy = enemy:getMaster()
            end
            
            --return player:getOutfit().lookFeet ~= enemy:getOutfit().lookFeet        
            return blue ~= red
        end,

        broadcast = function (msg, type)
            for x = team_battle.arena.from.x, team_battle.arena.to.x do
                for y = team_battle.arena.from.y, team_battle.arena.to.y do
                    local tile = Tile(Position(x, y, team_battle.arena.from.z))
                    if tile then
                        local creatures = tile:getCreatures()
                        for _, creature in ipairs(creatures) do
                            if creature:isPlayer() then
                                creature:sendPrivateMessage(creature, msg, type)
                            end
                        end
                    end
                end
            end
        end,

        getData = function (player, data)
            local key = {
                ['team'] = team_battle.stor_team
            }
            return player:getStorageValue(key[data])
        end,
                               
        hasDuplicateIP = function (player1)
            for _, player2 in ipairs(Game.getPlayers()) do
                if player2:getPosition():isInRange(team_battle.wait_room.from, team_battle.wait_room.to) then
                    if player1:getIp() == player2:getIp() then
                        return true
                    elseif player2:getIp() == 0 then
                        player2:remove()
                    end
                end
            end
            return false
        end,
                    
        getTeamInArena = function (t)
            local count = 0
            for _, player in ipairs(Game.getPlayers()) do
                if player:getPosition():isInRange(team_battle.arena.from, team_battle.arena.to) and (team_battle.getData(player, 'team') == t) then
                    count = count + 1
                end
            end
            return count        
        end,
        
        setOutfit = function (player, team)
            local condition = {
                {[0] = CONDITION_TEAM_A_FEMALE, [1] = CONDITION_TEAM_A_MALE},
                {[0] = CONDITION_TEAM_B_FEMALE, [1] = CONDITION_TEAM_B_MALE}
            }
            player:addCondition(condition[team][player:getSex()], true)
        end,
        
        setTeams = function ()
            local players = {}            
            for _, player in ipairs(Game.getPlayers()) do
                if player:getPosition():isInRange(team_battle.wait_room.from, team_battle.wait_room.to) then
                    table.insert(players, player)
                end
               end

               local size = math.floor(#players/2)
            local team_battle_a, team_battle_b = {}, {}
               for i = 1, 100 do
                math.randomseed(i)               		
                team_battle_a, team_battle_b = {}, {}
                local _players = table.clone(players)
                repeat
                    local v = _players[math.random(#_players)]
                    table.insert(#team_battle_a < size and team_battle_a or team_battle_b, v)
                    table.remove(_players, getIndex(_players, v))
                until #_players == 0
                if math.abs(getTeamLevel(team_battle_a) - getTeamLevel(team_battle_b)) < 100 then
                    break
                end               		
               end

               for _, player in ipairs(team_battle_a) do                
                team_battle.setOutfit(player, 1)
                player:setStorageValue(team_battle.stor_team, 1)
                team_battle.register(player)
                team_battle.team_a[player:getName()] = {}
               end
               for _, player in ipairs(team_battle_b) do                
                team_battle.setOutfit(player, 2)
                player:setStorageValue(team_battle.stor_team, 2)
                team_battle.register(player)
                team_battle.team_b[player:getName()] = {}
               end
        end,
        
        teleport = function (player, from, to)
            local oldPosArena = player:getPosition()
            local newPosArena = Position(math.random(from.x, to.x), math.random(from.y, to.y), from.z)
            position = player:getClosestFreePosition(newPosArena, false)
            player:teleportTo(position)
            oldPosArena:sendMagicEffect(CONST_ME_POFF)
			position:sendMagicEffect(CONST_ME_TELEPORT)
        end,

        teleportA = function (player, to)
            player:teleportTo(to)
        end,

        teleportB = function (player, to)
            player:teleportTo(to)
        end,
                                           
        heal = function (player)
            player:addHealth(player:getMaxHealth())
            player:addMana(player:getMaxMana())
            local condition = 1
            player:removeCondition(condition)
            for n = 1, 27 do
                condition = condition * 2
                if condition ~= 64 then
                    player:removeCondition(condition)
                end
            end
        end,
        
        onEnd = function (player)
            team_battle.heal(player)
            player:removeCondition(CONDITION_OUTFIT)
            team_battle.unregister(player)
            player:teleportTo(player:getTown():getTemplePosition())
            --player:remove()
        end,
                                
        sendLongMessage = function (array, type, init)
            local strings, i, position, added = {""}, 1, 1, false
            for index = 1, #array do
                if(added) then
                    if(i > (position * 10)) then
                        strings[position] = strings[position] .. ","
                        position = position + 1
                        strings[position] = ""
                    else
                        strings[position] = i == 1 and "" or strings[position] .. ", "
                    end
                end
                strings[position] = strings[position] .. array[index]
                i = i + 1
                added = true
            end
            for i, str in ipairs(strings) do
                if(str:sub(str:len()) ~= ",") then
                    str = str .. "."
                end
                team_battle.broadcast((init and i == 1) and (init .. str) or str, type)
            end
        end,
                        
        info_event = function ()
            if getGlobalStorageValue(team_battle.status) == 1 then
                local msg = team_battle.msg_stat:format(getGlobalStorageValue(team_battle.team_a_frags), getGlobalStorageValue(team_battle.team_b_frags))
                team_battle.broadcast(msg, TALKTYPE_BROADCAST)
                addEvent(team_battle.info_event, team_battle.event_info*60*1000)  
            end
        end,

        getTeamPlayers = function (t)
            local list = {}
            for _, player in ipairs(Game.getPlayers()) do
                if team_battle.getData(player, 'team') == t then
                    table.insert(list, player:getName())
                end
            end
            return list
        end,
                    
        register = function (player)
            player:registerEvent('teambattle_stats')
            player:registerEvent('teambattle_death')
        end,
        
        unregister = function (player)
            player:unregisterEvent('teambattle_stats')
            player:unregisterEvent('teambattle_death')
            player:setStorageValue(team_battle.stor_team, -1)
        end,
                        
        cancel = function ()
            setGlobalStorageValue(team_battle.status, -1)
            for _, player in ipairs(Game.getPlayers()) do
                if player:getPosition():isInRange(team_battle.wait_room.from, team_battle.wait_room.to) then
                    player:teleportTo(player:getTown():getTemplePosition())
                end
            end     
        end,
        
        finish = function ()
            if getGlobalStorageValue(team_battle.status) == 1 then
                if getGlobalStorageValue(team_battle.team_a_frags) > getGlobalStorageValue(team_battle.team_b_frags) then
                    team_battle.broadcast(team_battle.msg_win:format(TEAM_BATTLE_A.name, getGlobalStorageValue(team_battle.team_a_frags), getGlobalStorageValue(team_battle.team_a_frags), getGlobalStorageValue(team_battle.team_b_frags)), TALKTYPE_BROADCAST)
                    for k, v in pairs(team_battle.team_a) do
                        local player = Player(k)
                        if player ~= nil then
                            player:addItem(team_battle.reward[1], team_battle.reward[2])
                            player:sendPrivateMessage(player, team_battle.msg_bonus:format(team_battle.reward[2],ItemType(team_battle.reward[1]):getName()), TALKTYPE_BROADCAST)
                            team_battle.team_a[k] = nil
                        else
                            team_battle.team_a[k] = {team_battle.reward[1], team_battle.reward[2]}
                        end
                    end
                elseif getGlobalStorageValue(team_battle.team_b_frags) > getGlobalStorageValue(team_battle.team_a_frags) then
                    team_battle.broadcast(team_battle.msg_win:format(TEAM_BATTLE_B.name, getGlobalStorageValue(team_battle.team_b_frags), getGlobalStorageValue(team_battle.team_a_frags), getGlobalStorageValue(team_battle.team_b_frags)), TALKTYPE_BROADCAST)
                    for k, v in pairs(team_battle.team_b) do
                        local player = Player(k)
                        if player ~= nil then
                            player:addItem(team_battle.reward[1], team_battle.reward[2])
                            player:sendPrivateMessage(player, team_battle.msg_bonus:format(team_battle.reward[2],ItemType(team_battle.reward[1]):getName()), TALKTYPE_BROADCAST)
                            team_battle.team_b[k] = nil
                        else
                            team_battle.team_b[k] = {team_battle.reward[1], team_battle.reward[2]}
                        end
                    end
                elseif getGlobalStorageValue(team_battle.team_a_frags) == getGlobalStorageValue(team_battle.team_b_frags) then
                    team_battle.broadcast(team_battle.msg_draw:format(getGlobalStorageValue(team_battle.team_a_frags)), TALKTYPE_BROADCAST)
                end
                setGlobalStorageValue(team_battle.status, -1)
                setGlobalStorageValue(team_battle.team_a_frags, -1)
                setGlobalStorageValue(team_battle.team_b_frags, -1)           
                for _, player in ipairs(Game.getPlayers()) do
                    if team_battle.getData(player, 'team') > 0 then
                        team_battle.onEnd(player)
                    end
                end                     
            end
        end,
        
        start = function ()
            if getGlobalStorageValue(team_battle.status) == 0 then
                local count = 0
                for i, player in ipairs(Game.getPlayers()) do
                    if player:getPosition():isInRange(team_battle.wait_room.from, team_battle.wait_room.to) then
                        count = count + 1
                    end
                end
                if count < team_battle.min_players then
                    team_battle.cancel()
                    return broadcastMessage(team_battle.msg_cancel, MESSAGE_EVENT_ADVANCE)
                end
                team_battle.team_a = {}
                team_battle.team_b = {}
                team_battle.setTeams()
                team_battle.broadcast(team_battle.msg_begin, TALKTYPE_BROADCAST)
                team_battle.sendLongMessage(team_battle.getTeamPlayers(1), TALKTYPE_BROADCAST, '[Team ' .. TEAM_BATTLE_A.name .. ' Players] ')
                team_battle.sendLongMessage(team_battle.getTeamPlayers(2), TALKTYPE_BROADCAST, '[Team ' .. TEAM_BATTLE_B.name .. ' Players] ')
                setGlobalStorageValue(team_battle.status, 1)
                setGlobalStorageValue(team_battle.team_a_frags, 0)
                setGlobalStorageValue(team_battle.team_b_frags, 0)
                broadcastMessage(team_battle.msg_begin, MESSAGE_EVENT_ADVANCE)
                addEvent(team_battle.info_event, team_battle.event_info*60*1000)
                for _, player in ipairs(Game.getPlayers()) do
                    if team_battle.getData(player, 'team') > 0 then
                        if team_battle.getData(player, 'team') == 1 then
                            team_battle.teleportA(player, TEAM_BATTLE_A.position)
                        else
                            team_battle.teleportB(player, TEAM_BATTLE_B.position)
                        end
                        player:say('Go!', TALKTYPE_MONSTER_YELL)
                    end
                end
                addEvent(team_battle.finish, team_battle.finish_time*60*1000)
                addEvent(team_battle.broadcast, (team_battle.finish_time-2)*60*1000, team_battle.msg_finish:format(2), TALKTYPE_BROADCAST)
            end
        end,
    }

function Position:isInRange(fromPosition, toPosition)
return ((self.x >= fromPosition.x and self.y >= fromPosition.y and self.z <= fromPosition.z
    and self.x <= toPosition.x and self.y <= toPosition.y and self.z >= toPosition.z) 
    or (self.x >= fromPosition.x and self.y >= fromPosition.y and self.z <= 6
    and self.x <= toPosition.x and self.y <= toPosition.y and self.z >= 6))
end