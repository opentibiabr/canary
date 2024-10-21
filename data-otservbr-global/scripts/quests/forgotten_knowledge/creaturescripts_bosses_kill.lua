local bosses = {
	-- bosses
	["lady tenebris"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.LadyTenebrisKilled },
	["the enraged thorn knight"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.ThornKnightKilled },
	["lloyd"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.LloydKilled },
	["soul of dragonking zyrtarch"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.DragonkingKilled },
	["melting frozen horror"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.HorrorKilled },
	["the time guardian"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.TimeGuardianKilled },
	["the blazing time guardian"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.TimeGuardianKilled },
	["the freezing time guardian"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.TimeGuardianKilled },
	["the last lore keeper"] = { storage = Storage.Quest.U11_02.ForgottenKnowledge.LastLoreKilled },
	-- IA interactions
	["an astral glyph"] = {},
}

local bossesForgottenKill = CreatureEvent("ForgottenKnowledgeBossDeath")

function bossesForgottenKill.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if bossConfig.storage then
			if creature:getName():lower() == "the last lore keeper" then
				player:setStorageValue(bossConfig.storage, os.time() + (13 * 24 * 3600) + (20 * 3600))
			else
				player:setStorageValue(bossConfig.storage, os.time() + 20 * 3600)
			end
		elseif creature:getName():lower() == "the enraged thorn knight" then
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.PlantCounter, 0)
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.BirdCounter, 0)
		end
	end)

	if creature:getName():lower() == "melting frozen horror" then
		local egg = Tile(Position(32269, 31084, 14)):getTopCreature()
		if egg then
			local pos = egg:getPosition()
			egg:remove()
			Game.createMonster("baby dragon", pos, true, true)
		end
		local horror = Tile(Position(32267, 31071, 14)):getTopCreature()
		if horror then
			horror:remove()
		end
	end
	return true
end

bossesForgottenKill:register()
