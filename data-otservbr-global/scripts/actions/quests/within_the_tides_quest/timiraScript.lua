local centerRoom = Position(33815, 32704, 9)

local clearEsquerdo = Position(33807, 32695, 9)
local clearDireito = Position(33825, 32712, 9)


local t = {
    players = { 
        [1] = Position(33809, 32702, 8),
        [2] = Position(33808, 32702, 8),
        [3] = Position(33807, 32702, 8),
        [4] = Position(33806, 32702, 8),
        [5] = Position(33805, 32702, 8)
    },
    
    boss = {name = "Timira The Many-Headed", create_pos = Position(33815, 32704, 9)},  
    destination = Position(33810, 32704, 9), 
    
    cooldown = {20, "hour"},
    
    storageEvent = Storage.Quest.U12_90.WithinTheTides.Bosses.TimiraTheManyHeadedKilled,
    storage = Storage.Quest.U12_90.WithinTheTides.Bosses.TimiraTheManyHeadedTimer
}


local timiraScript = Action()
function timiraScript.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local players, tab = {}, t.players
    for i = 1, #tab do
        local tile = Tile(tab[i])
        if tile then
            local p = Player(tile:getTopCreature())
            if p then
                if p:getStorageValue(t.storage) <= os.time() then
                    players[#players + 1] = p:getId()
                end
            end
        end
    end
	local specs, spec = Game.getSpectators(centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with boss.")
				return true
			end
	end
    if #players == 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "None of the players did not wait 20 hours to go again.")
        return true
    end
    for i = 1, #tab do
        local playerTile = Tile(tab[i])
        local playerToGo = Player(playerTile:getTopCreature())
        if playerToGo then
            if isInArray(players, playerToGo:getId()) then
			addEvent(clearRoom, 0,centerRoom, clearEsquerdo, clearDireito, t.storageEvent)
                playerToGo:setStorageValue(t.storage, os.time() + 72000)
                playerTile:relocateTo(t.destination)
                tab[i]:sendMagicEffect(CONST_ME_POFF)
            end
        end
    end
	player:setStorageValue(storageEvent, 1)
		addEvent(function()
			Game.createMonster(t.boss.name, t.boss.create_pos)
        end, 1000)
    t.destination:sendMagicEffect(CONST_ME_TELEPORT)
    
    -- item:transform(item.itemid == 8911 and 8912 or 8911)
    return true
end

function mathtime(table)
local unit = {"sec", "min", "hour", "day"}
for i, v in pairs(unit) do
if v == table[2] then
return table[1]*(60^(v == unit[4] and 2 or i-1))*(v == unit[4] and 24 or 1)
end
end
return error("Bad declaration in mathtime function.")
end

function getStrTime(table)
local unit = {["sec"] = "second",["min"] = "minute",["hour"] = "hour",["day"] = "day"}
return tostring(table[1].." "..unit[table[2]]..(table[1] > 1 and "s" or ""))
end
	
timiraScript:position({x = 33810, y = 32702, z = 8})
timiraScript:register()

