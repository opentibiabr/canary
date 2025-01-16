local modalBuyMW = Action()

function modalBuyMW.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player then
		player:registerEvent("modalBuyMW")
		local w = ModalWindow(0, "Escolha a Magic Wall.")
		for key, value in pairs(GetWallsCustom()) do
			if not playerHaveCustomWall(player, key) then
				w:addChoice(key, value.cor)
			end
		end
		w:addButton(0, "Ok")
		w:addButton(1, "Voltar")
		w:setDefaultEnterButton(0)
		w:setDefaultEscapeButton(1)
		w:sendToPlayer(player)
		return true
	end
end

modalBuyMW:id(ITEM_MAGIC_WALL_CUSTOM)
modalBuyMW:register()

local creatureBuyMW = CreatureEvent("modalBuyMW")

function creatureBuyMW.onModalWindow(player, modalWindowId, buttonId, choiceId)
	if player then
		player:unregisterEvent("modalBuyMW")
		local mwEscolhida = GetCustomMagicWallByStorage(choiceId)
		if buttonId == 0 and player:getItemCount(ITEM_MAGIC_WALL_CUSTOM) >= 1 and mwEscolhida then
			if player:removeItem(ITEM_MAGIC_WALL_CUSTOM, 1) then
				local playerKV = player:kv()
				playerKV:set("custommagicwall." .. choiceId .. ".purchased", 1)
				playerKV:set("activemagicwall", choiceId)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce comprou a MW " .. mwEscolhida.cor)
			end
		end
	end
	return true
end

creatureBuyMW:type("modalwindow")
creatureBuyMW:register()

local modalChangeMW = TalkAction("!changemw", "!mw", "!mudarmw")

function modalChangeMW.onSay(player, words, param)
	if player then
		player:registerEvent("modalChangeMW")
		local w = ModalWindow(0, "Escolha a Magic Wall.")
		w:addChoice(0, "padrao")
		for key, value in pairs(GetWallsCustom()) do
			if playerHaveCustomWall(player, key) then
				w:addChoice(key, value.cor)
			end
		end
		w:addButton(0, "Ok")
		w:addButton(1, "Voltar")
		w:setDefaultEnterButton(0)
		w:setDefaultEscapeButton(1)
		w:sendToPlayer(player)
		return true
	end
end
modalChangeMW:groupType("normal")
modalChangeMW:register()

local creatureChangeMW = CreatureEvent("modalChangeMW")

function creatureChangeMW.onModalWindow(player, modalWindowId, buttonId, choiceId)
	if player then
		local playerKV = player:kv()
		player:unregisterEvent("modalChangeMW")
		if buttonId == 0 then
			if choiceId == 0 then
				playerKV:set("activemagicwall", choiceId)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce escolheu a MW padrao")
			else
				local mwEscolhida = GetCustomMagicWallByStorage(choiceId)
				playerKV:set("activemagicwall", choiceId)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce escolheu a MW " .. mwEscolhida.cor)
			end
		end
	end
	return true
end

creatureChangeMW:type("modalwindow")
creatureChangeMW:register()

function containsSpecificElement(table, element)
	local concatenated = table.concat(table, ",")
	return string.find(concatenated, element) ~= nil
end
