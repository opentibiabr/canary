local quest = {
	name = "Outfit and Addon Quests",
	startStorageId = Storage.OutfitQuest.DefaultStart,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Assassin Addon: The Red Death",
			storageId = Storage.Quest.U7_8.AssassinOutfits.AssassinBaseOutfit,
			missionId = 10168,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Atrad wants only two items from you for his old katana: a behemoth claw and a nose ring, \z
					both at the same time. He also told you about a &quot;horned fox&quot; who wears such as nose ring",
				[2] = "You have received the second assassin addon.",
			},
		},
		[2] = {
			name = "Citizen Addon: Backpack",
			storageId = Storage.Quest.U7_8.CitizenOutfits.MissionBackpack,
			missionId = 10169,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Collect 100 pieces of minotaur leather and bring it to either Amber or Lubo \z
					to have them make a backpack addon for you.",
				[2] = "You delivered 100 pieces of minotaur leather. Some time is needed to make the backpack for you though. \z
					You should check back later and ask either Amber or Lubo for your backpack.",
			},
		},
		[3] = {
			name = "Citizen Addon: Feather Hat",
			storageId = Storage.Quest.U7_8.CitizenOutfits.MissionHat,
			missionId = 10170,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Collect a legion helmet, 100 chicken feathers and 50 honeycombs and bring them to either \z
					Hanna or Norma to have them make a feather hat addon for you.",
				[2] = "You got the Citizen Hat Addon!",
			},
		},
		[4] = {
			name = "Barbarian Outfit Quest",
			storageId = Storage.Quest.U7_8.BarbarianOutfits.BarbarianAddon,
			missionId = 10171,
			startValue = 1,
			endValue = 17,
			states = {
				[1] = "Bron told you that his brother Ajax in Northport needs to learn that violence is not \z
					always the answer. He told you to make his brother angry, then show him that all he \z
					needed to do was say 'please' to fix the situation.",
				[2] = "You will need to leave Ajax alone for an hour, then return to him.",
				[3] = "Ajax told you that he has thought about it, and that violence is not always good. \z
					Return to Bron now, and tell him that Ajax said fist not always good",
				[4] = "Bron mentioned that he has someone in his house that he doesn't like, and he wants you to \z
					get advice from Ajax about how to handle the situation. Go back to Ajax and ask him about Gelagos",
				[5] = "Ajax told you his brother needs Fighting Spirit, and that you should get some from a Djinn \z
					and give it to him.",
				[6] = "You brought Bron the Fighting Spirit. He acted a little strange.",
				[7] = "In order to make a shirt as a present for Ajax, Bron wants you to bring him 50 Pieces of \z
					Red Cloth and 50 Pieces of Green Cloth.",
				[8] = "Bron wants you to bring him 10 Spider Silk Yarn.",
				[9] = "Bron wants you to bring him the Warrior's Sweat.",
				[10] = "You brought him all required items! accept it!",
				[11] = "You got the Barbarian Wig Addon! Bring now the present from Bron to Ajax!",
				[12] = "Bring Ajax in Northport 100 Iron Ore.",
				[13] = "Bring Ajax 1 Huge Chunk of Crude Iron.",
				[14] = "Bring Ajax 50 Perfect Behemoth Fang",
				[15] = "Bring Ajax 50 Lizard Leather",
				[16] = "Come later in 2 hours and ask Ajax for the axe.",
				[17] = "You got the Axe Addon!",
			},
		},
		[5] = {
			name = "Beggar Outfit: The Newest Fashion",
			storageId = Storage.Quest.U7_8.BeggarOutfits.BeggarOutfit,
			missionId = 10172,
			startValue = 1,
			endValue = 8,
			states = {
				[1] = "Your current task is to bring Hugo 20 pieces of brown cloth, like the worn and ragged ghoul clothing.",
				[2] = "Your current task is to bring 50 pieces of minotaur leather to Hugo. \z
					If you don't know how to get leather, you should ask Kalvin.",
				[3] = "Your current task is to bring 10 bat wings to Hugo.",
				[4] = "Your current task is to bring 30 heaven blossoms to Hugo. Elves are said to cultivate these flowers.",
				[5] = "You brought all items required for the &quot;poor man's look&quot; to Hugo. \z
					He told you to come back to him after a whole day has passed, then the outfit should be finished.",
				[6] = "You got the outfit!",
				[7] = "Now you need to go after the items to get the first addon.",
				[8] = "Congratulations, you delivered the items for the first addon.",
			},
		},
		[6] = {
			name = "Druid Outfit Quest",
			storageId = Storage.Quest.U7_8.DruidOutfits.DruidHatAddon,
			missionId = 10173,
			startValue = 1,
			endValue = 10,
			states = {
				[1] = "Ceiron sends you to collect a sample of the blooming Griffinclaw.",
				[2] = "Ask Ceiron for task.",
				[3] = "take Ceirons waterskin and try to fill it with water from this special trickle. \z
					In the mountains between Ankrahmun and Tiquanda are two hydra lairs. \z
					It is important that you take the water directly from the trickle, not from the pond",
				[4] = "Ask Ceiron for task.",
				[5] = "Bring Ceiron 100 ounces of demon dust.",
				[6] = "Ask Ceiron for task.",
				[7] = "The last mission is to find and retrieve Ceiron's Wolf Tooth Chain lost inside the Orc Fortress.",
				[8] = "Ask Ceiron for Faolan.",
				[9] = "Head over to Cormaya, find A Majestic Warwolf's Cave and ask her about an addon.",
				[10] = "You got the Outfit!",
			},
		},
		[7] = {
			name = "Hunter Outfit Quest",
			storageId = Storage.Quest.U7_8.HunterOutfits.HunterHatAddon,
			missionId = 10174,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Elane sends you to Liberty Bay to bring her the Crossbow from the Cult.",
				[2] = "Bring Elane 100 pieces of lizard leather and 100 pieces of red dragon leather.",
				[3] = "Bring Elane 5 enchanted chicken wings.",
				[4] = "Bring Elane one piece of royal steel, draconian steel and hell steel each.",
				[5] = "You got the Outfit!",
			},
		},
		[8] = {
			name = "Knight Addon: Helmet",
			storageId = Storage.Quest.U7_8.KnightOutfits.MissionHelmet,
			missionId = 10175,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "Your current task is to bring 100 perfect behemoth fangs to Gregor in Thais.",
				[2] = "Your current task is to retrieve the helmet of Ramsay the Reckless from Banuta. \z
					These pesky apes steal everything they can get their dirty hands on.",
				[3] = "Your current task is to obtain a flask of warrior's sweat, which can be magicially extracted \z
					from headgear worn by a true warrior, but only in small amounts. Djinns are said to be good at this.",
				[4] = "Your current task is to bring royal steel to Gregor in Thais. \z
					Royal steel can only be refined by very skilled smiths.",
				[5] = "You have delivered all items required for the helmet addon. \z
					Go talk to Sam and tell him Gregor sent you. He will be glad to refine your helmet.",
				[6] = "Sam is currently creating the helmet for you. Be patient and don't forget to check on it later!",
			},
		},
		[9] = {
			name = "Mage &amp; Summoner Outfit Quest (Wand)",
			storageId = Storage.Quest.U7_8.MageAndSummonerOutfits.AddonWand,
			missionId = 10176,
			startValue = 1,
			endValue = 7,
			states = {
				[1] = "You found Angelina in a Prison. She told you a secret: \z
				Lynda in Thais can create a blessed wand. Greet her from Angelina, maybe she will aid you.",
				[2] = "Lynda send you to bring her a sample of all five wands and five rods \z
					(Snakebite, Moonlight, Necrotic, Terra, Hailstorm, Vortex, Dragonbreath, Decay, Cosmic Energy and Inferno)",
				[3] = "Bring Lynda 10 ounces of magic sulphur",
				[4] = "Bring Lynda the Necromancer's soul stone",
				[5] = "Bring Lynda 20 ankhs now to complete the ritual.",
				[6] = "You need to wait 3 hours for the ritual to be completed",
				[7] = "You got the Outfit!",
			},
		},
		[10] = {
			name = "Mage &amp; Summoner Outfit Quest (Fluid Belt)",
			storageId = Storage.Quest.U7_8.MageAndSummonerOutfits.AddonBelt,
			missionId = 10177,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Now you can get a lottery ticket at Sandra for 100 empty vials.",
				[2] = "You got the Outfit! Now you can get for a lottery prize 50000 gold!",
			},
		},
		[11] = {
			name = "Female Mage and Male Summoner Addon: Headgear",
			storageId = Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak,
			missionId = 10178,
			startValue = 1,
			endValue = 11,
			states = {
				[1] = "Your current task is to bring 70 bat wings to Myra in Port Hope.",
				[2] = "Your current task is to bring 20 pieces of red cloth to Myra in Port Hope. \z
					These are said to make an excellent material for a cape.",
				[3] = "Your current task is to bring 40 pieces of ape fur to Myra in Port Hope.",
				[4] = "Your current task is to bring 35 holy orchids to Myra in Port Hope. Elves are said to cultivate these.",
				[5] = "Your current task is to bring 10 spools of spider silk yarn to Myra in Port Hope. \z
					Only very large spiders produce silk which is strong enough to be yarned by mermaids.",
				[6] = "Your current task is to bring 60 lizard scales to Myra in Port Hope. \z
					Lizard scales are great for all sort of magical potions.",
				[7] = "Your current task is to bring 40 red dragon scales to Myra in Port Hope.",
				[8] = "Your current task is to bring 15 ounces of magic sulphur to Myra in Port Hope. \z
					Djinns are said to be good at extracting magic sulphur.",
				[9] = "Your current task is to bring 30 ounces of vampire dusts to Myra in Port Hope. \z
					You might need to ask a priest for a special blessed stake to turn vampires into dust.",
				[10] = "You finally collected all of the items which Myra asked for. \z
					Go talk to Zoltan in Edron and tell him that Myra nominated you for an award.",
			},
		},
		[12] = {
			name = "Norseman Outfit Quest",
			storageId = Storage.Quest.U8_0.TheIceIslands.NorsemanOutfit,
			missionId = 10179,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Bring Hjaern 5 frostheart shards to get the first Addon. Ask him for shard!",
				[2] = "Bring Hjaern 10 frostheart shards to get the second Addon. Ask him for shard!",
				[3] = "You got the Outfit Addons! You can trade the rest shards to Hjaern for 2000 gold each!",
			},
		},
		[13] = {
			name = "Warrior Addon: Shoulder Spike",
			storageId = Storage.Quest.U7_8.WarriorOutfits.WarriorShoulderAddon,
			missionId = 10180,
			startValue = 1,
			endValue = 7,
			states = {
				[1] = "Your current task is to bring 100 hardened bones to Trisha in Carlin. \z
					They can sometimes be extracted from creatures that consist only of - you guessed it, bones. \z
					You need an obsidian knife though.",
				[2] = "Your current task is to bring 100 turtle shells to Trisha in Carlin. \z
					Turtles can be found on some idyllic islands which have recently been discovered.",
				[3] = "Your current task is to show that you have fighting spirit. Maybe someone grants you a wish...?",
				[4] = "Your current task is to obtain a dragon claw. \z
					You cannot get this special claw from any common dragons in Tibia. \z
					It requires a special one, a lord among the lords.",
				[5] = "You have delivered all items requried for the shoulder spike addon. \z
					Go talk to Cornelia and tell her Trisha sent you. She will be glad to create the should spikes.",
				[6] = "Cornelia is currently creating the should spikes for you. \z
					Be patient and don't forget to check on it later!",
				[7] = "You have obtained the shoulder spike addon.",
			},
		},
		[14] = {
			name = "Wizard Outfits Quest",
			storageId = Storage.Quest.U7_8.WizardOutfits,
			missionId = 10181,
			startValue = 1,
			endValue = 7,
			states = {
				[1] = "Bring Lugri the Medusa shield!",
				[2] = "Bring Lugri the Dragon Scale Mail!",
				[3] = "Bring Lugri the Crown Legs!",
				[4] = "Bring Lugri the Ring of the Sky!",
				[5] = "You got the first Outfit Addon!",
				[6] = "Bring The Queen Of The Banshees 50 Holy Orchids and she will reward you with the second addon.",
				[7] = "You got the second Outfit Addon!",
			},
		},
		[15] = {
			name = "Pirate Outfit Quest (Sabre)",
			storageId = Storage.Quest.U7_8.PirateOutfits.PirateSabreAddon,
			missionId = 10182,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Bring Duncan 100 Eye Patches from pirates!",
				[2] = "Bring Duncan 100 peg legs from pirates!",
				[3] = "Bring Duncan 100 pirate hooks from pirates!",
				[4] = "Go to Morgan and tell him this codeword: 'firebird' to get the outfit addon!",
				[5] = "You got the Outfit Addon!",
			},
		},
		[16] = {
			name = "Oriental Addon: Hipwear",
			storageId = Storage.Quest.U7_8.OrientalOutfits.FirstOrientalAddon,
			missionId = 10183,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your current task is to find a mermaid's comb. \z
					If you have ever encountered a mermaid, you should ask her. \z
					Bring the comb to Habdel if you are male or to Ishina if you are female.",
				[2] = "You have received the first oriental addon.",
			},
		},
		[17] = {
			name = "Oriental Addon: Headgear",
			storageId = Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon,
			missionId = 10184,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Your current task is to bring 100 pieces of ape fur to Razan if you are male, \z
					or to Miraia if you are female.",
				[2] = "Your current task is to bring 100 fish fins to Razan if you are male, or to Miraia if you are female.",
				[3] = "Your current task is to bring 2 enchanted chicken wings to Razan if you are male, \z
					or to Miraia if you are female.",
				[4] = "Your current task is to bring 100 pieces of blue cloth to Razan if you are male, \z
					or to Miraia if you are female.",
				[5] = "You have received the second oriental addon.",
			},
		},
		[18] = {
			name = "Shaman Addon: Staff",
			storageId = Storage.Quest.U7_8.ShamanOutfits.MissionStaff,
			missionId = 10185,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Try to find a monster which sometimes lurks in the Tiquandian jungle as the revenge of the jungle \z
					against mankind. Bring the rare root it carries to Chondur as well as 5 voodoo dolls.",
			},
		},
		[19] = {
			name = "Shaman Addon: Mask",
			storageId = Storage.Quest.U7_8.ShamanOutfits.MissionMask,
			missionId = 10186,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your current task is to collect 5 tribal masks from the dworcs and 5 banana staves from the apes. \z
					Bring them to Chondur to earn your shamanic mask.",
			},
		},
	},
}

return quest
