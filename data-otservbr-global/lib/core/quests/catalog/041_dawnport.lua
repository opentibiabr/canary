local quest = {
	name = "Dawnport",
	startStorageId = Storage.Quest.U10_55.Dawnport.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "In the Adventures Outpost",
			storageId = Storage.Quest.U10_55.Dawnport.GoMain,
			missionId = 10389,
			startValue = 1,
			endValue = 2,
			description = "You have reached the Outpost, where young heroes are trained in combat and hunting. \z
			When you have reached level 8 at least, you can leave for the Mainland. Talk to Inigo if you have questions.",
		},
		[2] = {
			name = "The Lost Amulet",
			storageId = Storage.Quest.U10_55.Dawnport.TheLostAmulet,
			missionId = 10390,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Mr Morris tasked you to find an ancient amulet that was lost somewhere on Dawnport - probably next to a corpse somewhere.",
				[2] = "Come back to Mr Morris.",
				[3] = "Mr Morris thanks for you the help.",
			},
		},
		[3] = {
			name = "The Stolen Log Book",
			storageId = Storage.Quest.U10_55.Dawnport.TheStolenLogBook,
			missionId = 10391,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Mr Morris urged you to find a log book that was stolen by trolls.",
				[2] = "Mr Morris thanks you for the help.",
			},
		},
		[4] = {
			name = "The Rare Herb",
			storageId = Storage.Quest.U10_55.Dawnport.TheRareHerb,
			missionId = 10392,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Mr Morris needs the rare Dawnfire herb harvested and brought to him. It grows on gray sand only, he said.",
				[2] = "Come back to Mr Morris.",
				[3] = "Mr Morris thanks you for the help.",
			},
		},
		[5] = {
			name = "The Dorm Key",
			storageId = Storage.Quest.U10_55.Dawnport.TheDormKey,
			missionId = 10393,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "The key to the adventurer's dormitory has disappeared. Maybe you can find it. Ask around to find out who was the last to have seen it.",
				[2] = "Use the fishing rod in the nearby lake to fish Old Nasty.",
				[3] = "Come back to Woblin with Old Nasty",
				[4] = "Come back to Mr Morris with Key 0010",
				[5] = "Mr Morris thanks for the help",
			},
		},
		[6] = {
			name = "Task: A Toll on Trolls",
			storageId = Storage.Quest.U10_55.Dawnport.MorrisTrollCount,
			missionId = 10394,
			startValue = 0,
			endValue = 20,
			description = function(player)
				return string.format("You already hunted %d/20 Mountain Trolls.", (math.max(player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisTrollCount), 0)))
			end,
		},
		[7] = {
			name = "Task: The Goblin Slayer",
			storageId = Storage.Quest.U10_55.Dawnport.MorrisGoblinCount,
			missionId = 10395,
			startValue = 0,
			endValue = 20,
			description = function(player)
				return string.format("You already hunted %d/20 Muglex Clan Footman.", (math.max(player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblinCount), 0)))
			end,
		},
		[8] = {
			name = "Task: Plus Minos a Few",
			storageId = Storage.Quest.U10_55.Dawnport.MorrisMinosCount,
			missionId = 10396,
			startValue = 0,
			endValue = 20,
			description = function(player)
				return string.format("You already hunted %d/20 Minotaurs Bruisers.", (math.max(player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinosCount), 0)))
			end,
		},
	},
}

return quest
