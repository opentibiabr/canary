local quest = {
	name = "Hot Cuisine",
	startStorageId = Storage.Quest.U8_5.HotCuisineQuest.QuestStart,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Hot Cuisine",
			storageId = Storage.Quest.U8_5.HotCuisineQuest.QuestLog,
			missionId = 1070,
			startValue = 1,
			endValue = 16,
			states = {
				[1] = "You've become the apprentice of Maltre Jean Pierre. \z
					The first dish he will teach you to prepare is Rotworm Stew. Bring him the ingredients he told you.",
				[2] = "You have completed the first dish, the second dish he will teach you to prepare is Hydra Tongue Salad. \z
					Bring him the ingredients he told you.",
				[3] = "You have completed the second dish, the third dish he will teach you to prepare is Roasted Dragon Wings. \z
					Bring him the ingredients he told you.",
				[4] = "You have completed the third dish, the fourth dish he will teach you to prepare is Tropical Fried \z
					Terrorbird. Bring him the ingredients he told you.",
				[5] = "You have completed the fourth dish, the fifth dish he will teach you to prepare is \z
					Banana Chocolate Shake. Bring him the ingredients he told you.",
				[6] = "You have completed the fifth dish, the sixth dish he will teach you to prepare is Veggie Casserole. \z
					Bring him the ingredients he told you.",
				[7] = "You have completed the sixth dish, the seventh dish he will teach you to prepare is \z
					Filled Jalapeno Peppers. Bring him the ingredients he told you.",
				[8] = "You have completed the seventh dish, the eight dish he will teach you to prepare is Blessed Steak. \z
					Bring him the ingredients he told you.",
				[9] = "You have completed the eight dish, the ninth dish he will teach you to prepare is Northern Fishburger. \z
					Bring him the ingredients he told you.",
				[10] = "You have completed the ninth dish, the tenth dish he will teach you to prepare is Carrot Cake. \z
					Bring him the ingredients he told you.",
				[11] = "You have completed the tenth dish. You are now able to obtain the cookbook from \z
					Jean Pierre's room upstairs.",
				[12] = "The eleventh dish he will teach you to prepare is Coconut Shrimp Bake. \z
					Bring him the ingredients he told you.",
				[13] = "You have completed the eleventh dish, the twelfth dish he will teach you to prepare is Blackjack. \z
					Bring him the ingredients he told you.",
				[14] = "You have completed the twelfth dish, the thirteenth dish he will teach you to \z
					prepare is Demonic Candy Balls. Bring him the ingredients he told you.",
				[15] = "You have completed the thirteenth dish, the fourteenth dish he will teach you to \z
					prepare is Sweet Mangonaise Elixir. Bring him the ingredients he told you.",
				[16] = "You have completed all the dishes. You are now able to make all the dishes in any order you want.",
			},
		},
	},
}

return quest
