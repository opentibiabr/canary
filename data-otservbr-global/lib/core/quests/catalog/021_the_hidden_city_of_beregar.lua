local quest = {
	name = "The Hidden City of Beregar",
	startStorageId = Storage.Quest.U8_4.TheHiddenCityOfBeregar.DefaultStart,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Going Down",
			storageId = Storage.Quest.U8_4.TheHiddenCityOfBeregar.GoingDown,
			missionId = 10228,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Deliver 3 Gear Wheels to Xorlosh.",
				[2] = "You sucessfully helped Xorlosh in repairing the elevator. \z
					You can now enter the teleporter to the eastern part of the mine.",
			},
		},
		[2] = {
			name = "Justice for All",
			storageId = Storage.Quest.U8_4.TheHiddenCityOfBeregar.JusticeForAll,
			missionId = 10229,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "Nokmir told you that he is falsely accused of being a thief. \z
					You could help him by talking to Grombur about the case. \z
					Furthermore you should try to find that ring which belongs to Rerun.",
				[2] = "You should talking to Grombur about Nokmir.",
				[3] = "You should try to find that ring which belongs to Rerun everywhere in the mine.",
				[4] = "You have found Rerun's ring. Bring the ring to the emperor Rehal and talk to him about Nokmir.",
				[5] = "You informed emperor Rehal about your recent discoveries and he acquitted Nokmir of being a thief.",
				[6] = "You told Nokmir about his acquittal and he granted you access to the northern mine.",
			},
		},
		[3] = {
			name = "Pythius the Rotten",
			storageId = Storage.Quest.U8_4.TheHiddenCityOfBeregar.FirewalkerBoots,
			missionId = 10230,
			startValue = 1,
			endValue = 1,
			states = {
				[1] = "You won the battle against the malicious undead dragon Pythius the Rotten. \z
					He granted you firewalker boots as a reward.",
			},
		},
		[4] = {
			name = "Sweet as Chocolate Cake",
			storageId = Storage.Quest.U8_4.TheHiddenCityOfBeregar.SweetAsChocolateCake,
			missionId = 10231,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Bake a Chocolate Cake and bring it to Bolfona at the bar.",
				[2] = "Report back to Frafnar by telling him about the mission.",
				[3] = "You told Frafnar that you did everything he asked you to do. \z
					You may now enter the western part of the mine.",
			},
		},
		[5] = {
			name = "The Good Guard",
			storageId = Storage.Quest.U8_4.TheHiddenCityOfBeregar.TheGoodGuard,
			missionId = 10232,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Grombur asked you to get him a cask of dwarven brown ale. \z
					You heard that Boozer in Venore tried to brew some. Maybe you should pay him a visit.",
				[2] = "Grombur liked the ale and you are now allowed to enter his part of the mine.",
			},
		},
	},
}

return quest
