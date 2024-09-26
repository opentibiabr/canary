local internalNpcName = "Addoner"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 115,
	lookBody = 39,
	lookLegs = 96,
	lookFeet = 118,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Come see my Addons bro!'}
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

addoninfo = { ---cost = costo en dinero, items= items que pedira el npc, puntosBuff= cantidad de puntos que daras en mision
    ['first citizen addon'] = {cost = 0, items = {{5878,100}}, outfit_female = 136, outfit_male = 128, addon = 1, storageID = Storage.OutfitQuest.Citizen.AddonBackpack, puntosBuff = 10},
    ['second citizen addon'] = {cost = 0, items = {{5890,50}, {5902,25}, {3374,1}}, outfit_female = 136, outfit_male = 128, addon = 2, storageID = Storage.OutfitQuest.Citizen.AddonHat, puntosBuff = 10},
    ['first hunter addon'] = {cost = 0, items = {{5876,100}, {5948,100}, {5891,5}, {5887,1}, {5889,1}, {5888,1}}, outfit_female = 137, outfit_male = 129, addon = 1, storageID = Storage.OutfitQuest.Hunter.AddonHat, puntosBuff = 15},
    ['second hunter addon'] = {cost = 0, items = {{5875,1}}, outfit_female = 137, outfit_male = 129, addon = 2, storageID = Storage.OutfitQuest.Hunter.AddonGlove, puntosBuff = 15},
    ['first knight addon'] = {cost = 0, items = {{5880,100}, {5892,1}}, outfit_female = 139, outfit_male = 131, addon = 1, storageID = Storage.OutfitQuest.Knight.AddonSword, puntosBuff = 10},
    ['second knight addon'] = {cost = 0, items = {{5893,100}, {5924,1}, {5885,1}, {5887,1}}, outfit_female = 139, outfit_male = 131, addon = 2, storageID = 51296, puntosBuff = 15},
    ['first mage addon'] = {cost = 0, items = {{3074,1}, {3075,1}, {3072,1}, {3073,1}, {3071,1}, {3066,1}, {3070,1}, {3069,1}, {3065,1}, {3067,1}, {5904,10}, {3077,20}, {5809,1}}, outfit_female = 141, outfit_male = 130, addon = 1, storageID = Storage.OutfitQuest.MageSummoner.AddonWand, puntosBuff = 15},
    ['second mage addon'] = {cost = 0, items = {{5903,1}}, outfit_female = 141, outfit_male = 130, addon = 2, storageID = Storage.OutfitQuest.MageSummoner.AddonHatCloak, puntosBuff = 185},
    ['first summoner addon'] = {cost = 0, items = {{5958,1}}, outfit_female = 138, outfit_male = 133, addon = 1, storageID = 51295, puntosBuff = 10},
    ['second summoner addon'] = {cost = 0, items = {{5894,70}, {5911,20}, {5883,40}, {5922,35}, {5886,10}, {5881,60}, {5882,40}, {5904,15}, {5905,30}}, outfit_female = 138, outfit_male = 133, addon = 2, storageID = Storage.OutfitQuest.MageSummoner.AddonWandTimer, puntosBuff = 15},
    ['first barbarian addon'] = {cost = 0, items = {{5880,100}, {5892,1}, {5893,50}, {5876,50}}, outfit_female = 147, outfit_male = 143, addon = 1, storageID = 51032, puntosBuff = 15},
    ['second barbarian addon'] = {cost = 0, items = {{5884,1}, {5885,1}, {5910,50}, {5911,50}, {5886,10}}, outfit_female = 147, outfit_male = 143, addon = 2, storageID = 51033, puntosBuff = 15},
    ['first druid addon'] = {cost = 0, items = {{5896,50}, {5897,50}}, outfit_female = 148, outfit_male = 144, addon = 1, storageID = Storage.OutfitQuest.DruidHatAddon, puntosBuff = 10},
    ['second druid addon'] = {cost = 0, items = {{5906,100}}, outfit_female = 148, outfit_male = 144, addon = 2, storageID = Storage.OutfitQuest.DruidBodyAddon, puntosBuff = 15},
    ['first nobleman addon'] = {cost = 150000, items = {}, outfit_female = 140, outfit_male = 132, addon = 1, storageID = Storage.OutfitQuest.NoblemanFirstAddon, puntosBuff = 10},
    ['second nobleman addon'] = {cost = 150000, items = {}, outfit_female = 140, outfit_male = 132, addon = 2, storageID = Storage.OutfitQuest.NoblemanSecondAddon, puntosBuff = 10},
    ['first oriental addon'] = {cost = 0, items = {{5945,1}}, outfit_female = 150, outfit_male = 146, addon = 1, storageID = Storage.OutfitQuest.FirstOrientalAddon, puntosBuff = 10},
    ['second oriental addon'] = {cost = 0, items = {{5883,100}, {5895,100}, {5891,2}, {5912,100}}, outfit_female = 150, outfit_male = 146, addon = 2, storageID = Storage.OutfitQuest.SecondOrientalAddon, puntosBuff = 25},
    ['first warrior addon'] = {cost = 0, items = {{5925,100}, {5899,100}, {5884,1}, {5919,1}}, outfit_female = 142, outfit_male = 134, addon = 1, storageID = Storage.OutfitQuest.WarriorShoulderAddon, puntosBuff = 20},
    ['second warrior addon'] = {cost = 0, items = {{5880,100}, {5887,1}}, outfit_female = 142, outfit_male = 134, addon = 2, storageID = Storage.OutfitQuest.WarriorSwordAddon, puntosBuff = 10},
    ['first wizard addon'] = {cost = 0, items = {{5922,50}}, outfit_female = 149, outfit_male = 145, addon = 1, storageID = 51034, puntosBuff = 10},
    ['second wizard addon'] = {cost = 0, items = {{3436,1}, {3386,1}, {3382,1}, {3006,1}}, outfit_female = 149, outfit_male = 145, addon = 2, storageID = 51035, puntosBuff = 15},
    ['first assassin addon'] = {cost = 0, items = {{5912,50}, {5910,50}, {5911,50}, {5913,50}, {5914,50}, {5909,50}, {5886,10}}, outfit_female = 156, outfit_male = 152, addon = 1, storageID = Storage.OutfitQuest.AssassinFirstAddon, puntosBuff = 20},
    ['second assassin addon'] = {cost = 0, items = {{5804,1}, {5930,1}}, outfit_female = 156, outfit_male = 152, addon = 2, storageID = Storage.OutfitQuest.AssassinSecondAddon, puntosBuff = 20},
    ['first beggar addon'] = {cost = 0, items = {{5878,50}, {5921,30}, {5913,20}, {5894,10}, {5883,100}}, outfit_female = 157, outfit_male = 153, addon = 1, storageID = Storage.OutfitQuest.BeggarFirstAddonDoor, puntosBuff = 20},
    ['second beggar addon'] = {cost = 0, items = {{6107,1}}, outfit_female = 157, outfit_male = 153, addon = 2, storageID = Storage.OutfitQuest.BeggarSecondAddon, puntosBuff = 10},
    ['first pirate addon'] = {cost = 0, items = {{6098,100}, {6126,100}, {6097,100}}, outfit_female = 155, outfit_male = 151, addon = 1, storageID = Storage.OutfitQuest.PirateSabreAddon, puntosBuff = 15},
    ['second pirate addon'] = {cost = 0, items = {{6101,1}, {6102,1}, {6100,1}, {6099,1}}, outfit_female = 155, outfit_male = 151, addon = 2, storageID = Storage.OutfitQuest.PirateHatAddon, puntosBuff = 15},
    ['first shaman addon'] = {cost = 0, items = {{3348,5}, {3403,5}}, outfit_female = 158, outfit_male = 154, addon = 1, storageID = 51036, puntosBuff = 15},
    ['second shaman addon'] = {cost = 0, items = {{5014,1}, {3002,5}}, outfit_female = 158, outfit_male = 154, addon = 2, storageID = 51037, puntosBuff = 15},
    ['first norseman addon'] = {cost = 0, items = {{7290,5}}, outfit_female = 252, outfit_male = 251, addon = 1, storageID = 51038, puntosBuff = 10},
    ['second norseman addon'] = {cost = 0, items = {{7290,10}}, outfit_female = 252, outfit_male = 251, addon = 2, storageID = 51039, puntosBuff = 10},
    ['first nightmare addon'] = {cost = 0, items = {{6499,1000}}, outfit_female = 269, outfit_male = 268, addon = 1, storageID = 51040, puntosBuff = 15},
    ['second nightmare addon'] = {cost = 0, items = {{6499,500}}, outfit_female = 269, outfit_male = 268, addon = 2, storageID = 51041, puntosBuff = 15},
    ['first jester addon'] = {cost = 0, items = {{5879,20}, {5878,40}}, outfit_female = 270, outfit_male = 273, addon = 1, storageID = 51042, puntosBuff = 10},
    ['second jester addon'] = {cost = 0, items = {{5909,25}}, outfit_female = 270, outfit_male = 273, addon = 2, storageID = 51043, puntosBuff = 10},
    ['first brotherhood addon'] = {cost = 0, items = {{6499,1000}}, outfit_female = 279, outfit_male = 278, addon = 1, storageID = 51044, puntosBuff = 15},
    ['second brotherhood addon'] = {cost = 0, items = {{6499,500}}, outfit_female = 279, outfit_male = 278, addon = 2, storageID = 51045, puntosBuff = 15},
    ['first demon hunter addon'] = {cost = 0, items = {{12575,1}}, outfit_female = 288, outfit_male = 289, addon = 1, storageID = 51299, puntosBuff = 10},
    ['second demon hunter addon'] = {cost = 0, items = {{30364,1}}, outfit_female = 288, outfit_male = 289, addon = 2, storageID = 51292, puntosBuff = 15},
    ['first yalaharian addon'] = {cost = 0, items = {{9041,1}}, outfit_female = 324, outfit_male = 325, addon = 1, storageID = 51046, puntosBuff = 10},
    ['second yalaharian addon'] = {cost = 0, items = {{9041,1}}, outfit_female = 324, outfit_male = 325, addon = 2, storageID = 51047, puntosBuff = 15},
    ['first warmaster addon'] = {cost = 0, items = {{10199,1}}, outfit_female = 336, outfit_male = 335, addon = 1, storageID = 51048, puntosBuff = 10},
    ['second warmaster addon'] = {cost = 0, items = {{10198,1}}, outfit_female = 336, outfit_male = 335, addon = 2, storageID = 51049, puntosBuff = 15},
    ['first wayfarer addon'] = {cost = 0, items = {{11701,1}}, outfit_female = 366, outfit_male = 367, addon = 1, storageID = 51050, puntosBuff = 10},
    ['second wayfarer addon'] = {cost = 0, items = {{11700,1}}, outfit_female = 366, outfit_male = 367, addon = 2, storageID = 51051, puntosBuff = 15},
    ['first afflicted addon'] = {cost = 0, items = {{12787,1}}, outfit_female = 431, outfit_male = 430, addon = 1, storageID = 51300, puntosBuff = 10},
    ['second afflicted addon'] = {cost = 0, items = {{12786,1}}, outfit_female = 431, outfit_male = 430, addon = 2, storageID = 51053, puntosBuff = 15},
    ['first elementalist addon'] = {cost = 0, items = {{12599,1}}, outfit_female = 433, outfit_male = 432, addon = 1, storageID = 51054, puntosBuff = 25},
    ['second elementalist addon'] = {cost = 0, items = {{12803,1}}, outfit_female = 433, outfit_male = 432, addon = 2, storageID = 51055, puntosBuff = 25},
    ['first deepling addon'] = {cost = 0, items = {{14019,1}}, outfit_female = 464, outfit_male = 463, addon = 1, storageID = 51056, puntosBuff = 10},
    ['second deepling addon'] = {cost = 0, items = {{14019,1}}, outfit_female = 464, outfit_male = 463, addon = 2, storageID = 51057, puntosBuff = 15},
    ['first insectoid addon'] = {cost = 0, items = {{14753,10}}, outfit_female = 466, outfit_male = 465, addon = 1, storageID = 51058, puntosBuff = 20},
    ['second insectoid addon'] = {cost = 0, items = {{14753,15}}, outfit_female = 466, outfit_male = 465, addon = 2, storageID = 51059, puntosBuff = 20},
    ['first crystal warlord addon'] = {cost = 0, items = {{16256,1}}, outfit_female = 513, outfit_male = 512, addon = 1, storageID = 51080, puntosBuff = 10},
    ['second crystal warlord addon'] = {cost = 0, items = {{16257,1}}, outfit_female = 513, outfit_male = 512, addon = 2, storageID = 51081, puntosBuff = 15},
    ['first soil guardian addon'] = {cost = 0, items = {{16253,1}}, outfit_female = 514, outfit_male = 516, addon = 1, storageID = 51082, puntosBuff = 10},
    ['second soil guardian addon'] = {cost = 0, items = {{16254,1}}, outfit_female = 514, outfit_male = 516, addon = 2, storageID = 51083, puntosBuff = 15},
    ['first demon addon'] = {cost = 0, items = {{30363,1}}, outfit_female = 542, outfit_male = 541, addon = 1, storageID = 51293, puntosBuff = 10},
    ['second demon addon'] = {cost = 0, items = {{30362,1}}, outfit_female = 542, outfit_male = 541, addon = 2, storageID = 51294, puntosBuff = 15},
    ['first makeshift warrior addon'] = {cost = 0, items = {{27657,1}}, outfit_female = 1043, outfit_male = 1042, addon = 1, storageID = 51084, puntosBuff = 15},
    ['second makeshift warrior addon'] = {cost = 0, items = {{27656,1}}, outfit_female = 1043, outfit_male = 1042, addon = 2, storageID = 51085, puntosBuff = 15},
    ['first cave explorer addon'] = {cost = 15000000, items = {}, outfit_female = 575, outfit_male = 574, addon = 1, storageID = 51086, puntosBuff = 10},
    ['second cave explorer addon'] = {cost = 15000000, items = {}, outfit_female = 575, outfit_male = 574, addon = 2, storageID = 51087, puntosBuff = 15},
	['first dream warden addon'] = {cost = 0, items = {{20276,1}}, outfit_female = 578, outfit_male = 577, addon = 1, storageID = 51088, puntosBuff = 15},
    ['second dream warden addon'] = {cost = 0, items = {{20275,1}}, outfit_female = 578, outfit_male = 577, addon = 2, storageID = 51089, puntosBuff = 15},
    ['first glooth engineer addon'] = {cost = 0, items = {{21814,50}}, outfit_female = 618, outfit_male = 610, addon = 1, storageID = 51298, puntosBuff = 15},
    ['second glooth engineer addon'] = {cost = 0, items = {{21814,50}}, outfit_female = 618, outfit_male = 610, addon = 2, storageID = 51297, puntosBuff = 15},
	['first rift warrior addon'] = {cost = 0, items = {{22516,300}}, outfit_female = 845, outfit_male = 846, addon = 1, storageID = 51090, puntosBuff = 15},
    ['second rift warrior addon'] = {cost = 0, items = {{22516,400}}, outfit_female = 845, outfit_male = 846, addon = 2, storageID = 51091, puntosBuff = 15},
	['first battle mage addon'] = {cost = 0, items = {{28792,5}}, outfit_female = 1070, outfit_male = 1069, addon = 1, storageID = 51092, puntosBuff = 20},
    ['second battle mage addon'] = {cost = 0, items = {{28793,20}}, outfit_female = 1070, outfit_male = 1069, addon = 2, storageID = 51093, puntosBuff = 20},
    ['first dream warrior addon'] = {cost = 0, items = {{30169,10}}, outfit_female = 1147, outfit_male = 1146, addon = 1, storageID = 51094, puntosBuff = 15},
    ['second dream warrior addon'] = {cost = 0, items = {{30168,1}}, outfit_female = 1147, outfit_male = 1146, addon = 2, storageID = 51095, puntosBuff = 15},
	['first percht raider addon'] = {cost = 0, items = {{30275,1}}, outfit_female = 1162, outfit_male = 1161, addon = 1, storageID = 51096, puntosBuff = 15},
    ['second percht raider addon'] = {cost = 0, items = {{30276,1}}, outfit_female = 1162, outfit_male = 1161, addon = 2, storageID = 51097, puntosBuff = 15},
    ['first hand of the inquisition addon'] = {cost = 0, items = {{31738,1}}, outfit_female = 1244, outfit_male = 1243, addon = 1, storageID = 51098, puntosBuff = 20},
    ['second hand of the inquisition addon'] = {cost = 0, items = {{31737,1}}, outfit_female = 1244, outfit_male = 1243, addon = 2, storageID = 51099, puntosBuff = 20},
    ['first poltergeist addon'] = {cost = 0, items = {{32630,1}}, outfit_female = 1271, outfit_male = 1270, addon = 1, storageID = 51100, puntosBuff = 20},
    ['second poltergeist addon'] = {cost = 0, items = {{32631,1}}, outfit_female = 1271, outfit_male = 1270, addon = 2, storageID = 51101, puntosBuff = 20},
    ['first revenant addon'] = {cost = 0, items = {{34076,1}}, outfit_female = 1323, outfit_male = 1322, addon = 1, storageID = 51102, puntosBuff = 20},
    ['second revenant addon'] = {cost = 0, items = {{34075,1}}, outfit_female = 1323, outfit_male = 1322, addon = 2, storageID = 51103, puntosBuff = 30},
    ['first rascoohan addon'] = {cost = 0, items = {{35595,1}}, outfit_female = 1372, outfit_male = 1371, addon = 1, storageID = 51104, puntosBuff = 15},
    ['second rascoohan addon'] = {cost = 0, items = {{35695,1}}, outfit_female = 1372, outfit_male = 1371, addon = 2, storageID = 51105, puntosBuff = 20},
    ['first citizen of issavi addon'] = {cost = 0, items = {{37003,1}}, outfit_female = 1387, outfit_male = 1386, addon = 1, storageID = 51106, puntosBuff = 10},
    ['second citizen of issavi addon'] = {cost = 0, items = {{37002,1}}, outfit_female = 1387, outfit_male = 1386, addon = 2, storageID = 51107, puntosBuff = 15},
    ['first fire-fighter addon'] = {cost = 0, items = {{39544,1}}, outfit_female = 1569, outfit_male = 1568, addon = 1, storageID = 51108, puntosBuff = 15},
    ['second fire-fighter addon'] = {cost = 0, items = {{39545,1}}, outfit_female = 1569, outfit_male = 1568, addon = 2, storageID = 51109, puntosBuff = 20},
    ['first ancient aucar addon'] = {cost = 0, items = {{40532,1}, {40534,1}}, outfit_female = 1598, outfit_male = 1597, addon = 1, storageID = 51288, puntosBuff = 15},
    ['second ancient aucar addon'] = {cost = 0, items = {{40531,1}, {40533,1}}, outfit_female = 1598, outfit_male = 1597, addon = 2, storageID = 512899, puntosBuff = 15},
    ['first decaying defender addon'] = {cost = 0, items = {{43899,1}}, outfit_female = 1663, outfit_male = 1662, addon = 1, storageID = 51290, puntosBuff = 30},
    ['second decaying defender addon'] = {cost = 0, items = {{43900,1}}, outfit_female = 1663, outfit_male = 1662, addon = 2, storageID = 51291, puntosBuff = 30}
	
	
     

 }

