local theWelterEgg = CreatureEvent("TheWelterEgg")
function theWelterEgg.onThink(creature)
	addEvent(function(cid)
		local creature = Creature(cid)
		if not creature then
			return
		end
		local pos = creature:getPosition()
		pos:sendMagicEffect(CONST_ME_POISONAREA)
		creature:remove()
		local summon = Game.createMonster("spawn of the welter", pos, false, true)
		if not summon then
			return
		end
		return true
	end, 10000, creature:getId())
end
theWelterEgg:register()
