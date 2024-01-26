local rewards = {
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
}

PrimalBagId = 39546
local primalBag = Action()

function primalBag.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end
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

primalBag:id(PrimalBagId)
primalBag:register()
