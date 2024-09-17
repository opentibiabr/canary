--[[
Reserved player action storage key ranges (const.hpp)
	It is possible to place the storage in a quest door, so the player who has that storage will go through the door

	Reserved player action storage key ranges (const.hpp at the source)
	[10000000 - 20000000]
	[1000 - 1500]
	[2001 - 2011]

	Others reserved player action/storages
	[100] = unmovable/untrade/unusable items
	[101] = use pick floor
	[102] = well down action
	[103-120] = others keys action
	[103] = key 0010
	[303] = key 0303
	[1000] = level door. Here 1 must be used followed by the level.
	Example: 1010 = level 10,
	1100 = level 100]

	Questline = Storage through the Quest
]]

Global = {
	Storage = {
		FamiliarSummonEvent10 = 30054,
		FamiliarSummonEvent60 = 30055,
		CobraFlask = 30056,

		-- Reserved storage from 64000 - 64099
		TibiaDrome = {
			-- General Upgrades
			BestiaryBetterment = {
				TimeLeft = 64000,
				LastActivatedAt = 64001,
			},
			CharmUpgrade = {
				TimeLeft = 64002,
				LastActivatedAt = 64003,
			},
			KooldownAid = {
				LastActivatedAt = 64005,
			},
			StaminaExtension = {
				LastActivatedAt = 64007,
			},
			StrikeEnhancement = {
				TimeLeft = 64008,
				LastActivatedAt = 64009,
			},
			WealthDuplex = {
				TimeLeft = 64010,
				LastActivatedAt = 64011,
			},
			-- Resilience
			FireResilience = {
				TimeLeft = 64012,
				LastActivatedAt = 64013,
			},
			IceResilience = {
				TimeLeft = 64014,
				LastActivatedAt = 64015,
			},
			EarthResilience = {
				TimeLeft = 64016,
				LastActivatedAt = 64017,
			},
			EnergyResilience = {
				TimeLeft = 64018,
				LastActivatedAt = 64019,
			},
			HolyResilience = {
				TimeLeft = 64020,
				LastActivatedAt = 64021,
			},
			DeathResilience = {
				TimeLeft = 64022,
				LastActivatedAt = 64023,
			},
			PhysicalResilience = {
				TimeLeft = 64024,
				LastActivatedAt = 64025,
			},
			-- Amplifications
			FireAmplification = {
				TimeLeft = 64026,
				LastActivatedAt = 64027,
			},
			IceAmplification = {
				TimeLeft = 64028,
				LastActivatedAt = 64029,
			},
			EarthAmplification = {
				TimeLeft = 64030,
				LastActivatedAt = 64031,
			},
			EnergyAmplification = {
				TimeLeft = 64032,
				LastActivatedAt = 64033,
			},
			HolyAmplification = {
				TimeLeft = 64034,
				LastActivatedAt = 64035,
			},
			DeathAmplification = {
				TimeLeft = 64036,
				LastActivatedAt = 64037,
			},
			PhysicalAmplification = {
				TimeLeft = 64038,
				LastActivatedAt = 64039,
			},
		},
	},
}
