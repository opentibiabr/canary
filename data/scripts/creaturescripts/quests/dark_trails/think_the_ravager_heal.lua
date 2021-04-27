local theRavagerHeal = CreatureEvent("TheRavagerHeal")

function theRavagerHeal.onThink(creature)
	local health = math.random(7500, 9000)
	local hp = (creature:getHealth()/creature:getMaxHealth())*100
	if creature:getName() == "The Ravager" and (hp < 99.99) then
		local tile = Tile(creature:getPosition()):getItemById(3172)
		if not tile then
			return true
		end
		creature:addHealth(health)
		creature:say("The Ravager is healed by the strange floor rune!", TALKTYPE_ORANGE_1)
	end
	return true
end

theRavagerHeal:register()
