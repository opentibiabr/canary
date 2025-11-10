local quest = {
	name = "The Beginning",
	startStorageId = Storage.Quest.U8_2.TheBeginningQuest.SantiagoQuestLog,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "The Cockroach Plague",
			storageId = Storage.Quest.U8_2.TheBeginningQuest.SantiagoQuestLog,
			missionId = 10218,
			startValue = 1,
			endValue = 11,
			states = {
				[1] = "You have found a fisherman called Santiago, who has a little problem. \z
					Maybe you should talk to him again to find out more.",
				[2] = "Santiago asked you to go into his house. Upstairs you will find a chest. \z
					You can keep what you find inside of it. Once you got that, talk to Santiago again.",
				[3] = "You have found Santiago's Coat and reported back to him. \z
					Your quest is not done yet, you should talk to him a bit more.",
				[4] = "Santiago gave you a weapon. After equipping it, go to the cellar of his house to find out \z
					about the cockroach plague.",
				[5] = "You brought the cockroach legs to Santiago. He still has something to tell you though.",
				[6] = "Santiago asked you, if those cockroaches hurt you. You should reply to him!",
				[7] = "Santiago has a valuable lesson for you. You should talk to him again.",
				[8] = "Santiago showed you how some monsters might hurt you. \z
					Better to talk to him to learn a way to heal yourself.",
				[9] = "Santiago gave you some fish! Just 'use' it to eat it and regain health. \z
					Afterwards, you should talk to Santiago again.",
				[10] = "Santiago asked you if you had seen Zirella. Don't let him wait for the answer.",
				[11] = "You have helped Santiago a lot by killing the cokcroaches in his cellar. \z
					In exchange, he gave you equipment and some valuable experience. Well done!",
			},
		},
		[2] = {
			name = "Collecting Wood",
			storageId = Storage.Quest.U8_2.TheBeginningQuest.ZirellaQuestLog,
			missionId = 10219,
			startValue = 1,
			endValue = 8,
			states = {
				[1] = "You have a vague idea that Zirella might need you for collecting firewood, \z
					but you don't know yet where to get it. You should talk to her again.",
				[2] = "You know that the branches Zirella needs might be gotten from dead trees in \z
					the forest south of here, but you don't know the details yet. You should talk to her \z
						but there is some information missing. You should talk to Zirella again.",
				[4] = "You have learned that you can push the branch which you've broken from a dead tree by \z
					'Drag &amp; Drop', but you still need some information. You should talk to Zirella again.",
				[5] = "You know that you have to 'Use' the branch. Then leftclick with the changed cursor on the cart. \z
					Now you just have to tell Zirella that you will help her.",
				[6] = "Go into the forest south of here and look for trees without leaves. 'Use' one to break a branch \z
					from it, then drag &amp; drop the branch back to her cart and 'Use' it with the cart.",
				[7] = "You have brought a branch to Zirella, congratulations! You should talk to her again for your reward.",
				[8] = "You have helped Zirella by collecting wood for her. The reward can be found in her house.",
			},
		},
		[3] = {
			name = "A Hungry Tailor",
			storageId = Storage.Quest.U8_2.TheBeginningQuest.CarlosQuestLog,
			missionId = 10220,
			startValue = 1,
			endValue = 8,
			states = {
				[1] = "You found another person named Carlos. You should talk to him learn how to change your outfit.",
				[2] = "Carlos taught you how to change your outfit. Now he seems to be wanting a small favour from you. \z
					Talk to him again to learn more.",
				[3] = "Carlos asked you whether you could bring him some food. \z
					Talk to him again to learn how to find food here.",
				[4] = "Carlos asked you to hunt some deer and rabbits and loot them to find a piece of ham or meat. \z
					However you haven't agreed yet, so you should tell him that you'll do it.",
				[5] = "You agreed to bring Carlos some food. \z
					Hunt some deer or rabbit until you find a piece of meat or ham talk to Carlos again.",
				[6] = "To sell the meat or ham to Carlos, talk to him and ask him for a 'trade'.",
				[7] = "You sucessfully learnt how to change your outfit and how to trade with NPCs. \z
					Time to head over the bridge to Rookgaard!",
				[8] = "You have passed the bridge to Rookgaard and have sucessfully completed the Tutorial. \z
					If you want to skip the tutorial in the future with a new character, simply say 'skip tutorial' to Santiago.",
			},
		},
	},
}

return quest
