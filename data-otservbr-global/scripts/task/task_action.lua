function endTaskModalWindow(player, storage)
	local data = getTaskByStorage(storage)
	local newmessage
	local completion = false
	if player:getTaskKills(data.storagecount) < data.total then
		if taskOptions.selectLanguage == 1 then
			newmessage = task_pt_br.missionError
		else
			newmessage = "You have already completed, or are in progress on this task."
		end
	else
		player:endTask(storage, false)
		completion = true
		if taskOptions.selectLanguage == 1 then
			newmessage = task_pt_br.missionErrorTwo .. (data.rewards and task_pt_br.missionErrorTwoo or "")
		else
			newmessage = "You completed the task" .. (data.rewards and "\nHere are your rewards:" or "")
		end
	end
	local title = taskOptions.selectLanguage == 1 and task_pt_br.title or "Task System"
	local window = ModalWindow{
		title = title,
		message = newmessage
	}
	if completion and data.rewards then
		if player:getStorageValue(taskOptions.bonusReward) >= 1 then
				if taskOptions.selectLanguage == 1 then
				player:say('Recompensa Resgatada:', TALKTYPE_MONSTER_SAY)
				else
				player:say('Redeemed Reward:', TALKTYPE_MONSTER_SAY)
				end
			for _, info in pairs (data.rewards) do
				if info[1] == "exp" then
					player:addExperience(info[2]*taskOptions.bonusRate)
					player:getPosition():sendMagicEffect(29)
					player:say('Exp: '.. info[2]*taskOptions.bonusRate ..'', TALKTYPE_MONSTER_SAY)
					if taskOptions.selectLanguage == 1 then
						window:addChoice(task_pt_br.choiceText ..""..info[2]*taskOptions.bonusRate)
					else
						window:addChoice("- Experience: "..info[2]*taskOptions.bonusRate)
					end
				elseif tonumber(info[1]) then
					window:addChoice("- ".. info[2]*taskOptions.bonusRate .." "..ItemType(info[1]):getName())
					player:addItem(info[1], info[2]*taskOptions.bonusRate)
					player:getPosition():sendMagicEffect(29)
					if taskOptions.selectLanguage == 1 then
					player:say('Pr�mios: '..  info[2]*taskOptions.bonusRate .. ' ' ..ItemType(info[1]):getName(), TALKTYPE_MONSTER_SAY)
					else
					player:say('Others: '..  info[2]*taskOptions.bonusRate .. ' ' ..ItemType(info[1]):getName(), TALKTYPE_MONSTER_SAY)
					end
					player:setStorageValue(storagecheck, player:getStorageValue(storagecheck) + 1)
				end
			end
		else
				if taskOptions.selectLanguage == 1 then
				player:say('Recompensa Resgatada:', TALKTYPE_MONSTER_SAY)
				else
				player:say('Redeemed Reward:', TALKTYPE_MONSTER_SAY)
				end
			for _, info in pairs (data.rewards) do
				if info[1] == "exp" then
					player:addExperience(info[2])
					player:getPosition():sendMagicEffect(29)
					player:say('Exp: '.. info[2] ..'', TALKTYPE_MONSTER_SAY)
					if taskOptions.selectLanguage == 1 then
						window:addChoice(task_pt_br.choiceText ..""..info[2])
					else
						window:addChoice("- Experience: "..info[2])
					end
				elseif tonumber(info[1]) then
					window:addChoice("- ".. info[2] .." "..ItemType(info[1]):getName())
					player:addItem(info[1], info[2])
					player:getPosition():sendMagicEffect(29)
					if taskOptions.selectLanguage == 1 then
					player:say('Pr�mios: '.. ItemType(info[1]):getName() .. '', TALKTYPE_MONSTER_SAY)
					else
					player:say('Others: '.. ItemType(info[1]):getName() .. '', TALKTYPE_MONSTER_SAY)
					end
					player:setStorageValue(storagecheck, player:getStorageValue(storagecheck) + 1)
				end
			end
		end
	end
	if taskOptions.selectLanguage == 1 then
		window:addButton(task_pt_br.returnButton, function() sendTaskModalWindow(player) end)
	else
		window:addButton("Back", function() sendTaskModalWindow(player) end)
	end
	window:sendToPlayer(player)
