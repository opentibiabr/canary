local noxiousClaw = MoveEvent()

function noxiousClaw.onEquip(player, item, slot)
	item:transform(9392)
	if Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) then
		return true
	end

	doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -200, -200, CONST_ME_DRAWBLOOD)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It tightens around your wrist as you take it on.")
	return true
end

noxiousClaw:type("equip")
noxiousClaw:id(9393)
noxiousClaw:level(100)
noxiousClaw:register()
