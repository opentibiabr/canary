local soulcatcherSummon = CreatureEvent("SoulcatcherSummon")
function soulcatcherSummon.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if creature and creature:getName() == "Soulcatcher" then
		if creature:getHealth() <= 49999 then
			local random = math.random(1, 100)
			if random <= 15 then
				Game.createMonster("Corrupted Soul", Position(33358, 31187, 10), true, true)
			end
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

soulcatcherSummon:register()
