taskOptions = {
	bonusReward = 65001, -- storage bonus reward
	bonusRate = 1, -- rate bonus reward
	taskBoardPositions = {
        {x = 32359, y = 32237, z = 7},       
    },
	selectLanguage = 1, -- options: 1 = pt_br or 2 = english
	uniqueTask = true, -- do one task at a time
	uniqueTaskStorage = 65002
}

task_pt_br = {
	exitButton = "Fechar",
	confirmButton = "Validar",
	cancelButton = "Anular",
	returnButton = "Voltar",
	title = "Quadro De Missoes",
	missionError = "Missao esta em andamento ou ela ja foi concluida.",
	uniqueMissionError = "Voce so pode fazer uma missao por vez.",
	missionErrorTwo = "Voce concluiu a missao",
	missionErrorTwoo = "\nAqui estao suas recompensas:",
	choiceText = "- Experiencia: ",
	messageAcceptedText = "Voce aceitou essa missao!",
	messageDetailsText = "Detalhes da missao:",
	choiceMonsterName = "Missao: ",
	choiceMonsterRace = "Racas: ",
	choiceMonsterKill = "Abates: ",
	choiceEveryDay = "Repeticao: Todos os dias",
	choiceRepeatable = "Repeticao: Sempre",
	choiceOnce = "Repeticao: Apenas uma vez",
	choiceReward = "Recompensas:",
	messageAlreadyCompleteTask = "Voce ja concluiu essa missao.",
	choiceCancelTask = "Voce cancelou essa missao",
	choiceCancelTaskError = "Voce nao pode cancelar essa missao, porque ela ja foi concluida ou nao foi iniciada.",
	choiceBoardText = "Escolha uma missao e use os botoes abaixo:",
	choiceRewardOnHold = "Resgatar Premio",
	choiceDailyConclued = "Diaria Concluida",
	choiceConclued = "Concluida",
	messageTaskBoardError = "O quadro de missoes esta muito longe ou esse nao e o quadro de missoes correto.",
	messageCompleteTask = "Voce terminou essa missao! \nRetorne para o quadro de missoes e pegue sua recompensa.",
}

