local astralGlyphDeath = CreatureEvent("AstralGlyphDeath")
function astralGlyphDeath.onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	local targetMonster = creature:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() == 'an astral glyph' then
		Game.createMonster('the last lore keeper', targetMonster:getPosition(), true, true)
	end
	return true
end
astralGlyphDeath:register()
