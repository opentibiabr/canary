--
--	Title system created by @marcosvf132 for Canary repository. (OTBR)
--	Updated on 23/06/2022
--	To-Do 'isUnlocked' list:
--	 - "Admirer of the Crown"
--	 - "Jack of all Taints"
--	 - "Reigning Drome Champion"
--
if TitleSystem == nil then
	TitleSystem = {
		enabled = true,
		gold = {
			[1] = {name = "Gold Hoarder", id = 1, description = "Earned at least 1,000,000 gold.", amount = 1000000},
			[2] = {name = "Platinum Hoarder", id = 2, description = "Earned at least 10,000,000 gold.", amount = 10000000},
			[3] = {name = "Crystal Hoarder", id = 3, description = "Earned at least 100,000,000 gold.", amount = 100000000},
		},
		mounts = {
			[1] = {name = "Beaststrider (Grade 1)", id = 4, description = "Unlocked 10 or more Mounts.", amount = 10, permanent = true},
			[2] = {name = "Beaststrider (Grade 2)", id = 5, description = "Unlocked 20 or more Mounts.", amount = 20, permanent = true},
			[3] = {name = "Beaststrider (Grade 3)", id = 6, description = "Unlocked 30 or more Mounts.", amount = 30, permanent = true},
			[4] = {name = "Beaststrider (Grade 4)", id = 7, description = "Unlocked 40 or more Mounts.", amount = 40, permanent = true},
			[5] = {name = "Beaststrider (Grade 5)", id = 8, description = "Unlocked 50 or more Mounts.", amount = 50, permanent = true},
		},
		outfits = {
			[1] = {name = "Tibia's Topmodel (Grade 1)", id = 9, description = "Unlocked 10 or more Outfits.", amount = 10, permanent = true},
			[2] = {name = "Tibia's Topmodel (Grade 2)", id = 10, description = "Unlocked 20 or more Outfits.", amount = 20, permanent = true},
			[3] = {name = "Tibia's Topmodel (Grade 3)", id = 11, description = "Unlocked 30 or more Outfits.", amount = 30, permanent = true},
			[4] = {name = "Tibia's Topmodel (Grade 4)", id = 12, description = "Unlocked 40 or more Outfits.", amount = 40, permanent = true},
			[5] = {name = "Tibia's Topmodel (Grade 5)", id = 13, description = "Unlocked 50 or more Outfits.", amount = 50, permanent = true},
		},
		level = {
			[1] = {name = "Trolltrasher", id = 14, description = "Reached level 50.", amount = 50},
			[2] = {name = "Cyclopscamper", id = 15, description = "Reached level 100.", amount = 100},
			[3] = {name = "Demondoom", id = 16, description = "Reached level 300.", amount = 300},
			[4] = {name = "Dragondouser", id = 17, description = "Reached level 200.", amount = 200},
			[5] = {name = "Drakenbane", id = 18, description = "Reached level 400.", amount = 400},
			[6] = {name = "Silencer", id = 19, description = "Reached level 500.", amount = 500},
			[7] = {name = "Exalted", id = 20, description = "Reached level 1000.", amount = 1000},
		},
		highscores = {
			[1] = {name = "Legend of Fishing", id = 21, description = "Highest fishing level on character's world.", skill = HIGHSCORE_CATEGORY_FISHING},
			[2] = {name = "Legend of Magic", id = 22, description = "Highest magic level on character's world.", skill = HIGHSCORE_CATEGORY_MAGIC_LEVEL},
			[3] = {name = "Legend of Marksmanship", id = 23, description = "Highest distance fighting level on character's world.", skill = HIGHSCORE_CATEGORY_DISTANCE_FIGHTING},
			[4] = {name = "Legend of the Axe", id = 24, description = "Highest axe fighting level on character's world.", skill = HIGHSCORE_CATEGORY_AXE_FIGHTING},
			[5] = {name = "Legend of the Club", id = 25, description = "Highest club fighting level on character's world.", skill = HIGHSCORE_CATEGORY_CLUB_FIGHTING},
			[6] = {name = "Legend of the Fist", id = 26, description = "Highest fist fighting level on character's world.", skill = HIGHSCORE_CATEGORY_FIST_FIGHTING},
			[7] = {name = "Legend of the Shield", id = 27, description = "Highest Shielding level on character's world.", skill = HIGHSCORE_CATEGORY_SHIELDING},
			[8] = {name = "Legend of the Sword", id = 28, description = "Highest sword fighting level on character's world.", skill = HIGHSCORE_CATEGORY_SWORD_FIGHTING},
			[9] = {name = "Apex Predator", id = 29, description = "Highest Level on character's world.", skill = HIGHSCORE_CATEGORY_EXPERIENCE},
			[10] = {names = {male = "Prince Charming", female = "Princess Charming"}, id = 30, description = "Highest score of accumulated charm points on character's world.", skill = HIGHSCORE_CATEGORY_CHARMS},
		},
		bestiary = {
			[1] = {name = "Bipedantic", id = 31, description = "Unlocked All Humanoid Bestiary entries.", race = BESTY_RACE_HUMANOID},
			[2] = {names = {male = "Blood Moon Hunter", female = "Blood Moon Huntress"}, id = 32, description = "Unlocked All Lycanthrope Bestiary entries.", race = BESTY_RACE_LYCANTHROPE},
			[3] = {name = "Coldblooded", id = 33, description = "Unlocked All Amphibic Bestiary entries.", race = BESTY_RACE_AMPHIBIC},
			[4] = {name = "Death from Below", id = 34, description = "Unlocked all Bird Bestiary entries.", race = BESTY_RACE_BIRD},
			[5] = {name = "Demonator", id = 35, description = "Unlocked all Demon Bestiary entries.", race = BESTY_RACE_DEMON},
			[6] = {name = "Dragonslayer", id = 36, description = "Unlocked all Dragon Bestiary entries.", race = BESTY_RACE_DRAGON},
			[7] = {name = "Elementalist", id = 37, description = "Unlocked all Elemental Bestiary entries.", race = BESTY_RACE_ELEMENTAL},
			[8] = {name = "Exterminator", id = 38, description = "Unlocked all Vermin Bestiary entries.", race = BESTY_RACE_VERMIN},
			[9] = {name = "Fey Swatter", id = 39, description = "Unlocked all Fey Bestiary entries.", race = BESTY_RACE_FEY},
			[10] = {names = {male = "Ghosthunter", female = "Ghosthuntress"}, id = 40, description = "Unlocked all Undead Bestiary entries.", race = BESTY_RACE_UNDEAD},
			[11] = {names = {male = "Handyman", female = "Handywoman"}, id = 41, description = "Unlocked all Construct Bestiary entries.", race = BESTY_RACE_CONSTRUCT},
			[12] = {names = {male = "Huntsman", female = "Huntress"}, id = 42, description = "Unlocked all Mammal Bestiary entries.", race = BESTY_RACE_MAMMAL},
			[13] = {name = "Interdimensional Destroyer", id = 43, description = "Unlocked all Extra Dimensional Bestiary entries.", race = BESTY_RACE_EXTRA_DIMENSIONAL},
			[14] = {names = {male = "Manhunter", female = "Manhuntress"}, id = 44, description = "Unlocked all Human Bestiary entries.", race = BESTY_RACE_HUMAN},
			[15] = {names = {male = "Master of Illusion", female = "Mistress of Illusion"}, id = 45, description = "Unlocked all Magical Bestiary entries.", race = BESTY_RACE_MAGICAL},
			[16] = {name = "Ooze Blues", id = 46, description = "Unlocked all Slime Bestiary entries.", race = BESTY_RACE_SLIME},
			[17] = {name = "Sea Bane", id = 47, description = "Unlocked all Aquatic Bestiary entries.", race = BESTY_RACE_AQUATIC},
			[18] = {name = "Snake Charmer", id = 48, description = "Unlocked all Reptile Bestiary entries.", race = BESTY_RACE_REPTILE},
			[19] = {name = "Tumbler", id = 49, description = "Unlocked all Giant Bestiary entries.", race = BESTY_RACE_GIANT},
			[20] = {name = "Weedkiller", id = 50, description = "Unlocked all Plant Bestiary entries.", race = BESTY_RACE_PLANT},
			[21] = {name = "Executioner", id = 51, description = "Unlocked all Bestiary entries.", race = false},
		},
		login = {
			[1] = {name = "Creature of Habit (Grade 1)", id = 52, description = "Reward Streak of at least 7 days of consecutive logins.", amount = 7, permanent = true},
			[2] = {name = "Creature of Habit (Grade 2)", id = 53, description = "Reward Streak of at least 30 days of consecutive logins.", amount = 30, permanent = true},
			[3] = {name = "Creature of Habit (Grade 3)", id = 54, description = "Reward Streak of at least 90 days of consecutive logins.", amount = 90, permanent = true},
			[4] = {name = "Creature of Habit (Grade 4)", id = 55, description = "Reward Streak of at least 180 days of consecutive logins.", amount = 180, permanent = true},
			[5] = {name = "Creature of Habit (Grade 5)", id = 56, description = "Reward Streak of at least 365 days of consecutive logins.", amount = 365, permanent = true},
		},
		task = {
			[1] = {names = {male = "Aspiring Huntsman", female = "Aspiring Huntswoman"}, id = 57, description = "Invested 160,000 tasks points.", amount = 160000, permanent = true},
			[2] = {name = "Competent Beastslayer", id = 58, description = "Invested 320,000 tasks points.", amount = 320000, permanent = true},
			[3] = {name = "Feared Bountyhunter", id = 59, description = "Invested 430,000 tasks points.", amount = 430000, permanent = true},
		},
		map = {
			[1] = {name = "Dedicated Entrepreneur", id = 60, description = "Explored 50% of all the map areas.", amount = 50},
			[2] = {name = "Globetrotter", id = 61, description = "Explored all map areas.", amount = 100},
		},
		quest = {
			[1] = {name = "Planegazer", id = 62, description = "Followed the trail of the Planestrider to the end.", storage = {key = 1000, value = 1}, permanent = true},
			[2] = {name = "Hero of Bounac", id = 63, description = "You prevailed during the battle of Bounac and broke the siege that held Bounac's people in its firm grasp.", storage = {key = 1000, value = 1}, permanent = true},
			[3] = {name = "Royal Bounacean Advisor", id = 64, description = "Called to the court of Bounac by Kesar the Younger himself.", storage = {key = 1000, value = 1}, permanent = true},
			[4] = {name = "Time Traveller", id = 65, description = "Anywhere in time or space.", storage = {key = 1000, value = 1}, permanent = true},
		},
		others = {
			[1] = {name = "Admirer of the Crown", id = 66, description = "Adjust your crown and handle it.", permanent = true, isUnlocked = function(player)
				if not(player) then
					return false
				end

				-- To-Do
				return false
			end},
			[2] = {name = "Big Spender", id = 67, description = "Unlocked the full Golden Outfit.", permanent = true, isUnlocked = function(player)
				if not(player) then
					return false
				end

				return player:hasOutfit(1211, 3) and player:hasOutfit(1210, 3)
			end},
			[3] = {name = "Guild Leader", id = 68, description = "Leading a Guild.", isUnlocked = function(player)
				if not(player) then
					return false
				end

				return player:getGuildLevel() == 3
			end},
			[4] = {name = "Jack of all Taints", id = 69, description = "Highest score for killing Goshnar and his aspects on character's world.", isUnlocked = function(player)
				if not(player) then
					return false
				end

				-- To-Do
				return false
			end},
			[5] = {name = "Reigning Drome Champion", id = 70, description = "Finished most recent Tibiadrome rota ranked in the top 5.", isUnlocked = function(player)
				if not(player) then
					return false
				end

				-- To-Do
				return false
			end},
		}
	}
	--
	do
		if not(TitleSystem.enabled) then
			return
		end
		--
		for _, titleSystem_it in pairs(TitleSystem) do
			if type(titleSystem_it) == "table" and #titleSystem_it > 0 then
				for __, it in pairs(titleSystem_it) do
					if it.id ~= nil then
						if it.names ~= nil then
							Game.registerPlayerTitle(it.id, it.names.male, it.names.female, it.description, it.permanent)
						else
							Game.registerPlayerTitle(it.id, it.name, it.name, it.description, it.permanent)
						end
					end
				end
			end
		end
	end
