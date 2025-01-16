local feature = TalkAction("!autoloot")

local validValues = {
	-- "all",
	"on",
	"off",
}

function feature.onSay(player, words, param)
	if not configManager.getBoolean(configKeys.AUTOLOOT) then
		return true
	end
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) and configManager.getBoolean(configKeys.VIP_AUTOLOOT_VIP_ONLY) and not player:isVip() then
		player:sendCancelMessage("You need to be VIP to use this command!")
		return true
	end
	if not table.contains(validValues, param) then
		local validValuesStr = table.concat(validValues, "/")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid param specified. Usage: !feature [" .. validValuesStr .. "]")
		return true
	end

	if param == "all" then
		player:setFeature(Features.AutoLoot, 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "AutoLoot is now enabled for all kills (including bosses).")
	elseif param == "on" then
		player:setFeature(Features.AutoLoot, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "AutoLoot is now enabled for all regular kills (no bosses).")
	elseif param == "off" then
		player:setFeature(Features.AutoLoot, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "AutoLoot is now disabled.")
	end
	return true
end

feature:separator(" ")
feature:groupType("normal")
feature:register()

------------ Manage Loot (used in otc) ------------
AutoLootConfig = {
	storage = 70000,
	freeAccountLimit = 20,
	premiumAccountLimit = 40,
}
local manageloot = TalkAction("!manageloot")

function manageloot.onSay(player, words, param, type)
	local oldProtocol = player:getClient().version < 1200
	if not oldProtocol then
		player:sendCancelMessage("Only old protocol allowed.")
		return
	end

	local split = param:splitTrimmed(",")
	local action = split[1]
	if not action then
		player:showTextDialog(2160, string.format("Examples of use:\n%s add,gold coin\n%s remove,gold coin\n%s clear\n%s show\n\n~Available slots~\nfreeAccount: %d\npremiumAccount: %d", words, words, words, words, AutoLootConfig.freeAccountLimit, AutoLootConfig.premiumAccountLimit), false)
		return false
	end

	if action == "clear" then
		setPlayerAutolootItems(player, {})
		player:sendCancelMessage("Autoloot list cleaned.")
	elseif action == "show" then
		local items = getPlayerAutolootItems(player)
		local description = { string.format("~ Your autoloot list, capacity: %d/%d ~\n", #items, getPlayerLimit(player)) }
		for i, itemId in pairs(items) do
			description[#description + 1] = string.format("%d) %s", i, ItemType(itemId):getName())
		end
		player:showTextDialog(2160, table.concat(description, "\n"), false)
	else
		if not table.contains({ "add", "remove" }, action) then
			player:showTextDialog(2160, string.format("Examples of use:\n%s add,gold coin\n%s remove,gold coin\n%s clear\n%s show\n\n~Available slots~\nfreeAccount: %d\npremiumAccount: %d", words, words, words, words, AutoLootConfig.freeAccountLimit, AutoLootConfig.premiumAccountLimit), false)
			return false
		end

		local id = split[2]
		local itemType = ItemType(id)
		if id < 1 or not itemType then
			player:sendCancelMessage(string.format("The item %s does not exists!", id))
			return false
		end

		if action == "add" then
			local limits = getPlayerLimit(player)
			if #getPlayerAutolootItems(player) >= limits then
				player:sendCancelMessage(string.format("Your auto loot only allows you to add %d items.", limits))
				return false
			end

			if addPlayerAutolootItem(player, itemType:getId()) then
				player:sendCancelMessage(string.format("Perfect you have added to the list: %s", itemType:getName()))
			else
				player:sendCancelMessage(string.format("The item %s already exists!", itemType:getName()))
			end
		elseif action == "remove" then
			if removePlayerAutolootItem(player, itemType:getId()) then
				player:sendCancelMessage(string.format("Perfect you have removed to the list the article: %s", itemType:getName()))
			else
				player:sendCancelMessage(string.format("The item %s does not exists in the list.", itemType:getName()))
			end
		end
	end

	return true
end

manageloot:groupType("normal")
manageloot:separator(" ")
--manageloot:register()
