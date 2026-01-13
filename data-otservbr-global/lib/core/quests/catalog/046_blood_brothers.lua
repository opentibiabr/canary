local quest = {
	name = "Blood Brothers",
	startStorageId = Storage.Quest.U8_4.BloodBrothers.QuestLine,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 01: Gaining Trust",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission01,
			missionId = 10433,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Think of a way to earn Julius' trust and prove that you are not a vampire. Once you thought of something, talk to him again about your mission.",
				[2] = "",
				[3] = "",
				[4] = "You have Julius' trust.",
			},
		},
		[2] = {
			name = "Mission 02: Bad Eggs",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission02,
			missionId = 10434,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Bake garlic cookies by using the garlic dough on a baking tray before you put it on the oven. Hand out cookies to the citizens and watch their reactions. Report any suspicious people to Julius.",
				[2] = "You have reported five suspects - probably vamires - to Julius.",
			},
		},
		[3] = {
			name = "Mission 03: His True Face",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission03,
			missionId = 10435,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Use the magic words 'alori mort' in front of the suspicious citizens you discovered to hopefully reveal who among them is their leader.",
				[2] = "",
				[3] = "You reported the incident with Armenius to Julius.",
			},
		},
		[4] = {
			name = "Mission 04: The Dark Lands",
			storageId = Storage.Quest.U8_4.BloodBrothers.Mission04,
			missionId = 10436,
			startValue = 1,
			endValue = 1,
			states = {
				[1] = "Your task is to find someone to bring you to Vengoth. Explore the island and use Julius' map whenever you find an unusual spot to mark it. Mark at least 5 spots including the castle and report back.",
			},
		},
	},
}

return quest
