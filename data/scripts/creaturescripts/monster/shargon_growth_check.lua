local shargonGrowthCheck = CreatureEvent("ShargonGrowthCheck")
function shargonGrowthCheck.onThink(creature)
	local tilePos = Tile({x=creature:getPosition().x+math.random(-1, 1), y=creature:getPosition().y+math.random(-1, 1), z=creature:getPosition().z })
	if not tilePos then
		return true
	end
	if tilePos:getItemById(1497) or tilePos:getItemById(1499) then
		creature:say("Your tricks are older then my minions! You wont trap me! Amuse yourself with my slaves as long was your traps are in place!", TALKTYPE_ORANGE_2)
		for i = 1, 20 do
			Game.createMonster("Death Reaper", {x = 176 + math.random(-6,6), y = 386 + math.random(-6,6), z = 7}, false, true)
			creature:remove()
		end
	end
	return true
end
shargonGrowthCheck:register()
