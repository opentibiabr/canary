local katanaCorpseQuest1 = Action()

function katanaCorpseQuest1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 3367
	if not player:canGetReward(rewardId, "katanacorpse1") then
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a viking helmet.")
	player:addItem(rewardId, 1)
	player:questKV("katanacorpse1"):set("completed", true)
	return true
end

katanaCorpseQuest1:uid(20006)
katanaCorpseQuest1:register()
