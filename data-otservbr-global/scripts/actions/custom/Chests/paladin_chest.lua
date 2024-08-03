local rewards = {
    { id = 34098, name = "pair of soulstalkers" },
    { id = 43881, name = "sanguine greaves" },
    { id = 27648, name = "gnome armor" },
    { id = 39149, name = "alicorn headguard" },
    { id = 31579, name = "embrace of nature" },
    { id = 36667, name = "eldritch breechess" },
    { id = 39161, name = "feverbloom boots" },
    { id = 34156, name = "lion spangenhelm" },
    { id = 32617, name = "fabulous legs" },
    { id = 34094, name = "soulshell" },
    { id = 11689, name = "elite draken helmet" },
	{ id = 3555, name = "golden boots" }
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

bagyouCovet:id(44904)
bagyouCovet:register()