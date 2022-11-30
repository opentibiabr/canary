local maxsummons = 2

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
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

spell:name("death priest shargon summon")
spell:words("###378")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()