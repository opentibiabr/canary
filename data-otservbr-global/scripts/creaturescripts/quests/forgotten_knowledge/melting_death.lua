local monster = {
	name = 'baby dragon',
	pos = Position(32269, 31084, 14)
}

local meltingDeath = CreatureEvent("MeltingDeath")
function meltingDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	if not creature then
		return
	end

	if creature:isMonster() and creature:getName():lower() ~= 'melting frozen horror' then
		return true
	end

	Tile(monster.pos):getTopCreature():remove()
	Game.createMonster(monster.name, Position(monster.pos), true, true)
	return true
end

meltingDeath:register()
