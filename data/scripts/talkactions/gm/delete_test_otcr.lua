local talkAction = TalkAction("!testOTCR")

local options = {
	["Creature"] = {
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
	["Map"] = {
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
	["Item"] = { {
		name = "Shader",
		action = function(player)
			local item = player:addItem(ITEM_BAG, 1, false, CONST_SLOT_BACKPACK)
			item:setShader("Map - Party")
			player:sendTextMessage(MESSAGE_GAMEMASTER_CONSOLE, "item have shader : " .. item:getShader())
		end,
	} },
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
				subModalWindow:addChoice(subOption.name, function(player, button, choice)
					if button.name == "OK" then
						subOption.action(player)
					end
				end)
			end

			subModalWindow:addButton("OK")
			subModalWindow:addButton("Cancel")
			subModalWindow:sendToPlayer(player)
		end)
	end

	modalWindow:addButton("OK")
	modalWindow:addButton("Cancel")
	modalWindow:sendToPlayer(player)
	return false
end

talkAction:groupType("gamemaster")
talkAction:separator(" ")
talkAction:register()
