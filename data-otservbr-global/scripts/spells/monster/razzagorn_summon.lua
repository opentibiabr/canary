local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	for i = 1, 4 do
		local mid = Game.createMonster("Demon", Position(math.random(33416, 33431), math.random(32460, 32474), 14), true, true)
		if not mid then
			return
		end
	end
	return
end

spell:name("razzagorn summon")
spell:words("###412")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()