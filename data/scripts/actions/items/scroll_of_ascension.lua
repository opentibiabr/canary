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

	if math.random(10) > 1 then
		player:setMonsterOutfit("Demon", 30 * 10 * 1000)
	else
		player:setMonsterOutfit("Ferumbras", 30 * 10 * 1000)
	end

	player:setExhaustion("scroll-of-ascension", 60 * 60)
	player:say("Magical sparks whirl around the scroll as you read it and then your appearance is changing.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	return true
end

scrollOfAscension:id(22771)
scrollOfAscension:register()
