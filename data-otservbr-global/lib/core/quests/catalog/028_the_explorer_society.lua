local quest = {
	name = "The Explorer Society",
	startStorageId = Storage.Quest.U7_6.ExplorerSociety.QuestLine,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Joining the Explorers",
			storageId = Storage.Quest.U7_6.ExplorerSociety.JoiningTheExplorers,
			missionId = 10295,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "The mission should be simple to fulfil. You have to seek out Uzgod in \z
					Kazordoon and get the pickaxe for us. Or just find dwarven pickaxe on your own...",
				[2] = "Get into Dwacatra and get Uzgod's family brooch.",
				[3] = "Bring family brooch back to Uzgod",
				[4] = "Bring the pickaxe back to the Explorer Society representative.",
				[5] = "You have completed Joining the Explorers",
			},
		},
		[2] = {
			name = "The Ice Delivery",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheIceDelivery,
			missionId = 10296,
			startValue = 6,
			endValue = 8,
			states = {
				[6] = "Take this ice pick and use it on a block of ice in the caves beneath Folda. \z
					Get some ice and bring it here as fast as you can. \z
					If the ice melt away, report on your ice delivery mission anyway.",
				[7] = "You have 10 minutes before the icicle defrosts. Run back to the Explorer Society representative!",
				[8] = "You have completed The Ice Delivery.",
			},
		},
		[3] = {
			name = "The Butterfly Hunt",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheButterflyHunt,
			missionId = 10297,
			startValue = 9,
			endValue = 17,
			states = {
				[9] = "This preparation kit will allow you to collect a PURPLE butterfly you have killed. \z
					Just use it on the fresh corpse of a PURPLE butterfly.",
				[10] = "Return the prepared butterfly to Explorer Society representative.",
				[11] = "Ask for another butterfly hunt.",
				[12] = "This preparation kit will allow you to collect a BLUE butterfly you have killed. \z
					Just use it on the fresh corpse of a BLUE butterfly.",
				[13] = "Return the prepared butterfly to Explorer Society representative.",
				[14] = "Ask for another butterfly hunt.",
				[15] = "This preparation kit will allow you to collect a RED butterfly you have killed. \z
					Just use it on the fresh corpse of a RED butterfly.",
				[16] = "Return the prepared butterfly to Explorer Society representative.",
				[17] = "You have completed The Butterfly Hunt.",
			},
		},
		[4] = {
			name = "The Plant Collection",
			storageId = Storage.Quest.U7_6.ExplorerSociety.ThePlantCollection,
			missionId = 10298,
			startValue = 18,
			endValue = 26,
			states = {
				[18] = "Take botanist's container. Use it on a jungle bells plant to collect a sample.",
				[19] = "Report about your plant collection to Explorer Society representative.",
				[20] = "Ask for plant collection when you are ready to continue.",
				[21] = "Use botanist's container on a witches cauldron to collect a sample.",
				[22] = "Report about your plant collection to Explorer Society representative.",
				[23] = "Ask for plant collection when you are ready to continue.",
				[24] = "Use this botanist's container on a giant jungle rose to obtain a sample.",
				[25] = "Report about your plant collection to Explorer Society representative.",
				[26] = "You have completed The Plant Collection.",
			},
		},
		[5] = {
			name = "The Lizard Urn",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheLizardUrn,
			missionId = 10299,
			startValue = 27,
			endValue = 29,
			states = {
				[27] = "In the south-east of Tiquanda is a small settlement of the lizard people. \z
					Beneath the newly constructed temple there, the lizards hide the urn. \z
					Acquire an ancient urn which is some sort of relic to the lizard people of Tiquanda.",
				[28] = "Bring the Funeral Urn back to the Explorer Society.",
				[29] = "You have completed The Lizard Urn.",
			},
		},
		[6] = {
			name = "The Bonelord Secret",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheBonelordSecret,
			missionId = 10300,
			startValue = 30,
			endValue = 32,
			states = {
				[30] = "Travel to the city of Darashia and then head north-east for the pyramid. \z
						If any documents are left, you probably find them in the catacombs beneath.",
				[31] = "Bring the Wrinkled Parchment back to the Explorer Society representative.",
				[32] = "You have completed The Bonelord Secret.",
			},
		},
		[7] = {
			name = "The Orc Powder",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheOrcPowder,
			missionId = 10301,
			startValue = 33,
			endValue = 35,
			states = {
				[33] = "As far as we can tell, the orcs maintain some sort of training facility \z
					in some hill in the north-east of their city. \z
					There you should find lots of their war wolves and hopefully also some of the orcish powder.",
				[34] = "Bring the Strange Powder to the Explorer Society representative to complete your mission.",
				[35] = "You have completed The Orc Powder.",
			},
		},
		[8] = {
			name = "The Elven Poetry",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheElvenPoetry,
			missionId = 10302,
			startValue = 36,
			endValue = 38,
			states = {
				[36] = "This mission is easy but nonetheless vital. Travel Hellgate beneath Ab'Dendriel and get the book.",
				[37] = "Bring back an elven poetry book to the Explorer Society representative.",
				[38] = "You have completed The Elven Poetry.",
			},
		},
		[9] = {
			name = "The Memory Stone",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheMemoryStone,
			missionId = 10303,
			startValue = 39,
			endValue = 41,
			states = {
				[39] = "In the ruins of north-western Edron you should be able to find a memory stone. ",
				[40] = "Bring back a memory stone to the Explorer Society representative.",
				[41] = "You have completed The Memory Stone.",
			},
		},
		[10] = {
			name = "The Rune Writings",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheRuneWritings,
			missionId = 10304,
			startValue = 42,
			endValue = 44,
			states = {
				[42] = "Somewhere under the ape infested city of Banuta, one can find dungeons \z
					that were once inhabited by lizards. Look there for an atypical structure that \z
					would rather fit to Ankrahmun and its Ankrahmun Tombs. Copy the runes you will find on this structure.",
				[43] = "Report back to the Explorer Society representative.",
				[44] = "You have completed The Rune Writings.",
			},
		},
		[11] = {
			name = "The Ectoplasm",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheEctoplasm,
			missionId = 10305,
			startValue = 45,
			endValue = 47,
			states = {
				[45] = "Take ectoplasm container and use it on a ghost that was recently slain.",
				[46] = "Return back to the Explorer Society representative with the collected ectoplasm.",
			},
		},
		[12] = {
			name = "The Spectral Dress",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheSpectralDress,
			missionId = 10306,
			startValue = 48,
			endValue = 50,
			states = {
				[48] = "The queen of the banshees lives in the so called Ghostlands, south west of Carlin. \z
					Try to get a spectral dress from her.",
				[49] = "Report to the Explorer Society with the spectral dress.",
			},
		},
		[13] = {
			name = "The Spectral Stone",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheSpectralStone,
			missionId = 10307,
			startValue = 51,
			endValue = 55,
			states = {
				[51] = "Please travel to our second base and ask them to mail us their latest research reports. \z
					Then return here and ask about new missions.",
				[52] = "Tell our fellow explorer that the papers are in the mail already.",
				[53] = "Take the spectral essence and use it on the strange carving in this building \z
					as well as on the corresponding tile in our second base.",
				[54] = "Good! Now use the spectral essence on the strange carving in our second base.",
			},
		},
		[14] = {
			name = "The Astral Portals",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheAstralPortals,
			missionId = 10308,
			startValue = 56,
			endValue = 56,
			states = {
				[56] = "Both carvings are now charged and harmonised. You are able to travel in zero time from \z
					one base to the other, but you need to have an orichalcum pearl in your possession to use it as power source.",
			},
		},
		[15] = {
			name = "The Island of Dragons",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheIslandofDragons,
			missionId = 10309,
			startValue = 57,
			endValue = 59,
			states = {
				[57] = "Travel to Okolnir and try to find a proof for the existence of dragon lords there in the old times. \z
					I think old Buddel might be able to bring you there.",
				[58] = "Report back to Lurik with the dragon scale.",
			},
		},
		[16] = {
			name = "The Ice Music",
			storageId = Storage.Quest.U7_6.ExplorerSociety.TheIceMusic,
			missionId = 10310,
			startValue = 60,
			endValue = 62,
			states = {
				[60] = "There is a cave on Hrodmir, north of the southernmost barbarian camp Krimhorn. \z
					In this cave, there are a waterfall and a lot of stalagmites. \z
					Take the resonance crystal and use it on the stalagmites in the cave to record the sound of the wind.",
				[61] = "Report back to Lurik.",
				[62] = "Now you may use the Astral Bridge from Liberty Bay to Svargrond.",
			},
		},
		[17] = {
			name = "The Undersea Kingdom",
			storageId = Storage.Quest.U7_6.ExplorerSociety.CalassaQuest,
			missionId = 10311,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Captain Max will bring you to Calassa whenever you are ready. Please try to retrieve the missing logbook which must be in one of the sunken shipwrecks.",
				[2] = "Report about your Calassa mission to Berenice in Liberty Bay.",
				[3] = "Congratulations, you completed the remaining part of this mission!",
			},
		},
	},
}

return quest
