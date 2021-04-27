local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local voices = {
	{text = 'Come chat with ol\' Bozo!'},
	{text = 'Do you know the one with the dragon? Where - and then ... hahahaha! Oh no, I guess I ruined it.'},
	{text = 'The fools\' guild? Are you serious? No, of course not! Hahaha!'},
	{text = 'Welcome, welcome, step closer!'}
}
npcHandler:addModule(VoiceModule:new(voices, 10, 20))

local config = {
	[1] = {
		text = {
			[1] = 'Do you have a fitting flower for me?',
			[2] = 'You don\'t have a fitting flower! Why do only fools apply for the fools guild?',
			[3] = 'Indeed. This flower will do the trick, so to say. Just ask me about another mission whenever you\'re ready.'
		},
		yes = true,
		removeItem = {itemId = 7476},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission1, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 2}
		}
	},
	[2] = {
		text = {
			[1] = {
				'The next task will be a bit more difficult. I pride myself on being the major manufacturer of stink bombs in whole Tibia. Stop chuckling you fool aspirant ...',
				'The worst part is getting the perfect stench. Whenever a slime dies, it leaves a noxious gas cloud ...',
				'If you are able to collect its scent in the first few seconds after the slime\'s death, we have the ideal substance to create dozens of stink bombs ...',
				'Take this special vial and fill it with the perfect stench. Then return here and we will talk about your mission.'
			}
		},
		addItem = {itemId = 7478},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission2, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 3}
		}
	},
	[3] = {
		text = {
			[1] = 'Do you have acquired the exquisite stench we need?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = 'Ugh. You got some efficient stuff there. I have to admit you have a talent for such distasteful matters. Perhaps you feel ready for another mission. Just ask me about it.'
		},
		yes = true,
		removeItem = {itemId = 7477},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission2, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 4}
		}
	},
	[4] = {
		text = {
			[1] = {
				'I think you\'re ready for a small promotion. Provided that you finish another mission, that is ...',
				'As you might know, nothing helps you to break the ice so easily when you meet new people as a pie thrown in the face ...',
				'Of course, this habit leads to a dramatic shortage of pies now and then. And that\'s what we need you for. Mirabell in Edron creates the most creamy and sticky pies in the world ...',
				'Get me a dozen of them, this means 12, you fool. Then report to me about your mission.'
			}
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission3, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 5}
		}
	},
	[5] = {
		text = {
			[1] = 'So do you bring me a box full of pies?',
			[2] = 'No, you don\'t! Why do only fools apply for the fools guild?',
			[3] = {
				'Excellent. Poor Harsky, poor Stutch. They will mourn the day they dared to yawn during a performance of the magnificent Bozo ...',
				'However, I grant you the title of \'Fool in Training\' for your efforts. Just don\'t let it go to your head and don\'t use this highly spiritual title to show off ...',
				'If you are interested in another mission, talk to me.'
			}
		},
		yes = true,
		removeItem = {itemId = 7484},
		pie = true,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission3, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 6}
		}
	},
	[6] = {
		text = {
			[1] = {
				'Ah, the fool in training wants to see some action? Fine with me. I think you are ready for a big prank. But first I need 18 vials filled with wine ...',
				'Get them and report here about your mission.'
			}
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission4, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 7}
		}
	},
	[7] = {
		text = {
			[1] = 'Do you have 18 vials of wine?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = {
				'So lets see. I put them into this crate which looks just like the ones in which old Xodet gets his mana potions [1]ed ...',
				'Here take this crate and bring it to Xodet\'s shop. In front of the shop, you should see the latest [1]y. Just use this crate on the other one to exchange them ...',
				'Bring me the interchanged crate and talk to me about your mission.'
			}
		},
		yes = true,
		removeItem = {itemId = 2006, count = 18, subType = 15},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission4, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 8}
		},
		addItem = {itemId = 7482}
	},
	[8] = {
		text = {
			[1] = 'Do you bring me Xodet\'s exchanged crate?',
			[2] = 'No, you don\'t! Why do only fools apply for the fools guild?',
			[3] = 'I see. I guess we can expect a few drunken mages soon! Am I mistaken or are you up for some more challenging missions? Just ask me about if you feel foolish enough.'
		},
		yes = true,
		removeItem = {itemId = 7483},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission4, value = 3},
			{key = Storage.WhatAFoolish.Questline, value = 9}
		}
	},
	[9] = {
		text = {
			[1] = {
				'I have a fine prank in mind but without proper preparation, you\'d end up hacked in pieces by the dwarfs. By chance I found out about an artefact that might save the day ...',
				'There is a mysterious tower, known as Triangle Tower, north of Jakundaf Desert. In this tower, you will find a magic watch that we need for our dangerous fun ...',
				'Well, I\'ll have the fun and you\'ll have the danger but you can view it from a positive side - view it from my side for instance. Now get that watch and report about your mission.'
			}
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission5, value = 1},
			{key = Storage.WhatAFoolish.TriangleTowerDoor, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 10}
		}
	},
	[10] = {
		text = {
			[1] = 'Did you get the watch?',
			[2] = 'No you have not! Why do only fools apply to the fools guild?',
			[3] = {
				'Oh boy, you will have so much fun with that watch if they don\'t catch and kill you. I envy you so much ... Bozo: So listen my little fool, this watch has the power to advance you in time. It will come in handy when you are stealing the beard of the dwarven emperor ...',
				'Oh, come on, don\'t faint like some baby. It\'s perfectly safe with that watch ... well, almost. You sneak into the emperor\'s bedroom when it\'s empty. Use the watch directly beside the bed\'s pillow ...',
				'This should advance you in time. You will appear next to the sleeping emperor. His guards will be outside so they shouldn\'t bother you. Use a sharp kitchen knife to cut off his beard ...',
				'Then quickly use the watch again to advance in time once more. You should appear at a time when everybody has left the room...',
				'Sneak out and come here to report about your mission. As the watch will only work those 2 times, make sure that you\'ve got the beard when returning here.'
			}
		},
		yes = true,
		checkItemCount = 8187,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission5, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 11}
		}
	},
	[11] = {
		text = {
			[1] = 'Did you get the beard?',
			[2] = 'No, you don\'t! Why do only fools apply for the fools guild?',
			[3] = {
				'You got the beard and survived. I think for the first time in my whole life I\'m impressed, no wait, it was just a stone in my shoe ...',
				'Still, as a small recognition of your accomplishments I\'m willing to tell you how to get your own jester outfit. If you are interested in more fun and adventures, ask me for more missions.'
			}
		},
		yes = true,
		checkStorage = Storage.WhatAFoolish.EmperorBeardShave,
		removeItem = {itemId = 7479},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission5, value = 3},
			{key = Storage.WhatAFoolish.Questline, value = 12}
		}
	},
	[12] = {
		text = {
			[1] = 'I can\'t think of anything right now. Maybe you should try to get your jester outfit.'
		}
	},
	[13] = {
		text = {
			[1] = 'You know, nothing has brought more fun and joy to humanity than the whoopee cushion. Its creation is a delicate matter though. Bring me 4 pieces of minotaur leather first and then lets talk about this mission.'
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission6, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 14}
		}
	},
	[14] = {
		text = {
			[1] = 'Do you have the four minotaur leathers?',
			[2] = 'No, you don\'t! Why do only fools apply for the fools guild?',
			[3] = 'Good, this was the first part. Now it gets difficult. To sew it together, we need a very fine yarn, as fine as the silk of a giant spider. Bring me some giant spider silk and talk to me about your mission.'
		},
		yes = true,
		removeItem = {itemId = 5878, count = 4},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission6, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 15}
		}
	},
	[15] = {
		text = {
			[1] = 'Do you have the spider silk with you?',
			[2] = 'No, you don\'t! Why do only fools apply for the fools guild?',
			[3] = 'Let\'s see, a stitch here, a stitch there. Hey Presto! A whoopee cushion! Are you ready for the fun part? Then talk to me about your next mission.'
		},
		yes = true,
		removeItem = {itemId = 5879},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission6, value = 3},
			{key = Storage.WhatAFoolish.Questline, value = 16}
		},
		effect = CONST_ME_POFF
	},
	[16] = {
		text = {
			[1] = {
				'Now that we have this whoopee cushion it would be a waste not to use it, don\'t you agree ...',
				'Don\'t speak! I already know what you have in your impish mind my friend and I agree fully. You will bring this cushion to Carlin and place it right on Queen Eloise\'s throne! Then return here and talk to me about your mission.'
			}
		},
		addItem = {itemId = 7485},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission6, value = 4},
			{key = Storage.WhatAFoolish.Questline, value = 17}
		}
	},
	[17] = {
		text = {
			[1] = 'Have you placed the whoopee cushion on the throne in Carlin?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = 'This will cause quite a commotion in Carlin. I think we should play some pranks in many more places to spread humour all over the world. Talk to me about your next mission to learn more about it.'

		},
		yes = true,
		checkStorage = Storage.WhatAFoolish.WhoopeeCushion,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission6, value = 5},
			{key = Storage.WhatAFoolish.Questline, value = 18}
		}
	},
	[18] = {
		text = {
			[1] = {
				'The time has come to play a prank on some arrogant Venorean. I found out that Carina, the jeweller, is terribly afraid of mice ...',
				'Your task is quite easy. Steal the toy mouse of Queen Eloise\'s cat and show it to Carina in Venore to scare her to death. Then report about your mission.'
			}
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission7, value = 1},
			{key = Storage.WhatAFoolish.QueenEloiseCatDoor, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 19}
		}
	},
	[19] = {
		text = {
			[1] = 'Have you been to Venore and scared Carina as I asked you to?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = 'Excellent. The Venoreans have been safe from my pranks far too long. If you are ready for another mission, talk to me.'

		},
		yes = true,
		checkStorage = Storage.WhatAFoolish.ScaredCarina,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission7, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 20}
		}
	},
	[20] = {
		text = {
			[1] = {
				'These Venoreans think they are safe from us. They couldn\'t be more wrong. Let them feel the wrath of the fools! Get a spoon and collect some sulphur from an inactive lava hole ...',
				'Be very careful when you get the easily inflammable substance. Then let\'s talk about the next part of your mission.'
			}
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission8, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 21}
		}
	},
	[21] = {
		text = {
			[1] = 'Have you collected the sulphur?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = 'So much for part one of my foolish master plan. Now travel to Tiquanda and use a kitchen knife to cut some leaves of the jungle dweller bush for me. Bring them with you when you report about your mission.'
		},
		yes = true,
		removeItem = {itemId = 8204},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission8, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 22}
		}
	},
	[22] = {
		text = {
			[1] = 'Do you have the leaves with you?',
			[2] = 'No, you don\'t! Why do only fools apply for the fools guild?',
			[3] = 'So far so good. I will prepare some nasty surprise for your next mission. Talk to me about it whenever you feel ready.'
		},
		yes = true,
		removeItem = {itemId = 8109},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission8, value = 3},
			{key = Storage.WhatAFoolish.Questline, value = 23}
		}
	},
	[23] = {
		text = {
			[1] = {
				'Now look at this, someone has made exploding cigars out of the sulphur and the leaves! Coincidentally I have a great idea how wecould use them ...',
				'Take this cigar and give it to Theodore Loveless, the Venorean representative in Liberty Bay. After you [1]ed our little\'present\', report here about the outcome of your mission.'
			}
		},
		addItem = {itemId = 7499},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission8, value = 4},
			{key = Storage.WhatAFoolish.Questline, value = 24}
		}
	},
	[24] = {
		text = {
			[1] = 'Have you [1]ed the exploding cigar to Theodore Loveless?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = 'You\'re hell of a guy, I bet you enjoyed it. As you represent everything a fool stands for, I give you this fool\'s sceptre to spiceup your jester outfit. If you are interested, there are even more missions for a fool like yourself. Just ask about them.'
		},
		yes = true,
		checkStorage = Storage.WhatAFoolish.Cigar,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission8, value = 5},
			{key = Storage.WhatAFoolish.Questline, value = 25}
		},
		addItem = {itemId = 7958},
		addon = 1
	},
	[25] = {
		text = {
			[1] = {
				'Well, I think as a true fool you have to think big. So our next little prank will be on a grand scale. Of course, this will need some preparation ...',
				'Firstly, take this vial and use it on a dead stalker immediately after his death to collect his warm blood. Report about your mission when you are done.'
			}
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission9, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 26}
		},
		addItem = {itemId = 7478}
	},
	[26] = {
		text = {
			[1] = 'Have you gotten the blood that we need?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = {
				'Congratulations! Now let\'s talk about the complicated part. We need the ink of a quara constrictor. Use this vial on a fresh corpse to get the ink ...',
				'Stop making these grimaces! I know it\'s a foolish task, but after all that\'s also the fun about it. Get the ink and report to me about your mission.'
			}
		},
		yes = true,
		removeItem = {itemId = 7488},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission9, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 27}
		},
		addItem = {itemId = 7478}
	},
	[27] = {
		text = {
			[1] = 'Have you acquired the constrictor\'s ink?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = 'Excellent. As a true fool you have of course no clue what these ingredients are good for, but I will enlighten you. Just ask about your next mission and I\'ll tell you everything you need to know.'
		},
		yes = true,
		removeItem = {itemId = 7489},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission9, value = 3},
			{key = Storage.WhatAFoolish.Questline, value = 28}
		}
	},
	[28] = {
		text = {
			[1] = {
				'Blood of a stalker and ink of a quara are the main ingredients of the prop for our next prank. Mix it together to obtain some nice vanishing ink ...',
				'It looks exactly like normal ink, however, exposed to air it will vanish within minutes. I\'m sure you understand how useful this ink can be ...',
				'Now, listen to my plan. Go to Sam and order 2000 steel shields. He will never agree to it if you do not sign a contract ...',
				'Use the vanishing ink to sign the contract and then hand the paper back to him. This will keep this humourless doter busy for a while. Talk to me about your mission when you are done.'
			}
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission9, value = 4},
			{key = Storage.WhatAFoolish.Questline, value = 29}
		},
		addItem = {itemId = 7490}
	},
	[29] = {
		text = {
			[1] = 'So have you fooled the old Sam yet?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = 'What a splendid prank! If you are ready for more, ask me about the next mission.'
		},
		yes = true,
		checkStorage = Storage.WhatAFoolish.Contract,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission9, value = 5},
			{key = Storage.WhatAFoolish.Questline, value = 30}
		}
	},
	[30] = {
		text = {
			[1] = {
				'This time I have no real mission for you, rather a small errand. I bet you had expected some dangerous and exhausting quest but since I like you so much, I make it veeeeery easy for you ...',
				'Here are some cookies. Beware though, those are exploding confetti cookies. You will have to [1] them to 10 special persons, then return to me and report about your mission. Seems easy, doesn\'t it? Are you going to accept this mission?'
			},
			[3] = {
				'Great! That\'s the word of a true fool! Maybe you want to write the names down. Here we go: [1] a cookie to: ...',
				'The pompous hero Avar Tar in Edron, Simon the greedy beggar on Fibula, the pirate Ariella on the Shattered Isles, the dubious Lorbas next to the ruins of the Dark Cathedral, King Markwin in the underground city Mintwalin ...',
				'The shaman Hjaern on the ice island Nibelor, the witch Wyda in the Green Claw Swamp, the ape Hairycles in the jungle city Banuta ...',
				'The orc king in the orc fortress Uldrek\'s Rock and the last one to EITHER Yaman, the green djinn, OR, Nah\'Bob, the blue djinn ...',
				'A piece of cake isn\'t it? Did you take notes? If you need the list again, just ask me for it. Otherwise leave now and report about the mission whenever you\'re done.'
			}
		},
		yes = true,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission10, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 31}
		},
		addItem = {itemId = 8111, count = 10}
	},
	[31] = {
		text = {
			[1] = 'Are you done with your little delivery mission?',
			[3] = 'Indeed, you\'re done. By the way, you look a little bit tired and dirty. However, if you still have some power left, ask me about the next mission.'
		},
		yes = true,
		cookiesDelivery = true,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission10, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 32}
		}
	},
	[32] = {
		text = {
			[1] = {
				'I\'m sure you\'re wondering how many tiring missions old Bozo has still in store for you! Don\'t worry! You\'re almost done, only one final mission left ...',
				'Well, that is after you got the needed material. First of all, bring me 5 pieces of white cloth. Then we talk more about your mission.'
			}
		},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission11, value = 1},
			{key = Storage.WhatAFoolish.Questline, value = 33}
		}
	},
	[33] = {
		text = {
			[1] = 'Have you been able to get hold of 5 pieces of white cloth?',
			[2] = 'No, you haven\'t! Why do only fools apply for the fools guild?',
			[3] = {
				'Well done. Anyway, I reeeally hate to tell you but ... as white as it\'s now we have no use for it. Don\'t worry though. There is a way to give it an old and worn look ...',
				'The unforgiving desert sun combined with the noxious fumes of the Plague Spike in Darama will do the trick ...',
				'Travel to Darama, climb the Plague Spike and look for a nice spot to let mother nature do the work. Perhaps something like an altar would be useful. Once you\'re done, return here and learn about the next step of your mission.'
			}
		},
		yes = true,
		removeItem = {itemId = 5909, count = 5},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission11, value = 2},
			{key = Storage.WhatAFoolish.Questline, value = 34}
		},
		addItem = {itemId = 7500}
	},
	[34] = {
		text = {
			[1] = 'Do you have a piece of old and worn cloth?',
			[2] = 'No, you don\'t! Why do only fools apply for the fools guild?',
			[3] = {
				'Fine, fine. Now let\'s do the last step of our foolish plan. Smart as I am, I used a pair of scissors to create some old and worn bands from the cloth you have brought me. DON\'T touch it yet ...',
				'Travel to Darashia and visit caliph Kazzan. Use the bands made of the worn cloth to disguise yourself as a mummy ...',
				'Finally, talk to the caliph to give him the scare of his lifetime. Afterwards come back here and tell me about the fun you had with this mission.'
			}
		},
		yes = true,
		removeItem = {itemId = 7501},
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission11, value = 3},
			{key = Storage.WhatAFoolish.Questline, value = 35}
		},
		addItem = {itemId = 7502}
	},
	[35] = {
		text = {
			[1] = 'Well, my diligent pupil, have you scared the caliph yet?',
			[2] = 'No, you don\'t! Why do only fools apply for the fools guild?',
			[3] = 'By Kurik, I knew you have it in you. You are a fool after my fancy. Take this jester hat, you deserve it. It will go nicely with your jester costume.'
		},
		yes = true,
		checkStorage = Storage.WhatAFoolish.ScaredKazzan,
		updateStorages = {
			{key = Storage.WhatAFoolish.Mission11, value = 4},
			{key = Storage.WhatAFoolish.Questline, value = 36}
		},
		addItem = {itemId = 7957},
		addon = 2,
		last = true
	},
	[36] = {
		text = {
			[1] = 'You are a fully trained fool now who has developed to an accomplished jester. Your final mission is to bring fun and joy to the whole world.'
		}
	}
}

