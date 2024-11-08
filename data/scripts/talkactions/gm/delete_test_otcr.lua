local talkAction = TalkAction("!testOTCR")

local options = {
	Creature = {
		{
			name = "set attach Effect 7",
			action = function(player)
				player:attachEffectById(7)
			end,
		},
		{
			name = "get all attach Effect",
			action = function(player)
				local effects = player:getAttachedEffects()
				if #effects > 0 then
					local effectsString = "your AE are: " .. table.concat(effects, ", ")
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, effectsString)
				else
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "you do not have any AE.")
				end
			end,
		},
		{
			name = "detach Effect 7",
			action = function(player)
				player:detachEffectById(7)
			end,
		},
		{
			name = "set Shader player",
			action = function(player)
				player:setShader("Outfit - Rainbow")
			end,
		},
		{
			name = "no shader player",
			action = function(player)
				player:setShader("")
			end,
		},
		{
			name = "get Shader player",
			action = function(player)
				player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, player:getShader())
			end,
		},
	},
	Map = {
		{
			name = "set Shader Map",
			action = function(player)
				player:setMapShader("Map - Party")
			end,
		},
		{
			name = "no shader Map",
			action = function(player)
				player:setMapShader("")
			end,
		},
		{
			name = "get Shader Map",
			action = function(player)
				player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, player:getMapShader())
			end,
		},
	},
	Items = { {
		name = "Shader",
		action = function(player)
			local item = player:addItem(ITEM_BAG, 1, false, CONST_SLOT_BACKPACK)
			item:setShader("Map - Party")
			player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "item have shader : " .. item:getShader())
		end,
	} },
	game_outfit = {
		{
			name = "Add permanent aura 8 to first player",
			action = function(player)
				local spectators = Game.getSpectators(player:getPosition(), false, false)
				if #spectators > 0 then
					for _, spectator in ipairs(spectators) do
						if spectator:isPlayer() and spectator:getId() ~= player:getId() then
							spectator:addCustomOutfit("aura", 8)
							player:say(spectator:getName() .. " add aura 8", TALKTYPE_SAY)
							break
						end
					end
				end
			end,
		},
		{
			name = "remove permanent aura 8 to first player",
			action = function(player)
				local spectators = Game.getSpectators(player:getPosition(), false, false)
				if #spectators > 0 then
					for _, spectator in ipairs(spectators) do
						if spectator:isPlayer() and spectator:getId() ~= player:getId() then
							spectator:removeCustomOutfit("aura", 8)
							player:say(spectator:getName() .. " remove aura 8", TALKTYPE_SAY)
							break
						end
					end
				end
			end,
		},
		{
			name = "pdump auras",
			action = function(player)
				local effects = Game.getAllAttachedeffects("aura")
				if #effects > 0 then
					local ids = {}
					for _, effect in ipairs(effects) do
						table.insert(ids, effect.id)
					end
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "aura registered on the server: " .. table.concat(ids, ", "))
				else
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "the server did not charge aura check .xml")
				end
			end,
		},
		{
			name = "pdump wing",
			action = function(player)
				local effects = Game.getAllAttachedeffects("wing")
				if #effects > 0 then
					local ids = {}
					for _, effect in ipairs(effects) do
						table.insert(ids, effect.id)
					end
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "wing registered on the server: " .. table.concat(ids, ", "))
				else
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "the server did not charge wing check .xml")
				end
			end,
		},
		{
			name = "pdump effect",
			action = function(player)
				local effects = Game.getAllAttachedeffects("effect")
				if #effects > 0 then
					local ids = {}
					for _, effect in ipairs(effects) do
						table.insert(ids, effect.id)
					end
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "effect registered on the server: " .. table.concat(ids, ", "))
				else
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "the server did not charge effect check .xml")
				end
			end,
		},
		{
			name = "pdump shader",
			action = function(player)
				local effects = Game.getAllAttachedeffects("shader")
				if #effects > 0 then
					local ids = {}
					for _, effect in ipairs(effects) do
						table.insert(ids, effect.name)
					end
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "shader registered on the server: " .. table.concat(ids, ", "))
				else
					player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "the server did not charge shader check .xml")
				end
			end,
		},
	},
}

function talkAction.onSay(player, words, param, type)
	local modalWindow = ModalWindow({
		title = "Fast Test",
		message = "Choose one of the following options:",
	})

	for category, subOptions in pairs(options) do
		modalWindow:addChoice(category, function(player, button, choice)
			local subModalWindow = ModalWindow({
				title = "Select a Sub-Option",
				message = "Choose one of the following sub-options for " .. category .. ":",
			})

			for _, subOption in ipairs(subOptions) do
				subModalWindow:addChoice(subOption.name, function(plyr, btn, ch)
					if button.name == "OK" then
						subOption.action(plyr)
					end
				end)
			end

			subModalWindow:addButton("OK")
			subModalWindow:addButton("Cancel", function(plyr)
				subModalWindow:clear()
			end)
			subModalWindow:sendToPlayer(player)
		end)
	end

	modalWindow:addButton("OK")
	modalWindow:addButton("Cancel", function(player)
		modalWindow:clear()
	end)
	modalWindow:sendToPlayer(player)
	return false
end

talkAction:groupType("gamemaster")
talkAction:separator(" ")
talkAction:register()

local playerLoginTestOTCR = CreatureEvent("simpletest")

function playerLoginTestOTCR.onLogin(player)
	if not player then
		return false
	end
	if player:getClient().os >= 10 and player:getClient().os < 20 then
		player:say("say !testOTCR", TALKTYPE_SAY)
	end
	return true
end

playerLoginTestOTCR:register()
