local thePaleCountKill = CreatureEvent("ThePaleCountKill")
function thePaleCountKill.onThink(creature)
	local hp = (creature:getHealth()/creature:getMaxHealth())*100
	if (hp < 75) then
		creature:say("Dare to follow me to my Sanctuary below and you shall DIE!", TALKTYPE_ORANGE_1)
		creature:remove()
		Game.createMonster("the pale count2", { x=32972, y=32419, z=15 })
	end
	return true
end
thePaleCountKill:register()
