taskOptions = {
	bonusReward = 65001, -- storage bonus reward
	bonusRate = 1, -- rate bonus reward
	taskBoardPositions = {
        {x = 32378, y = 32239, z = 7},  -- thais dp 
	    {x = 32330, y = 31779, z = 7},  -- carlin dp
		{x = 32914, y = 32074, z = 7},  -- venore dp
		{x = 32680, y = 31686, z = 7},  -- ab'dendriel dp
		{x = 32652, y = 31904, z = 8},  -- kazordoon dp 
		{x = 33126, y = 32840, z = 7},  -- ankrahmun dp
		{x = 33173, y = 31815, z = 7},  -- edron dp
		{x = 33026, y = 31452, z = 11},  -- farmine dp
		{x = 33215, y = 32460, z = 8},  -- darashia dp
		{x = 32335, y = 32834, z = 7},  -- liberty bay dp
		{x = 32622, y = 32736, z = 7},  -- port hope dp
		{x = 32264, y = 31141, z = 7},  -- svargrond dp
		{x = 32788, y = 31248, z = 7},  -- yalahar dp
		{x = 33447, y = 31314, z = 8},  -- gray beach dp
		{x = 33654, y = 31663, z = 8},  -- krailos dp
		{x = 33625, y = 31895, z = 7},  -- oramond dp
		{x = 33552, y = 32385, z = 6},  -- roshamuul dp
		{x = 33921, y = 31480, z = 7},  -- issavi dp
		{x = 33491, y = 32223, z = 6},  -- feyrist dp
		{x = 32389, y = 32489, z = 7},  -- bounac dp
		{x = 33777, y = 32842, z = 7},  -- marapur dp
		
    },
	selectLanguage = 2 -- options: 1 = pt_br or 2 = english
}

task_pt_br = {
	exitButton = "Exit",
	confirmButton = "Confirm",
	cancelButton = "Cancel",
	returnButton = "Back",
	title = "Task Board",
	missionError = "Task is in progress or has already been completed.",
	missionErrorTwo = "You completed the task",
	missionErrorTwoo = "\nHere are your rewards:",
	choiceText = "- Experience: ",
	messageAcceptedText = "You accepted this task!",
	messageDetailsText = "Task details:",
	choiceMonsterName = "Name: ",
	choiceMonsterKill = "Kills: ",
	choiceEveryDay = "Repeat: Every day",
	choiceRepeatable = "Repeat: Always",
	choiceOnce = "Repetition: Only once",
	choiceReward = "Rewards:",
	messageAlreadyCompleteTask = "You have already completed this task.",
	choiceCancelTask = "You canceled this task",
	choiceCancelTaskError = "You cannot cancel this task because it has already been completed or has not been started.",
	choiceBoardText = "Choose a task and use the buttons below:",
	choiceRewardOnHold = "Redeem Prize",
	choiceDailyConclued = "Daily Conclusion",
	choiceConclued = "Conclusion",
	messageTaskBoardError = "The quest board is too far away or this is not the correct quest board.",
	messageCompleteTask = "You finished this mission! \nReturn to the quest board and claim your reward.",
}

