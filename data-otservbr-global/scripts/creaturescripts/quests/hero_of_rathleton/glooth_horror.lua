local config = {
	{name = 'Feeble Glooth Horror',  monster = 'Weakened Glooth Horror'},
	{name = 'Weakened Glooth Horror', monster = 'Glooth Horror'},
	{name = 'Glooth Horror', monster = 'Strong Glooth Horror'},
	{name = 'Strong Glooth Horror', monster = 'Empowered Glooth Horror'}
}

local gloothHorror = CreatureEvent("GloothHorror")
function gloothHorror.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local name = targetMonster:getName()
	for i = 1, #config do
		if name == config[i].name then
			for j = 1, 2 do
				local spawnMonster = Game.createMonster(config[i].monster, targetMonster:getPosition(), true, true)
				if spawnMonster then
					spawnMonster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
			break
		end
	end
	return true
end

gloothHorror:register()
