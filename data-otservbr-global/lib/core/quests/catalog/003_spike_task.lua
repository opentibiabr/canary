local quest = {
	name = "Spike Task",
	startStorageId = Storage.Quest.U10_20.SpikeTaskQuest.QuestLine,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "First Task",
			storageId = Storage.Quest.U10_20.SpikeTaskQuest.Gnomilly,
			missionId = 1021,
			startValue = 0,
			endValue = 100,
			description = function(player)
				return string.format("You have %d points of task. You need 100 points to take Cave Explorer outfit.", (math.max(player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Gnomilly), 0)))
			end,
		},
		[2] = {
			name = "Second Task",
			storageId = Storage.Quest.U10_20.SpikeTaskQuest.Gnombold.Points,
			missionId = 1022,
			startValue = 0,
			endValue = 100,
			description = function(player)
				return string.format("You have %d points of task. You need 100 points to take first addon.", (math.max(player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Gnombold.Points), 0)))
			end,
		},
		[3] = {
			name = "Third Task",
			storageId = Storage.Quest.U10_20.SpikeTaskQuest.Gnomargery.Points,
			missionId = 1023,
			startValue = 0,
			endValue = 100,
			description = function(player)
				return string.format("You have %d points of task. You need 100 points to take second addon.", (math.max(player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Gnomargery.Points), 0)))
			end,
		},
	},
}

return quest
