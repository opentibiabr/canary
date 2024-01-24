local rewards = {
	{ id = 43864, name = "Sanguine Blade" },
	{ id = 43866, name = "Sanguine Cudgel" },
	{ id = 43868, name = "Sanguine Hatchet" },
	{ id = 43870, name = "Sanguine Razor" },
	{ id = 43872, name = "Sanguine Bludgeon" },
	{ id = 43874, name = "Sanguine Battleaxe" },
	{ id = 43876, name = "Sanguine Legs" },
	{ id = 43877, name = "Sanguine Bow" },
	{ id = 43879, name = "Sanguine Crossbow" },
	{ id = 43881, name = "Sanguine Greaves" },
	{ id = 43882, name = "Sanguine Coil" },
	{ id = 43884, name = "Sanguine Boots" },
	{ id = 43885, name = "Sanguine Rod" },
	{ id = 43887, name = "Sanguine Galoshes" },
}

BagYouCovetId = 43898

local bagyouCovet = Action()

function bagyouCovet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]

	player:addItem(rewardItem.id, 1)
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a " .. rewardItem.name .. ".")

	local text = player:getName() .. " received a " .. rewardItem.name .. " from a " .. item:getName() .. "."
	local vocation = player:vocationAbbrev()
	Webhook.sendMessage(":game_die: " .. player:getMarkdownLink() .. " received a **" .. rewardItem.name .. "** from a _" .. item:getName() .. "_.")
	Broadcast(text, function(targetPlayer)
		return targetPlayer ~= player
	end)
	return true
end

bagyouCovet:id(BagYouCovetId)
bagyouCovet:register()
