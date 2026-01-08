local quest = {
	name = "Wrath of the Emperor",
	startStorageId = Storage.Quest.U8_6.WrathOfTheEmperor.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 01: Catering the Lions Den",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission01,
			missionId = 10348,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "You must bring Zalamon 3 nails and a piece of wood so that he can make a Marked Crate for you.",
				[2] = "Go to the tunnel in eastern Muggy Plains and reach the other side. \z
				Try to hide in the dark and avoid being seen at all by using the crate. \z
				After that you need to find the rebel hideout and talk to their leader Chartan.",
				[3] = "You passed the maintenance tunnel and successfully made contact with the resistance in their hideout north of the Great Gate.",
			},
		},
		[2] = {
			name = "Mission 02: First Contact",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission02,
			missionId = 10349,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Chartan needs you to reactivate the teleport to the Muggy Plains. \z
				Head downstairs and into the temple and craft material to repair the teleport. \z
				To do this you will need some tools to improvise.",
				[2] = "As you give the coal into the pool the corrupted fluid begins to dissolve, leaving purified, \z
				refreshing water. The teleporter is reactivated. Report back to Chartan.",
				[3] = "Report back to Zalamon for the next mission.",
			},
		},
		[3] = {
			name = "Mission 03: The Keeper",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission03,
			missionId = 10350,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Zalamon gives you a Flask of Plant Poison to destroy plants in the garden \z
				of the Emperor to lure out and kill The Keeper to get his tail. The garden is southeast of the rebel hideout.",
				[2] = "You killed the Keeper and got his tail. Bring it to Zalamon.",
				[3] = "You brought the tail of the Keeper to Zalamon and completed the mission. Ask for the next mission.",
			},
		},
		[4] = {
			name = "Mission 04: Sacrament of the Snake",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission04,
			missionId = 10351,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Zalamon now wants you to go to Deeper Banuta and get an Ancient Sceptre \z
				that will help in the fight against the emperor. \z
				On each floor under Deeper Banuta you collect a sceptre part from a Ghost of a Priest. \z
				On the 4th and final floor you need to assemble the sceptre..",
				[2] = "After you've assembled the Snake Sceptre and fought your way back out, \z
				head back to Zalamon and give it to him.",
				[3] = "You have delievered the recreated sceptre to the rebels.",
			},
		},
		[5] = {
			name = "Mission 05: New in Town",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission05,
			missionId = 10352,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Enter the imperial city Razachai to the west and talk to your contact in the ministry there for further missions.",
				[2] = "Now you only have to walk west until you find Zlak inside the big green building.",
				[3] = "You went deep inside the city to find Zlak and completed the mission. Ask for the next mission.",
			},
		},
		[6] = {
			name = "Mission 06: The Office Job",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission06,
			missionId = 10353,
			startValue = 0,
			endValue = 5,
			description = function(player)
				return string.format("Kill four Magistrati in the office building. Then report back to Zlak. You have killed %d magistrati so far.", (math.max(player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission06), 1)))
			end,
		},
		[7] = {
			name = "Mission 07: A Noble Cause",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission07,
			missionId = 10354,
			startValue = 0,
			endValue = 6,
			description = function(player)
				return string.format("Kill six nobles in the city and report back to Zlak. You have killed %d nobles so far.", (math.max(player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission07), 0)))
			end,
		},
		[8] = {
			name = "Mission 08: Uninvited Guests",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission08,
			missionId = 10355,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Use the old escape tunnel in the northern basement of the ministry to enter the imperial palace. Fight your way to the basement to meet your new rebel contact.",
				[2] = "You have reached your rebel contact Zizzle in the imperial palace.",
			},
		},
		[9] = {
			name = "Mission 09: The Sleeping Dragon",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission09,
			missionId = 10356,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "To enter the inner realms of the Emperor you need to free the mind of a dragon. \z
				An interdimensional potion will help you to enter this dream and unleash his consciousness.",
				[2] = "You travelled through the Sleeping Dragon dreams and freed his mind.",
			},
		},
		[10] = {
			name = "Mission 10: A Message of Freedom",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission10,
			missionId = 10357,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "After solving the riddle, and talking again to the Sleeping Dragon you got a Spiritual Charm. \z
				Report back to Zizzle.",
				[2] = "You possess the key to enter the inner realms of the emperor. \z
				Start with the one in the north-west and work your way clockwise trough the room and kill those manifestation. \z
				Then use your sceptre on the remain to destroy the emperor's influence over the crystal.",
				[3] = "You possess the key to enter the inner realms of the emperor. \z
				You destroyed 1 of 4 emperor's influences.",
				[4] = "You possess the key to enter the inner realms of the emperor. \z
				You destroyed 2 of 4 emperor's influences.",
				[5] = "You possess the key to enter the inner realms of the emperor. \z
				You destroyed 3 of 4 emperor's influences.",
				[6] = "You possess the key to enter the inner realms of the emperor. \z
				You destroyed all emperor's influences.",
			},
		},
		[11] = {
			name = "Mission 11: Payback Time",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission11,
			missionId = 10358,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your Mission is to kill Zalamon. Step into the teleporter to confront him. \z
				Finally use your sceptre on the death body.",
				[2] = "Go back to Awareness Of The Emperor and report him your success!",
			},
		},
		[12] = {
			name = "Mission 12: Just Rewards",
			storageId = Storage.Quest.U8_6.WrathOfTheEmperor.Mission12,
			missionId = 10359,
			startValue = 0,
			endValue = 1,
			states = {
				[0] = "The Emperor has promised you wealth beyond measure. Go claim it in the ministry.",
				[1] = "You completed this Quest!",
			},
		},
	},
}

return quest
