local loginEvents = CreatureEvent("LoginEvents")
function loginEvents.onLogin(player)

	local events = {
		--Monster
		"LowerRoshamuul",
		--Others
		"AdvanceSave",
		"BestiaryOnKill",
		"BossParticipation",
		"DropLoot",
		"PlayerDeath",
		"RookgaardAdvance",
		"FamiliarLogin",
		"AdvanceFamiliar",
		--Quests
		--Adventurers Guild Quest
		"Thegreatdragonhuntkill",
		--Bigfoot Burden Quest
		"BossesWarzone",
		"ParasiteWarzone",
		"VersperothKill",
		"WigglerKill",
		--Cults Of Tibia Quest
		"BossesCults",
		"MinotaurTask",
		"VortexCarlin",
		"LeidenHeal",
		"GlowingRubbishAmulet",
		"DestroyedPillar",
		"HealthPillar",
		"YalahariHealth",
		"EssenceOfMalice",
		--Dangerous Depths Quest
		"LostExileKill",
		"SnailSlimeKill",
		"TheBaronFromBelowKill",
		--Dawnport Quest
		"MorrisMinotaurKill",
		"MorrisGoblinKill",
		"MorrisTrollKill",
		--Elemental Spheres Quest
		"OverlordKill",
		--Ferumbras Ascendant Quest
		"AscendantBossesKill",
		"TheShattererKill",
		--Firewalker Boots
		"PythiusTheRottenKill",
		--Forgotten Knowledge Quest
		"BossesForgottenKill",
		"AstralPower",
		"EnergyPrismDeath",
		"ReplicaServant",
		--Hero Of Rathleton
		"RathletonBossKill",
		--Secret Service
		"BlackKnightKill",
		--Service Of Yalahar
		"DiseasedTrio",
		"Azerus",
		"QuaraLeaders",
		--Inquisition
		"InquisitionBossKill",
		"UngreezKill",
		--Killing In The Name Of
		"KillingInTheNameOfKill",
		"KillingInTheNameOfMinotaurKill",
		"TiquandasRevengeKill",
		"DemodrasKill",
		--Kilmaresh
		"BragrumolKill",
		"MozradekKill",
		"XogixathKill",
		"FafnarKill",
		--Liquid Black
		"DeeplingBosses",
		--Raging Mage Worldchange
		"EnergizedRagingMageKill",
		"RagingMageKill",
		"YielothaxKill",
		--Spike Tasks
		"LowerSpikeKill",
		"UpperSpikeKill",
		"MiddleSpikeKill",
		--Svargrond Arena
		"SvargrondArenaKill",
		--The Ice Islands Quest
		"HuskyKill",
		--The First Dragon
		"KillDragon",
		"SomewhatBeatableDeath",
		--The New Frontier
		"ShardOfCorruptionKill",
		"TireczKill",
		--Thieves Guild
		"NomadKill",
		--Threatened Dreams - Nightmare Intruders
		"ThreatenedDreamsNightmareMonstersKills",
		--Wrath of the Emperor
		"LizardMagistratusKill",
		"LizardNobleKill",
		"KeeperKill",
		"BossesKill",
		"ZalamonKill",
		-- The Rookie Guard
		"VascalirRatKills",
		-- An Uneasy Alliance
		"RenegadeOrcKill"
	}

	for i = 1, #events do
		player:registerEvent(events[i])
	end
	return true
end
loginEvents:register()
