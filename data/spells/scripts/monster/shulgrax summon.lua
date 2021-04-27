function onCastSpell(creature, var)
	local summoncount = creature:getSummons()
	if #summoncount < 8 then
		for i = 1, 4 do
			local mid = Game.createMonster("Sin Devourer", Position(math.random(33478, 33491), math.random(32781, 32793), 13), true, true)
			if not mid then
				return
			end
			mid:setMaster(creature)
		end
		for i = 1, 4 do
			local mid2 = Game.createMonster("Damned Soul", Position(math.random(33478, 33491), math.random(32781, 32793), 13), true, true)
			if not mid2 then
				return
			end
		end
	end
	return
end
