local quest = {
	name = "The Way of the Monk",
	startStorageId = Storage.Quest.U14_15.TheWayOfTheMonk.QuestLine,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "The Three-Fold Path",
			storageId = Storage.Quest.U14_15.TheWayOfTheMonk.Missions.TreeFoldPath,
			missionId = 10502,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = function(player)
					return string.format(
						"You have learned about the Three-Fold Path from ambassador Manop on Dawnport. Follow the way of Merudri, train hard and you will become a true warrior monk. Start by visiting the four Merudri shrines on Dawnport and report back to Manop.\n\nVisited the first shrine: %s/1\nVisited the second shrine: %s/1\nVisited the third shrine: %s/1\nVisited the fourth shrine: %s/1",
						player:getStorageValue(Storage.Quest.U14_15.TheWayOfTheMonk.DawnportFirstShrine) or 0,
						player:getStorageValue(Storage.Quest.U14_15.TheWayOfTheMonk.DawnportSecondShrine) or 0,
						player:getStorageValue(Storage.Quest.U14_15.TheWayOfTheMonk.DawnportThirdShrine) or 0,
						player:getStorageValue(Storage.Quest.U14_15.TheWayOfTheMonk.DawnportFourthShrine) or 0
					)
				end,
				[2] = function(player)
					return string.format(
						"You have chosen the path of the monk. Find the Blue Valley and visit the Enpa to learn more about the warrior monks and the way of the Merudri. Visit all eleven shrines of the Merudri to complete your pilgrimage on the Tree-Fold Path. Consult Enpa-Dela Pema in the Blue Valley to reveal more about this journey.\n\nMost recent visited Merudri shrine: %s/11",
						player:getStorageValue(Storage.Quest.U14_15.TheWayOfTheMonk.ShrinesCount)
					)
				end,
				[3] = "You have visited all eleven shrines.",
			},
		},
	},
}

return quest
