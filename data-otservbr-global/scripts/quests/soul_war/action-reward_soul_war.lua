local rewardSoulWar = Action()

function rewardSoulWar.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local rewardItem = SoulWarQuest.finalRewards[math.random(1, #SoulWarQuest.finalRewards)]
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local soulWarQuest = player:soulWarQuestKV()
	if soulWarQuest:get("final-reward") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already received your reward.")
		return true
	end

	if not soulWarQuest:get("goshnar's-megalomania-killed") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to defeat Goshnar's Megalomania to receive your reward.")
		return true
	end

	player:addItem(rewardItem.id, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. rewardItem.name .. ".")
	soulWarQuest:set("final-reward", true)
	return true
end

rewardSoulWar:position({ x = 33620, y = 31400, z = 10 })
rewardSoulWar:register()
