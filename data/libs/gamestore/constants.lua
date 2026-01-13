local GameStore = {
	ModuleName = "GameStore",
	Developers = { "Cjaker", "metabob", "Rick", "Dudantas" },
	Version = "2.0",
	LastUpdated = "21-10-2025 9:37PM",
}

GameStore.OfferTypes = {
	OFFER_TYPE_NONE = 0,
	OFFER_TYPE_ITEM = 1,
	OFFER_TYPE_STACKABLE = 2,
	OFFER_TYPE_CHARGES = 3,
	OFFER_TYPE_OUTFIT = 4,
	OFFER_TYPE_OUTFIT_ADDON = 5,
	OFFER_TYPE_MOUNT = 6,
	OFFER_TYPE_NAMECHANGE = 7,
	OFFER_TYPE_SEXCHANGE = 8,
	OFFER_TYPE_HOUSE = 9,
	OFFER_TYPE_EXPBOOST = 10,
	OFFER_TYPE_PREYSLOT = 11,
	OFFER_TYPE_PREYBONUS = 12,
	OFFER_TYPE_TEMPLE = 13,
	OFFER_TYPE_BLESSINGS = 14,
	OFFER_TYPE_PREMIUM = 15,
	-- 16, -- Empty
	OFFER_TYPE_ALLBLESSINGS = 17,
	OFFER_TYPE_INSTANT_REWARD_ACCESS = 18,
	OFFER_TYPE_CHARMS = 19,
	OFFER_TYPE_HIRELING = 20,
	OFFER_TYPE_HIRELING_NAMECHANGE = 21,
	OFFER_TYPE_HIRELING_SEXCHANGE = 22,
	OFFER_TYPE_HIRELING_SKILL = 23,
	OFFER_TYPE_HIRELING_OUTFIT = 24,
	OFFER_TYPE_HUNTINGSLOT = 25,
	OFFER_TYPE_ITEM_BED = 26,
	OFFER_TYPE_ITEM_UNIQUE = 27,
}

GameStore.SubActions = {
	PREY_THIRDSLOT_REAL = 0,
	PREY_WILDCARD = 1,
	INSTANT_REWARD = 2,
	BLESSING_TWIST = 3,
	BLESSING_SOLITUDE = 4,
	BLESSING_PHOENIX = 5,
	BLESSING_SUNS = 6,
	BLESSING_SPIRITUAL = 7,
	BLESSING_EMBRACE = 8,
	BLESSING_BLOOD = 9,
	BLESSING_HEART = 10,
	BLESSING_ALL_PVE = 11,
	BLESSING_ALL_PVP = 12,
	CHARM_EXPANSION = 13,
	TASKHUNTING_THIRDSLOT = 14,
	PREY_THIRDSLOT_REDIRECT = 15,
}

GameStore.ActionType = {
	OPEN_HOME = 0,
	OPEN_PREMIUM_BOOST = 1,
	OPEN_CATEGORY = 2,
	OPEN_USEFUL_THINGS = 3,
	OPEN_OFFER = 4,
	OPEN_SEARCH = 5,
}

GameStore.CoinType = {
	Coin = 0,
	Transferable = 1,
}

GameStore.Kv = {
	expBoostCount = "exp-boost-count",
	purchaseCooldown = "purchase-cooldown",
}

GameStore.ConverType = {
	SHOW_NONE = 0,
	SHOW_MOUNT = 1,
	SHOW_OUTFIT = 2,
	SHOW_ITEM = 3,
	SHOW_HIRELING = 4,
}

GameStore.ConfigureOffers = {
	SHOW_NORMAL = 0,
	SHOW_CONFIGURE = 1,
}

GameStore.ClientOfferTypes = {
	CLIENT_STORE_OFFER_OTHER = 0,
	CLIENT_STORE_OFFER_NAMECHANGE = 1,
	CLIENT_STORE_OFFER_HIRELING = 3,
}

GameStore.HistoryTypes = {
	HISTORY_TYPE_NONE = 0,
	HISTORY_TYPE_GIFT = 1,
	HISTORY_TYPE_REFUND = 2,
}

