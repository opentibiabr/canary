local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local pos = creature:getPosition()
	if pos.z ~= 15 then
		return true
	end
	if creature:getName():lower() == 'the freezing time guardian' then
		Game.createMonster('lost time', { x=creature:getPosition().x+math.random(-2, 2), y=creature:getPosition().y+math.random(-2, 2), z=creature:getPosition().z })
	elseif creature:getName():lower() == 'the blazing time guardian' then
		Game.createMonster('time waster', { x=creature:getPosition().x+math.random(-2, 2), y=creature:getPosition().y+math.random(-2, 2), z=creature:getPosition().z })
	end
	return true
end

spell:name("time guardian lost time")
spell:words("###439")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()