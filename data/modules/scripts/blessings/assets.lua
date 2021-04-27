Blessings.Types = {
	REGULAR = 1,
	ENHANCED = 2,
	PvP = 3
}

Blessings.All = {
	[1] = {id = 1, name = "Twist of Fate", type = Blessings.Types.PvP},
	[2] = {id = 2, name = "The Wisdom of Solitude", charm = 11262, type = Blessings.Types.REGULAR, losscount = true, inquisition = true},
	[3] = {id = 3, name = "The Spark of the Phoenix", charm = 11258, type = Blessings.Types.REGULAR, losscount = true, inquisition = true},
	[4] = {id = 4, name = "The Fire of the Suns", charm = 11261, type = Blessings.Types.REGULAR, losscount = true, inquisition = true},
	[5] = {id = 5, name = "The Spiritual Shielding", charm = 11260, type = Blessings.Types.REGULAR, losscount = true, inquisition = true},
	[6] = {id = 6, name = "The Embrace of Tibia", charm = 11259, type = Blessings.Types.REGULAR, losscount = true, inquisition = true},
	[7] = {id = 7, name = "Blood of the Mountain", charm = 28036, type = Blessings.Types.ENHANCED, losscount = true, inquisition = false},
	[8] = {id = 8, name = "Heart of the Mountain", charm = 28037, type = Blessings.Types.ENHANCED, losscount = true, inquisition = false}
}


Blessings.LossPercent = {
	[0] = {item = 100, skill = 0},
	[1] = {item = 70, skill = 8},
	[2] = {item = 45, skill = 16},
	[3] = {item = 25, skill = 24},
	[4] = {item = 10, skill = 32},
	[5] = {item = 0, skill = 40},
	[6] = {item = 0, skill = 48},
	[7] = {item = 0, skill = 56},
	[8] = {item = 0, skill = 56}
}


Blessings.BitWiseTable = {
	[0] = 1,
	[1] = 2,
	[2] = 4,
	[3] = 8,
	[4] = 16,
	[5] = 32,
	[6] = 64,
	[7] = 128,
	[8] = 256,
	[9] = 512,
	[10] = 1024,
	[11] = 2048,
	[12] = 4096,
	[13] = 8192,
	[14] = 16384,
	[15] = 32768
}