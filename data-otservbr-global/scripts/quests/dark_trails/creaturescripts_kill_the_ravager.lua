local function removeTeleport(position)
	local teleportItem = Tile({ x = 33496, y = 32070, z = 8 }):getItemById(1949)
	if teleportItem then
		teleportItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
	end
end

local theRavager = CreatureEvent("TheRavagerDeath")
function theRavager.onDeath(creature)
	local position = creature:getPosition()
	position:sendMagicEffect(CONST_ME_TELEPORT)
	local item = Game.createItem(1949, 1, { x = 33496, y = 32070, z = 8 })
	if item:isTeleport() then
		item:setDestination(Position(33459, 32083, 8))
	end
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.DarkTrails.Mission11) < 1 then
			player:setStorageValue(Storage.DarkTrails.Mission11, 1)
		end
	end)
	addEvent(removeTeleport, 5 * 60 * 1000, position)
	return true
end

theRavager:register()