end
function acceptedTaskModalWindow(player)
	local title = taskOptions.selectLanguage == 1 and task_pt_br.title or "Task System"
	local customMessage = taskOptions.selectLanguage == 1 and task_pt_br.messageAcceptedText or "You accepted this task!"
	local window = ModalWindow{
		title = title,
		message = customMessage
	}
	player:getPosition():sendMagicEffect(CONST_ME_TREASURE_MAP)
	if taskOptions.selectLanguage == 1 then
		window:addButton(task_pt_br.returnButton, function() sendTaskModalWindow(player) end)
	else
		window:addButton("Back", function() sendTaskModalWindow(player) end)
	end
	window:sendToPlayer(player)
end

function confirmTaskModalWindow(player, storage)
	local title = taskOptions.selectLanguage == 1 and task_pt_br.title or "Task System"
	local detailsMessage = taskOptions.selectLanguage == 1 and task_pt_br.messageDetailsText or "Here are the details of your task:"
	local window = ModalWindow{
		title = title,
		message = detailsMessage
	}
	local data = getTaskByStorage(storage)
	if taskOptions.selectLanguage == 1 then
		window:addChoice(task_pt_br.choiceMonsterName..""..data.name)
		window:addChoice(task_pt_br.choiceMonsterKill..""..data.total)
		if data.type == "daily" then
			window:addChoice(task_pt_br.choiceEveryDay)
		elseif data.type == "repeatable" then
			window:addChoice(task_pt_br.choiceRepeatable)
		elseif data.type == "once" then
			window:addChoice(task_pt_br.choiceOnce)
		end
	else
		window:addChoice("Monster name: "..data.name)
		window:addChoice("Necessary deaths: "..data.total)
		if data.type == "daily" then
			window:addChoice("You can repeat: Every day!")
		elseif data.type == "repeatable" then
			window:addChoice("You can repeat: Always!")
		elseif data.type == "once" then
			window:addChoice("You can repeat: Only once!")
		end
	end
	if data.rewards then
		if taskOptions.selectLanguage == 1 then
			window:addChoice(task_pt_br.choiceReward)
		else
			window:addChoice("Rewards:")
		end
		if player:getStorageValue(taskOptions.bonusReward) >= 1 then
			for _, info in pairs(data.rewards) do
				if info[1] == "exp" then
					if taskOptions.selectLanguage == 1 then
						window:addChoice(task_pt_br.choiceText ..""..info[2]*taskOptions.bonusRate)
					else
						window:addChoice("- Experience: "..info[2]*taskOptions.bonusRate)
					end
				elseif tonumber(info[1]) then
					window:addChoice("- " .. info[2]*taskOptions.bonusRate .. " ".. ItemType(info[1]):getName())
				end
			end
		else
			for _, info in pairs(data.rewards) do
				if info[1] == "exp" then
					if taskOptions.selectLanguage == 1 then
						window:addChoice(task_pt_br.choiceText ..""..info[2])
					else
						window:addChoice("- Experience: "..info[2])
					end
				elseif tonumber(info[1]) then
					window:addChoice("- " .. info[2] .. " ".. ItemType(info[1]):getName())
				end
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
	if taskOptions.selectLanguage == 1 then
		window:addButton(task_pt_br.confirmButton, confirmCallback)
		window:addButton(task_pt_br.returnButton, function() sendTaskModalWindow(player) end)
	else
		window:addButton("Choose", confirmCallback)
		window:addButton("Back", function() sendTaskModalWindow(player) end)
	end
	window:sendToPlayer(player)
end

function errorModalWindow(player)
	local title = taskOptions.selectLanguage == 1 and task_pt_br.title or "Task System"
	local completedMessage = taskOptions.selectLanguage == 1 and task_pt_br.messageAlreadyCompleteTask or "You have already completed this task."
	local window = ModalWindow{
		title = title,
		message = completedMessage
	}
	player:getPosition():sendMagicEffect(CONST_ME_STUN)
	if taskOptions.selectLanguage == 1 then
		window:addButton(task_pt_br.returnButton, function() sendTaskModalWindow(player) end)
	else
		window:addButton("Back", function() sendTaskModalWindow(player) end)
	end
	window:sendToPlayer(player)
