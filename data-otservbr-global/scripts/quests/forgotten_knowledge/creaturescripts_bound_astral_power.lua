local positions = {
	[1] = { pos = Position(31975, 32856, 15), nextPos = Position(31975, 32839, 15) },
	[2] = { pos = Position(31975, 32839, 15), nextPos = Position(31995, 32839, 15) },
	[3] = { pos = Position(31995, 32839, 15), nextPos = Position(31995, 32856, 15) },
	[4] = { pos = Position(31995, 32856, 15), nextPos = Position(31975, 32856, 15) },
}

local astralPower = CreatureEvent("BoundAstralPowerDeath")
function astralPower.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	Game.setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AstralPowerCounter, Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AstralPowerCounter) + 1)
	if Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AstralPowerCounter) >= 4 then
		Game.setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AstralPowerCounter, 1)
	end

	local msg = "The destruction of the power source gained you more time until the glyph is powered up!"
	local player = Player(mostDamageKiller)
	if not player then
		return true
	end
	for i = 1, #positions do
		if player:getPosition():getDistance(positions[i].pos) < 7 then
			creature:say(msg, TALKTYPE_MONSTER_SAY, false, nil, positions[i].pos)
			Game.createMonster("bound astral power", positions[i].nextPos, true, true)
			Game.setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AstralGlyph, 1)
			addEvent(Game.setStorageValue, 1 * 60 * 1000, Storage.Quest.U11_02.ForgottenKnowledge.AstralGlyph, 0)
		end
	end
	return true
end

astralPower:register()
