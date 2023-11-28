local ferumbrasMortalShell = CreatureEvent("FerumbrasMortalShell")

local config = AscendingFerumbrasConfig

function ferumbrasMortalShell.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	if creature:getName():lower() ~= "destabilized ferumbras" then
		return true
	end

	local monster = Game.createMonster("Ferumbras Mortal Shell", config.bossPos, true, true)
	if not monster then
		return true
	end
	monster:say("AAAAAAAAAAAAAAAAAAHHHHHHHHHHHHHH!", TALKTYPE_MONSTER_SAY)
	lasthitkiller:say("FINALY YOU FORCED FERUMBRAS BACK INTO A MORTAL FORM - HE IS NOT AMUSED!", TALKTYPE_MONSTER_SAY, nil, nil, config.bossPos)
	return true
end

ferumbrasMortalShell:register()
