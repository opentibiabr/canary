local coconutShrimpBake = Action()

function coconutShrimpBake.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("jean-pierre-foods") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	local headItem = player:getSlotItem(CONST_SLOT_HEAD)
	if not headItem or headItem.itemid ~= 11585 then
		return true
	end

	player:setExhaustion("coconut-shrimp-bake", 24 * 60 * 60)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Underwater walking speed increased.")
	player:say("Yum.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("jean-pierre-foods", 10 * 60)
	item:remove(1)
	return true
end

coconutShrimpBake:id(11584)
coconutShrimpBake:register()
