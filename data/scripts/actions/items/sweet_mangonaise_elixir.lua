local ringMultiplicationTable = {
	[3048] = 3048,
	[3049] = 3086,
	[3050] = 3087,
	[3051] = 3088,
	[3052] = 3089,
	[3053] = 3090,
	[3091] = 3094,
	[3092] = 3095,
	[3093] = 3096,
	[3097] = 3099,
	[3098] = 3100,
	[6299] = 6300,
	[12669] = 12670,
	[16114] = 16264,
}

local sweetMangonaiseElixir = Action()

function sweetMangonaiseElixir.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("special-foods-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	local playerRing = player:getSlotItem(CONST_SLOT_RING)
	if not playerRing or not table.contains(ringMultiplicationTable, playerRing:getId()) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No ring equipped.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local ringId = ringMultiplicationTable[playerRing:getId()]
	if not ringId then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This ring cannot be multiplied.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	for i = 1, 10 do
		player:addItem(ringId)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your ring has been multiplied.")
	player:say("Slurp.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

sweetMangonaiseElixir:id(11588)
sweetMangonaiseElixir:register()
