local quest = {
	name = "The Dream Courts",
	startStorageId = Storage.Quest.U12_00.TheDreamCourts.Main.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "The Dream Courts",
			storageId = Storage.Quest.U12_00.TheDreamCourts.WardStones.Questline,
			missionId = 10457,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = function(player)
					return string.format("You already got %d/8 energized ward stones.", math.max(player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Count), 0))
				end,
				[2] = "You must kill the Nightmare Beast.",
				[3] = "By defeating the dreadful Nightmare Beast you did the Winter Court and the Summer Court alike a great favor. From now on, the dream elves will regard you as a friend.",
			},
		},
		[2] = {
			name = "Unsafe Release",
			storageId = Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline,
			missionId = 10458,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Part I",
				[2] = "Part II",
				[3] = "Andre was happy to hear that the compass works as intendend. From now on it is possible that he will charge your compass again. It can be used to give acess to mystical chests once a day.",
			},
		},
		[3] = {
			name = "Haunted House",
			storageId = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
			missionId = 10459,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = function(player)
					return string.format(
						"A tormented soul trusted you with the secret of this house: join the passages to the three dungeons it connects to reveal a hidden portal within!\n\nCellar %d/1\nTemple %d/1\nTomb %d/1",
						math.max(player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar), 0),
						math.max(player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple), 0),
						math.max(player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Tomb), 0)
					)
				end,
				[2] = "Part I - burried catedral",
				[3] = "Part II - puzzle dos livros",
				[4] = "Part III - bosses",
				[5] = "Part IV - last stone",
				[6] = "Activating the ward stone after defeating the Faceless Bane has gained you acess to the deepest mysteries of the dream courts.",
			},
		},
		[4] = {
			name = "The Seven Keys",
			storageId = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Questline,
			missionId = 10460,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = function(player)
					return string.format("You already got %d/7 secret keys.", math.max(player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Count), 0))
				end,
				[2] = "You found the seven keys to unlock the Seven Dream Doors in the Labyrinth of Summer's and Winter's Dreams.",
			},
		},
	},
}

return quest
