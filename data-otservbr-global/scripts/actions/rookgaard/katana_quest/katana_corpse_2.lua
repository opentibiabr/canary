local katanaCorpseQuest2 = Action()

function katanaCorpseQuest2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 3300
	if not player:canGetReward(rewardId, "katanacorpse2") then
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a katana.")
	player:addItem(rewardId, 1)
	player:questKV("katanacorpse2"):set("completed", true)
	return true
end

katanaCorpseQuest2:uid(20007)
katanaCorpseQuest2:register()
