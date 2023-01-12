local greaterMinion = CreatureEvent("GreaterMinion")
function greaterMinion.onThink(creature)
	addEvent(function(cid)
		local creature = Creature(cid)
		if not creature then
			return
		end
		local pos = creature:getPosition()
		local creatureMaster = creature:getMaster()
		pos:sendMagicEffect(CONST_ME_MORTAREA)
		local say = creatureMaster:say("The minion gains greater power!", TALKTYPE_ORANGE_2)
		if not say then
			return
		end
		creature:remove()
		local summon = Game.createMonster("greater death minion", pos, false, true)
		if not summon then
			return
		end
		return true
	end, 7000, creature:getId())
end
greaterMinion:register()