end

function cancelTaskModalWindow(player, managed)
	local newmessage
	if managed then
		if taskOptions.selectLanguage == 1 then
			newmessage = task_pt_br.choiceCancelTask
		else
			newmessage = "You canceled this task."
		end
	else
		if taskOptions.selectLanguage == 1 then
			newmessage = task_pt_br.choiceCancelTaskError
		else
			newmessage = "You cannot cancel this task, because it is already completed or not started."
		end
	end
	local title = taskOptions.selectLanguage == 1 and task_pt_br.title or "Task System"
	local window = ModalWindow{
		title = title,
		message = newmessage
	}
	player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
	if taskOptions.selectLanguage == 1 then
		window:addButton(task_pt_br.returnButton, function() sendTaskModalWindow(player) end)
	else
		window:addButton("Back", function() sendTaskModalWindow(player) end)
	end
	window:sendToPlayer(player)
end

function sendTaskModalWindow(player)
	local title = taskOptions.selectLanguage == 1 and task_pt_br.title or "Task System"
	local taskButtonMessage = taskOptions.selectLanguage == 1 and task_pt_br.choiceBoardText or "Choose a task and use the buttons below:"
	local window = ModalWindow{
		title = title,
		message = taskButtonMessage
	}
	local temptasks = {}
	for _, data in pairs (taskConfiguration) do
		temptasks[#temptasks+1] = data.storage
		if player:hasStartedTask(data.storage) then
			if taskOptions.selectLanguage == 1 then
				window:addChoice(data.name .. " ["..(player:getTaskKills(data.storagecount) >= data.total and "".. task_pt_br.choiceRewardOnHold .."]" or player:getTaskKills(data.storagecount).."/"..data.total.."]"))
			else
				window:addChoice(data.name .. " ["..(player:getTaskKills(data.storagecount) >= data.total and "Reward on Hold]" or player:getTaskKills(data.storagecount).."/"..data.total.."]"))
			end
		elseif player:canStartCustomTask(data.storage) == false then
			if data.type == "daily" then
				if taskOptions.selectLanguage == 1 then
					window:addChoice(data.name .. ", [".. task_pt_br.choiceDailyConclued .."]")
				else
					window:addChoice(data.name .. ", [Concluded Daily]")
				end
			else
				if taskOptions.selectLanguage == 1 then
					window:addChoice(data.name ..", [".. task_pt_br.choiceConclued .."]")
				else
					window:addChoice(data.name ..", [Concluded]")
				end
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
	if taskOptions.selectLanguage == 1 then
		window:addButton(task_pt_br.exitButton)
		window:addButton(task_pt_br.confirmButton, confirmCallback)
		window:addButton(task_pt_br.cancelButton, cancelCallback)
	else
		window:addButton("Exit")
		window:addButton("Choose", confirmCallback)
		window:addButton("Cancel", cancelCallback)
	end
	window:sendToPlayer(player)
end

function sendTaskModalCheck(player)
	local title = taskOptions.selectLanguage == 1 and task_pt_br.title or "Task System"
	local taskButtonMessage = taskOptions.selectLanguage == 1 and task_pt_br.choiceBoardText or "Choose a task and use the buttons below:"
	local window = ModalWindow{
		title = title,
		message = taskButtonMessage
	}
	local temptasks = {}
	for _, data in pairs (taskConfiguration) do
		temptasks[#temptasks+1] = data.storage
		if player:hasStartedTask(data.storage) then
			
			window:addChoice(data.name ..", ["..player:getTaskKills(data.storagecount).."/"..data.total.."]")
		end
	end
	
	if taskOptions.selectLanguage == 1 then
		window:addButton(task_pt_br.exitButton)
	else
		window:addButton("Exit")
	end
	window:sendToPlayer(player)
end

local task = Action()

function task.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
	if player then
		sendTaskModalWindow(player)
	end
	
	return false
end

task:id(28887)
task:register()


local taskTalk = TalkAction("!task")

function taskTalk.onSay(player, words, param)
	
	if player then
		sendTaskModalCheck(player)
	end
	
	return false
end

taskTalk:separator(" ")
taskTalk:register()