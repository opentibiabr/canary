local function removeTp(position, itemid)
	local teleport = Tile(position):getItemById(itemid)
	if teleport then
		teleport:remove()
	end
end

local deathFallen = CreatureEvent("FallenDeath")

function deathFallen.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	if corpse then
		corpse:setDestination(Position(33621, 31023, 14))
		addEvent(removeTp, 30 * 1000, corpse:getPosition(), 1949)
	end
	return true
end

deathFallen:register()