end
--
-- Gold section
TitleSystem.goldFunction = function(player, amount)
	if not(player) then
		return false
	end

	return player:getBankBalance() >= amount
end
--
-- Mount section
TitleSystem.mountFunction = function(player, amount)
	if not(player) then
		return false
	end

	local unlocked = 0
	for _, mountTable in ipairs(Game.getMounts()) do
		if player:hasMount(mountTable.id) then
			unlocked = unlocked + 1
		end
	end
	return unlocked >= amount
end
--
-- Outfit section
TitleSystem.outfitFunction = function(player, amount)
	if not(player) then
		return false
	end

	local unlocked = 0
	for _, outfitTable in ipairs(Game.getOutfits(player:getSex())) do
		if player:hasOutfit(outfitTable.lookType) then
			unlocked = unlocked + 1
		end
	end
	return unlocked >= amount
end
--
-- Level section
TitleSystem.levelFunction = function(player, amount)
	if not(player) then
		return false
	end

	return player:getLevel() >= amount
end
--
-- Highscores section
TitleSystem.highscoreFunction = function(player, skill)
	if not(player) then
		return false
	end

	return Game.getHighscoresLeaderId(skill) == player:getGuid()
end
--
-- Bestiary section
TitleSystem.bestiaryFunction = function(player, race)
	if not(player) then
		return false
	end

	if race == false then
		for i = BESTY_RACE_FIRST, BESTY_RACE_LAST do
			if player:getBestiaryRaceEntries(i) < Game.getBestiaryRaceAmount(i) then
				return false
			end
		end

		return true
	end

	return player:getBestiaryRaceEntries(race) >= Game.getBestiaryRaceAmount(race)