local jesterOutfit = {
	[-1] = {
		text = {
			[1] = 'First we will need one piece of red cloth. Do you have it with you?',
			[2] = 'Ok, now we need one piece of blue cloth. Do you have one with you by chance?'
		},
		removeItemId = 5911,
		newValue = 1,
		choice = 1
	},
	[1] = {
		text = {
			[1] = 'Now we need one piece of blue cloth. Do you have one with you by chance?',
			[2] = 'Ok, now we need one piece of green cloth. Do you have one with you by chance?'
		},
		removeItemId = 5912,
		newValue = 2,
		choice = 2
	},
	[2] = {
		text = {
			[1] = 'Now we need one piece of green cloth. Do you have one with you by chance?',
			[2] = 'At last we need one piece of yellow cloth. Do you have one with you by chance?'
		},
		removeItemId = 5910,
		newValue = 3,
		choice = 3
	},
	[3] = {
		text = {
			[1] = 'Now we need one piece of yellow cloth. Do you have one with you by chance?',
			[2] = 'That\'s it. Here is your jester outfit. It\'s admittedly a bit basic but maybe you\'ll earn some nice accessories soon. At least you are more fittingly dressed for your next missions now.'
		},
		removeItemId = 5914,
		newValue = 4,
		addOutfit = true,
		last = true
	}
}

