local soul_cleanse = MoveEvent()

function soul_cleanse.onStepIn(creature, item, position, fromPosition)
	if creature:isMonster() then
		GraveDanger.cleanse(creature, item)
	end
	return true
end

soul_cleanse:id(31160)
soul_cleanse:register()
