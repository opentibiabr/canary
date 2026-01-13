local quest = {
	name = "Sam's Old Backpack",
	startStorageId = Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackNpc,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Dwarven Armor Quest",
			storageId = Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackNpc,
			missionId = 10187,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Sam sends you to see Kroox in Kazordoon to get a special dwarven armor. \z
					Just tell him, his old buddy Sam is sending you.",
				[2] = "You have the permission to retrive a dwarven armor from the mines. \z
					The problem is, some giant spiders made the tunnels where the storage is their new home.",
				[3] = "You have completed Dwarven Armor Quest!",
			},
		},
	},
}

return quest