taskConfiguration = {
{name = "Goblin", color = 40, total = 100, type = "repeatable", storage = 190000, storagecount = 190001, 
	rewards = {
	{3043, 3},
	{"exp", 50000},
	},
	races = {
		"Goblin",
		"Goblin Assassin",
		"Goblin Scavenger",	
	},
},
{name = "Troll", color = 40, total = 100, type = "repeatable", storage = 190002, storagecount = 190003, 
	rewards = {
	{3043, 3},
	{"exp", 50000},
	},
	races = {
		"Troll",
		"Swamp Troll",
		"Frost Troll",
		"Island Troll",
	},
},

{name = "Rotworm", color = 40, total = 200, type = "repeatable", storage = 190004, storagecount = 190005, 
	rewards = {
	{3043, 5},
	{"exp", 80000},
	},
	races = {
		"Rotworm",
		"Carrion Worm",
		"White Pale",
		"Rotworm Queen",
	},
},

{name = "Minotaur", color = 40, total = 250, type = "daily", storage = 190006, storagecount = 190007, 
	rewards = {
	{10327, 1},
	{"exp", 120000},
	},
	races = {
		"Minotaur",
		"Minotaur Archer",
		"Minotaur Mage",
		"Minotaur Guard",
	},
},

{name = "Dwarf", color = 40, total = 250, type = "repeatable", storage = 190008, storagecount = 190009, 
	rewards = { 
	{"exp", 120000},
	{3043, 5},
	},
	races = {
		"Dwarf",
		"Dwarf Soldier",
		"Dwarf Guard",
		"Dwarf Geomancer",
	},
},

{name = "Dworcs", color = 40, total = 250, type = "repeatable", storage = 190010, storagecount = 190011, 
	rewards = { 
	{3043, 5},
	},
	races = {
		"Dworc Venomsniper",
		"Dworc Voodoomaster",
		"Dworc Fleshhunter",
	},
},

{name = "Elf", color = 40, total = 300, type = "repeatable", storage = 190012, storagecount = 190013, 
	rewards = {
	{3043, 8},
	{"exp", 150000},
	},
	races = {
		"Elf",
		"Elf Scout",
		"Elf Arcanist",	
	},
},

{name = "Dark", color = 40, total = 400, type = "repeatable", storage = 190014, storagecount = 190015, 
	rewards = {
	{3043, 8},
	{"exp", 150000},
	},
	races = {
		"Dark Apprentice",
		"Dark Magician",
		"Dark Monk",
		"Assassin",
	},
},

{name = "Tombs", color = 40, total = 600, type = "daily", storage = 190016, storagecount = 190017, 
	rewards = { 
	{19083, 1},
	{"exp", 150000},
	},
	races = {
		"Ghost",
		"Mummy",
		"Ghoul",
		"Demon Skeleton",
		"Skeleton",
		"Crypt Shambler",
	},
},

{name = "Scarab", color = 40, total = 600, type = "repeatable", storage = 190018, storagecount = 190019, 
	rewards = { 
	{3043, 8},
	{"exp", 200000},
	},
	races = {
		"Scarab",
		"Larva",		
	},
},

{name = "Cyclops", color = 40, total = 800, type = "daily", storage = 190020, storagecount = 190021, 
	rewards = { 
	{37469, 1},
	{"exp", 250000},
	},
	races = {
		"Cyclops",
		"Cyclops Smith",
		"Cyclops Drone",
	},
},

{name = "Coryms", color = 40, total = 800, type = "repeatable", storage = 190022, storagecount = 190023, 
	rewards = { 
	{"exp", 250000},
	},
	races = {
		"Corym Charlatan",
		"Corym Skirmisher",
		"Corym Vanguard",
	},
},

{name = "Kongra", color = 40, total = 800, type = "repeatable", storage = 190024, storagecount = 190025, 
	rewards = { 
	{3043, 10},
	},
	races = {
		"Kongra",
		"Sibang",
		"Merlkin",
	},
},

{name = "Pirates", color = 40, total = 800, type = "daily", storage = 190026, storagecount = 190027, 
	rewards = { 
	{5926, 1},
	{"exp", 200000},
	},
	races = {
		"Pirate Marauder",
		"Pirate Cutthroat",
		"Pirate Corsair",
		"Pirate Buccaneer",
	},
},

{name = "Barbarians", color = 40, total = 800, type = "daily", storage = 190028, storagecount = 190029, 
	rewards = { 
	{7290, 1},
	{"exp", 200000},
	},
	races = {
		"Barbarian Bloodwalker",
		"Barbarian Brutetamer",
		"Barbarian Headsplitter",
		"Barbarian Skullhunter",
	},
},

{name = "Djinn", color = 40, total = 800, type = "daily", storage = 190030, storagecount = 190031, 
	rewards = { 
	{"exp", 200000},
	},
	races = {
		"Marid",
		"Efreet",
		"Green Djinn",
		"Blue Djinn",
	},
},

{name = "Dragon", color = 40, total = 1500, type = "daily", storage = 190032, storagecount = 190033, 
	rewards = {   
	{64005, 100},	
	{"exp", 300000},
	},
	races = {
		"Dragon",
		"Dragon Hatchling",
	},
},

{name = "Oramond", color = 40, total = 2000, type = "once", storage = 190034, storagecount = 190035, 
	rewards = { 
	{38706, 1},
	{"exp", 500000},
	},
	races = {
		"Minotaur Hunter",
		"Mooh Tah Warrior",
		"Minotaur Amazon",
		"Worm Priestess",
		"Execowtioner",
		"Moohtant",
	},
},

{name = "Cloak Of Terror", color = 40, total = 1000, type = "daily", storage = 190026, storagecount = 190027, 
	rewards = { 
	{"exp", 30000000},
	},
	races = {
		"Cloak Of Terror",
	},
},

{name = "Vibrant Phantom", color = 40, total = 1000, type = "daily", storage = 190028, storagecount = 190029, 
	rewards = { 
	{"exp", 30000000},
	},
	races = {
		"Vibrant Phantom",
	},
},

{name = "Courage Leech", color = 40, total = 1000, type = "daily", storage = 190030, storagecount = 190031, 
	rewards = { 
	{"exp", 30000000},
	},
	races = {
		"Courage Leech",
	},
},

{name = "Brachiodemon", color = 40, total = 1000, type = "daily", storage = 190032, storagecount = 190033, 
	rewards = { 
	{"exp", 30000000},
	},
	races = {
		"Brachiodemon",
	},
},

{name = "Infernal Demon", color = 40, total = 50000, type = "once", storage = 190034, storagecount = 190035, 
	rewards = { 
	{34109, 2},
	},
	races = {
		"Infernal Demon",
	},
},

{name = "Infernal Phantom", color = 40, total = 1000, type = "daily", storage = 190036, storagecount = 190037, 
	rewards = { 
	{"exp", 30000000},
	},
	races = {
		"Infernal Phantom",
	},
},
}

