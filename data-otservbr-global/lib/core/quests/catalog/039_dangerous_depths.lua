local quest = {
	name = "Dangerous Depths",
	startStorageId = Storage.Quest.U11_50.DangerousDepths.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Dwarves: Home Improvement",
			storageId = Storage.Quest.U11_50.DangerousDepths.Dwarves.Home,
			missionId = 10380,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = function(player)
					return ("Destroy makeshift homes of the Lost to force them to fight you! Try making some \z
					prisoners in the progress and report back to Klom Stonecutter.\n\nLost Exiles: %d/20\nPrisoners (bonus): \z
					%d/3"):format(math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.LostExiles), 0), math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Prisoners), 0))
				end,
				[2] = "You drove off the Lost but more are sure to come. Check back with Klom Stonecutter at a later time.",
			},
		},
		[2] = {
			name = "Dwarves: Subterranean Life",
			storageId = Storage.Quest.U11_50.DangerousDepths.Dwarves.Subterranean,
			missionId = 10381,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = function(player)
					return ("Klome Stonecutter sent you on a grave mission to exterminate large populaces of \z
					subterranian life. Looks like the dwarves make short work of the deep intruders.\n\nSubterranean organisms: \z
					%d/50"):format(math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Dwarves.Organisms), 0))
				end,
				[2] = "You helped Klom defend the outpost by cutting down a number of vermin from deep down below. \z
				The gnomes don't seem to completely approve of this but everyone appreciates the drop in the enemy's ranks.",
			},
		},
		[3] = {
			name = "Gnomes: Gnomal Warming Measurements",
			storageId = Storage.Quest.U11_50.DangerousDepths.Gnomes.Measurements,
			missionId = 10382,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = function(player)
					return ("Gnomus sent you on a mission to measure the rising heat from below.\n\nLocation A: \z
					%d/1\nLocation B: %d/1\nLocation C: %d/1\nLocation D: %d/1\nLocation E: %d/1"):format(
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationA), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationB), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationC), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationD), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LocationE), 0)
					)
				end,
				[2] = "You helped Lardoc Bashsmite fighting back the verminous growth in the northern mineshaft. \z
				Return to him later to see if he has more work for you.",
			},
		},
		[4] = {
			name = "Gnomes: Ordnance",
			storageId = Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance,
			missionId = 10383,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Gnomus sent you to find and rescue the gnome ordnance the outpost is currently waiting for. \z
				Travel to the east of the cave system and find the old gnome trail where reinforcements will arrive.",
				[2] = function(player)
					return ("You found the old gnome trail where ordnance for the gnome outpost arrive, escort them \z
					and their pack animals to safety and return to Gnomus.\n\nRescued gnomes: %d/5\nRescued animals: %d/3"):format(math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.GnomesCount), 0), math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.CrawlersCount), 0))
				end,
				[3] = "You helped Lardoc Bashsmite fighting back the verminous growth in the northern mineshaft. \z
				Return to him later to see if he has more work for you.",
			},
		},
		[5] = {
			name = "Gnomes: Uncharted Territory",
			storageId = Storage.Quest.U11_50.DangerousDepths.Gnomes.Charting,
			missionId = 10384,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = function(player)
					return ("Chart the area around the deep base for Gnomus. Look for especific landmarks: \z
					\n\nOld Gate: %d/1\nThe Gaze: %d/1\nLost Ruin: %d/1\nOutpost: %d/1\nBastion: %d/1\nBroken Tower: \z
					%d/1"):format(
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.OldGate), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.TheGaze), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.LostRuin), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Outpost), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Bastion), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.BrokenTower), 0)
					)
				end,
				[2] = "You helped Gnomus chart the area around the deep base. You found traces of what \z
				could have been an old civilisation but there's not enough left to draw any conclusion.",
			},
		},
		[6] = {
			name = "Scouts: Explosive Growth",
			storageId = Storage.Quest.U11_50.DangerousDepths.Scouts.Growth,
			missionId = 10385,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = function(player)
					return ("You found the mine shaft. Burn all the growth and report back to Lardoc Bashsmite! \z
					\n\nFirst Room: %d/1\nSecond room: %d/1\nThird room: %d/1\nFourth room: %d/1\nFifth room: %d/1"):format(
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.FirstBarrel), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.SecondBarrel), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.ThirdBarrel), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.FourthBarrel), 0),
						math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.FifthBarrel), 0)
					)
				end,
				[2] = "You helped Lardoc Bashsmite fighting back the verminous growth in the northern mineshaft. \z
				Return to him later to see if he has more work for you.",
			},
		},
		[7] = {
			name = "Scouts: Pesticide",
			storageId = Storage.Quest.U11_50.DangerousDepths.Scouts.Diremaw,
			missionId = 10386,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = function(player)
					return ("Lardoc asked you to follow a plan of the gnomes to stop the deep threat by trying to \z
					neutralise diremaw spawn with pesticies. Diremaws lay eggs inside corpses of their skin. \z
					\n\nNeutralised: %d/20"):format(math.max(player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Scouts.DiremawsCount), 0))
				end,
				[2] = "You reported back to Lardoc Bashsmite to inform him that the gnome's plan to \z
				neutralise diremaw corpses seems to work.",
			},
		},
	},
}

return quest
