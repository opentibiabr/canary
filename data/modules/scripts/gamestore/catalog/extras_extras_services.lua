return {
	icons = { "Category_ExtraServices.png" },
	name = "Extra Services",
	parent = "Extras",
	rookgaard = true,
	state = GameStore.States.STATE_NONE,
	offers = {
		{
			icons = { "Name_Change.png" },
			name = "Character Name Change",
			price = 250,
			id = 65002,
			description = "<i>Tired of your current character name? Purchase a new one!</i>\n\n{character}\n{info} relog required after purchase to finalise the name change",
			type = GameStore.OfferTypes.OFFER_TYPE_NAMECHANGE,
		},
		{
			icons = { "Sex_Change.png" },
			name = "Character Sex Change",
			price = 120,
			id = 65003,
			description = "<i>Turns your female character into a male one - or vice versa.</i>\n\n{character}\n{activated}\n{info} you will keep all outfits you have purchased or earned in quest",
			type = GameStore.OfferTypes.OFFER_TYPE_SEXCHANGE,
		},
	},
}
