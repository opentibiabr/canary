local quest = {
	name = "The First Dragon",
	startStorageId = Storage.Quest.U11_02.TheFirstDragon.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Power",
			storageId = Storage.Quest.U11_02.TheFirstDragon.DragonCounter,
			missionId = 10368,
			startValue = 0,
			endValue = 200,
			description = function(player)
				return ("You already hunted %d/200 dragons."):format(player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.DragonCounter))
			end,
		},
		[2] = {
			name = "Treasure",
			storageId = Storage.Quest.U11_02.TheFirstDragon.ChestCounter,
			missionId = 10369,
			startValue = 0,
			endValue = 20,
			description = "Treasure is the favorite of the dragon lords. \z
			Find and take Kalyassa's treasures spread across the world.",
		},
		[3] = {
			name = "Knowledge",
			storageId = Storage.Quest.U11_02.TheFirstDragon.GelidrazahAccess,
			missionId = 10370,
			startValue = 0,
			endValue = 1,
			description = "You learned that frost dragon's incitement is the thirst for knowledge, \z
			perhaps if you bring some to Gelidrazah's you'll meet him.",
		},
		[4] = {
			name = "Life",
			storageId = Storage.Quest.U11_02.TheFirstDragon.SecretsCounter,
			missionId = 10371,
			startValue = 0,
			endValue = 3,
			description = "Undead dragons aspires for life. \z
			No better way to see life as it grows around the world, is there?",
		},
	},
}

return quest
