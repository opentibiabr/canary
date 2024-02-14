local rewardBags = {
	[BAG_YOU_DESIRE] = {
		{ id = 34082, name = "soulcutter" },
		{ id = 34083, name = "soulshredder" },
		{ id = 34084, name = "soulbiter" },
		{ id = 34085, name = "souleater" },
		{ id = 34086, name = "soulcrusher" },
		{ id = 34087, name = "soulmaimer" },
		{ id = 34097, name = "pair of soulwalkers" },
		{ id = 34099, name = "soulbastion" },
		{ id = 34088, name = "soulbleeder" },
		{ id = 34089, name = "soulpiercer" },
		{ id = 34094, name = "soulshell" },
		{ id = 34098, name = "pair of soulstalkers" },
		{ id = 34090, name = "soultainter" },
		{ id = 34092, name = "soulshanks" },
		{ id = 34095, name = "soulmantle" },
		{ id = 34091, name = "soulhexer" },
		{ id = 34093, name = "soulstrider" },
		{ id = 34096, name = "soulshroud" },
	},

	[PRIMAL_BAG] = {
		{ id = 39147, name = "spiritthorn armor" },
		{ id = 39148, name = "spiritthorn helmet" },
		{ id = 39177, name = "charged spiritthorn ring" },
		{ id = 39149, name = "alicorn headguard" },
		{ id = 39150, name = "alicorn quiver" },
		{ id = 39180, name = "charged alicorn ring" },
		{ id = 39151, name = "arcanomancer regalia" },
		{ id = 39152, name = "arcanomancer folio" },
		{ id = 39183, name = "charged arcanomancer sigil" },
		{ id = 39153, name = "arboreal crown" },
		{ id = 39154, name = "arboreal tome" },
		{ id = 39186, name = "charged arboreal ring" },
	},

	[BAG_YOU_COVET] = {
		{ id = 43864, name = "sanguine blade" },
		{ id = 43866, name = "sanguine cudgel" },
		{ id = 43868, name = "sanguine hatchet" },
		{ id = 43870, name = "sanguine razor" },
		{ id = 43872, name = "sanguine bludgeon" },
		{ id = 43874, name = "sanguine battleaxe" },
		{ id = 43876, name = "sanguine legs" },
		{ id = 43877, name = "sanguine bow" },
		{ id = 43879, name = "sanguine crossbow" },
		{ id = 43881, name = "sanguine greaves" },
		{ id = 43882, name = "sanguine coil" },
		{ id = 43884, name = "sanguine boots" },
		{ id = 43885, name = "sanguine rod" },
		{ id = 43887, name = "sanguine galoshes" },
	},
}

local randomItems = Action()

function randomItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardBag = rewardBags[item.itemid]
	if not rewardBag then
		return false
	end

	local randomIndex = math.random(1, #rewardBag)
	local rewardItem = rewardBag[randomIndex]
	player:addItem(rewardItem.id, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a " .. rewardItem.name .. ".")

	local text = player:getName() .. " received a " .. rewardItem.name .. " from a " .. item:getName() .. "."
	Webhook.sendMessage(":game_die: " .. player:getMarkdownLink() .. " received a **" .. rewardItem.name .. "** from a _" .. item:getName() .. "_.")
	Broadcast(text, function(targetPlayer)
		return targetPlayer ~= player
	end)

	item:remove(1)
	return true
end

for itemId, info in pairs(rewardBags) do
	randomItems:id(tonumber(itemId))
end

randomItems:register()
