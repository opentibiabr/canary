local outfit = createConditionObject(CONDITION_OUTFIT)
setConditionParam(outfit, CONDITION_PARAM_TICKS, 30 * 1000)
addOutfitCondition(outfit, { lookType = 1065 })

local movements_library_mazzinor = MoveEvent()

function movements_library_mazzinor.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	creature:addCondition(outfit)
	creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The remains deporalize you temporaly.")
	creature:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	item:remove(1)

	return true
end

movements_library_mazzinor:aid(4951)
movements_library_mazzinor:register()
