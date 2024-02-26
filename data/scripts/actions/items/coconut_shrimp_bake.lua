local coconutShrimpBake = Action()

function coconutShrimpBake.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("jean-pierre-foods") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	local headItem = player:getSlotItem(CONST_SLOT_HEAD)
	if not headItem or (headItem.itemid ~= 5460 and headItem.itemid ~= 11585 and headItem.itemid ~= 13995) then
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Underwater walking speed increased.")
	player:say("Yum.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("jean-pierre-foods", 10 * 60)
	player:setExhaustion("coconut-shrimp-bake", 24 * 60 * 60)
	item:remove(1)
	return true
end

coconutShrimpBake:id(11584)
coconutShrimpBake:register()
