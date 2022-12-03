local rewards = {
    { id = 39147, name = "spiritthorn armor" },
    { id = 39148, name = "spiritthorn helmet" },
    { id = 39149, name = "alicorn headguard" },
    { id = 39150, name = "alicorn quiver" },
    { id = 39151, name = "arcanomancer regalia" },
    { id = 39152, name = "arcanomancer folio" },
    { id = 39153, name = "arboreal crown" },
    { id = 39154, name = "arboreal tome" },
    { id = 39177, name = "spiritthorn ring" },
    { id = 39180, name = "alicorn ring" },
    { id = 39183, name = "arcanomancer sigil" },
    { id = 38186, name = "arboreal ring" }
}

local primalBag = Action()

function primalBag.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]

	player:addItem(rewardItem.id, 1)
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received one ' .. rewardItem.name .. '.')
	return true
end

primalBag:id(39546)
primalBag:register()
