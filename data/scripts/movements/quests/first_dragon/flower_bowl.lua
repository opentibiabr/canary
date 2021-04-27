local flowerBowl = MoveEvent()

function flowerBowl.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() then
		return true
	end
	
	if item.uid == 1066 then
		if creature:getName() == 'Unbeatable Dragon' then
			creature:say('An allergic reaction weakens the dragon!', TALKTYPE_MONSTER_SAY)
			creature:remove()
			Game.createMonster('Somewhat Beatable', position, true, true)
		end
	end
	return true
end

flowerBowl:id(9679)
flowerBowl:register()