local quest = {
	name = "The Ape City",
	startStorageId = Storage.Quest.U7_6.TheApeCity.Started,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Hairycles' Missions",
			storageId = Storage.Quest.U7_6.TheApeCity.Questline,
			missionId = 10217,
			startValue = 1,
			endValue = 18,
			states = {
				[1] = "Find whisper moss in the dworc settlement south of Port Hope and bring it back to Hairycles.",
				[2] = "You have completed the first mission. Hairycles was happy about the whisper moss you gave to him. \z
					He might have another mission for you.",
				[3] = "Hairycles asked you to bring him cough syrup from a human settlement. \z
					A healer might know more about this medicine.",
				[4] = "You have completed the second mission. Hairycles was happy about the cough syrup you gave to him. \z
					He might have another mission for you.",
				[5] = "Hairycles asked you to bring him a magical scroll from the lizard settlement Chor.",
				[6] = "You have completed the third mission. Hairycles appreciated that you brought \z
					the scroll to him and will try to read it. Maybe he has another mission for you later.",
				[7] = "Since Hairycles was not able to read the scroll you brought him, he asked you dig for a tomb in the \z
					desert to the east. Proceed in this tomb until you find an obelisk between red stones and read it.",
				[8] = "You have completed the fourth mission. \z
					Hairycles read your mind and can now translate the lizard scroll. \z
					He might have another mission for you.",
				[9] = "Hairycles wants to create a life charm for the ape people. \z
					He needs a hydra egg since it has strong regenerating powers.",
				[10] = "You have completed the fifth mission. \z
					Hairycles attempts to create a might charm for the protection of the ape people. \z
					He might have another mission for you later.",
				[11] = "Hairycles need a witches' cap mushroom which is supposed to be hidden in a dungeon deep under Fibula.",
				[12] = "You have completed the sixth mission. You brought the witches' cap mushroom back to Hairycles. \z
					He might have another mission for you.",
				[13] = "Hairycles is worried about an ape cult which drinks some strange fluid that the lizards left behind. \z
					Go to the old lizard temple under Banuta and destroy three of the casks there with a crowbar.",
				[14] = "You have completed the seventh mission. \z
					You found the old lizard ruins under Banuta and destroyed three of the casks with snake blood. \z
					Hairycles might have another mission for you.",
				[15] = "The apes now need a symbol of their faith. \z
					Speak with the blind prophet in a cave to the northeast and go to the Forbidden Land. \z
					Find a hair of the giant, holy ape Bong and bring it back.",
				[16] = "You completed the eighth mission. Hairycles gladly accepted the hair of the ape \z
					god which you brought him. He told you to have one final mission for you.",
				[17] = "Go into the deepest catacombs under Banuta and destroy the monument of \z
					the snake god with the hammer that Hairycles gave to you.",
				[18] = "You successfully destroyed the monument of the snake god. \z
					As reward, you can buy sacred statues from Hairycles. \z
					If you haven't done so yet, you should also ask him for a shaman outfit.",
			},
		},
	},
}

return quest
