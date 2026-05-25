local borethDeath = CreatureEvent("BorethDeath")

function borethDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamageKiller)
	local fromPos = Position(32936, 31474, 1)
	local toPos = Position(32944, 31482, 1)

	for x = fromPos.x, toPos.x do
		for y = fromPos.y, toPos.y do
			local tile = Tile(Position(x, y, 1))
			if tile then
				for _, spectator in ipairs(tile:getCreatures()) do
					if spectator:isMonster() and spectator:getName():lower() == "plaguethrower" then
						spectator:remove()
					end
				end
			end
		end
	end

	return true
end

borethDeath:register()
