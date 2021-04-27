local distortedSource = CreatureEvent("DistortedSource")
function distortedSource.onThink(creature)
	local health, difference, glyph, pos = 0, 0, Tile(Position(31989, 32823, 15)):getTopCreature(), creature:getPosition()
	if creature:getHealth() <= 40000 then
		creature:addHealth(10000, false)
	elseif creature:getHealth() >= 55000 or Game.getStorageValue(GlobalStorage.ForgottenKnowledge.AstralGlyph) < 1 then
		local spectators = Game.getSpectators(Position(31986, 32847, 14), false, false, 12, 12, 12, 12)
		for i = 1, #spectators do
			local spec = spectators[i]
			if spec:getName():lower() == 'an astral glyph' then
				local pos2 = spec:getPosition()
				health = spec:getHealth()
				difference = glyph:getHealth() - health
				spec:teleportTo(Position(31989, 32823, 15))
				glyph:addHealth( - difference)
				glyph:teleportTo(pos2)
				glyph:say('Drawing upon the power of the source, the Glyph becomes shielded again!', TALKTYPE_MONSTER_SAY)
				return true
			end
		end
	end

	if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.AstralGlyph) >= 1 then
		local spectators = Game.getSpectators(Position(31986, 32847, 14), false, false, 12, 12, 12, 12)
		for i = 1, #spectators do
			local spec2 = spectators[i]
			if spec2:getName():lower() == 'a shielded astral glyph' then
				local pos3 = spec2:getPosition()
				health = spec2:getHealth()
				difference = glyph:getHealth() - health
				spec2:teleportTo(Position(31989, 32823, 15))
				glyph:addHealth( - difference)
				glyph:teleportTo(pos3)
				glyph:say('Without the power of the source the Glyph loses its protection!', TALKTYPE_MONSTER_SAY)
				return true
			end
		end
	end
end
distortedSource:register()
