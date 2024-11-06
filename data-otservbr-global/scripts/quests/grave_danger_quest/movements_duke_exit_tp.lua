local duke_exit_tp = MoveEvent()

function duke_exit_tp.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	creature:removeCondition(CONDITION_OUTFIT)

	return true
end

duke_exit_tp:aid(14561)
duke_exit_tp:register()
