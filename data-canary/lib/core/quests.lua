if not Quests then
	Quests = {
		[1] = {
			name = "Example",
			startStorageId = Storage.Quest.ExampleQuest.Example,
			startStorageValue = 1,
			missions = {
				[1] = {
					name = "The Hidden Seal",
					storageId = Storage.Quest.ExampleQuest.Example,
					missionId = 1,
					startValue = 1,
					endValue = 1,
					description = "You broke the first seal.",
				},
			},
		},
	}
end
