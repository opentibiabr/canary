local quest = {
	name = "Sea of Light",
	startStorageId = Storage.Quest.U8_54.SeaOfLight.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 1: The Plans",
			storageId = Storage.Quest.U8_54.SeaOfLight.Mission1,
			missionId = 10188,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Spectulus in Edron has sent you on a mission to find out the whereabouts of a certain inventor. \z
					A beggar in Edron seems to know more about this topic than he wants to tell.",
				[2] = "The beggar turned out to be the inventor himself. \z
					You successfully convinced him to give you the only remaining plans of his creation. \z
					You should return to Spectulus in Edron to tell him the news.",
				[3] = "You gave the plans to the astronomer. \z
					He began reconstructing the invention as soon as he got ahold of them. \z
					It will take a while for him to work out the problem which caused the initial failure.",
				[4] = "You returned to Speculus who finally worked out the failure of the initial construction. \z
					He recapitulated the plans and needs only one item before he can start building the magic device.",
			},
		},
		[2] = {
			name = "Mission 2: The Collector",
			storageId = Storage.Quest.U8_54.SeaOfLight.Mission2,
			missionId = 10189,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Spectulus asked you to enter the Lost Mines beneath Edron and recover a rare crystal. In exchange for \z
				it you will gain access to the lair of the Collector who guards a vital component of the device.",
				[2] = "Luckily, you survived the horrors of the Lost Mines and recovered a rare crystal. \z
				You should visit Spectulus in Edron to seek counsel on what to do next.",
				[3] = "You returned to astronomer Spectulus and gave him the rare crystal.",
			},
		},
		[3] = {
			name = "Mission 3: The Mirror Crystal",
			storageId = Storage.Quest.U8_54.SeaOfLight.Mission3,
			missionId = 10190,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "In order to access the lair of the Collector, you will need to find the creature's well on \z
					an ice isle near Carlin. To donate the rare crystal overcome your greed and use it at the well's pedestal.",
				[2] = "You offered the rare crystal to the creature and can now enter the Collector's lair. \z
					Its crystal chamber cannot be accessed by outsiders. You need to find a way to snatch the Mirror Crystal.",
				[3] = "The Collector has been defeated. \z
					You packed the fragile Mirror Crystal into the device Spectulus gave you. \z
					All yo have to do now is to return to the astronomer and to present him your acquisition.",
				[4] = "It may have been the excitement or simple nervousness but as soon as Spectulus removed the crystal, \z
					it somehow slipped. Unfinishable for all eternity, the device left yet another scholar in despair.",
			},
		},
	},
}

return quest