local o = {'citizen', 'hunter', 'knight', 'mage', 'nobleman', 'summoner', 'warrior', 'barbarian', 'druid', 'wizard', 'oriental', 'pirate', 'assassin', 'beggar', 'shaman', 'norseman', 'nightmare', 'jester', 'brotherhood', 'demon', 'demon hunter', 'yalaharian', 'warmaster', 'wayfarer', 'afflicted', 'elementalist', 'deepling', 'insectoid', 'glooth engineer', 'crystal warlord', 'soil guardian', 'cave explorer', 'dream warden', 'rift warrior', 'makeshift warrior', 'battle mage', 'dream warrior', 'percht raider', 'hand of the inquisition', 'poltergeist', 'revenant', 'rascoohan', 'citizen of issavi', 'fire-fighter', 'ancient aucar', 'decaying defender',}
local rtnt = {}
local function creatureSayCallback(npc, creature, type, message)
local talkUser = creature
local player = Player(creature)
local playerId = player:getGuid()

local talkState = {}
    if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

    if addoninfo[message] ~= nil then
        local itemsTable = addoninfo[message].items
        local items_list = ''
        if (getPlayerStorageValue(creature, addoninfo[message].storageID) ~= -1) then
                npcHandler:say('You already have this addon!', npc, creature)
                npcHandler:resetNpc(creature)
                return true
        elseif table.maxn(itemsTable) > 0 then
            for i = 1, table.maxn(itemsTable) do
                local item = itemsTable[i]
                items_list = items_list .. item[2] .. ' ' .. ItemType(item[1]):getName()
                if i ~= table.maxn(itemsTable) then
                    items_list = items_list .. ', '
                end
            end
        end
        local text = ''
        if (addoninfo[message].cost > 0) then
            text = addoninfo[message].cost .. ' gp'
        elseif table.maxn(addoninfo[message].items) then
            text = items_list
        elseif (addoninfo[message].cost > 0) and table.maxn(addoninfo[message].items) then
            text = items_list .. ' and ' .. addoninfo[message].cost .. ' gp'
        end
        npcHandler:say('For ' .. message .. ' you will need ' .. text .. '. Do you have it all with you?', npc, creature)
        rtnt = message
        talkState[talkUser] = addoninfo[message].storageID
        npcHandler:setTopic(playerId, 2)
        return true
    elseif npcHandler:getTopic(playerId) == 2 then
        if MsgContains(message, "yes") then
            local items_number = 0
            if table.maxn(addoninfo[rtnt].items) > 0 then
                for i = 1, table.maxn(addoninfo[rtnt].items) do
                    local item = addoninfo[rtnt].items[i]
                    if (getPlayerItemCount(creature,item[1]) >= item[2]) then
                        items_number = items_number + 1
                    end
                end
            end
            if(getPlayerMoney(creature) >= addoninfo[rtnt].cost) and (items_number == table.maxn(addoninfo[rtnt].items)) then
                doPlayerRemoveMoney(creature, addoninfo[rtnt].cost)
                if table.maxn(addoninfo[rtnt].items) > 0 then
                    for i = 1, table.maxn(addoninfo[rtnt].items) do
                        local item = addoninfo[rtnt].items[i]
                        doPlayerRemoveItem(creature,item[1],item[2])
                    end
                end
                doPlayerAddOutfit(creature, addoninfo[rtnt].outfit_male, addoninfo[rtnt].addon)
