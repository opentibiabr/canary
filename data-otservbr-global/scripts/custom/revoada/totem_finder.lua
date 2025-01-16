local revoadaTotemFinder = Action()
local cities = {
	"Thais", --1
	"Carlin", --2
	"Ankrahmun", --3
	"Darashia", --4
	"Port Hope", --5
	"yalahar", --6
	"Edron", --7
	"Oramond", --8
}

function revoadaTotemFinder.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cityIndex = Game.getStorageValue(GlobalStorage.RevoadaTotemCityIndex) or 0
	if cityIndex < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Taberna Totem wasn't born yet!")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Taberna Totem was born in %s.", cities[cityIndex]))
	end
	return true
end

revoadaTotemFinder:id(64053)
revoadaTotemFinder:register()

----------------------------------------------------------------
local questRevoadaForge = Action()
function questRevoadaForge.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 31190 and item.uid == 20012 then
		local check = player:kv():scoped("totem-finder-quest"):get("completed") or false
		if not check then
			local inbox = player:getStoreInbox()
			if inbox then
				inbox:addItem(64053, 1)
				inbox:addItem(44740, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You have found 1 Taberna Totem Finder and 1 Stamina Refill!")
				player:kv():scoped("totem-finder-quest"):set("completed", true)
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already collected your reward!")
		end
	end
	return true
end

questRevoadaForge:id(31190)
questRevoadaForge:register()
