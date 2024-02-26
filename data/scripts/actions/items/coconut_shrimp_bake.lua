local coconutShrimpBake = Action()

function coconutShrimpBake.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("special-foods-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	local headItem = player:getSlotItem(CONST_SLOT_HEAD)
	if not headItem then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You should only eat this dish when wearing a helmet of the deep or a depth galea and walking underwater.")
		return true
	end

	local acceptableHelmets = { 5460, 11585, 13995 }
	if not table.contains(acceptableHelmets, headItem:getId()) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You should only eat this dish when wearing a helmet of the deep or a depth galea and walking underwater.")
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your underwater walking speed while wearing a " .. headItem:getName() .. " has increased for twenty-four hours.")
	player:say("Yum.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	player:setExhaustion("coconut-shrimp-bake", 24 * 60 * 60)
	item:remove(1)
	return true
end

coconutShrimpBake:id(11584)
coconutShrimpBake:register()
