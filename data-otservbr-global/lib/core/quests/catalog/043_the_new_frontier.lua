local quest = {
	name = "The New Frontier",
	startStorageId = Storage.Quest.U8_54.TheNewFrontier.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 01: New Land",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission01,
			missionId = 10409,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Explore the new land and reach the bottom of the mountain.",
				[2] = "You have found a passage from the mountains. You can report back to Ongulf.",
				[3] = "You have reported the scouted route to Ongulf.",
			},
		},
		[2] = {
			name = "Mission 02: From Kazordoon With Love",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission02[1],
			missionId = 10410,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Find Melfar of the imperial mining guild close to a mine entrance west of Kazordoon. \z
				Ask him to send more miners and wood.",
				[2] = "Prepare the three trees which Melfar marked on your map with the beaver bait. \z
				Once you've marked all three return to Melfar and tell him about your success.",
				[3] = "Melfar has finally promised to send more miners and wood. Report this to Ongulf in Farmine.",
				[4] = "You have reported that Melfar will send more miners and wood for Farmine.",
			},
		},
		[3] = {
			name = "Mission 03: Strangers in the Night",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission03,
			missionId = 10411,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Find the unknown stalkers somewhere in the mountains. They apparently climbed up \z
				somewhere during their escape. Try to negotiate a peaceful agreement if possible.",
				[2] = "You have talked to the leader of the primitive humans and have assured their peacefulness. \z
				Report this to Ongulf back in the base.",
				[3] = "You have negotiated a peacful agreement between the dwarfs and the local primitives.",
			},
		},
		[4] = {
			name = "Mission 04: The Mine Is Mine",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission04,
			missionId = 10412,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Free the mine of the monstrous threat. Use a lift to reach the mines and look for a leader \z
				of the stone creatures. Slay this creature and report back to Ongulf.",
				[2] = "You have slain the monster that terrorised the mines.",
			},
		},
		[5] = {
			name = "Mission 05: Getting Things Busy",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission05[1],
			missionId = 10413,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = 'Try getting the support of the people mentioned. Talk to them about "farmine", then \z
					choose the "flatter", "threaten", "impress", "bluff", "reason" or "plea" and report \z
					any progress to Ongulf.',
				[2] = "You have gained the necessary support for Farmine.",
			},
		},
		[6] = {
			name = "Mission 5: Support of Kazordoon's Worm Tamer",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission05.Humgolf,
			missionId = 10414,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Talk to the worm tamer in Kazordoon.",
				[2] = "Find an item that interests Humgolf to get another chance.",
			},
		},
		[7] = {
			name = "Mission 5: Support of the Edron Academy",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission05.Wyrdin,
			missionId = 10415,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Talk to the magician Wyrdin in the Edron Academy.",
				[2] = "Find an item that interests Wyrdin to get another chance.",
			},
		},
		[8] = {
			name = "Mission 5: Support of the Explorer Society",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission05.Angus,
			missionId = 10416,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Talk to the representative of the Explorer Society in Port Hope.",
				[2] = "Find an item that interests Angus to get another chance.",
			},
		},
		[9] = {
			name = "Mission 5: Support of the Inventor Telas",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission05.Telas,
			missionId = 10417,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Talk to the inventor Telas in Edron.",
				[2] = "Find an item that interests Telas to get another chance.",
			},
		},
		[10] = {
			name = "Mission 5: Support of the Thaian King",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission05.KingTibianus,
			missionId = 10418,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Talk to King Tibianus in the Thaian Castle.",
				[2] = "Find an item that interests King Tibianus to get another chance.",
			},
		},
		[11] = {
			name = "Mission 5: Support of the Venorean Traders",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission05.Leeland,
			missionId = 10419,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Talk to Leeland Slim, the representative of the Venorean Traders.",
				[2] = "Find an item that interests Leeland Slim to get another chance.",
			},
		},
		[12] = {
			name = "Mission 06: Days Of Doom",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission06,
			missionId = 10420,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Try to pacify the orcs of the steppe. It is probably necessary to find some leader of the orcish tribes.",
				[2] = "You have talked to the minotaur leaders of the orcs. They agreed to spare Farmine if you \z
				prove your worth in their arena. You will have to survive against Mooh'Tah master for 2 minutes, so prepare!",
				[3] = "You have survived the arena. Talk to Curos again about your mission.",
				[4] = "Your negotiations had moderate success. Your can report back to Ongulf.",
				[5] = "You have ensured a brittle peace between Farmine and the orcs.",
			},
		},
		[13] = {
			name = "Mission 07: Messengers Of Peace",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission07[1],
			missionId = 10421,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find a lizardman somewhere in the north and try to start a negotiation of peace.",
				[2] = "It seems that the lizardmen are not interested in peace and you will have to focus \z
				on other problems at hand.",
			},
		},
		[14] = {
			name = "Mission 08: An Offer You Can't Refuse",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission08,
			missionId = 10422,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Captured by lizardmen trap you have to find a way out of the prison. Perhaps \z
				something in your cell might lead you to an opportunity for freedom.",
				[2] = "You managed to find a way of the captivity of the lizardmen - but for a price.",
			},
		},
		[15] = {
			name = "Mission 09: Mortal Combat",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission09[1],
			missionId = 10423,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "You are expected to participate in the great tournament of the lizard race. \z
				Travel to the Isle of Strife and brave the challenges there.",
				[2] = "You are the champion of the great tournament! Still the lizardmen are a menace to \z
				behold. You should report to Chrak before you leave the isle.",
				[3] = "You have reported your latest doings to Chrak. It seems you bought the dwarfs some \z
				time of peace. Only the dragon kings may know how long though.",
			},
		},
		[16] = {
			name = "Mission 10: New Horizons",
			storageId = Storage.Quest.U8_54.TheNewFrontier.Mission10[1],
			missionId = 10424,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Ongulf will be anxious to learn about your latest adventures. Travel back to Farmine \z
				for a final report.",
				[2] = "Ongulf got very satisfied with your journey, this land is yours to be taken. You can \z
				find now on top of the mountain a red carpet, it might offer you access to some cities.", -- This last questlog message is not accurate, need to update.
			},
		},
		[17] = {
			name = "Tome of Knowledge Counter",
			storageId = Storage.Quest.U8_54.TheNewFrontier.TomeofKnowledge,
			missionId = 10425,
			startValue = 1,
			endValue = 12,
			states = {
				[1] = "You brought the fist Tome of Knowledge to Cael. He learnt more about the lizard culture. \z
				Pompan will sell you dragon tapestries from now on.",
				[2] = "You brought the second Tome of Knowledge to Cael. He learnt more about the minotaur culture. \z
				Pompan will sell you minotaur backpacks from now on.",
				[3] = "You brought the third Tome of Knowledge to Cael. \z
				He learnt more about the last stand of the draken culture. Esrik will sell you lizard weapon rack from now on.",
				[4] = "You brought the fourth Tome of Knowledge to Cael. \z
				He learnt something interesting about a certain food that the lizardmen apparently prepare. \z
				Swolt will trade you a bunch of ripe rice for 10 rice balls from now on.",
				[5] = "You brought the fifth Tome of Knowledge to Cael. \z
				He learnt more about the last stand of the lizards in the South, Zzaion. \z
				Pompan will sell you lizard backpacks from now on.",
				[6] = "You brought the sixth Tome of Knowledge to Cael. \z
				He learnt a few things about the primitive human culture on this continent. \z
				Cael will sell you War Drums and Didgeridoo from now on.",
				[7] = "You brought the seventh Tome of Knowledge to Cael. \z
				He learnt something interesting about the Zao steppe. \z
				Now you to use the snake teleport at the peak of the mountain.",
				[8] = "You brought the eighth Tome of Knowledge to Cael. \z
				He learnt a few things about an illness. \z
				Now you can enter a corruption hole in the north-eastern end of Zao.",
				[9] = "You brought the ninth Tome of Knowledge to Cael. \z
				He learnt something interesting about the Draken origin. \z
				Esrik will buy lizard equipment from you now.",
				[10] = "You brought the tenth Tome of Knowledge to Cael. \z
				He learnt more about the last stand of the lizard dynasty. \z
				Now you can enter the Zao Palace. It is situated deep underground, below the mountain base of the Lizards.",
				[11] = "You brought the eleventh Tome of Knowledge to Cael. \z
				He learnt something interesting about dragons and their symbolism. \z
				You can buy a Dragon Statue from NPC Cael after you bring him a Red Lantern.",
				[12] = "You brought the twelfth Tome of Knowledge to Cael. \z
				He learnt something about reveals some of the power structures in Zao. \z
				Cael will now make a Dragon Throne for you after you bring him a Red Piece of Cloth. \z
				He will reward you with 5000 experience points for each extra tome you give to him.",
			},
		},
	},
}

return quest
