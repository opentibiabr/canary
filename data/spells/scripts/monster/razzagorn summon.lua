function onCastSpell(creature, var)
	for i = 1, 4 do
		local mid = Game.createMonster("Demon", Position(math.random(33416, 33431), math.random(32460, 32474), 14), true, true)
		if not mid then
			return
		end
	end
	return
end
