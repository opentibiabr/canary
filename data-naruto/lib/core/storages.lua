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

Storage = {
	Quest = {
		Key = {
			ID1000 = 103,
		},
		ExampleQuest = {
			Example = 9000,
			Door = 9001,
		},
	},

	DelayLargeSeaShell = 30002,
	Imbuement = 30004,
}

GlobalStorage = {
	FuneralQuest = {
		RotwormQuest = 6000,
		BanditsQuest = 6001,
		CyclopsQuest = 6002,
		BASG = 6003,
		KosheiQuest = 6011,
		SecretServiceQuest = 6004,
		BAGQ = 6005,
		BansheeQuest = 6006,
		BAWQ = 6007,
		YalaharQuest = 6008,
		POIQuest = 6009,
		InquisitionQuest = 6010,
		CursedSpreadQuest = 6012,
		BehemothQuest = 6013,
		DemonHelmetQuest = 6014,
		DwarvenQuest = 6015,
		FeyristQuest = 6016,
		FireWalkerQuest = 6017,
	},
}
