local function checkBlood(position)
	local tile = Tile(position)
	local items = tile:getItems()
	for i = 1, #items do
		local item = items[i]
		if not ItemType(item):isMovable() then
			item:remove()
		end
	end
end
local thornKnightDeath = CreatureEvent("ThornKnightDeath")
function thornKnightDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster then
		return true
	end
	if targetMonster:getName():lower() == 'mounted thorn knight' then
		targetMonster:say('The thorn knight unmounts!', TALKTYPE_MONSTER_SAY)
		Game.createMonster('the shielded thorn knight', targetMonster:getPosition(), true, true)
		Game.createMonster('thorn steed', targetMonster:getPosition(), false, true)
		addEvent(checkBlood, 1, targetMonster:getPosition())
		return true
	elseif targetMonster:getName():lower() == 'the shielded thorn knight' then
		Game.createMonster('the enraged thorn knight', targetMonster:getPosition(), true, true)
		addEvent(checkBlood, 1, targetMonster:getPosition())
		return true
	end
	return true
end
thornKnightDeath:register()
