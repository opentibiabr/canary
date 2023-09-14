local centerRoom = Position(32498, 31124, 15)

local clearEsquerdo = Position(32489, 31117, 15)
local clearDireito = Position(32507, 31133, 15)



local t = {
    players = { 
        [1] = Position(32530, 31122, 15),
        [2] = Position(32531, 31122, 15),
        [3] = Position(32532, 31122, 15),
        [4] = Position(32533, 31122, 15),
        [5] = Position(32534, 31122, 15)

    },
    
    boss = {name = "the brainstealer", create_pos = Position(32498, 31124, 15)},
  
    destination = Position(32498, 31128, 15), 
    
    cooldown = {20, "hour"}, 
    
    storageEvent = Storage.Quest.U12_70.TooHotToHandle.TheBrainstealerKilled,
    storage = Storage.Quest.U12_70.TooHotToHandle.TheBrainstealer
}
local the_brainstealer_lever = Action()
function the_brainstealer_lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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
	local specs, spec = Game.getSpectators(centerRoom, false, false, 30, 30, 30, 30)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with boss.")
				return true
			end
	end
    if #players == 0 then
        player:sendCancelMessage("None of the players did not wait " .. getStrTime(t.cooldown) .. " to go again.")
        return true
    end
    for i = 1, #tab do
        local playerTile = Tile(tab[i])
        local playerToGo = Player(playerTile:getTopCreature())
        if playerToGo then
            if isInArray(players, playerToGo:getId()) then
			addEvent(clearRoom, 0,centerRoom, clearEsquerdo, clearDireito, t.storageEvent)
                playerToGo:setStorageValue(t.storage, mathtime(t.cooldown) + os.time())
                playerTile:relocateTo(t.destination)
                tab[i]:sendMagicEffect(CONST_ME_POFF)
            end
        end
    end
	
		addEvent(function()
			Game.createMonster(t.boss.name, t.boss.create_pos)
        end, 1000)
    t.destination:sendMagicEffect(CONST_ME_TELEPORT)
    

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

the_brainstealer_lever:aid(49611)
the_brainstealer_lever:register()
