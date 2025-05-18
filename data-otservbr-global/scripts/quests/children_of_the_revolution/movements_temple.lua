local temple = MoveEvent()

function temple.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline) == 4 then
		--Questlog, Children of the Revolution 'Mission 1: Corruption'
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission01, 2)
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline, 5)
		player:say("The temple has been corrupted and is lost. Zalamon should be informed about this as soon as possible.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

temple:type("stepin")
temple:uid(3163)
temple:register()
