local messages = {
	{"Gnomedix: So let the examination begin! Now don't move. Don't be afraid. The good doctor gnome won't hurt you - hopefully!", CONST_ME_LOSEENERGY},
	{"Gnomedix: Now! Now! Don't panic! It's all over soon!"},
	{"Gnomedix: Let me try a bigger chisel!", CONST_ME_POFF},
	{"Gnomedix: We're almost don... holy gnome! What's THIS???"},
	{"Gnomedix: I need a drill! Gnomenursey, quick!"},
	{"Gnomedix: Hold still now! This might tickle a little..", CONST_ME_STUN},
	{"Gnomedix: Take this, you evil ... whatever you are!"},
	{"Gnomedix: I got it! Yikes! What was that? Uhm, well ... you passed the ear examination. Talk to Gnomaticus for your next test.", CONST_ME_BLOCKHIT}
}

local function sendTextMessages(cid, index)
	local player = Player(cid)
	if not player then
		return true
	end

	if index ~= player:getStorageValue(Storage.BigfootBurden.GnomedixMsg) then
		return false
	end

	if player:getPosition() ~= Position({x = 32767, y = 31771, z = 10}) then
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, messages[index][1])
	if messages[index][2] then
		player:getPosition():sendMagicEffect(messages[index][2])
	end
	player:setStorageValue(Storage.BigfootBurden.GnomedixMsg,
	player:getStorageValue(Storage.BigfootBurden.GnomedixMsg) + 1)
	if index == 8 then
		Game.createMonster("Strange Slime", Position(32767, 31772, 10))
		player:setStorageValue(Storage.BigfootBurden.QuestLine, 11)
	end
end

local taskEar = MoveEvent()
function taskEar.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.BigfootBurden.QuestLine) ~= 10 then
		return true
	end
	player:setStorageValue(Storage.BigfootBurden.GnomedixMsg, 1)
	position:sendMagicEffect(CONST_ME_LOSEENERGY)

	for i = player:getStorageValue(Storage.BigfootBurden.GnomedixMsg), #messages do
		addEvent(sendTextMessages, (i - 1) * 4000, player.uid, i)
	end
	return true
end

taskEar:position({x = 32767, y = 31771, z = 10})
taskEar:register()
