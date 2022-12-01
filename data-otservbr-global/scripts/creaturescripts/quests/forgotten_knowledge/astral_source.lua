local astralSource = CreatureEvent("AstralSource")
function astralSource.onThink(creature)
	local hp = (creature:getHealth() / creature:getMaxHealth()) * 100
	local health, difference, glyph, pos = 0, 0, Tile(Position(31989, 32823, 15)):getTopCreature(), creature:getPosition()
	if hp < 5.5 and Game.getStorageValue(GlobalStorage.ForgottenKnowledge.AstralGlyph) >= 1 then
		sourcePos = creature:getPosition()
		creature:say('Your damage distorted the source and prevents the Glyph to draw on its power.', TALKTYPE_MONSTER_SAY)
		creature:remove()
		local source = Tile(Position(31986, 32823, 15)):getTopCreature()
		if source then
			source:teleportTo(sourcePos)
		end
		local spectators = Game.getSpectators(Position(31986, 32847, 14), false, false, 12, 12, 12, 12)
		for i = 1, #spectators do
			local spec = spectators[i]
			if spec:getName():lower() == 'a shielded astral glyph' then
				health = spec:getHealth()
				difference = glyph:getHealth() - health
				local pos = spec:getPosition()
				spec:teleportTo(Position(31989, 32823, 15))
				glyph:addHealth( - difference)
				glyph:teleportTo(pos)
				glyph:say('Without the power of the source the Glyph loses its protection!', TALKTYPE_MONSTER_SAY)
			end
		end
	elseif Game.getStorageValue(GlobalStorage.ForgottenKnowledge.AstralGlyph) < 1 then
		creature:addHealth(10000, false)
	end
end
astralSource:register()
