local ringMultiplicationTable = {
	[3095] = 3092,
	[3096] = 3093,
	[6300] = 6299,
	[3099] = 3097,
	[3088] = 3051,
	[3089] = 3052,
	[3048] = 3048,
	[3087] = 3050,
	[16264] = 16114,
	[3100] = 3098,
	[12670] = 12669,
	[3086] = 3049,
	[3094] = 3091,
	[3090] = 3053,
}

local sweetMangonaiseElixir = Action()

function sweetMangonaiseElixir.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("jean-pierre-foods") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	local playerRing = player:getSlotItem(CONST_SLOT_RING)
	if not playerRing or playerRing:getId() == item:getId() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No ring equipped.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	if ringMultiplicationTable[playerRing.itemid] then
		local ringMultiplierAmount = (playerRing.itemid == ringMultiplicationTable[playerRing.itemid]) and 20 or 1
		for i = 1, 10 do
			player:addItem(ringMultiplicationTable[playerRing.itemid], ringMultiplierAmount)
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your ring has been multiplied.")
		item:remove(1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This ring cannot be multiplied.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end

	player:say("Slurp.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("jean-pierre-foods", 10 * 60)
	return true
end

sweetMangonaiseElixir:id(11588)
sweetMangonaiseElixir:register()
