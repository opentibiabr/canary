local quest = {
	name = "The Shattered Isles",
	startStorageId = Storage.Quest.U7_8.TheShatteredIsles.DefaultStart,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "A Djinn in Love",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove,
			missionId = 10263,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "You need to return to Marina and ask her for a date with Ocelus.",
				[2] = "You need to return to Ocelus with the bad news.",
				[3] = "Ocelus told you to get a poem for him, if you didn't buy one already, \z
				head to Ab'Dendriel and buy a Love Poem from Elvith.",
				[4] = "You need to go recite the poem to Marina and impress her \z
				with the Djinn's romantic and poetic abilities.",
				[5] = "After reciting the poem to Marina, she decided to date Ocelus and release Ray Striker from her spell.",
			},
		},
		[2] = {
			name = "A Poem for the Mermaid",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.APoemForTheMermaid,
			missionId = 10264,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "You need to find the man-stealing mermaid and try to break her spell over poor Raymond, \z
				the mermaid Marina is near the northern coast of the island.",
				[2] = "You discovered that she does in fact have a spell on him, and will not release him unless \z
				someone better comes along.",
				[3] = "You are a true master in reciting love poems now. \z
				No mermaid will be able to resist if you ask for a date!",
			},
		},
		[3] = {
			name = "Access to Goroma",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.AccessToGoroma,
			missionId = 10265,
			startValue = 1,
			endValue = 1,
			description = "After helping Jack Fate to collect the 30 woodpieces, \z
				Jack Fate in Liberty Bay will bring you to Goroma.",
		},
		[4] = {
			name = "Access to Laguna Island",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.AccessToLagunaIsland,
			missionId = 10266,
			startValue = 1,
			endValue = 1,
			description = "After arranging a date for Marina and Ocelus, you are allowed to use Marina's sea turtles. \z
				They will bring you to the idyllic Laguna Islands.",
		},
		[5] = {
			name = "Access to Meriana",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.AccessToMeriana,
			missionId = 10267,
			startValue = 1,
			endValue = 1,
			description = "After earning the trust of the governor's daughter Eleonore, \z
				Captain Waverider in Liberty Bay will bring you to Meriana if you tell him the secret codeword 'peg leg'.",
		},
		[6] = {
			name = "Access to Nargor",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.AccessToNargor,
			missionId = 10268,
			startValue = 1,
			endValue = 1,
			description = "After convincing the people in Sabrehaven that you are a trustworthy hero, \z
			Sebastian will sail you to Nargor.",
		},
		[7] = {
			name = "Ray's Mission 1: Fafnar's Fire",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.RaysMission1,
			missionId = 10269,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Ray Striker asked you to travel to Edron and pretend to the alchemist Sandra that you are the one \z
				whom the other pirates sent to get the fire. When she asks for a payment, tell her \z
				'Your continued existence is payment enough'.",
				[2] = "Sandra will be enraged and will cut any deals with pirates. Report back to Raymond Striker.",
				[3] = "Ray Striker was pleased to hear about Sandra's rage. If you haven't done so yet, \z
				ask him for other missions.",
			},
		},
		[8] = {
			name = "Ray's Mission 2: Sabotage",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.RaysMission2,
			missionId = 10270,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Buy a fire bug at Liberty Bay and infiltrate Nargor. \z
				Find the pirates' harbor and use the fire bug to sabotage their catapult there.",
				[2] = "You were able to sabotage the catapult in the pirate's harbor. \z
				Report back to Ray Striker to tell him about mission.",
				[3] = "Ray Striker was pleased to hear about successful sabotage. \z
				If you haven't done so yet, ask him for other missions.",
			},
		},
		[9] = {
			name = "Ray's Mission 3: Spy Mission",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.RaysMission3,
			missionId = 10271,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Travel to Nargor and try to enter de pirate's tavern by deceiving the guard in front of it. \z
				Read all the plans which you can find in the tavern and report back to Striker.",
				[2] = "You studied all of the pirate's plans in their tavern which will give insight about their next strikes. \z
				If you haven't done so yet, ask Ray for another mission.",
			},
		},
		[10] = {
			name = "Ray's Mission 4: Proof of Death",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.RaysMission4,
			missionId = 10272,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Travel to Nargor and try to find out more about the mission Klaus offers. \z
				He apparently wants the death of Ray Striker and your task is to convince him that Ray is dead.",
				[2] = "Klaus told you to kill Ray Striker and bring him his lucky pillow as a proof. \z
				Ray should be interested in hearing about this mission.",
				[3] = "You informed Ray that Klaus needs his lucky pillow as proof of his death. \z
				Ray gave it to you, now go convince Klaus that the mission is fulfilled and Ray is Dead!",
				[4] = "Klaus belieaves that Ray Striker is dead and will celebrate a big party. \z
				You should tell Ray about your successful mission.",
				[5] = "Ray was very impressed to hear about your successful mission \z
				and gave you a ship and a pirate outfit as reward.",
			},
		},
		[11] = {
			name = "Reputation in Sabrehaven: Suspicious",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven,
			missionId = 10273,
			startValue = 2,
			endValue = 13,
			states = {
				[2] = "Ariella asked you for a few days of adequate supply. \z
				Help her and improve your reputation in Sabrehaven.",
				[3] = "You have finished one mission. Ask around in Sabrehaven and surroundings whether the \z
				people there might have missions for you. This will improve your reputation and earn their trust.",
				[4] = "Morgan asked you to deliver a letter safely to old Eremo on Cormaya. \z
				Help him and improve your reputation in Sabrehaven.",
				[5] = "You delivered the letter safely to old Eremo. Report back to Morgan and \z
				improve your reputation in Sabrehaven.",
				[6] = "You have finished two missions. Ask around in Sabrehaven and surroundings \z
				whether the people there might have missions for you. This will improve your reputation and earn their trust.",
				[7] = "Duncan requested an atlas of the explorers society. Help him and improve your reputation in Sabrehaven.",
				[8] = "You have finished three missions. Ask around in Sabrehaven and surroundings whether the \z
				people there might have missions for you. This will improve your reputation and earn their trust.",
				[9] = "Chondur asked at least five pirate voodoo dolls to lift the curse. Help him and improve \z
				your reputation in Sabrehaven.",
				[10] = "You have finished four missions. Ask around in Sabrehaven and surroundings whether the \z
				people there might have missions for you. This will improve your reputation and earn their trust.",
				[11] = "Ariella asked you to bring a sample of whisper beer from a secret whisper bar in Carlin. \z
				Help her and improve your reputation in Sabrehaven.",
				[12] = "Take the sample of whisper beer to Ariella. Help her and improve your reputation in Sabrehaven.",
			},
		},
		[12] = {
			name = "Reputation in Sabrehaven: Friendly",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven,
			missionId = 10274,
			startValue = 14,
			endValue = 17,
			states = {
				[14] = "You have finished five missions. People in Sabrehaven seem to start trusting you. \z
				Maybe this is a good time for some more difficult missions.",
				[15] = "You have finished six missions. People in Sabrehaven seem to start trusting you. \z
				Maybe this is a good time for some more difficult missions.",
				[16] = "You have finished seven missions. People in Sabrehaven seem to start trusting you. \z
				Maybe this is a good time for some more difficult missions.",
			},
		},
		[13] = {
			name = "Reputation in Sabrehaven: Cordial",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven,
			missionId = 10275,
			startValue = 18,
			endValue = 19,
			description = "You have finished eight missions. \z
			People in Sabrehaven seem to trust you, but there is still one last mission left.",
		},
		[14] = {
			name = "Reputation in Sabrehaven: Loyal",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven,
			missionId = 10276,
			startValue = 20,
			endValue = 22,
			states = {
				[20] = "You have finished nine missions. People in Sabrehaven are considering you as one of them.",
				[21] = "You have finished all missions. \z
				People in Sabrehaven are considering you as one of them and you earned their full trust.",
			},
		},
		[15] = {
			name = "The Counterspell",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell,
			missionId = 10277,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "You have begun Chondur's ritual. Bring him a fresh dead chicken so that he can begin to \z
				create a counterspell which will allow you to pass the magical barrier on Goroma.",
				[2] = "You have begun Chondur's ritual. Bring him a fresh dead rat so that he can continue \z
				creating a counterspell which will allow you to pass the magical barrier on Goroma.",
				[3] = "You have begun Chondur's ritual. Bring him a fresh dead black sheep so that he can \z
				complete his counterspell which will allow you to pass the magical barrier on Goroma.",
				[4] = "You may pass the energy barrier on Goroma. The counterspell Chondur created for you \z
				with his ritual will allow you to withstand the evil magic of the cultist.",
			},
		},
		[16] = {
			name = "The Errand",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.TheErrand,
			missionId = 10278,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You told Eleonore to run a small errand. Deliver the 200 gold pieces she \z
				gave to the herbalist Charlotta in the south-western part of Liberty Bay.",
				[2] = "You delivered the gold to Charlotta. Return to Eleonore and tell her the secret password: peg leg",
			},
		},
		[17] = {
			name = "The Governor's Daughter",
			storageId = Storage.Quest.U7_8.TheShatteredIsles.TheGovernorDaughter,
			missionId = 10279,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "You promised to find Eleonore's lost ring. She told you that a parrot stole it from her \z
				dressing table and flew to the nearby mountains. You might need a rake to retrieve the ring.",
				[2] = "You found the ring. Return it to Eleonore.",
				[3] = "You returned the ring to Eleonore.",
			},
		},
	},
}

return quest
