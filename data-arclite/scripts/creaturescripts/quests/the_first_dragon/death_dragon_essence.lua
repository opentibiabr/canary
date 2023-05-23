local deathDragonEssence = CreatureEvent("DragonEssenceDeath")

function deathDragonEssence.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local spectators = Game.getSpectators(Position(33617, 31023, 14), false, false, 14, 14, 14, 14)
		for i = 1, #spectators do
			local spec = spectators[i]
			if spec:getName() == 'Dragon Essence' then
				spec:remove()
			end
		end
		Game.createMonster('The First Dragon', Position(33617, 31023, 14), true, true)
		creature:say('BEWARE! THE FIRST DRAGON APROACHES!', TALKTYPE_MONSTER_SAY, false, nil, Position(33617, 31023, 14))
	return true
end

deathDragonEssence:register()
