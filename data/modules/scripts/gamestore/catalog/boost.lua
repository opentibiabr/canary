return {
	icons = { "Category_Boosts.png" },
	name = "Boosts",
	rookgaard = true,
	state = GameStore.States.STATE_NONE,
	offers = {
		{
			icons = { "XP_Boost.png" },
			name = "XP Boost",
			price = 30,
			id = 65010,
			description = "<i>Purchase a boost that increases the experience points your character gains from hunting by 50%!</i>\n\n{character}\n{info} lasts for 1 hour hunting time\n{info} paused if stamina falls under 14 hours\n{info} can be purchased up to 5 times between 2 server saves\n{info} price increases with every purchase\n{info} cannot be purchased if an XP boost is already active",
			type = GameStore.OfferTypes.OFFER_TYPE_EXPBOOST,
		},
	},
}
