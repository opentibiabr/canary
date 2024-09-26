function endTaskModalWindow(player, storage)
	local data = getTaskByStorage(storage)
	local newmessage
	local completion = false
	if player:getTaskKills(data.storagecount) < data.total then
		if taskOptions.selectLanguage == 1 then
			newmessage = task_pt_br.missionError
		else
			newmessage = "You have completed or are in progress on this task."
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
				player:say('Redeemed reward:', TALKTYPE_MONSTER_SAY)
				else
				player:say('Redeemed reward:', TALKTYPE_MONSTER_SAY)
				end
			for _, info in pairs (data.rewards) do
				if info[1] == "exp" then
					player:addExperience(info[2]*taskOptions.bonusRate)
					player:getPosition():sendMagicEffect(CONST_ME_PRISMATIC_SPARK)
					player:say('Exp: '.. info[2]*taskOptions.bonusRate ..'', TALKTYPE_MONSTER_SAY)
					if taskOptions.selectLanguage == 1 then
						window:addChoice(task_pt_br.choiceText ..""..info[2]*taskOptions.bonusRate)
					else
						window:addChoice("- Experience: "..info[2]*taskOptions.bonusRate)
					end
				elseif tonumber(info[1]) then
					window:addChoice("- ".. info[2]*taskOptions.bonusRate .." "..ItemType(info[1]):getName())
					player:addItem(info[1], info[2]*taskOptions.bonusRate)
					player:getPosition():sendMagicEffect(CONST_ME_PRISMATIC_SPARK)
					if taskOptions.selectLanguage == 1 then
					player:say('Others: '..  info[2]*taskOptions.bonusRate .. ' ' ..ItemType(info[1]):getName(), TALKTYPE_MONSTER_SAY)
					else
					player:say('Others: '..  info[2]*taskOptions.bonusRate .. ' ' ..ItemType(info[1]):getName(), TALKTYPE_MONSTER_SAY)
					end
					player:setStorageValue(storagecheck, player:getStorageValue(storagecheck) + 1)
-- SISTEMA PUNTOS TASK ALA BASE DE DATOS
				elseif info[1] == "puntostask" then
					local puntostask = tonumber(info[2])
					-- Asegúrate de tener la conexión a la base de datos antes de ejecutar esta línea
					db.storeQuery("UPDATE players SET puntostask = puntostask + ? WHERE id = ?", puntostask, player:getGuid())


					
					if taskOptions.selectLanguage == 2 then
						window:addChoice("- Task Points: " .. puntostask)
						player:say('Task Points: ' .. puntostask, TALKTYPE_MONSTER_SAY)
					else
						window:addChoice("- Task Points: " .. puntostask)
						player:say('Task Points: ' .. puntostask, TALKTYPE_MONSTER_SAY)
					end
				end
			end
-- SISTEMA PUNTOS TASK ALA BASE DE DATOS
			elseif taskOptions.selectLanguage == 1 then
				player:say('Recompensa canjeada:', TALKTYPE_MONSTER_SAY)
				else
				player:say('Recompensa canjeada:', TALKTYPE_MONSTER_SAY)
				end
			for _, info in pairs (data.rewards) do
				if info[1] == "exp" then
					player:addExperience(info[2])
					player:getPosition():sendMagicEffect(CONST_ME_PRISMATIC_SPARK)
					player:say('Exp: '.. info[2] ..'', TALKTYPE_MONSTER_SAY)
					if taskOptions.selectLanguage == 1 then
						window:addChoice(task_pt_br.choiceText ..""..info[2])
					else
						window:addChoice("- Experience: "..info[2])
					end
				elseif tonumber(info[1]) then
					window:addChoice("- ".. info[2] .." "..ItemType(info[1]):getName())
					player:addItem(info[1], info[2])
					player:getPosition():sendMagicEffect(CONST_ME_PRISMATIC_SPARK)
					if taskOptions.selectLanguage == 1 then
					player:say('Otros: '.. ItemType(info[1]):getName() .. '', TALKTYPE_MONSTER_SAY)
					else
					player:say('Otros: '.. ItemType(info[1]):getName() .. '', TALKTYPE_MONSTER_SAY)
					end
					player:setStorageValue(storagecheck, player:getStorageValue(storagecheck) + 1)
-- PUNTOS TASK
				elseif info[1] == "puntostask" then
					local puntostask = tonumber(info[2])
					-- Asegúrate de tener la conexión a la base de datos antes de ejecutar esta línea
					
					db.storeQuery("UPDATE players SET puntostask = puntostask + ? WHERE id = ?", puntostask, player:getGuid())


					
					if taskOptions.selectLanguage == 2 then
						window:addChoice("- Task Points: " .. puntostask)
						player:say('Task Points: ' .. puntostask, TALKTYPE_MONSTER_SAY)
					else
						window:addChoice("- Task Points: " .. puntostask)
						player:say('Task Points: ' .. puntostask, TALKTYPE_MONSTER_SAY)
					end
				end
			end
		end