local value = {}

local function greetCallback(cid)
	if Player(cid):getSex() == PLAYERSEX_MALE then
		npcHandler:setMessage(MESSAGE_GREET, 'Hi there, how\'s it hanging, |PLAYERNAME|! What brings you {here}?')
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Hello, hello, hello, little lady |PLAYERNAME|! What brings you {here}?')
	end
	value[cid] = nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, 'join') then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) ~= -1 then
			npcHandler:say('Wow, your stupidity would be pride and joy for every fool. You\'ve already applied as a member. Let\'s rather talk about your current mission.', cid)
			return true
		end

		npcHandler:say('Do you wish to become a jester and join the fools guild?', cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, 'mission') then
		local targetValue = config[player:getStorageValue(Storage.WhatAFoolish.Questline)]
		if not targetValue then
			return true
		end

		if not targetValue.yes then
			if targetValue.updateStorages then
				for i = 1, #targetValue.updateStorages do
					local storage = targetValue.updateStorages[i]
					player:setStorageValue(storage.key, storage.value)
				end
			end

			if targetValue.addItem then
				player:addItem(targetValue.addItem.itemId, targetValue.addItem.count or 1)
			end
		end

		npcHandler:say(targetValue.text[1], cid)
		if targetValue.yes then
			npcHandler.topic[cid] = 3
			value[cid] = targetValue
		end
	elseif msgcontains(msg, 'jester outfit') then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) == 12 then
			local targetValue = jesterOutfit[player:getStorageValue(Storage.WhatAFoolish.JesterOutfit)]
			if not targetValue then
				return true
			end

			npcHandler:say(targetValue.text[1], cid)
			npcHandler.topic[cid] = 4
			value[cid] = targetValue
		else
			npcHandler:say('I\'m sure it suits you well.', cid)
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				'So you want to make a total fool of yourself? Fine with me, but note that becoming a real fool means more than being just an ordinary fool ...',
				'You will have to master a whole series of challenging, lengthy and, above all, totally foolish quests ...',
				'Are you sure you want to waste a part of your limited lifetime on a quest that makes a fool of yourself and which might award you with the prestigious title of a grand fool in a far away future?'
			}, cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			player:setStorageValue(Storage.WhatAFoolish.Questline, 1)
			player:setStorageValue(Storage.WhatAFoolish.Questlog, 1)
			player:setStorageValue(Storage.WhatAFoolish.Mission1, 1)
			npcHandler:say({
				'What a foolish decision! You are indeed a worthy candidate! But let\'s talk about business ...',
				'Being a jester is not just about telling jokes. A good jester heavily relies on requisites ...',
				'Getting some requisites will be your first job. First of all we need a good supply of water squirt flowers ...',
				'I\'m making them on my own in my spare time but I need the right material. South of Thais, next to the Whiteflower Temple, you will find the ideal flowers ...',
				'Take a kitchen knife, cut the thickest and healthiest flower and bring it here. Then talk to me about your mission.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			local targetValue = value[cid]
			if targetValue.checkStorage then
				if player:getStorageValue(targetValue.checkStorage) ~= 1 then
					npcHandler:say(targetValue.text[2], cid)
					npcHandler.topic[cid] = 0
					return true
				end
			end

			if targetValue.removeItem then
				if not player:removeItem(targetValue.removeItem.itemId, targetValue.removeItem.count or 1, targetValue.removeItem.subType or -1) then
					npcHandler:say(targetValue.text[2], cid)
					npcHandler.topic[cid] = 0
					return true
				end
			end

			if targetValue.checkItemCount then
				if player:getItemCount(targetValue.checkItemCount) == 0 then
					npcHandler:say(targetValue.text[2], cid)
					npcHandler.topic[cid] = 0
					return true
				end
			end

			if targetValue.cookiesDeliveryy then
				if player:getCookiesDelivered() ~= 10 then
					npcHandler:say('No, you aren\'t! Why do only fools apply for the fools guild?', cid)
					npcHandler.topic[cid] = 0
					return true
				end
			end

			if targetValue.pie then
				if player:getStorageValue(Storage.WhatAFoolish.PieBoxTimer) > 0
						and player:getStorageValue(Storage.WhatAFoolish.PieBoxTimer) < os.time() then
					npcHandler:say('Eeeek! What have you done?? These pies are crawling with bugs! Those must be the infamous parcel bugs! Get some new pies at once you wannabe fool, and this time without any bugs!', cid)
					npcHandler.topic[cid] = 0
					return true
				end
			end

			if targetValue.updateStorages then
				for i = 1, #targetValue.updateStorages do
					local storage = targetValue.updateStorages[i]
					player:setStorageValue(storage.key, storage.value)
				end
			end

			if targetValue.addItem then
				player:addItem(targetValue.addItem.itemId, targetValue.addItem.count or 1)
			end

			if targetValue.addon then
				player:addOutfitAddon(270, targetValue.addon)
				player:addOutfitAddon(273, targetValue.addon)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end

			if targetValue.effect then
				Npc():getPosition():sendMagicEffect(targetValue.effect)
			end

			if targetValue.last then
				player:addAchievement('Perfect Fool')
				player:addAchievement('Fool at Heart')
			end

			npcHandler:say(targetValue.text[3], cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 4 then
			local targetValue = value[cid]
			if not player:removeItem(targetValue.removeItemId, 1) then
				npcHandler:say('No, you don\'t! Why do only fools apply for the fools guild?', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.JesterOutfit, targetValue.newValue)
			if targetValue.addOutfit then
				player:addOutfit(270)
				player:addOutfit(273)
				player:setStorageValue(Storage.WhatAFoolish.Questline, 13)
			end
			npcHandler:say(targetValue.text[2], cid)
			if not targetValue.last then
				value[cid] = jesterOutfit[targetValue.choice]
			else
				npcHandler.topic[cid] = 0
			end
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] ~= 0 then
		if isInArray({1, 2}, npcHandler.topic[cid]) then
			npcHandler:say('Too bad, I\'m convinced you have it in you.', cid)
		elseif isInArray({3, 4}, npcHandler.topic[cid]) then
			if player:getStorageValue(Storage.WhatAFoolish.Questline) == 11
					and player:getStorageValue(Storage.WhatAFoolish.EmperorBeardShave) == 1 then
				player:setStorageValue(Storage.WhatAFoolish.Questline, 12)
				player:setStorageValue(Storage.WhatAFoolish.Mission5, 3)
				npcHandler:say({
					'You shaved the emperor, but lost the beard? What kind of fool are you? Well, at least he will have a nice surprise when he wakes up ...',
					'Still, as a small recognition of your accomplishments I\'m willing to tell you how to get your own jester outfit. If you are interested in more fun and adventures, ask me for more missions.'
				}, cid)
			elseif player:getStorageValue(Storage.WhatAFoolish.Questline) == 30 then
				npcHandler:say('You won\'t be successful in the fool\'s world with such an attitude.', cid)
			elseif player:getStorageValue(Storage.WhatAFoolish.Questline) == 35
					and player:getStorageValue(Storage.WhatAFoolish.LostDisguise) ~= 1 then
				player:addItem(7502, 1)
				player:setStorageValue(Storage.WhatAFoolish.LostDisguise, 1)
				npcHandler:say('You wasted the disguise?? Why do only fools apply for the fools guild? Here... try again, but be wittier this time.', cid)
			else
				npcHandler:say('Oh boy, why do only fools apply for the fools guild?', cid)
			end
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

keywordHandler:addKeyword({'sorcerer'}, StdModule.say, {npcHandler = npcHandler, text = 'I wanted to become a sorcerer, too, but I was overqualified!'}, function(player) return player:isSorcerer() end)
keywordHandler:addKeyword({'druid'}, StdModule.say, {npcHandler = npcHandler, text = 'I wanted to become a druid, too, but I was overqualified!'}, function(player) return player:isDruid() end)
keywordHandler:addKeyword({'paladin'}, StdModule.say, {npcHandler = npcHandler, text = 'I wanted to become a paladin, too, but I was overqualified!'}, function(player) return player:isPaladin() end)
keywordHandler:addKeyword({'knight'}, StdModule.say, {npcHandler = npcHandler, text = 'I wanted to become a knight, too, but I was overqualified!'}, function(player) return player:isKnight() end)
keywordHandler:addKeyword({'sorcerer'}, StdModule.say, {npcHandler = npcHandler, text = 'The good thing about them is that they can\'t be at two places at the same time.'})
keywordHandler:addKeyword({'druid'}, StdModule.say, {npcHandler = npcHandler, text = 'I wonder if they love my water squirt flowers as much as all other plants.'})
keywordHandler:addKeyword({'paladin'}, StdModule.say, {npcHandler = npcHandler, text = 'They are the king\'s favourites, because they know how to \'bow\'.'})
keywordHandler:addKeyword({'knight'}, StdModule.say, {npcHandler = npcHandler, text = 'Did you notice that old knights have their scars just on their backs?'})

keywordHandler:addKeyword({'here'}, StdModule.say, {npcHandler = npcHandler, text = 'A fitting place for a {jester}. I guess there are worse {jobs} around.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'Bozo: Nah, no jests about His Royal Highness.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'I rarely leave the castle. It\'s really stressful to be as popular as me.'})
keywordHandler:addKeyword({'castle'}, StdModule.say, {npcHandler = npcHandler, text = 'This castle is my home. A fitting place for a jester and all other fools. Feel welcome.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a jester, not a doctor!'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Bozo. But it\'s more than a name, it\'s a lifestyle for me!'})
keywordHandler:addKeyword({'bozo'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s me: Bozo, the jester!'})
keywordHandler:addKeyword({'guild'}, StdModule.say, {npcHandler = npcHandler, text = 'Ever since the first guild was created, there is a great demand of jesters and fools to join them.'})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Sell? Hmm, I know a little about magic and by chance I can sell you a truly unusual {weapon}.'})
keywordHandler:addKeyword({'joke'}, StdModule.say, {npcHandler = npcHandler, text = 'I know some \'monstrous\' jokes!'})
keywordHandler:addKeyword({'news'}, StdModule.say, {npcHandler = npcHandler, text = 'I know the newest jokes in tibia.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Thank you, I\'m fine, the gods are with me.'})
keywordHandler:addKeyword({'necromant', 'nectar'}, StdModule.say, {npcHandler = npcHandler, text = 'Pheeew! That sounds disgusting! Are you a cook at Frodo\'s?'})
keywordHandler:addKeyword({'necromant'}, StdModule.say, {npcHandler = npcHandler, text = 'Don\'t feed the necromants.'})
keywordHandler:addKeyword({'dog'}, StdModule.say, {npcHandler = npcHandler, text = 'Are we talking about Noodles?'})
keywordHandler:addKeyword({'poodle'}, StdModule.say, {npcHandler = npcHandler, text = 'Are we talking about Noodles?'})
keywordHandler:addKeyword({'noodles'}, StdModule.say, {npcHandler = npcHandler, text = 'Hey, the little one is almost as funny as me!'})
keywordHandler:addKeyword({'muriel'}, StdModule.say, {npcHandler = npcHandler, text = 'Better don\'t mess with sorcerers!'})
keywordHandler:addKeyword({'elane'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s pretty but too serious for my taste.'})
keywordHandler:addKeyword({'marvik'}, StdModule.say, {npcHandler = npcHandler, text = 'Humourless old guy! Once, he turned me into a frog for painting his distasteful cave in pink.'})
keywordHandler:addKeyword({'gregor'}, StdModule.say, {npcHandler = npcHandler, text = 'A man of steel with a stomach of wax. Never offer him a beer!'})
keywordHandler:addKeyword({'quentin'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s my baby brother. If you tell him I sent you, he will grant you an extra spell or two.'})
keywordHandler:addKeyword({'gorn'}, StdModule.say, {npcHandler = npcHandler, text = 'He sells spell scrolls each day at midnight, but you have to address him that very second.'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'I better make no jokes about THIS matter.'})
keywordHandler:addKeyword({'sam'}, StdModule.say, {npcHandler = npcHandler, text = 'Did you know that he sells a \'power axe of doom\' now? Run and buy it, he only has got three in store.'})
keywordHandler:addKeyword({'benjamin'}, StdModule.say, {npcHandler = npcHandler, text = 'He would make a fine jester, too.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'I know a lot of monster jokes. Just tell me a monster\'s name, come on.'})
keywordHandler:addKeyword({'demon'}, StdModule.say, {npcHandler = npcHandler, text = 'Why are the experienced heroes quicker than others? ... The demons love fast food!'})
keywordHandler:addKeyword({'ghoul'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do ghouls buy their robes? ... In a boooohtique!'})
keywordHandler:addKeyword({'dragon'}, StdModule.say, {npcHandler = npcHandler, text = 'Why do dragons breathe fire? ... They ate too many sorcerers in chilli sauce!'})
keywordHandler:addKeyword({'orc'}, StdModule.say, {npcHandler = npcHandler, text = 'Why do orcs have green skin? ... They ate at Frodo\'s!'})
keywordHandler:addKeyword({'cyclops'}, StdModule.say, {npcHandler = npcHandler, text = 'How many eyes does a cyclops have? ... One for each IQ point they have!'})
keywordHandler:addKeyword({'oswald'}, StdModule.say, {npcHandler = npcHandler, text = 'If you believe half the rumours he\'s spreading, you will get in a lot of trouble.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'If you are a bad jester, you get a chance to visit them now and then.'})
keywordHandler:addKeyword({'mino'}, StdModule.say, {npcHandler = npcHandler, text = 'What do all little minotaurs want to become when they are grown-ups? ... Cowboys, of course!'})
keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = 'Why do trolls live underground? ... Because there are so many pks on the surface!'})
keywordHandler:addKeyword({'bonelord'}, StdModule.say, {npcHandler = npcHandler, text = 'Why are bonelords so ugly? ... Because their mom and dad were bonelords, too!'})
keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'Why does the rat have a wooden leg? ... Because it is a former pirate!'})
keywordHandler:addKeyword({'spider'}, StdModule.say, {npcHandler = npcHandler, text = 'Why did the spider cross the road? ... Because it ... oh you already know this one!?'})
keywordHandler:addKeyword({'hugo'}, StdModule.say, {npcHandler = npcHandler, text = 'I had a cousin named like that.'})
keywordHandler:addKeyword({'cousin'}, StdModule.say, {npcHandler = npcHandler, text = 'He died some years ago.'})
keywordHandler:addKeyword({'durin'}, StdModule.say, {npcHandler = npcHandler, text = 'Isn\'t he the author of the book \'Fun with Demons\'?'})
keywordHandler:addKeyword({'stephan'}, StdModule.say, {npcHandler = npcHandler, text = 'He is kind of a father figure to me. Of course he denies all kinship to me.'})
keywordHandler:addKeyword({'steve'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a smart one. I heared he hid in a foreign country as the first bugs showed up.'})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = 'I am not foolish enough to believe in the existence of this weapon.'})
keywordHandler:addKeyword({'wall', 'carving'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, I saw some demon carvings in the dungeons as I hid there after a little joke on old Stutch.'})
keywordHandler:addKeyword({'demon', 'carving'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, they showed demons, seven actually, dancing around a sword! In something like a flaming pit.'})
keywordHandler:addKeyword({'flaming', 'pit'}, StdModule.say, {npcHandler = npcHandler, text = 'Ah, don\'t ask me! Usually mages and mystics know more about such stuff.'})

local jobKeyword = keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the royal jes ... uhm ... the royal tax-collector! Do you want to pay your taxes?'})
	jobKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Come back, when you have enough money.', reset = true}, function(player) return player:getMoney() < 50 end)
	jobKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Thank you very much. I will have a drink or two on your health!', reset = true}, nil, function(player) if player:removeMoneyNpc(50) then end end)
	jobKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Well, perhaps later.', reset = true})

local magicKeyword = keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'I actually know some spells! Do you want to learn how to \'lessen your load\' for 200 gold?'})
	magicKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Come back, when you have enough money.', reset = true}, function(player) return player:getMoney() < 200 end)
	magicKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Here you are, I already lessened your load.', reset = true}, nil, function(player) if player:removeMoneyNpc(200) then end end)
	magicKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'You don\'t know what offer you are missing!', reset = true})
keywordHandler:addAliasKeyword({'spell'})

local weaponKeyword = keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want to buy a \'mace of the fury\' for 250 gold?'})
	weaponKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Come back, when you have enough money.', reset = true}, function(player) return player:getMoney() < 250 end)
	weaponKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'And here it is, it suits you well!', reset = true}, nil, function(player) if player:removeMoneyNpc(250) then player:addItem(2570, 1) end end)
	weaponKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'You dont know what offer you have passed!', reset = true})

keywordHandler:addKeyword({'kiss'}, StdModule.say, {npcHandler = npcHandler, text = 'Uh, go away!', ungreet = true}, function(player) return player:getSex() == PLAYERSEX_MALE end)

local kissKeyword = keywordHandler:addKeyword({'kiss'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want to kiss me?'})
	kissKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Uh, oh! ... I am seeing stars!', reset = true}, nil, function(player) player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) end)
	kissKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Pah, I didn\'t want to kiss you anyway!', reset = true})

keywordHandler:addKeyword({'lady'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, women don\'t behave necessarily in a ladylike way just because they dress like one!'}, function(player) return player:getSex() == PLAYERSEX_MALE end)

local ladyKeyword = keywordHandler:addKeyword({'lady'}, StdModule.say, {npcHandler = npcHandler, text = 'Has any man said to you that you\'re not only beautiful but also intelligent?'})
	ladyKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'This is a world of fantasy and full of surprises!', reset = true})
	ladyKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Well, think about it!', reset = true})

npcHandler:setMessage(MESSAGE_FAREWELL, 'Remember: A joke a day keeps the ghouls away!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Hey! Fools have feelings too.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
