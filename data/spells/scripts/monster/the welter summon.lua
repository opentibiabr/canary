local function delayedCastSpell(cid, var)
	local creature = Creature(cid)
	if not creature then
		return
	end

	if creature:getName(creature:getMaster()) == "The Welter" then
	local summon = creature:getSummons()
		for i = 1, #summon do
			if summon[i]:getName() == "Egg" then
				summon[i]:getPosition():sendMagicEffect(CONST_ME_POISONAREA)
				local newmon = Game.createMonster("Spawn Of The Welter", summon[i]:getPosition(), false, true)
				summon[i]:remove()
				if not newmon then
					return
				end
				newmon:setMaster(creature)
			end
		end
	end
end

local maxsummons = 1

function onCastSpell(creature, var)
local summoncount = creature:getSummons()
	if #summoncount < 1 then
		for i = 1, maxsummons - #summoncount do
			local mon = Game.createMonster("Egg", creature:getPosition())
			if not mon then
				return
			end
			mon:setMaster(creature)
		end
	end
	addEvent(delayedCastSpell, 10000, creature:getId(), var)
	return true
end
