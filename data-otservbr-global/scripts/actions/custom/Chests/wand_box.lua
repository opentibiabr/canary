local rewards = {
    { id = 20089, name = "umbral spellbook" },
    { id = 43882, name = "sanguine coil" },
    { id = 40594, name = "alchemist's notepad" },
    { id = 39152, name = "arcanomancer folio" },
    { id = 30399, name = "cobra wand" },
    { id = 39162, name = "naga wand" },
    { id = 34153, name = "lion spellbook" },
    { id = 34090, name = "soultainter" },
    { id = 36672, name = "eldritch folio" },
    { id = 43883, name = "grand sanguine coil" },
    { id = 20090, name = "umbral master spellbook" },
    { id = 34152, name = "lion wand" }
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

bagyouCovet:id(44928)
bagyouCovet:register()