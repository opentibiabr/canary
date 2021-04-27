local maxsummons = 2

function onCastSpell(creature, var)
local summoncount = creature:getSummons()
	if #summoncount < 2 then
		local mon = Game.createMonster("Lesser Death Minion", creature:getPosition(), true, true)
		if not mon then
			return
		end
		mon:setMaster(creature)
	end
	return true
end
