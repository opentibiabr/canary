function onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 4 then
		for i = 1, 4 do
			local mid = Game.createMonster("Rage of Mazoran", Position(math.random(33576, 33593), math.random(32684, 32695), 14), true, true)
			if not mid then
				return
			end
			mid:setMaster(creature)
		end
	end
	return
end
