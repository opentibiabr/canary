local meleeCondition = Condition(CONDITION_ATTRIBUTES)
meleeCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreMelee)
meleeCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
meleeCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
meleeCondition:setParameter(CONDITION_PARAM_SKILL_MELEE, 10)
meleeCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local veggieCasserole = Action()

function veggieCasserole.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("special-foods-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	player:addCondition(meleeCondition)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel stronger.")
	player:say("Yum.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

veggieCasserole:id(9084)
veggieCasserole:register()
