local adventurersWarriorSkeleton = Action()

function adventurersWarriorSkeleton.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U10_80.TheGreatDragonHunt.WarriorSkeleton) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have discovered a deceased warrior's skeleton. It seems he tried to hunt the dragons around here - and failed.")
		player:addItem(5882, 1)

		if player:getStorageValue(Storage.Quest.U9_80.AdventurersGuild.QuestLine) < 1 then
			player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.QuestLine, 1)
		end

		player:setStorageValue(Storage.Quest.U10_80.TheGreatDragonHunt.WarriorSkeleton, 1)
		player:setStorageValue(Storage.Quest.U10_80.TheGreatDragonHunt.DragonCounter, 0)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The dead explorer is empty.")
	end

	return true
end

adventurersWarriorSkeleton:aid(50806)
adventurersWarriorSkeleton:register()
