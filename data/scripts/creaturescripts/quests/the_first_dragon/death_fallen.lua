local deathFallen = CreatureEvent("FallenDeath")

local function removeTp(position, itemid)
	local teleport = Tile(position):getItemById(itemid)
	if teleport then
		teleport:remove()
	end
end
function deathFallen.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	if corpse then
		corpse:setDestination(Position(33621, 31023, 14))
		addEvent(removeTp, 30 * 1000, corpse:getPosition(), 1397)
	end
	return true
end

deathFallen:register()
