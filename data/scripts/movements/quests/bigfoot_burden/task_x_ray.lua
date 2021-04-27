local messages = {
	{"Gnomedix: So let the examination begin! Now don't move. Don't be afraid. \z
	The good doctor gnome won't hurt you - hopefully!", CONST_ME_LOSEENERGY},
	{"Gnomedix: Now! Now! Don't panic! It's all over soon!"},
	{"Gnomedix: Let me try a bigger chisel!", CONST_ME_POFF},
	{"Gnomedix: We're almost don... holy gnome! What's THIS???"},
	{"Gnomedix: I need a drill! Gnomenursey, quick!"},
	{"Gnomedix: Hold still now! This might tickle a little..", CONST_ME_STUN},
	{"Gnomedix: Take this, you evil ... whatever you are!"},
	{"Gnomedix: I got it! Yikes! What was that? Uhm, well ... \z
	you passed the ear examination. Talk to Gnomaticus for your next test.", CONST_ME_BLOCKHIT}
}

local function sendTextMessages(cid, index, position)
	local player = Player(cid)
	if not player then
		return true
	end

	if index ~= player:getStorageValue(Storage.BigfootBurden.GnomedixMsg) then
		return false
	end

	local playerposuid = Tile(player:getPosition()):getGround()
	playerposuid = playerposuid:getUniqueId()
	if playerposuid ~= 3123 then
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, messages[index][1])
	if messages[index][2] then
		position:sendMagicEffect(messages[index][2])
	end
	player:setStorageValue(Storage.BigfootBurden.GnomedixMsg,
	player:getStorageValue(Storage.BigfootBurden.GnomedixMsg) + 1)
	if index == 8 then
		position.y = position.y + 1
		Game.createMonster("Strange Slime", position)
		player:setStorageValue(Storage.BigfootBurden.QuestLine, 11)
	end
end

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(2000)
condition:setOutfit({lookType = 33}) -- skeleton looktype

local taskXRay = MoveEvent()

function taskXRay.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 9200 then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 8 then
			player:addCondition(condition)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	elseif item.actionid == 9201 then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 8 then
			player:addCondition(condition)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 10)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"You have been succesfully g-rayed. Now let Doctor Gnomedix inspect your ears!")
		end
	elseif item.uid == 3123 then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) ~= 10 then
			return true
		end
		player:setStorageValue(Storage.BigfootBurden.GnomedixMsg, 1)
		position:sendMagicEffect(CONST_ME_LOSEENERGY)

		for i = player:getStorageValue(Storage.BigfootBurden.GnomedixMsg), #messages do
			addEvent(sendTextMessages, (i - 1) * 4000, player.uid, i, player:getPosition())
		end

	end
	return true
end

taskXRay:type("stepin")
taskXRay:aid(9200, 9201)
taskXRay:uid(3123)
taskXRay:register()
