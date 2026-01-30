local quest = {
	name = "Grave Danger",
	startStorageId = Storage.Quest.U12_20.GraveDanger.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "* Grave Danger - The Lich Knights",
			storageId = Storage.Quest.U12_20.GraveDanger.Questline,
			missionId = 10437,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = function(player)
					return string.format(
						"Prevent the raising of twelve lich knights. Sanctify the graves yet untouched and destroy any lich knights that might have been raised. Graves explored: %d/12",
						player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Edron)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.DarkCathedral)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Ghostlands)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Cormaya)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.FemorHills)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Ankrahmun)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Kilmaresh)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Vengoth)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Darashia)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Thais)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Orclands)
							+ player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.IceIslands)
							- 12
					)
				end,
			},
		},
		[2] = {
			name = "01 The grave in Edron",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Edron,
			missionId = 10438,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in Edron's north.",
				[2] = "The Edron grave was visited.",
			},
		},
		[3] = {
			name = "02 The grave in the dark cathedral",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.DarkCathedral,
			missionId = 10439,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in the dark cathedral.",
				[2] = "The grave in the dark cathedral was visited.",
			},
		},
		[4] = {
			name = "03 The grave in Ghostlands",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Ghostlands,
			missionId = 10440,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in the ghostlands.",
				[2] = "The grave in the Ghostlands was visited.",
			},
		},
		[5] = {
			name = "04 The grave in Cormaya",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Cormaya,
			missionId = 10441,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in Cormaya.",
				[2] = "The grave in Cormaya was visited.",
			},
		},
		[6] = {
			name = "05 The grave in the Femor Hills",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.FemorHills,
			missionId = 10442,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in the Femor Hills.",
				[2] = "The grave in the Femor Hills was visited.",
			},
		},
		[7] = {
			name = "06 The grave on an isle NE of Ankrahmun",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Ankrahmun,
			missionId = 10443,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave on an isle north-east of Ankrahmun.",
				[2] = "The grave on an isle north-east of Ankrahmun was visited.",
			},
		},
		[8] = {
			name = "07 The grave in Kilmaresh",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Kilmaresh,
			missionId = 10444,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in Kilmaresh.",
				[2] = "The grave in Kilmaresh was visited.",
			},
		},
		[9] = {
			name = "08 The grave in Vengoth",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Vengoth,
			missionId = 10445,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in Vengoth.", --
				[2] = "The grave in Vengoth was visited.",
			},
		},
		[10] = {
			name = "09 The grave in Darashia",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Darashia,
			missionId = 10446,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in Darashia.", --
				[2] = "The grave in Darashia was visited.",
			},
		},
		[11] = {
			name = "10 The grave in the old Thais temple",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Thais,
			missionId = 10447,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave in the old Thais temple.", --
				[2] = "The grave in the old temple of Thais has been visited.",
			},
		},
		[12] = {
			name = "11 The grave at the orclands entrance",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.Orclands,
			missionId = 10448,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave at the orclands entrance.", --
				[2] = "The grave at the orcland entrance was visited.",
			},
		},
		[13] = {
			name = "12 The grave on the southern ice islands",
			storageId = Storage.Quest.U12_20.GraveDanger.Graves.IceIslands,
			missionId = 10449,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the grave on the southern ice islands.", --
				[2] = "The grave on the southern ice islands was visited.",
			},
		},
		[14] = {
			name = "The Order of the Cobra",
			storageId = Storage.Quest.U12_20.GraveDanger.Cobra,
			missionId = 10450,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "", --
				[2] = "Scarlett Etzel once stood proud and righteous. The assassins she rallied around her under the Order of the Cobra, however, were of ill repute and had to be vanquished. And so did she, you prevailed.",
			},
		},
	},
}

return quest
