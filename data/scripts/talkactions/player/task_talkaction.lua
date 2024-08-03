function endTaskModalWindow(player, storage)
local data = getTaskByStorage(storage)
local newmessage
local completion = false
	if player:getTaskKills(data.storagecount) < data.total then
		newmessage = "You have already completed, or are in progress on this task."
	else
		player:endTask(storage, false)
		completion = true
		newmessage = "You completed the task" .. (data.rewards and "\nHere are your rewards:" or "")
	end
local window = ModalWindow{
	title = "Task System",
	message = newmessage
	}
	if completion and data.rewards then
	for _, info in pairs (data.rewards) do
		if info[1] == "exp" then
			player:addExperience(info[2])
			window:addChoice("- Experience: "..info[2])
		elseif tonumber(info[1]) then
			window:addChoice("- ".. info[2] .." "..ItemType(info[1]):getName())
			player:addItem(info[1], info[2])
		end
	end
end
	window:addButton("Back", function() sendTaskModalWindow(player) end)
	window:sendToPlayer(player)
end
function acceptedTaskModalWindow(player)
local window = ModalWindow{
	title = "Task System",
	message = "You accepted this task!"
	}
	window:addButton("Back", function() sendTaskModalWindow(player) end)
	window:sendToPlayer(player)
end

function confirmTaskModalWindow(player, storage)
local window = ModalWindow{
	title = "Task System",
	message = "Here are the details of your task:"
	}
local data = getTaskByStorage(storage)
	window:addChoice("Monster name: "..data.name)
	window:addChoice("Necessary deaths: "..data.total)
	if data.type == "daily" then
		window:addChoice("You can repeat: Every day!")
	elseif data.type[1] == "repeatable" then
		window:addChoice("You can repeat: ".. (data.type[2] == -1 and "Always." or data.type[2] .." times."))
	elseif data.type[1] == "once" then
		window:addChoice("You can repeat: Only once!")
	end
	if data.rewards then
		window:addChoice("Rewards:")
	for _, info in pairs(data.rewards) do
		if info[1] == "exp" then
			window:addChoice("- Experience: "..info[2])
		elseif tonumber(info[1]) then
			window:addChoice("- " .. info[2] .. " ".. ItemType(info[1]):getName())
		end
	end
end
local function confirmCallback(player, button, choice)
	if player:hasStartedTask(storage) or not player:canStartCustomTask(storage) then
		errorModalWindow(player)
	else
		acceptedTaskModalWindow(player)
		player:startTask(storage)
	end
end
	window:addButton("Choose", confirmCallback)
	window:addButton("Back", function() sendTaskModalWindow(player) end)
	window:sendToPlayer(player)
end

function errorModalWindow(player)
local window = ModalWindow{
	title = "Task System",
	message = "You have already completed this task."
	}
	window:addButton("Back", function() sendTaskModalWindow(player) end)
	window:sendToPlayer(player)
end

function cancelTaskModalWindow(player, managed)
local newmessage
	if managed then
		newmessage = "You canceled this task."
	else
		newmessage = "You cannot cancel this task, because it is already completed or not started."
	end
local window = ModalWindow{
	title = "Task System",
	message = newmessage
	}
	window:addButton("Back", function() sendTaskModalWindow(player) end)
	window:sendToPlayer(player)
end

function sendTaskModalWindow(player)
local window = ModalWindow{
	title = "Task System",
	message = "Choose a task and use the buttons below:"
	}
local temptasks = {}
	for _, data in pairs (taskConfiguration) do
		temptasks[#temptasks+1] = data.storage
	if player:hasStartedTask(data.storage) then
		window:addChoice(data.name .. " ["..(player:getTaskKills(data.storagecount) >= data.total and "Reward on Hold]" or player:getTaskKills(data.storagecount).."/"..data.total.."]"))
	elseif player:canStartCustomTask(data.storage) == false then
	if data.type == "daily" then
		window:addChoice(data.name .. ", [Concluded Daily]")
	else
		window:addChoice(data.name ..", [Concluded]")
	end
	else
		window:addChoice(data.name ..", "..data.total)
	end
end
local function confirmCallback(player, button, choice)
local id = choice.id
	if player:hasStartedTask(temptasks[id]) then
		endTaskModalWindow(player, temptasks[id])
	elseif not player:canStartCustomTask(temptasks[id]) then
		errorModalWindow(player)
	else
		confirmTaskModalWindow(player, temptasks[id])
	end
end
local function cancelCallback(player, button, choice)
local id = choice.id
	if player:hasStartedTask(temptasks[id]) then
	cancelTaskModalWindow(player, true)
	player:endTask(temptasks[id], true)
	else
	cancelTaskModalWindow(player, false)
	end
end
	window:addButton("Choose", confirmCallback)
	window:addButton("Cancel", cancelCallback)
	window:addButton("Exit")
	window:sendToPlayer(player)
end

local task = TalkAction("!task")

function task.onSay(player, words, param)
	sendTaskModalWindow(player)
	return false
end

task:separator(" ")
task:groupType("normal")
task:register()
