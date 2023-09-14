taskOptions = {
	bonusReward = 65001, -- storage bonus reward
	bonusRate = 2, -- rate bonus reward
	taskBoardPositions = {
        {x = 32358, y = 32239, z = 7},
        {x = 32362, y = 32239, z = 7},
    },
	selectLanguage = 1 -- options: 1 = pt_br or 2 = english
}

task_pt_br = {
	exitButton = "Back",
	confirmButton = "Ok",
	cancelButton = "Delete",
	returnButton = "Back",
	title = "Quadro De Missoes",
	missionError = "Missao esta em andamento ou ela ja foi concluida.",
	missionErrorTwo = "Voce concluiu a missao!",
	missionErrorTwoo = "\nAqui estao suas recompensas:",
	choiceText = "- Experiencia: ",
	messageAcceptedText = "Voce aceitou essa missao!",
	messageDetailsText = "Detalhes da missao:",
	choiceMonsterName = "Nome: ",
	choiceMonsterKill = "Abates: ",
	choiceEveryDay = "Repetido: Todos os dias",
	choiceRepeatable = "Repetido: Sempre",
	choiceOnce = "Repetido: Apenas uma vez",
	choiceReward = "Recompensas:",
	messageAlreadyCompleteTask = "Voce ja concluiu essa missao.",
	choiceCancelTask = "Voce cancelou essa missao.",
	choiceCancelTaskError = "Voce nao pode cancelar essa missao, porque ela ja foi concluida ou nao foi iniciada.",
	choiceBoardText = "Escolha uma missao e use os botoes abaixo:",
	choiceRewardOnHold = "Reward On",
	choiceDailyConclued = "Diaria Concluada",
	choiceConclued = "Concluida",
	messageTaskBoardError = "O Quadro De Missoes esta muito longe ou esse nao e o quadro de missoes correto.",
	messageCompleteTask = "Parabens, voce terminou essa Task! Sua recompensa ja esta disponivel. Lembre-se de esvaziar a backpack, ou seus premios podem cair no chao.",
}

