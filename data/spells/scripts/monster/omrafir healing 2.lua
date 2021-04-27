function onCastSpell(creature, var)
local health, hp, cpos = math.random(7500, 9000), (creature:getHealth()/creature:getMaxHealth())*100, creature:getPosition()

    if creature:getName() == "Omrafir" and (hp < 99.99) then
		local t = Tile(cpos)
		if t == nil then
			return
		end
		if t:getItemById(1487) or t:getItemById(1492) or t:getItemById(1500) then
			creature:addHealth(health)
			cpos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			creature:say("Omrafir gains new strength from the fire", TALKTYPE_ORANGE_1)
		else
		end
	end
end