end
--
-- Login section
TitleSystem.loginFunction = function(player, amount)
	if not(player) then
		return false
	end

	return player:getLoginStreak() >= amount
end
--
-- Task hunting section
TitleSystem.taskFunction = function(player, amount)
	if not(player) then
		return false
	end

	return player:getTaskHuntingPointsObtained() >= amount
end
--
-- Map section
TitleSystem.mapFunction = function(player, amount)
	if not(player) then
		return false
	end

	return player:getMapAreaDiscoveredPercentage() >= amount
end
--
-- Quest section
TitleSystem.questFunction = function(player, storage)
	if not(player) then
		return false
	end

	return player:getStorageValue(storage.key) == storage.value
end
--
--
function Player.initializeTitleSystem(self)
	if not(TitleSystem.enabled) then
		return false
	end
	--
	-- Gold section
	if TitleSystem.gold ~= nil and #(TitleSystem.gold) > 0 then
		for _, it in pairs(TitleSystem.gold) do
			if TitleSystem.goldFunction(self, it.amount) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Mount section
	if TitleSystem.mounts ~= nil and #(TitleSystem.mounts) > 0 then
		for _, it in pairs(TitleSystem.mounts) do
			if TitleSystem.mountFunction(self, it.amount) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Outfit section
	if TitleSystem.outfits ~= nil and #(TitleSystem.outfits) > 0 then
		for _, it in pairs(TitleSystem.outfits) do
			if TitleSystem.outfitFunction(self, it.amount) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Level section
	if TitleSystem.level ~= nil and #(TitleSystem.level) > 0 then
		for _, it in pairs(TitleSystem.level) do
			if TitleSystem.levelFunction(self, it.amount) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Highscores section
	if TitleSystem.highscores ~= nil and #(TitleSystem.highscores) > 0 then
		for _, it in pairs(TitleSystem.highscores) do
			if TitleSystem.highscoreFunction(self, it.skill) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Bestiary section
	if TitleSystem.bestiary ~= nil and #(TitleSystem.bestiary) > 0 then
		for _, it in pairs(TitleSystem.bestiary) do
			if TitleSystem.bestiaryFunction(self, it.race) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Login section
	if TitleSystem.login ~= nil and #(TitleSystem.login) > 0 then
		for _, it in pairs(TitleSystem.login) do
			if TitleSystem.loginFunction(self, it.amount) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Task hunting section
	if TitleSystem.task ~= nil and #(TitleSystem.task) > 0 then
		for _, it in pairs(TitleSystem.task) do
			if TitleSystem.taskFunction(self, it.amount) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Map section
	if TitleSystem.map ~= nil and #(TitleSystem.map) > 0 then
		for _, it in pairs(TitleSystem.map) do
			if TitleSystem.mapFunction(self, it.amount) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Quest section
	if TitleSystem.quest ~= nil and #(TitleSystem.quest) > 0 then
		for _, it in pairs(TitleSystem.quest) do
			if TitleSystem.questFunction(self, it.storage) then
				self:addTitle(it.id)
			end
		end
	end
	--
	-- Others section
	if TitleSystem.others ~= nil and #(TitleSystem.others) > 0 then
		for _, it in pairs(TitleSystem.others) do
			if it.isUnlocked(self) then
				self:addTitle(it.id)
			end
		end
	end
	--
	--
	return true
end
--@endofthefile