taskConfiguration = {

	{name = "Rotworm", color = 40, total = 100, type = "once", storage = 190042, storagecount = 190043, 
	rewards = {{3035, 50},{"exp", 50000}},
	},
	
	{name = "Carrion Worm", color = 40, total = 100, type = "once", storage = 190000, storagecount = 190001, 
	rewards = {{3035, 50},{"exp", 50000}},
	},
	
	{name = "Minotaur", color = 40, total = 20000, type = "once", storage = 190095, storagecount = 190096, 
	rewards = {
	{5804, 1},
	{"exp", 1000000},
	},
	},

	{name = "Dragon", color = 40, total = 1000, type = "daily", storage = 190002, storagecount = 190003, 
	rewards = {
	{3043, 100},
	{5884, 1},
	{"exp", 1500000},
	},
	},

	{name = "Dragon Lord", color = 40, total = 60000, type = "once", storage = 190004, storagecount = 190005, 
	rewards = {
	{5919, 1},
	{"exp", 1500000},
	},
	},

	{name = "Amazon", color = 40, total = 500, type = "repeatable", storage = 190008, storagecount = 190009, 
	rewards = { 
	{"exp", 1500000},
		},
	},

	{name = "Valkyrie", color = 40, total = 50000, type = "once", storage = 190010, storagecount = 190011, 
	rewards = { 
	{3437, 1},
		},
	},

	{name = "Weakened Frazzlemaw", color = 40, total = 1000, type = "daily", storage = 190012, storagecount = 190013, 
	rewards = { 
	{22516, 2},
		},
	},

	{name = "Enfeebled Silencer", color = 40, total = 1000, type = "daily", storage = 190014, storagecount = 190015, 
	rewards = { 
	{22721, 1},
		},
	},

	{name = "Deepling Guard", color = 40, total = 1000, type = "daily", storage = 190016, storagecount = 190017, 
	rewards = { 
	{14142, 1},
		},
	},

	{name = "Deepling Warrior", color = 40, total = 1000, type = "daily", storage = 190018, storagecount = 190019, 
	rewards = { 
	{"exp", 10000000},
		},
	},

	{name = "Deepling Scout", color = 40, total = 1000, type = "daily", storage = 190020, storagecount = 190021, 
	rewards = { 
	{"exp", 10000000},
		},
	},

	{name = "Guzzlemaw", color = 40, total = 5000, type = "once", storage = 190022, storagecount = 190023, 
	rewards = { 
	{20270, 1},
		},
	},

	{name = "Frazzlemaw", color = 40, total = 5000, type = "once", storage = 190100, storagecount = 190101, 
	rewards = { 
	{20272, 1},
		},
	},

	{name = "Silencer", color = 40, total = 5000, type = "once", storage = 190024, storagecount = 190025, 
	rewards = { 
	{20271, 1},
		},
	},

	{name = "Medusa", color = 40, total = 50000, type = "once", storage = 190026, storagecount = 190027, 
	rewards = { 
	{3393, 1},
		},
	},

	{name = "Demon", color = 40, total = 66000, type = "once", storage = 190028, storagecount = 190029, 
	rewards = { 
	{3365, 1},
		},
	},

	{name = "Hero", color = 40, total = 50000, type = "once", storage = 190030, storagecount = 190031, 
	rewards = { 
	{3394, 1},
		},
	},

	{name = "Cloak Of Terror", color = 40, total = 1000, type = "daily", storage = 190032, storagecount = 190033, 
	rewards = { 
	{"exp", 50000000},
		},
	},

	{name = "Vibrant Phantom", color = 40, total = 1000, type = "daily", storage = 190034, storagecount = 190035, 
	rewards = { 
	{"exp", 50000000},
		},
	},

	{name = "Courage Leech", color = 40, total = 1000, type = "daily", storage = 190036, storagecount = 190037, 
	rewards = { 
	{"exp", 50000000},
		},
	},

	{name = "Brachiodemon", color = 40, total = 1000, type = "daily", storage = 190038, storagecount = 190039, 
	rewards = { 
	{"exp", 50000000},
		},
	},

	{name = "Infernal Demon", color = 40, total = 15000, type = "once", storage = 190040, storagecount = 190041, 
	rewards = { 
	{34109, 1},
		},
	},

	{name = "Infernal Phantom", color = 40, total = 1000, type = "daily", storage = 190042, storagecount = 190043, 
	rewards = { 
	{"exp", 40000000},
		},
	},

	{name = "Juggernaut", color = 40, total = 10000, type = "once", storage = 190044, storagecount = 190045, 
	rewards = { 
	{3422, 1},
		},
	},

	{name = "Dawnfire Asura", color = 40, total = 1000, type = "daily", storage = 190046, storagecount = 190047, 
	rewards = { 
	{"exp", 20000000},
		},
	},
	

	{name = "Girtablilu Warrior", color = 40, total = 5000, type = "once", storage = 190052, storagecount = 190053, 
	rewards = {   
	{"exp", 100000000},
		},
	},

	{name = "Dark Carnisylvan", color = 40, total = 25000, type = "once", storage = 190062, storagecount = 190063, 
	rewards = { 
	{"exp", 100000000},
		},
	},

	{name = "Midnight Asura", color = 40, total = 1000, type = "daily", storage = 190064, storagecount = 190065, 
	rewards = { 
	{"exp", 20000000},
		},
	},
	
	{name = "Infernal Demon", color = 40, total = 15000, type = "once", storage = 190065, storagecount = 190066, 
	rewards = { 
	{"exp", 50000000},
		},
	},

	{name = "Meraki Boss", color = 40, total = 1, type = "daily", storage = 190067, storagecount = 190068, 
	rewards = { 
	{"exp", 50000000},
	{36725, 1},
	{36724, 1},
		},
	},

	{name = "falcon Knight", color = 40, total = 10000, type = "once", storage = 190069, storagecount = 190070, 
	rewards = { 
	{"exp", 10000000},
	{30316, 1},
		},
	},
	
	{name = "falcon Paladin", color = 40, total = 10000, type = "once", storage = 190071, storagecount = 190072, 
	rewards = { 
	{"exp", 10000000},
	{30316, 1},
		},
	},

	{name = "Vampire Bride", color = 40, total = 5000, type = "daily", storage = 190073, storagecount = 190074, 
	rewards = { 
	{12306, 1},
		},
	},

	{name = "Crazed Winter Rearguard", color = 40, total = 3000, type = "daily", storage = 190075, storagecount = 190076, 
	rewards = { 
	{"exp", 10000000},
	{12547, 1},
		},
	},

	{name = "Crazed Summer Rearguard", color = 40, total = 5000, type = "once", storage = 190077, storagecount = 190078, 
	rewards = { 
	{33893, 1},
		},
	},

	{name = "Crazed Summer Rearguard", color = 40, total = 3000, type = "daily", storage = 190079, storagecount = 190080, 
	rewards = { 
	{"exp", 10000000},
		},
	},

	{name = "Rhindeer", color = 40, total = 2500, type = "daily", storage = 190081, storagecount = 190082, 
	rewards = { 
	{"exp", 30000000},
		},
	},

	{name = "Crape Man", color = 40, total = 3000, type = "daily", storage = 190083, storagecount = 190084, 
	rewards = { 
	{"exp", 30000000},
		},
	},

	{name = "Harpy", color = 40, total = 3000, type = "daily", storage = 190085, storagecount = 190086, 
	rewards = { 
	{"exp", 30000000},
		},
	},

	{name = "King Zelos", color = 40, total = 5, type = "daily", storage = 190087, storagecount = 190088, 
	rewards = { 
	{"exp", 30000000},
		},
	},

	{name = "The Pale Worm", color = 40, total = 5, type = "daily", storage = 190089, storagecount = 190090, 
	rewards = { 
	{"exp", 30000000},
		},
	},

	{name = "Megalomania", color = 40, total = 5, type = "daily", storage = 190091, storagecount = 190092, 
	rewards = { 
	{"exp", 30000000},
		},
	},

	{name = "Ferumbras Mortal Shell", color = 40, total = 1, type = "once", storage = 190093, storagecount = 190094, 
	rewards = { 
	{"exp", 30000000},
	{33893, 2}
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
		if data.name:lower() == name:lower() then
			return data
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
		-- player:say('Task: '..data.name ..' - ['.. kills + count .. '/'.. data.total ..']', TALKTYPE_MONSTER_SAY)
		
		local msg = ''..data.name ..' - ['.. kills + count .. '/'.. data.total ..']'
		player:sendChannelMessage("", msg, TALKTYPE_CHANNEL_R1, 12)
		return player:setStorageValue(data.storagecount, kills + count)
end