taskConfiguration = {
	{name = "Adult Goanna", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190011, 
	storagecount = 190012, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	{name = "Arachnophobica", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190013, 
	storagecount = 190014, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	{name = "Bashmu", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190015, 
	storagecount = 190016, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	{name = "Behemoth", 
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190017, 
	storagecount = 190018, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},	
	
	{name = "Black Sphinx Acolyte", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190019, 
	storagecount = 190020, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	{name = "Blood Beast", 
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190021, 
	storagecount = 190022, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
	
	{name = "Boar Man", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190023, 
	storagecount = 190024, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	{name = "Bog Raider", 
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190025, 
	storagecount = 190026, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
	
	{name = "Bony Sea Devil", 
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190027, 
	storagecount = 190028, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
		
	{name = "Brachiodemon", 
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190029, 
	storagecount = 190030, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
			
	{name = "Brain Squid", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190031, 
	storagecount = 190032, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	{name = "Branchy Crawler", 
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190033, 
	storagecount = 190034, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},	
	
	{name = "Breach Brood", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190035, 
	storagecount = 190036, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
		
	{name = "Brimstone Bug", 
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190037, 
	storagecount = 190038, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
				
	{name = "Broken Shaper", 
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190041, 
	storagecount = 190042, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
					
	{name = "Burning Book", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190043, 
	storagecount = 190044, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
						
	{name = "Burning Gladiator", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190045, 
	storagecount = 190046, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
							
	{name = "Burster Spectre", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190047, 
	storagecount = 190048, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
								
	{name = "Capricious Phantom", 
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190049, 
	storagecount = 190050, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
									
	{name = "Carnivostrich", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190051, 
	storagecount = 190052, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
										
	{name = "Cave Chimera", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190053, 
	storagecount = 190054, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
											
	{name = "Cave Devourer", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190055, 
	storagecount = 190056, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
												
	{name = "Chasm Spawn", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190057, 
	storagecount = 190058, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
													
	{name = "Choking Fear", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190059, 
	storagecount = 190060, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
														
	{name = "Cliff Strider", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190061, 
	storagecount = 190062, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
															
	{name = "Cloak of Terror", 
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190063, 
	storagecount = 190064, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																
	{name = "Cobra Assassin",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190065, 
	storagecount = 190066, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																	
	{name = "Cobra Scout", 
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190067, 
	storagecount = 190068, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																		
	{name = "Cobra Vizier",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190069, 
	storagecount = 190070, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																			
	{name = "Courage Leech",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190071, 
	storagecount = 190072, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																				
	{name = "Crape Man",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190073, 
	storagecount = 190074, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																					
	{name = "Crawler",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190075, 
	storagecount = 190076, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																						
	{name = "Crazed Summer Rearguard",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190077, 
	storagecount = 190078, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																							
	{name = "Crazed Summer Vanguard",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190079, 
	storagecount = 190080, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																								
	{name = "Crazed Winter Rearguard",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190081, 
	storagecount = 190082, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																									
	{name = "Crazed Winter Vanguard",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190083, 
	storagecount = 190084, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																										
	{name = "Crypt Warden",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190085, 
	storagecount = 190086, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																											
	{name = "Crypt Warrior",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190087, 
	storagecount = 190088, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																												
	{name = "Cult Believer",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190089, 
	storagecount = 190090, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																													
	{name = "Cult Enforcer",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190091, 
	storagecount = 190092, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																														
	{name = "Cult Scholar",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190093, 
	storagecount = 190094, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																
	{name = "Cunning Werepanther",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190507, 
	storagecount = 190508, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																															
	{name = "Cursed Book",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190095, 
	storagecount = 190096, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																
	{name = "Dark Carnisylvan",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190097, 
	storagecount = 190098, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																	
	{name = "Dark Torturer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190099, 
	storagecount = 190100, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																		
	{name = "Dawnfire Asura",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190101, 
	storagecount = 190102, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																			
	{name = "Deathling Scout",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190103, 
	storagecount = 190104, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																				
	{name = "Deathling Spellsinger",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190105, 
	storagecount = 190106, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																					
	{name = "Deepling Guard",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190107, 
	storagecount = 190108, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																						
	{name = "Deepling Scout",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190109, 
	storagecount = 190110, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																							
	{name = "Deepling Spellsinger",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190111, 
	storagecount = 190112, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																								
	{name = "Deepworm",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190113, 
	storagecount = 190114, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																									
	{name = "Demon",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190115, 
	storagecount = 190116, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																										
	{name = "Demon Outcast",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190117, 
	storagecount = 190118, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																											
	{name = "Destroyer",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190119, 
	storagecount = 190120, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																												
	{name = "Devourer",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190121, 
	storagecount = 190122, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																													
	{name = "Diremaw",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190123, 
	storagecount = 190124, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																														
	{name = "Distorted Phantom",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190125, 
	storagecount = 190126, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
	
   {name = "Dragolisk",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190515, 
	storagecount = 190516, 
	rewards = { 
		{3043,30}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 600000}
	 },
	},
																																															
	{name = "Dragon",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190127, 
	storagecount = 190128, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																
	{name = "Dragon Hatchling",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190129, 
	storagecount = 190130, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																	
	{name = "Dragon Lord",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190131, 
	storagecount = 190132, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																		
	{name = "Dragon Lord Hatchling",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190133, 
	storagecount = 190134, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																			
	{name = "Draken Spellweaver",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190135, 
	storagecount = 190136, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 600000}
	 },
	},
																																																				
	{name = "Draken Warmaster",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190137, 
	storagecount = 190138, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																					
	{name = "Dread Intruder",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190139, 
	storagecount = 190140, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																						
	{name = "Druid's Apparition",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190141, 
	storagecount = 190142, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																							
	{name = "Elder Wyrm",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190143, 
	storagecount = 190144, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																								
	{name = "Emerald Tortoise",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190145, 
	storagecount = 190146, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																									
	{name = "Energetic Book",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190147, 
	storagecount = 190148, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																										
	{name = "Energuardian of Tales",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190149, 
	storagecount = 190150, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																											
	{name = "Enfeebled Silencer",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190151, 
	storagecount = 190152, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																												
	{name = "Exotic Bat",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190153, 
	storagecount = 190154, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																													
	{name = "Exotic Cave Spider",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190155, 
	storagecount = 190156, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																														
	{name = "Eyeless Devourer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190157, 
	storagecount = 190158, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 4000000}
	 },
	},
																																																															
	{name = "Falcon Knight",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190159, 
	storagecount = 190160, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																
	{name = "Falcon Paladin",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190161, 
	storagecount = 190162, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																	
	{name = "Feral Sphinx",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190163, 
	storagecount = 190164, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																							
	{name = "Feral Werecrocodile",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190501, 
	storagecount = 190502,
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																		
	{name = "Flimsy Lost Soul",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190165, 
	storagecount = 190166, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																			
	{name = "Floating Savant",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190167, 
	storagecount = 190168, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																				
	{name = "Foam Stalker",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190169, 
	storagecount = 190170, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																					
	{name = "Frazzlemaw",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190171, 
	storagecount = 190172, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 20},
		{"exp", 600000}
	 },
	},
																																																																						
	{name = "Freakish Lost Soul",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190173, 
	storagecount = 190174, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																							
	{name = "Frost Dragon",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190175, 
	storagecount = 190176, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																								
	{name = "Frost Dragon Hatchling",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190177, 
	storagecount = 190178, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																									
	{name = "Frost Flower Asura",
	color = 40, 
	total = 400, 
	type = "daily", 
	storage = 190179, 
	storagecount = 190180, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																										
	{name = "Fury",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190181, 
	storagecount = 190182, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																											
	{name = "Gazer Spectre",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190183, 
	storagecount = 190184, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																												
	{name = "Ghastly Dragon",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190185, 
	storagecount = 190186, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																													
	{name = "Giant Spider",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190187, 
	storagecount = 190188, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																														
	{name = "Girtablilu Warrior",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190189, 
	storagecount = 190190, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																															
	{name = "Glooth Anemone",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190191, 
	storagecount = 190192, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																
	{name = "Glooth Bandit",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190193, 
	storagecount = 190194, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																	
	{name = "Glooth Brigand",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190195, 
	storagecount = 190196, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																		
	{name = "Glooth Golem",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190197, 
	storagecount = 190198, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																			
	{name = "Gore Horn",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190199, 
	storagecount = 190200, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																				
	{name = "Gorerilla",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190201, 
	storagecount = 190202, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																					
	{name = "Grim Reaper",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190203, 
	storagecount = 190204, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																						
	{name = "Grimeleech",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190205, 
	storagecount = 190206, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																							
	{name = "Guardian of Tales",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190207, 
	storagecount = 190208, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																								
	{name = "Guzzlemaw",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190209, 
	storagecount = 190210, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																									
	{name = "Harpy",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190211, 
	storagecount = 190212, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																										
	{name = "Headpecker",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190213, 
	storagecount = 190214, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																											
	{name = "Hellflayer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190215, 
	storagecount = 190216, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																												
	{name = "Hellhound",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190217, 
	storagecount = 190218, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																													
	{name = "Hellspawn",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190219, 
	storagecount = 190220, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																														
	{name = "Hero",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190221, 
	storagecount = 190222, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																															
	{name = "Hideous Fungus",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190223, 
	storagecount = 190224, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																
	{name = "Hulking Carnisylvan",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190225, 
	storagecount = 190226, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																	
	{name = "Hulking Prehemoth",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190227, 
	storagecount = 190228, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																		
	{name = "Humongous Fungus",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190229, 
	storagecount = 190230, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																			
	{name = "Hydra",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190231, 
	storagecount = 190232, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																				
	{name = "Icecold Book",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190233, 
	storagecount = 190234, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																					
	{name = "Iks Aucar",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190235, 
	storagecount = 190236, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																						
	{name = "Iks Chuka",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190237, 
	storagecount = 190238, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																							
	{name = "Iks Pututu",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190239, 
	storagecount = 190240, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																								
	{name = "Infernal Demon",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190241, 
	storagecount = 190242, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																									
	{name = "Infernal Phantom",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190243, 
	storagecount = 190244, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																										
	{name = "Insane Siren",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190245, 
	storagecount = 190246, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																											
	{name = "Insectoid Worker",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190247, 
	storagecount = 190248, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																												
	{name = "Instable Breach Brood",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190249, 
	storagecount = 190250, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																													
	{name = "Instable Sparkion",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190251, 
	storagecount = 190252, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																														
	{name = "Ironblight",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190253, 
	storagecount = 190254, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																															
	{name = "Juggernaut",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190255, 
	storagecount = 190256, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																
	{name = "Juvenile Bashmu",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190257, 
	storagecount = 190258, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																	
	{name = "Knight's Apparition",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190259, 
	storagecount = 190260, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																																		
	{name = "Knowledge Elemental",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190261, 
	storagecount = 190262, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																			
	{name = "Lamassu",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190263, 
	storagecount = 190264, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																				
	{name = "Lancer Beetle",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190265, 
	storagecount = 190266, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																					
	{name = "Lava Golem",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190267, 
	storagecount = 190268, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																						
	{name = "Lava Lurker",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190269, 
	storagecount = 190270, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																							
	{name = "Lavafungus",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190271, 
	storagecount = 190272, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																								
	{name = "Lavaworm",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190273, 
	storagecount = 190274, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																									
	{name = "Liodile",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190275, 
	storagecount = 190276, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																										
	{name = "Lizard Chosen",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190277, 
	storagecount = 190278, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																											
	{name = "Lizard High Guard",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190279, 
	storagecount = 190280, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																												
	{name = "Lizard Legionnaire",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190281, 
	storagecount = 190282, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																													
	{name = "Lizard Dragon Priest",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190283, 
	storagecount = 190284, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																														
	{name = "Lumbering Carnivor",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190285, 
	storagecount = 190286, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																															
	{name = "Magma Crawler",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190287, 
	storagecount = 190288, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																
	{name = "Makara",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190289, 
	storagecount = 190290, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																	
	{name = "Manticore",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190291, 
	storagecount = 190292, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																		
	{name = "Mantosaurus",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190293, 
	storagecount = 190294, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																																																			
	{name = "Many Faces",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190295, 
	storagecount = 190296, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																																																				
	{name = "Mean Lost Soul",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190297, 
	storagecount = 190298, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																					
	{name = "Medusa",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190299, 
	storagecount = 190300, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	   {name = "Mega Dragon",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190517, 
	storagecount = 190518, 
	rewards = { 
		{3043,30}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 600000}
	 },
	},
																																																																																																																																						
	{name = "Menacing Carnivor",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190301, 
	storagecount = 190302, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																							
	{name = "Mercurial Menace",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190303, 
	storagecount = 190304, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																																																								
	{name = "Midnight Asura",
	color = 40, 
	total = 400, 
	type = "daily", 
	storage = 190305, 
	storagecount = 190306, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																									
	{name = "Minotaur Cult Follower",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190307, 
	storagecount = 190308, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																										
	{name = "Minotaur Cult Prophet",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190309, 
	storagecount = 190310, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																											
	{name = "Minotaur Cult Zealot",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190311, 
	storagecount = 190312, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																												
	{name = "Minotaur Hunter",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190313, 
	storagecount = 190314, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																													
	{name = "Mooh'Tah Warrior",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190315, 
	storagecount = 190316, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																														
	{name = "Mould Phantom",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190317, 
	storagecount = 190318, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																																																															
	{name = "Naga Archer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190319, 
	storagecount = 190320, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																																
	{name = "Naga Warrior",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190321, 
	storagecount = 190322, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																																	
	{name = "Nighthunter",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190323, 
	storagecount = 190324, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																																																																		
	{name = "Nightmare",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190325, 
	storagecount = 190326, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 200000}
	 },
	},
																																																																																																																																																			
	{name = "Noxious Ripptor",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190327, 
	storagecount = 190328, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																																																																				
	{name = "Ogre Rowdy",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190329, 
	storagecount = 190330, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																																					
	{name = "Ogre Ruffian",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190331, 
	storagecount = 190332, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																																						
	{name = "Ogre Sage",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190333, 
	storagecount = 190334, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																																							
	{name = "Orc Cult Fanatic",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190335, 
	storagecount = 190336, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																																								
	{name = "Orc Cult Inquisitor",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190337, 
	storagecount = 190338, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																																									
	{name = "Orc Cult Minion",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190339, 
	storagecount = 190340, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																																										
	{name = "Orc Cult Priest",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190341, 
	storagecount = 190342, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																																											
	{name = "Orewalker",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190343, 
	storagecount = 190344, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																																												
	{name = "Paladin's Apparition",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190345, 
	storagecount = 190346, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																																																																																																																																													
	{name = "Phantasm",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190347, 
	storagecount = 190348, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																																																																																																														
	{name = "Pirat Bombardier",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190349, 
	storagecount = 190350, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																																															
	{name = "Pirat Cutthroat",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190351, 
	storagecount = 190352, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																																																
	{name = "Pirat Mate",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190353, 
	storagecount = 190354, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 200000}
	 },
	},
																																																																																																																																																																	
	{name = "Pirat Scoundrel",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190355, 
	storagecount = 190356, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																																																		
	{name = "Pirate Buccaneer",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190357, 
	storagecount = 190358, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																																																																																																																			
	{name = "Pirate Corsair",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190359, 
	storagecount = 190360, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},																																																																																																																																																																			
	
	{name = "Pirate Cutthroat",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190361, 
	storagecount = 190362, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
		
	{name = "Pirate Marauder",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190363, 
	storagecount = 190364, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
			
	{name = "Plaguesmith",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190365, 
	storagecount = 190366, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
				
	{name = "Poisonous Carnisylvan",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190367, 
	storagecount = 190368, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
					
	{name = "Priestess of the Wild Sun",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190369, 
	storagecount = 190370, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
						
	{name = "Rage Squid",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190371, 
	storagecount = 190372, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
							
	{name = "Ravenous Lava Lurker",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190373, 
	storagecount = 190374, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
								
	{name = "Renegade Knight",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190375, 
	storagecount = 190376, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
									
	{name = "Retching Horror",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190377, 
	storagecount = 190378, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
										
	{name = "Rhindeer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190379, 
	storagecount = 190380, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
											
	{name = "Ripper Spectre",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190381, 
	storagecount = 190382, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
												
	{name = "Rot Elemental",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190383, 
	storagecount = 190384, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
													
	{name = "Rotten Golem",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190385, 
	storagecount = 190386, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
														
	{name = "Sabretooth",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190387, 
	storagecount = 190388, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
															
	{name = "Serpent Spawn",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190389, 
	storagecount = 190390, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																
	{name = "Shrieking Cry-Stal",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190391, 
	storagecount = 190392, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																	
	{name = "Silencer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190393, 
	storagecount = 190394, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																		
	{name = "Skeleton Elite Warrior",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190395, 
	storagecount = 190396, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																			
	{name = "Sorcerer's Apparition",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190397, 
	storagecount = 190398, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																				
	{name = "Sparkion",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190399, 
	storagecount = 190400, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																					
	{name = "Spectre",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190401, 
	storagecount = 190402, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																						
	{name = "Sphinx",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190403, 
	storagecount = 190404, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																							
	{name = "Spiky Carnivor",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190405, 
	storagecount = 190406, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																								
	{name = "Spitter",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190407, 
	storagecount = 190408, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																									
	{name = "Squid Warden",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190409, 
	storagecount = 190410, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																										
	{name = "Stabilizing Dread Intruder",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190411, 
	storagecount = 190412, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																											
	{name = "Stabilizing Reality Reaver",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190413, 
	storagecount = 190414, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																												
	{name = "Stalking Stalk",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190415, 
	storagecount = 190416, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																													
	{name = "Streaked Devourer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190417, 
	storagecount = 190418, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																														
	{name = "Sulphider",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190419, 
	storagecount = 190420, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																															
	{name = "Sulphur Spouter",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190421, 
	storagecount = 190422, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																
	{name = "Thanatursus",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190423, 
	storagecount = 190424, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																	
	{name = "Tremendous Tyrant",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190425, 
	storagecount = 190426, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																		
	{name = "True Dawnfire Asura",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190427, 
	storagecount = 190428, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																			
	{name = "True Frost Flower Asura",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190429, 
	storagecount = 190430, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																			
	{name = "True Midnight Asura",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190431, 
	storagecount = 190432, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																				
	{name = "Eyeless Devourer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190433, 
	storagecount = 190434, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																					
	{name = "Tunnel Tyrant",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190435, 
	storagecount = 190436, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	{name = "Turbulent Elemental", 
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190511, 
	storagecount = 190512, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																						
	{name = "Two-Headed Turtle",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190437, 
	storagecount = 190438, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																							
	{name = "Undead Dragon",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190439, 
	storagecount = 190440, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																								
	{name = "Undead Elite Gladiator",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190441, 
	storagecount = 190442, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																									
	{name = "Undertaker",
	color = 40, 
	total = 700, 
	type = "daily", 
	storage = 190443, 
	storagecount = 190444, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 35},
		{"exp", 4000000}
	 },
	},
																																										
	{name = "Usurper Archer",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190445, 
	storagecount = 190446, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																											
	{name = "Usurper Knight",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190447, 
	storagecount = 190448, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																												
	{name = "Usurper Warlock",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190449, 
	storagecount = 190450, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																													
	{name = "Vampire",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190451, 
	storagecount = 190452, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																														
	{name = "Vampire Bride",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190453, 
	storagecount = 190454, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																															
	{name = "Vampire Viscount",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190455, 
	storagecount = 190456, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																
	{name = "Varnished Diremaw",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190457, 
	storagecount = 190458, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																	
	{name = "Venerable Girtablilu",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190459, 
	storagecount = 190460, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																		
	{name = "Vexclaw",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190461, 
	storagecount = 190462, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																			
	{name = "Vicious Squire",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190463, 
	storagecount = 190464, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																				
	{name = "Vile Grandmaster",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190465, 
	storagecount = 190466, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																					
	{name = "Wailing Widow",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190467, 
	storagecount = 190468, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
	
	{name = "Wardragon",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190513, 
	storagecount = 190514, 
	rewards = { 
		{3043,30}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 600000}
	 },
	},
																																																						
	{name = "Weakened Frazzlemaw",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190469, 
	storagecount = 190470, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																							
	{name = "Weeper",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190471, 
	storagecount = 190472, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																								
	{name = "Werebadger",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190473, 
	storagecount = 190474, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																									
	{name = "Werebear",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190475, 
	storagecount = 190476, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																										
	{name = "Wereboar",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190477, 
	storagecount = 190478, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																												
	{name = "Werecrocodile",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190503, 
	storagecount = 190504, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 1400000}
	 },
	},
																																																											
	{name = "Werefox",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190479, 
	storagecount = 190480, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																												
	{name = "Werehyaena",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190481, 
	storagecount = 190482, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																													
	{name = "Werehyaena Shaman",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190483, 
	storagecount = 190484, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																														
	{name = "Werelion",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190485, 
	storagecount = 190486, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																															
	{name = "Werelioness",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190487, 
	storagecount = 190488, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
	
	{name = "Werepanther",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190499, 
	storagecount = 190500, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
				
	{name = "Weretiger",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190505, 
	storagecount = 190506,  
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																
	{name = "Werewolf",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190489, 
	storagecount = 190490, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																			
	{name = "White Weretiger",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190509, 
	storagecount = 190510, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	},
																																																																	
	{name = "Worm Priestess",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190491, 
	storagecount = 190492, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																		
	{name = "Wyrm",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190493, 
	storagecount = 190494, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																			
	{name = "Yielothax",
	color = 40, 
	total = 350, 
	type = "daily", 
	storage = 190495, 
	storagecount = 190496, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 15},
		{"exp", 600000}
	 },
	},
																																																																				
	{name = "Young Goanna",
	color = 40, 
	total = 500, 
	type = "daily", 
	storage = 190497, 
	storagecount = 190498, 
	rewards = { 
		{3043,10}, -- id crystal coin
		{"puntostask", 25},
		{"exp", 1400000}
	 },
	}
}
 
squareWaitTime = 5000
taskQuestLog = 65000 -- A storage so you get the quest log
dailyTaskWaitTime = 20 * 60 * 60 

function Player.getCustomActiveTasksName(self)
local player = self
	if not player then
		return false
	end
local tasks = {}
	for i, data in pairs(taskConfiguration) do
		if player:getStorageValue(data.storagecount) ~= -1 then
		tasks[#tasks + 1] = data.name
		end
	end
	return #tasks > 0 and tasks or false
end


function getTaskByStorage(storage)
	for i, data in pairs(taskConfiguration) do
		if data.storage == tonumber(storage) then
			return data
		end
	end
	return false
end

function getTaskByMonsterName(name)
	for i, data in pairs(taskConfiguration) do
		if data.name:lower() == name:lower() then
			return data
		end
	end
	return false
end

function Player.startTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if player:getStorageValue(taskQuestLog) == -1 then
		player:setStorageValue(taskQuestLog, 1)
	end
	player:setStorageValue(storage, player:getStorageValue(storage) + 1)
	player:setStorageValue(data.storagecount, 0)
	return true
end

function Player.canStartCustomTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	if data.type == "daily" then
		return os.time() >= player:getStorageValue(storage)
	elseif data.type == "once" then
		return player:getStorageValue(storage) == -1
	elseif data.type[1] == "repeatable" and data.type[2] ~= -1 then
		return player:getStorageValue(storage) < (data.type[2] - 1)
	else
		return true
	end
end

function Player.endTask(self, storage, prematurely)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
end
	if prematurely then
		if data.type == "daily" then
			player:setStorageValue(storage, -1)
		else
			player:setStorageValue(storage, player:getStorageValue(storage) - 1)
	end
	else
		if data.type == "daily" then
			player:setStorageValue(storage, os.time() + dailyTaskWaitTime)
		end
	end
	player:setStorageValue(data.storagecount, -1)
	return true
end

function Player.hasStartedTask(self, storage)
local player = self
	if not player then
		return false
	end
local data = getTaskByStorage(storage)
	if data == false then
		return false
	end
	return player:getStorageValue(data.storagecount) ~= -1
end


function Player.getTaskKills(self, storage)
local player = self
	if not player then
		return false
	end
	return player:getStorageValue(storage)
end

function Player.addTaskKill(self, storage, count)
    local player = self
    if not player then
        return false
    end

    local data = getTaskByStorage(storage)
    if data == false then
        return false
    end

    local kills = player:getTaskKills(data.storagecount)
    if kills >= data.total then
        return false
    end

    if kills + count >= data.total then
        local rewardAmount = 0
        for _, reward in pairs(data.rewards) do
            if reward[1] == "puntostask" then
                rewardAmount = reward[2]
                break
            end
        end

        -- Otorgar puntostask al jugador y actualizar la base de datos
        local storeQuery = string.format("UPDATE players SET puntostask = puntostask + %d WHERE id = %d", rewardAmount, player:getGuid())
		db.storeQuery(storeQuery)

        if taskOptions.selectLanguage == 1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, task_pt_br.messageCompleteTask)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] You have finished this task! To claim your rewards, return to the task board and claim your reward.")
        end

        return player:setStorageValue(data.storagecount, data.total)
    end

    player:say('Task: '..data.name ..' - ['.. kills + count .. '/'.. data.total ..']', TALKTYPE_MONSTER_SAY)
    return player:setStorageValue(data.storagecount, kills + count)
end