-- PUNTOS TASK
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
			window:addChoice("Puedes repetir: Siempre!")
		elseif data.type == "once" then
			window:addChoice("Puedes repetir: Solo una vez!")
		end
	end
	if data.rewards then
		if taskOptions.selectLanguage == 1 then
			window:addChoice(task_pt_br.choiceReward)
		else
			window:addChoice("rewards:")
		end
	
		local puntostask = player:getStorageValue(taskOptions.puntostaskStorage) -- Ajusta según tu configuración real
	
		if player:getStorageValue(taskOptions.bonusReward) >= 1 then
			for _, info in pairs(data.rewards) do
				if info[1] == "exp" then
					if taskOptions.selectLanguage == 1 then
						window:addChoice(task_pt_br.choiceText .. "" .. info[2]*taskOptions.bonusRate)
					else
						window:addChoice("- Experience: " .. info[2]*taskOptions.bonusRate)
					end
				elseif info[1] == "puntostask" then
					window:addChoice("- Task Points: " .. info[2])
				elseif tonumber(info[1]) then
					window:addChoice("- " .. info[2]*taskOptions.bonusRate .. " " .. ItemType(info[1]):getName())
				end
			end
		else
			for _, info in pairs(data.rewards) do
				if info[1] == "exp" then
					if taskOptions.selectLanguage == 1 then
						window:addChoice(task_pt_br.choiceText .. "" .. info[2])
					else
						window:addChoice("- Experience: " .. info[2])
					end
				elseif info[1] == "puntostask" then
					window:addChoice("- Task Points: " .. info[2])
				elseif tonumber(info[1]) then
					window:addChoice("- " .. info[2] .. " " .. ItemType(info[1]):getName())
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
			newmessage = "You cannot cancel this task because it is already completed or has not started.."
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

-- TIENDA DE TASK
local tiendaProductos = {
    {nombre = "___Addon Items___", itemId = 1, costo = 0},     
	{nombre = "Nose Ring", itemId = 5804, costo = 700},
	{nombre = "Simon's Favorite Staff", itemId = 6107, costo = 700},
	{nombre = "Vampiric Crest", itemId = 9041, costo = 700},
	{nombre = "Dragon Claw", itemId = 5919, costo = 700},
    {nombre = "Sedge Hat", itemId = 11700, costo = 700},
    {nombre = "Small Golden Anchor", itemId = 14019, costo = 700},
	{nombre = "Crude Wood Planks", itemId = 27657, costo = 500},
	{nombre = "Tinged Pot", itemId = 27656, costo = 500},
    {nombre = "Badbara", itemId = 30362, costo = 700},
    {nombre = "Whinona", itemId = 12575, costo = 700},
    {nombre = "Cryana", itemId = 30364, costo = 700},
    {nombre = "Tearesa", itemId = 30363, costo = 700},
    {nombre = "___Items Variados___", itemId = 1, costo = 0},
	{nombre = "Blossom Bag", itemId = 25780, costo = 200},
	{nombre = "Bear Skin", itemId = 31578, costo = 150},
	{nombre = "Zaoan Chess Box", itemId = 18339, costo = 300},
    {nombre = "___Mount Items___", itemId = 1, costo = 0},
	{nombre = "Colourful Water Lily", itemId = 39548, costo = 350},
	{nombre = "Control Unit", itemId = 21186, costo = 100},
	{nombre = "Diapason", itemId = 12547, costo = 250},
	{nombre = "Four-Leaf Clover", itemId = 14143, costo = 600},
	{nombre = "Golem Wrench", itemId = 16251, costo = 200},
	{nombre = "Hunting Horn", itemId = 12260, costo = 200},
	{nombre = "Leech", itemId = 17858, costo = 150},
	{nombre = "Nail Case", itemId = 19136, costo = 250},
	{nombre = "The Lion's Heart", itemId = 21439, costo = 250},
	
	
 -- Agrega más productos según sea necesario
}
-- TIENDA DE TASK

function sendTaskModalWindow(player)
	local title = taskOptions.selectLanguage == 1 and task_pt_br.title or "Task System"
	local taskButtonMessage = taskOptions.selectLanguage == 1 and task_pt_br.choiceBoardText or "Choose a Task, Cancel or go to the Shop:"
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
				window:addChoice(data.name .. " ["..(player:getTaskKills(data.storagecount) >= data.total and "Waiting reward]" or player:getTaskKills(data.storagecount).."/"..data.total.."]"))
			end
		elseif player:canStartCustomTask(data.storage) == false then
			if data.type == "daily" then
				if taskOptions.selectLanguage == 1 then
					window:addChoice(data.name .. ", [".. task_pt_br.choiceDailyConclued .."]")
				else
					window:addChoice(data.name .. ", [Completed daily]")
				end
			else
				if taskOptions.selectLanguage == 1 then
					window:addChoice(data.name ..", [".. task_pt_br.choiceConclued .."]")
				else
					window:addChoice(data.name ..", [Finished]")
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
	--logica para la tienda-.-
    local function tiendaCallback(player, button, choice)
        local title = taskOptions.selectLanguage == 2 and "Shop" or "Shop"
        local message = taskOptions.selectLanguage == 2 and "Buy your Addon Items or various items!" or "Purchase of Addon Items and miscellaneous items!"

        local shopWindow = ModalWindow{
            title = title,
            message = message
        }
    -- Agrega elementos de la tienda a la ventana modal
