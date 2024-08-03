local rewards = {
    { id = 20089, name = "umbral spellbook" },
    { id = 43886, name = "grand sanguine rod" },
    { id = 34151, name = "lion rod" },
    { id = 39154, name = "arboreal tome" },
    { id = 30400, name = "cobra rod" },
    { id = 39163, name = "naga rod" },
    { id = 34153, name = "lion spellbook" },
    { id = 34091, name = "soulhexer" },
    { id = 36673, name = "eldritch folio" },
    { id = 43885, name = "sanguine rod" },
    { id = 20090, name = "umbral master spellbook" },
    { id = 28716, name = "falcon rod" }
}

local bagyouCovet = Action()

function bagyouCovet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]

	player:addItem(rewardItem.id, 1)
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewardItem.name .. '.')
	return true
end

bagyouCovet:id(44929)
bagyouCovet:register()