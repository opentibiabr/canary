local scrollOfAscension = Action()

function scrollOfAscension.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("scroll-of-ascension") then
		return true
	end

	local playerTile = Tile(player:getPosition())
	if playerTile and playerTile:getGround() and table.contains(swimmingTiles, playerTile:getGround():getId()) then
		player:say("The scroll could get wet, step out of the water first.", TALKTYPE_MONSTER_SAY)
		return true
	end

	player:setMonsterOutfit(math.random(10) > 1 and "Demon" or "Ferumbras", 5 * 60 * 1000)
	player:say("Magical sparks whirl around the scroll as you read it and then your appearance is changing.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_HITBYFIRE)
	player:setExhaustion("scroll-of-ascension", 60 * 60)
	return true
end

scrollOfAscension:id(22771)
scrollOfAscension:register()
