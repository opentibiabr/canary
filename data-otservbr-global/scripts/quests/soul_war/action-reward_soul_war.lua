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

local phantasmalJadeMount = Action()

function phantasmalJadeMount.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local soulWarQuest = player:soulWarQuestKV()
	if soulWarQuest:get("panthasmal-jade-mount") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have Phantasmal Jade mount!")
		return true
	end

	if table.contains({ 34072, 34073, 34074 }, item.itemid) then
		if player:getItemCount(34072) >= 4 and player:getItemCount(34073) == 1 and player:getItemCount(34074) == 1 then
			player:removeItem(34072, 4)
			player:removeItem(34073, 1)
			player:removeItem(34074, 1)
			player:addMount(167)
			player:addAchievement("You got Horse Power")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You won Phantasmal Jade mount.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You won You got Horse Power achievement.")
			player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
			soulWarQuest:set("panthasmal-jade-mount", true)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have the necessary items!")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	end

	return true
end

phantasmalJadeMount:id(34072, 34073, 34074)
phantasmalJadeMount:register()
