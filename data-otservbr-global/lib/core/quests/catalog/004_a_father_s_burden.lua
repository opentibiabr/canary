local quest = {
	name = "A Father's Burden",
	startStorageId = Storage.Quest.U8_6.AFathersBurden.QuestLog,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "The Birthday Presents",
			storageId = Storage.Quest.U8_6.AFathersBurden.Status,
			missionId = 1024,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Gather the material Tereban listed. \z
					Talk to him about your mission when you have given him everything he was looking for.",
				[2] = "You brought all the required materials to Tereban and guaranteed his sons a great birthday party.",
			},
		},
		[2] = {
			name = "The Magic Bow - Sinew",
			storageId = Storage.Quest.U8_6.AFathersBurden.Sinew,
			missionId = 1025,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the wyvern Heoni in the Edron mountains and take his sinew to Tereban.",
				[2] = "You delivered Heoni's sinew to Tereban.",
			},
		},
		[3] = {
			name = "The Magic Bow - Wood",
			storageId = Storage.Quest.U8_6.AFathersBurden.Wood,
			missionId = 1026,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the special wood in the barbarian camps of Hrodmir and bring it to Tereban. \z
					It might be a good idea to start looking in the northernmost camp.",
				[2] = "You delivered the Wood to Tereban.",
			},
		},
		[4] = {
			name = "The Magic Robe - Cloth",
			storageId = Storage.Quest.U8_6.AFathersBurden.Cloth,
			missionId = 1027,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the spectral cloth hidden deep in the crypts of the isle of the kings and bring it to Tereban. \z
					You might have to look for a secret entrance.",
				[2] = "You delivered the spectral cloth to Tereban.",
			},
		},
		[5] = {
			name = "The Magic Robe - Silk",
			storageId = Storage.Quest.U8_6.AFathersBurden.Silk,
			missionId = 1028,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find exquisite silk in the spider caves of southern Zao and deliver it to Tereban.",
				[2] = "You brought Tereban the required silk.",
			},
		},
		[6] = {
			name = "The Magic Rod - Crystal",
			storageId = Storage.Quest.U8_6.AFathersBurden.Crystal,
			missionId = 1029,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find a magic crystal in the tomb buried under the sand east of Ankrahmun and bring it to Tereban.",
				[2] = "Tereban received the magic crystal he was looking for.",
			},
		},
		[7] = {
			name = "The Magic Rod - Root",
			storageId = Storage.Quest.U8_6.AFathersBurden.Root,
			missionId = 1030,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the mystic root under the city of Banuta and bring it to Tereban.",
				[2] = "The magic root was delievered to Tereban.",
			},
		},
		[8] = {
			name = "The Magic Shield - Iron",
			storageId = Storage.Quest.U8_6.AFathersBurden.Iron,
			missionId = 1031,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find some old iron in the mines of Kazordoon for Tereban. Don't get lost - \z
				start searching close to the city.",
				[2] = "Tereban got the old iron he required.",
			},
		},
		[9] = {
			name = "The Magic Shield - Scale",
			storageId = Storage.Quest.U8_6.AFathersBurden.Scale,
			missionId = 1032,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the dragon Glitterscale in the caves north of Thais and take its scale to Tereban.",
				[2] = "You handed the looted scale to Tereban.",
			},
		},
	},
}

return quest
