local astralGlyphDeath = CreatureEvent("AstralGlyphDeath")
function astralGlyphDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	Game.createMonster("the last lore keeper", creature:getPosition(), true, true)
	return true
end

astralGlyphDeath:register()
