local movements_corruptedNature = MoveEvent()

function movements_corruptedNature.onStepIn(creature, item, position, fromPosition)
	if not creature or not creature:isMonster() then
		return true
	end

	local r = math.random(7000, 10000)
	local cName = creature:getName()
	local cPos = creature:getPosition()

	if cName:lower() == "plant attendant" then
		creature:remove()

		local abomination = Game.createMonster("Plant Abomination", cPos)

		if abomination then
			abomination:registerEvent("dreamCourtsDeath")
			abomination:say("The vile energy changes the attendant horribly!", TALKTYPE_MONSTER_SAY)
		end
	elseif cName:lower() == "plagueroot" then
		creature:addHealth(r)
	end

	return true
end

movements_corruptedNature:id(28951)
movements_corruptedNature:register()
