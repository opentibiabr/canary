local quest = {
	name = "Blood Brothers",
	startStorageId = Storage.Quest.U8_4.BloodBrothers.Trust,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 01: Gaining Trust",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission01,
			missionId = 10433,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Think of a way to earn Julius' trust and prove that you are not a vampire. \z
					Once you have thought of something, talk to him again about your mission.",
				[2] = "Julius wants more proof. He asked if you have ever baked garlic bread. \z
					Confirm whether you know how to bake it.",
				[3] = "Bake a garlic bread by using holy water on flour, then use the dough on garlic, \z
					and bake it in an oven. Bring it back to Julius and eat it in front of him.",
				[4] = "You have earned Julius' trust.",
			},
		},
		[2] = {
			name = "Mission 02: Bad Eggs",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission02,
			missionId = 10434,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Bake garlic cookies by using the garlic dough on a baking tray before putting it \z
					in the oven. Hand out cookies to the citizens and watch their reactions. \z
					Report any suspicious people to Julius.",
				[2] = "You have reported five suspects — probably vampires — to Julius.",
			},
		},
		[3] = {
			name = "Mission 03: His True Face",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission03,
			missionId = 10435,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Use the magic words 'alori mort' in front of the five suspicious citizens \z
					to reveal who among them is their leader.",
				[2] = "You used the spell on all five suspects. Report your findings to Julius.",
				[3] = "You reported the incident with Armenius to Julius.",
			},
		},
		[4] = {
			name = "Mission 04: The Dark Lands",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission04,
			missionId = 10436,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find someone to bring you to Vengoth. Explore the island and use Julius' map \z
					whenever you find an unusual spot to mark it. Mark at least 5 spots including \z
					the castle and report back to Julius.",
				[2] = "You have successfully mapped Vengoth and reported back to Julius.",
			},
		},
		[5] = {
			name = "Mission 05: Into the Castle",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission05,
			missionId = 10467,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Find a blood crystal somewhere in Yalahar. Ask around to find out where \z
					you could get one.",
				[2] = "Charge the blood crystal by finding someone who has lost something or \z
					someone dear to them. Their grief emits powerful energy.",
				[3] = "Gather three more adventurers with charged blood crystals. Stand together \z
					on the four symbols around Vengoth castle to attune yourselves and unlock \z
					the gate. Report back to Julius.",
				[4] = "You entered the castle but were blocked by invulnerable ghosts. Search for \z
					documents and books inside that reveal the history of the castle and its masters.",
			},
		},
		[6] = {
			name = "Mission 06: A Black History",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission06,
			missionId = 10468,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Explore the castle further. Search for hidden passages and look for \z
					documents or books that reveal the dark history of the castle and its masters.",
				[2] = "You have uncovered the black history of the vampire brothers. Report your \z
					findings to Julius and explore deeper to find Boreth, the first of the four brothers.",
			},
		},
		[7] = {
			name = "Mission 07: Boreth",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission07,
			missionId = 10469,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find Boreth, the first of the four vampire brothers, hidden somewhere in \z
					the castle. Defeat him and bring Julius proof of his death.",
				[2] = "You have defeated Boreth, the first of the four vampire brothers.",
			},
		},
		[8] = {
			name = "Mission 08: Lersatio",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission08,
			missionId = 10470,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Defeat Lersatio, the second vampire brother. He lurks in another tower \z
					of the castle. Use his mirrors to shatter them and lure him out. \z
					Bring Julius proof of his death.",
				[2] = "You have defeated Lersatio, the second vampire brother.",
			},
		},
		[9] = {
			name = "Mission 09: Marziel",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission09,
			missionId = 10471,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Defeat Marziel, the third vampire brother. Find access to his tower. \z
					A female character must step onto the throne carrying a vial of blood \z
					to awaken him. Bring Julius proof of his death.",
				[2] = "You have defeated Marziel, the third vampire brother.",
			},
		},
		[10] = {
			name = "Mission 10: Arthei",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission10,
			missionId = 10472,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Defeat Arthei, the master vampire brother. Find him in the deepest part \z
					of the castle and bring Julius proof of his death.",
				[2] = "You have defeated all four vampire brothers and freed Yalahar from their \z
					curse. Julius rewarded you with a special crest.",
			},
		},
	},
}

return quest