local playerId = player:getGuid() -- O usa getId() si se refiere al ID del jugador en la base de datos
local puntosBuff = (addoninfo[rtnt] and addoninfo[rtnt].puntosBuff) or 0

-- Imprime el ID del jugador y los puntos de buff para depuración
--print("ID del jugador: " .. playerId)
--print("Puntos de buff: " .. puntosBuff)

-- Construye la consulta SQL
local query = "UPDATE `players` SET `buffpoints` = `buffpoints` + " .. puntosBuff .. " WHERE `id` = " .. playerId .. ";"
--print("Consulta SQL generada: " .. query)

-- Ejecuta la consulta
local result, errorMessage = db.query(query)

-- Verifica el resultado
if not result then
  --  print("Error en la ejecución de la consulta SQL: " .. (errorMessage or "desconocido"))
else
   -- print("Consulta SQL ejecutada correctamente.")
end

-- Adicionalmente, aplica cambios adicionales como cambiar el outfit y el almacenamiento
doPlayerAddOutfit(creature, addoninfo[rtnt].outfit_female, addoninfo[rtnt].addon)
setPlayerStorageValue(creature, addoninfo[rtnt].storageID, 1)
npcHandler:say('Here you are.', npc, creature)
end
            rtnt = nil
            talkState[talkUser] = 0
            npcHandler:resetNpc(creature)
            return true
        end
    elseif MsgContains(message, "addon") then
        npcHandler:say('I can give you {first} or {second} addons for {' .. table.concat(o, "}, {") .. '} outfits.', npc, creature)
        rtnt = nil
        talkState[talkUser] = 0
        npcHandler:resetNpc(creature)
        return true
    elseif MsgContains(message, "help") then
        npcHandler:say('You must say \'first NAME addon\', for the first addon or \'second NAME addon\' for the second.', npc, creature)
        rtnt = nil
        talkState[talkUser] = 0
        npcHandler:resetNpc(creature)
        return true
    else
        if talkState[talkUser] ~= nil then
            if talkState[talkUser] > 0 then
            npcHandler:say('Come back when you get these items.', npc, creature)
            rtnt = nil
            talkState[talkUser] = 0
            npcHandler:resetNpc(creature)
            return true
            end
        end
    end
    return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|! If you want some addons, just ask me! Do you want to see my {addons}, or are you decided? If you are decided, just ask me like this: {first citizen addon}')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)