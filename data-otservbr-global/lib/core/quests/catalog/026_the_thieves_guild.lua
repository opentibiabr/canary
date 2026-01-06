local quest = {
	name = "The Thieves Guild",
	startStorageId = Storage.Quest.U8_2.TheThievesGuildQuest.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 1: Ivory Poaching",
			storageId = Storage.Quest.U8_2.TheThievesGuildQuest.Mission01,
			missionId = 10280,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Dorian wants you to collect 10 elephant tusks and deliver them to him.",
				[2] = "You delivered the ten tusks to Dorian.",
			},
		},
		[2] = {
			name = "Mission 2: Burglary",
			storageId = Storage.Quest.U8_2.TheThievesGuildQuest.Mission02,
			missionId = 10281,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Dorian wants you to steal a vase from Sarina, the owner of Carlin's general store.",
				[2] = "You have stolen the vase, report back to Dorian!",
				[3] = "You have delivered the stolen vase to Dorian, ask him for a new mission!",
			},
		},
		[3] = {
			name = "Mission 3: Invitation",
			storageId = Storage.Quest.U8_2.TheThievesGuildQuest.Mission03,
			missionId = 10282,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Your task is to somehow convince Oswald to hand you an invitation to the king's ball.",
				[2] = "You have received the invitation to the King's ball, report back to Dorian!",
				[3] = "You have delivered the invitation to Dorian, ask him for a new mission!",
			},
		},
		[4] = {
			name = "Mission 4: Bridge Robbery",
			storageId = Storage.Quest.U8_2.TheThievesGuildQuest.Mission04,
			missionId = 10283,
			startValue = 1,
			endValue = 8,
			states = {
				[1] = "Dorian wants you to find a forger in the outlaw camp, go talk to Snake eye.",
				[2] = "Snake Eye told you to visit Ahmet in Ankrahmun.",
				[3] = "Ahmet told you that he will only help a friend and asked you to kill at least one Nomad.",
				[4] = "You have killed a Nomad, go back to Ahmet!",
				[5] = "You have received the forged documents from Ahmet, next is to get a disguise from Percybald in Venore!",
				[6] = "You have received the dwarf disguise from Percybald. Now go do the deal with Nurik.",
				[7] = "You have traded the forged documents for the painting, report back to Dorian.",
				[8] = "You have delivered the painting to Dorian, ask him for a new mission!",
			},
		},
		[5] = {
			name = "Mission 5: Enforcing Debts",
			storageId = Storage.Quest.U8_2.TheThievesGuildQuest.Mission05,
			missionId = 10284,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your mission is to travel to Tiquanda. Fina a hidden smuggler cave to the north of Port Hope \z
				and try to retrieve the valuable goblet which Dorian is looking for. Once you got it, bring it to him.",
				[2] = "You have delivered the golden goblet to Dorian, ask him for a new mission!",
			},
		},
		[6] = {
			name = "Mission 6: Fishnapping",
			storageId = Storage.Quest.U8_2.TheThievesGuildQuest.Mission06,
			missionId = 10285,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Dorian wants you to fishnap Theodore Loveless' fish, first you need to get the key to his room. \z
				Talk to Chantalle in Liberty Bay.",
				[2] = "You have received the key for Theodore Loveless' room, time to fishnap his fish!",
				[3] = "You have fishnapped Theodore Loveless' fish, deliver it to Dorian.",
				[4] = "You have delivered the fish to Dorian, ask him for a new mission!",
			},
		},
		[7] = {
			name = "Mission 7: Blackmail",
			storageId = Storage.Quest.U8_2.TheThievesGuildQuest.Mission07,
			missionId = 10286,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your current task is to find compromising information about one of the \z
				Venore city guards, no matter how. A good starting point might be in their barracks.",
				[2] = "You have delivered the compromising letter to Dorian, ask him for a new mission!",
			},
		},
		[8] = {
			name = "Mission 8: Message",
			storageId = Storage.Quest.U8_2.TheThievesGuildQuest.Mission08,
			missionId = 10287,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Dorian wants you to deliver a message to his competitors in the dark cathedral.",
				[2] = "You have put up the message, report back to Dorian.",
				[3] = "You have reported back that you have completed the mission, \z
				Dorian now allows you to trade with Black Bert.",
			},
		},
	},
}

return quest
