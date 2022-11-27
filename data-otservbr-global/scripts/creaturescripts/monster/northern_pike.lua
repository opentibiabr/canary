local northernPike = CreatureEvent("NorthernPike")
function northernPike.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	local chance = math.random(1, 100)
	if chance < 50 then
		Game.createMonster("slippery northern pike", creature:getPosition())
	else
	end
end
northernPike:register()