for index, producto in ipairs(tiendaProductos) do
    local costo = producto.costo
    local itemId = producto.itemId

    shopWindow:addChoice(producto.nombre .. " - cost: " .. costo .. " points", function()
        -- Aquí deduces los puntostask del jugador y le das el artículo
        local puntostaskJugador = player:getStorageValue("puntostask") or 0

		if puntostaskJugador >= costo then
			-- Deducción de puntostask y entrega del artículo
			player:setStorageValue("puntostask", puntostaskJugador - costo)
			player:addItem(itemId, 1)
		
			-- Actualización de la base de datos
			local updateQuery = string.format("UPDATE `players` SET `puntostask` = %d WHERE `id` = %d", puntostaskJugador - costo, playerId)
			db.query(updateQuery)
		
			player:say("Successful purchase!", TALKTYPE_MONSTER_SAY)
		else
			player:say("You do not have enough task points.", TALKTYPE_MONSTER_SAY)
		end
    end)
end

	shopWindow:addButton("Buy", shopCallback)  -- Agrega esta línea

    shopWindow:addButton("Close", function() sendTaskModalWindow(player) end)
    shopWindow:sendToPlayer(player)
end

function shopCallback(player, _, choice)
    -- Obtén el ID del jugador
    local playerId = player:getGuid()

    -- Consulta para obtener los puntostask del jugador
    local playerPointsQuery = db.storeQuery('SELECT `puntostask` FROM `players` WHERE `id` =' .. playerId .. ' LIMIT 1;')

    if playerPointsQuery then
        local puntostaskJugador = Result.getNumber(playerPointsQuery, "puntostask") or 0

        -- Aquí deberías mostrar las opciones de compra
        local choiceIndex = choice.id  -- Esto es un ejemplo, debes ajustarlo según tu lógica

        -- Obtén información del producto seleccionado
        local producto = tiendaProductos[choiceIndex]
        local costo = producto.costo
        local itemId = producto.itemId

        if puntostaskJugador >= costo then
            -- Deducción de puntostask y entrega del artículo
            player:setStorageValue("puntostask", puntostaskJugador - costo)
            player:addItem(itemId, 1)

            -- Actualización de la base de datos
            local updateQuery = string.format("UPDATE `players` SET `puntostask` = %d WHERE `id` = %d", puntostaskJugador - costo, playerId)
            db.query(updateQuery)

            player:say("Successful purchase!", TALKTYPE_MONSTER_SAY)
        else
            player:say("You do not have enough task points.", TALKTYPE_MONSTER_SAY)
        end
    else
        -- Manejo de errores si la consulta no es exitosa
        player:say("Error getting task points from player. please try again.", TALKTYPE_MONSTER_SAY)
    end
end

	if taskOptions.selectLanguage == 1 then
		window:addButton(task_pt_br.exitButton)
		window:addButton(task_pt_br.confirmButton, confirmCallback)
		window:addButton(task_pt_br.cancelButton, cancelCallback)
	else
		window:addButton("exit")
		window:addButton("choose", confirmCallback)
		window:addButton("Cancel", cancelCallback)
		window:addButton("Shop", tiendaCallback)
	end

	window:sendToPlayer(player)
end


local task = Action()

function task.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local function getPositionTileItem(pos)
		local p = player:getPosition()
		if p.y ~= pos.y then
			return {{x = pos.x - 1, y = pos.y, z = pos.z}, {x = pos.x + 1, y = pos.y, z = pos.z}}
		elseif p.x ~= pos.x then
			return {{x = pos.x, y = pos.y + 1, z = pos.z}, {x = pos.x, y = pos.y - 1, z = pos.z}}
		elseif p.xy ~= pos.xy then
			return {{x = pos.x + 1, y = pos.y + 1, z = pos.z}, {x = pos.x - 1, y = pos.y - 1, z = pos.z}}
		elseif p.yx ~= pos.yx then
			return {{x = pos.x - 1, y = pos.y + 1, z = pos.z}, {x = pos.x + 1, y = pos.y - 1, z = pos.z}}
		end
	end
	
	local isInRange = false
	for _, itemPositionTile in ipairs(taskOptions.taskBoardPositions) do
		local positionTiles = getPositionTileItem(itemPositionTile)
		for _, pos in ipairs(positionTiles) do
			if player:getPosition():getDistance(pos) <= 1 then
				isInRange = true
				break
			end
		end
		if isInRange then
			break
		end
	end
	
	if isInRange then
		player:getPosition():sendMagicEffect(CONST_ME_TREASURE_MAP)
		sendTaskModalWindow(player)
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		if taskOptions.selectLanguage == 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. task_pt_br.messageTaskBoardError .."")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The quest board is too far away or this is not the correct quest board.")
		end
	end
	
	return false
end

task:id(43705) -- el objeto que al hacerle click abre la ventana modal de las misiones.
task:register()