squareWaitTime = 5000
taskQuestLog = 65000 -- A storage so you get the quest log
dailyTaskWaitTime = 20 * 60 * 60 

function Player.getCustomActiveTasksName(self)
local player = self
	if not player then
		return false
	end
local tasks = {}
	for i, data in pairs(taskConfiguration) do
		if player:getStorageValue(data.storagecount) ~= -1 then
		tasks[#tasks + 1] = data.name
		end
	end
	return #tasks > 0 and tasks or false
end


function getTaskByStorage(storage)
	for i, data in pairs(taskConfiguration) do
		if data.storage == tonumber(storage) then
			return data
		end
	end
	return false
end

function getTaskByMonsterName(name)
	for i, data in pairs(taskConfiguration) do
		for _, dataList in ipairs(data.races) do
		if dataList:lower() == name:lower() then
			return data
		end
		end
	end
	return false
end

function Player.startTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if player:getStorageValue(taskQuestLog) == -1 then
		player:setStorageValue(taskQuestLog, 1)
	end
	player:setStorageValue(storage, player:getStorageValue(storage) + 1)
	player:setStorageValue(data.storagecount, 0)
	return true
end

function Player.canStartCustomTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if data.type == "daily" then
		return os.time() >= player:getStorageValue(storage)
	elseif data.type == "once" then
		return player:getStorageValue(storage) == -1
	elseif data.type[1] == "repeatable" and data.type[2] ~= -1 then
		return player:getStorageValue(storage) < (data.type[2] - 1)
	else
		return true
	end
end

function Player.endTask(self, storage, prematurely)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
end
	if prematurely then
		if data.type == "daily" then
			player:setStorageValue(storage, -1)
		else
			player:setStorageValue(storage, player:getStorageValue(storage) - 1)
	end
	else
		if data.type == "daily" then
			player:setStorageValue(storage, os.time() + dailyTaskWaitTime)
		end
	end
	player:setStorageValue(data.storagecount, -1)
	return true
end

function Player.hasStartedTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	return player:getStorageValue(data.storagecount) ~= -1
end


function Player.getTaskKills(self, storage)
local player = self
	if not player then
		return false
	end
	return player:getStorageValue(storage)
end

function Player.addTaskKill(self, storage, count)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	local kills = player:getTaskKills(data.storagecount)
	if kills >= data.total then
		return false
	end
	if kills + count >= data.total then
		if taskOptions.selectLanguage == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, task_pt_br.messageCompleteTask)
		else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] You have finished this task! To claim your rewards, return to the quest board and claim your reward.")
		end
		return player:setStorageValue(data.storagecount, data.total)
	end
		player:say('Task: '..data.name ..' - ['.. kills + count .. '/'.. data.total ..']', TALKTYPE_MONSTER_SAY)
		return player:setStorageValue(data.storagecount, kills + count)
end