GameStore.States = {
	STATE_NONE = 0,
	STATE_NEW = 1,
	STATE_SALE = 2,
	STATE_TIMED = 3,
}

GameStore.StoreErrors = {
	STORE_ERROR_PURCHASE = 0,
	STORE_ERROR_NETWORK = 1,
	STORE_ERROR_HISTORY = 2,
	STORE_ERROR_TRANSFER = 3,
	STORE_ERROR_INFORMATION = 4,
}

GameStore.ServiceTypes = {
	SERVICE_STANDERD = 0,
	SERVICE_OUTFITS = 3,
	SERVICE_MOUNTS = 4,
	SERVICE_BLESSINGS = 5,
}

GameStore.SendingPackets = {
	S_CoinBalance = 0xDF, -- 223
	S_StoreError = 0xE0, -- 224
	S_RequestPurchaseData = 0xE1, -- 225
	S_CoinBalanceUpdating = 0xF2, -- 242
	S_OpenStore = 0xFB, -- 251
	S_StoreOffers = 0xFC, -- 252
	S_OpenTransactionHistory = 0xFD, -- 253
	S_CompletePurchase = 0xFE, -- 254
}

GameStore.RecivedPackets = {
	C_StoreEvent = 0xE9, -- 233
	C_TransferCoins = 0xEF, -- 239
	C_ParseHirelingName = 0xEC, -- 236
	C_OpenStore = 0xFA, -- 250
	C_RequestStoreOffers = 0xFB, -- 251
	C_BuyStoreOffer = 0xFC, -- 252
	C_OpenTransactionHistory = 0xFD, -- 253
	C_RequestTransactionHistory = 0xFE, -- 254
}

GameStore.ExpBoostValues = {
	[1] = 30,
	[2] = 45,
	[3] = 90,
	[4] = 180,
	[5] = 360,
}

GameStore.DefaultValues = {
	DEFAULT_VALUE_ENTRIES_PER_PAGE = 26,
}

GameStore.DefaultDescriptions = {
	OUTFIT = { "This outfit looks nice. Only high-class people are able to wear it!", "An outfit that was created to suit you. We are sure you'll like it.", "Legend says only smart people should wear it, otherwise you will burn!" },
	MOUNT = { "This is a fantastic mount that helps to become faster, try it!", "The first rider of this mount became the leader of his country! legends say that." },
	NAMECHANGE = { "Are you hunted? Tired of that? Get a new name, a new life!", "A new name to suit your needs!" },
	SEXCHANGE = { "Bored of your character's sex? Get a new sex for him now!!" },
	EXPBOOST = { "Are you tired of leveling slow? try it!" },
	PREYSLOT = {
		"It's hunting season! Activate a prey to gain a bonus when hunting a certain monster. Every character can purchase one Permanent Prey Slot, which enables the activation of an additional prey. \\nIf you activate a prey, you can select one monster out of nine. The bonus for your prey will be selected randomly from one of the following: damage boost, damage reduction, bonus XP, improved loot. The bonus value may range from 5% to 50%. Your prey will be active for 2 hours hunting time: the duration of an active prey will only be reduced while you are hunting.",
	},
	PREYBONUS = {
		"You activated a prey but do not like the randomly selected bonus? Roll for a new one! Here you can purchase five Prey Bonus Rerolls! \\nA Bonus Reroll allows you to get a bonus with a higher value (max. 50%). The bonus for your prey will be selected randomly from one of the following: damage boost, damage reduction, bonus XP, improved loot. The 2 hours hunting time will start anew once you have rolled for a new bonus. Your prey monster will stay the same.",
	},
	TEMPLE = { "Need a quick way home? Buy this transportation service to get instantly teleported to your home temple. \\n\\nNote, you cannot use this service while having a battle sign or a protection zone block. Further, the service will not work in no-logout zones or close to your home temple." },
}

GameStore.ItemLimit = {
	PREY_WILDCARD = 50,
	INSTANT_REWARD_ACCESS = 90,
	EXPBOOST = 6,
	HIRELING = 10,
}

return GameStore
