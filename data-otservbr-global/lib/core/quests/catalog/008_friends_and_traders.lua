local quest = {
	name = "Friends and Traders",
	startStorageId = Storage.Quest.U7_8.FriendsAndTraders.DefaultStart,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "The Sweaty Cyclops",
			storageId = Storage.Quest.U7_8.FriendsAndTraders.TheSweatyCyclops,
			missionId = 1067,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Big Ben, the cyclops in Ab'Dendriel sends you to bring him 3 bast skirts for his woman. \z
					After this he will help you to forge different steel.",
				[2] = "Big Ben, the cyclops in Ab'Dendriel will help you to forge different steel now. \z
					Just ask him if you need something.",
			},
		},
		[2] = {
			name = "The Mermaid Marina",
			storageId = Storage.Quest.U7_8.FriendsAndTraders.TheMermaidMarina,
			missionId = 1068,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Marina, the mermaid north of Sabrehaven sends you to bring her 50 honeycombs. \z
					After this she will help you create spool of yarn.",
				[2] = "Marina, the mermaid north of Sabrehaven will help you to create a spool of yarn \z
					from 10 pieces of spider silk. Just ask her if you need something.",
			},
		},
		[3] = {
			name = "The Blessed Stake",
			storageId = Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake,
			missionId = 1069,
			startValue = 1,
			endValue = 12,
			states = {
				[1] = "Quentin told you about an old prayer which can bind holy energy to an object. Each of its ten lines has to be recited by a different priest though. Bring Quentin a wooden stake from Gamon to start.",
				[2] = 'You received Quentin\'s prayer: "Light shall be near - and darkness afar". Now, bring your stake to Tibra in the Carlin church for the next line of the prayer.',
				[3] = 'You received Tibra\'s prayer: "Hope may fill your heart - doubt shall be banned". Now, bring your stake to Maealil in the Elven settlement for the next line of the prayer.',
				[4] = 'You received Maealil\'s prayer: "Peace may fill your soul - evil shall be cleansed". Now, bring your stake to Yberius in the Venore temple for the next line of the prayer.',
				[5] = 'You received Yberius\' prayer: "Protection will be granted - from dangers at hand". Now, bring your stake to Isimov in the dwarven settlement for the next line of the prayer.',
				[6] = 'You received Isimov\'s prayer: "Unclean spirits shall be repelled". Now, bring your stake to Amanda in Edron for the next line of the prayer.',
				[7] = 'You received Amanda\'s prayer: "Wicked curses shall be broken". Now, bring your stake to Kasmir in Darashia for the next line of the prayer.',
				[8] = 'You received Kasmir\'s prayer: "Let there be honor and humility". Now, bring your stake to Rahkem in Ankrahmun for the next line of the prayer.',
				[9] = 'You received Rahkem\'s prayer: "Let there be power and compassion". Now, bring your stake to Brewster in Port Hope for the next line of the prayer.',
				[10] = 'You received Brewster\'s prayer: "Your hand shall be guided - your feet shall walk in harmony". Now, bring your stake to Tyrias in Liberty Bay for the next line of the prayer.',
				[11] = "You received Tyrias' prayer: \"Your mind shall be a vessel for joy, light and wisdom\". He wasn't exactly happy though and said that if you need some mumbo jumbo again, you should rather go to Chondur.",
				[12] = "Chondur was surprised to hear that you had to travel through all of Tibia to have your wooden stake blessed. He offered you help with the blessing if you should need one again in the future.",
			},
		},
	},
}

return quest
