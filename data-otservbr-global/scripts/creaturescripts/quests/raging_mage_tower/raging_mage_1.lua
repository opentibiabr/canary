local ragingMage1 = CreatureEvent("RagingMage1")
function ragingMage1.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local playerDoubleMageKill = 775558
	local yielothaxKillStorage = 673003
	local enoughKills = 775559

	if killer:getStorageValue(playerDoubleMageKill) < 2 and not
	mostDamageKiller:hasAchievement('Mageslayer') and Game.getStorageValue(yielothaxKillStorage) < 2000 then
		creature:say("MWAAAHAHAAA!! NO ONE!! NO ONE CAN DEFEAT MEEE!!!",
		TALKTYPE_MONSTER_YELL, false, nil, Position(33143, 31527, 2))
		Game.createMonster("energized raging mage", Position(33142, 31529, 2))
		mostDamageKiller:setStorageValue(playerDoubleMageKill, mostDamageKiller:getStorageValue(playerDoubleMageKill) + 1)
		mostDamageKiller:addAchievement('Mageslayer')
	elseif Game.getStorageValue(yielothaxKillStorage) < 2000 then
		creature:say("MWAAAHAHAAA!! NO ONE!! NO ONE CAN DEFEAT MEEE!!!",
		TALKTYPE_MONSTER_YELL, false, nil, Position(33143, 31527, 2))
		Game.createMonster("Energized Raging Mage", Position(33142, 31529, 2))
	elseif Game.getStorageValue(yielothaxKillStorage) > 1999 then
		Game.createMonster("raging mage", Position(33142, 31529, 2))
		creature:say("GNAAAAAHRRRG!! WHAT? WHAT DID YOU DO TO ME!! I... I feel the energies crawling away... from me... DIE!!!",
		TALKTYPE_MONSTER_YELL, false, nil, Position(33143, 31527, 2))
		Game.setStorageValue(yielothaxKillStorage, 0)
		Game.setStorageValue(enoughKills, 1)
		local t, spectator = Game.getSpectators(creature:getPosition(), false, false, 10, 10, 10, 10)
		if #t ~= nil then
			for i = 1, #t do
				spectator = t[i]
				if spectator:isPlayer() and spectator:getStorageValue(673004) < 250 then
					spectator:teleportTo(Position(33142, 31529, 3))
					spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					spectator:say("You have not proven worthy in the dimensional struggle against the yielothax." , TALKTYPE_MONSTER_SAY, false, nil, Position(33142, 31529, 3))
				end
			end
		end
		return true
	end
end

ragingMage1:register()
