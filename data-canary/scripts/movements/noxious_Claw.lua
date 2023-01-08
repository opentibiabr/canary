local claw = MoveEvent()
claw:type("equip")

function claw.onEquip(player, item, slot, isCheck)
	if isCheck then
		return true
	end

	doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -200, -200, CONST_ME_DRAWBLOOD)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, (math.boolean_random() and "It tightens around your wrist as you take it on." or "Ouch! The serpent claw stabbed you."))
	item:transform(9392)
	return true
end

claw:id(9393)
claw:level(100)
claw:register()