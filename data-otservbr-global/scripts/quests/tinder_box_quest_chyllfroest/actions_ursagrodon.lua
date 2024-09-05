local config = {
	item1 = 20358,
	item2 = 20359,
	item3 = 20360,
	item4 = 20361,
	percentage = 90,
	storageKey = Storage.Quest.U10_37.TinderBoxQuestChyllfroest.Obedience,
}

local function revertIce(toPosition)
	local tile = toPosition:getTile()
	if tile then
		local thing = tile:getItemById(config.item4)
		if thing then
			thing:transform(config.item1)
		end
	end
end

local ursagrodon = Action()

function ursagrodon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rand = math.random(1, 100)
	local currentDate = os.date("*t")

	if currentDate.month < 4 or currentDate.month > 5 or (currentDate.month == 5 and currentDate.day > 1) then
		return player:sendCancelMessage("This can only be used between 1st of April and 1st of May.")
	end

	if target.itemid == config.item1 or target.itemid == config.item2 or target.itemid == config.item3 then
		if player:getStorageValue(config.storageKey) > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have the obedience of ursagrodon.")
			return true
		end

		if rand <= config.percentage then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The ice cracked and the frozen creature with it - be more careful next time!")
			item:remove(1)
			target:transform(config.item4)
			addEvent(revertIce, 600 * 1000, toPosition)
		else
			if target.itemid == config.item1 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You managed to melt about half of the ice blook. Quickly now, it's ice cold here and the ice block could freeze over again.")
				target:transform(config.item2)
			elseif target.itemid == config.item2 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You managed to melt almost the whole block, only the feet of the creature are still stuck in the ice. Finish the job!")
				target:transform(config.item3)
			elseif target.itemid == config.item3 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The freed ursagrodon look at you with glowing, obedient eyes.")
				target:transform(config.item4)
				item:remove(1)
				player:addMount(38)
				player:setStorageValue(config.storageKey, 1)
				addEvent(revertIce, 600 * 1000, toPosition)
			end
		end
	end
	return true
end

ursagrodon:id(20355)
ursagrodon:register()
