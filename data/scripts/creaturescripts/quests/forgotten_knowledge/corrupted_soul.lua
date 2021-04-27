local function removeVortex(pos)
	local vortex = Tile(pos):getItemById(26394) or Tile(pos):getItemById(26395) or Tile(pos):getItemById(26396)
	if vortex then
		vortex:remove()
	end
end

local corruptedSoul = CreatureEvent("CorruptedSoul")
function corruptedSoul.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster then
		return true
	end
	local pos = targetMonster:getPosition()
	local vortex = Tile(pos):getItemById(26394) or Tile(pos):getItemById(26395) or Tile(pos):getItemById(26396)
	if not vortex then
		Game.createItem(26394, 1, pos)
		return true
	end
	if vortex:getId() == 26394 then
		vortex:transform(26395)
	elseif vortex:getId() == 26395 then
		vortex:transform(26396)
	end
	addEvent(removeVortex, 30 * 1000, pos)
	return true
end

corruptedSoul:register()
