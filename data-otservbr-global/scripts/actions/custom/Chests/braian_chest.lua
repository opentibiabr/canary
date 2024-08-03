local rewards = {
    { id = 36656, name = "eldritch shield" },
    { id = 36657, name = "eldritch claymore" },
    { id = 36658, name = "gilded eldritch claymore" },
    { id = 36659, name = "eldritch warmace" },
    { id = 36660, name = "gilded eldritch warmace" },
    { id = 36661, name = "eldritch greataxe" },
    { id = 36662, name = "gilded eldritch greataxe" },
    { id = 36663, name = "eldritch cuirass" },
    { id = 36664, name = "eldritch bow" },
    { id = 36665, name = "gilded eldritch bow" },
    { id = 36666, name = "eldritch quiver" },
    { id = 36667, name = "eldritch breeches" },
	{ id = 36668, name = "eldritch wand" },
	{ id = 36669, name = "gilded eldritch wand" },
	{ id = 36670, name = "eldritch cowl" },
	{ id = 36671, name = "eldritch hood" },
	{ id = 36672, name = "eldritch folio" },
	{ id = 36673, name = "eldritch tome" },
	{ id = 36674, name = "eldritch rod" },
	{ id = 36675, name = "gilded eldritch rod" }
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

bagyouCovet:id(49613)
bagyouCovet:register()