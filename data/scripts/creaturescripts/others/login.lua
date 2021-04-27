local function onMovementRemoveProtection(cid, oldPos, time)
	local player = Player(cid)
	if not player then
		return true
	end

	local playerPos = player:getPosition()
	if (playerPos.x ~= oldPos.x or playerPos.y ~= oldPos.y or playerPos.z ~= oldPos.z) or player:getTarget() then
		player:setStorageValue(Storage.combatProtectionStorage, 0)
		return true
	end

	addEvent(onMovementRemoveProtection, 1000, cid, oldPos, time - 1)
end

local function protectionZoneCheck(playerName)
    doRemoveCreature(playerName)
    return true
end

local playerLogin = CreatureEvent("PlayerLogin")

function playerLogin.onLogin(player)
	local items = {
		{2120, 1},
		{2148, 3}
	}
	if player:getLastLoginSaved() == 0 then
		player:sendOutfitWindow()
		local backpack = player:addItem(1988)
		if backpack then
			for i = 1, #items do
				backpack:addItem(items[i][1], items[i][2])
			end
		end
		player:addItem(2050, 1, true, 1, CONST_SLOT_AMMO)
		db.query('UPDATE `players` SET `istutorial` = 0 where `id`='..player:getGuid())
	else
		player:sendTextMessage(MESSAGE_STATUS, "Welcome to " .. SERVER_NAME .. "!")
		player:sendTextMessage(MESSAGE_LOGIN, string.format("Your last visit in ".. SERVER_NAME ..": %s.", os.date("%d. %b %Y %X", player:getLastLoginSaved())))
	end

	local playerId = player:getId()

	-- kick other players from account
	if configManager.getBoolean(configKeys.ONE_PLAYER_ON_ACCOUNT) then
		local resultId = db.storeQuery("SELECT players.name FROM `players` INNER JOIN `players_online` WHERE players_online.player_id=players.id and players_online.player_id!=" .. player:getGuid() .. " and players.account_id=" .. player:getAccountId())
		if resultId ~= false then
			repeat
				if player:getAccountType() <= ACCOUNT_TYPE_GOD and player:getGroup():getId() < GROUP_TYPE_GOD then
					local name = result.getDataString(resultId, "name")
					if getCreatureCondition(Player(name), CONDITION_INFIGHT) == false then
						Player(name):remove()
					else
						addEvent(protectionZoneCheck, 2000, player:getName())
						doPlayerPopupFYI(player, "You cant login now.")
					end
				end
			until not result.next(resultId)
				result.free(resultId)
		end
	end
	-- End kick other players from account
	if isPremium(player) then
		player:setStorageValue(Storage.PremiumAccount, 1)
	end
	-- Premium Ends Teleport to Temple, change addon (citizen) houseless
	local defaultTown = "Thais" -- default town where player is teleported if his home town is in premium area
	local freeTowns = {"Ab'Dendriel", "Carlin", "Kazordoon", "Thais", "Venore", "Rookgaard", "Dawnport", "Dawnport Tutorial", "Island of Destiny"} -- towns in free account area

	if isPremium(player) == false and isInArray(freeTowns, player:getTown():getName()) == false then
		local town = player:getTown()
		local sex = player:getSex()
		local home = getHouseByPlayerGUID(getPlayerGUID(player))
		town = isInArray(freeTowns, town:getName()) and town or Town(defaultTown)
		player:teleportTo(town:getTemplePosition())
		player:setTown(town)
		player:sendTextMessage(MESSAGE_FAILURE, "Your premium time has expired.")
		player:setStorageValue(Storage.PremiumAccount, 0)
		if sex == 1 then
			player:setOutfit({lookType = 128, lookFeet = 114, lookLegs = 134, lookHead = 114,lookAddons = 0})
        elseif sex == 0 then
			player:setOutfit({lookType = 136, lookFeet = 114, lookLegs = 134, lookHead = 114, lookAddons = 0})
        end
        if home ~= nil and not isPremium(player) then
            setHouseOwner(home, 0)
            player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, 'You\'ve lost your house because you are not premium anymore.')
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, 'Your items from house are send to your inbox.')
        end
	end
	-- End 'Premium Ends Teleport to Temple'

	-- Recruiter system
	local resultId = db.storeQuery('SELECT `recruiter` from `accounts` where `id`='..getAccountNumberByPlayerName(getPlayerName(player)))
	local recruiterStatus = result.getNumber(resultId, 'recruiter')
	local sex = player:getSex()
	if recruiterStatus >= 1 then
		if sex == 1 then
			local outfit = player:hasOutfit(746)
			if outfit == false then
				player:addOutfit(746)
			end
		else
			local outfit = player:hasOutfit(745)
			if outfit == false then
				player:addOutfit(745)
			end
		end
	end
	if recruiterStatus >= 3 then
		if sex == 1 then
			local outfit = player:hasOutfit(746,1)
			if outfit == false then
				player:addOutfitAddon(746,1)
			end
		else
			local outfit = player:hasOutfit(745,1)
			if outfit == false then
				player:addOutfit(745,1)
			end
		end
	end
	if recruiterStatus >= 10 then
		if sex == 1 then
			local outfit = player:hasOutfit(746,2)
			if outfit == false then
				player:addOutfitAddon(746,2)
			end
		else
			local outfit = player:hasOutfit(745,2)
			if outfit == false then
				player:addOutfit(745,2)
			end
		end
	end
	-- End recruiter system

	DailyReward.init(playerId)

	player:loadSpecialStorage()

	if player:getGroup():getId() >= GROUP_TYPE_GAMEMASTER then
		player:setGhostMode(true)
	end
	-- Boosted creature
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Today's boosted creature: " .. Game.getBoostedCreature() .. " \
	Boosted creatures yield more experience points, carry more loot than usual and respawn at a faster rate.")

	-- Stamina
	nextUseStaminaTime[playerId] = 1

	-- EXP Stamina
	nextUseXpStamina[playerId] = 1

	-- Prey Small Window
	for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
		player:sendPreyData(slot)
	end

	-- New prey
	nextPreyTime[playerId] = {
		[CONST_PREY_SLOT_FIRST] = 1,
		[CONST_PREY_SLOT_SECOND] = 1,
		[CONST_PREY_SLOT_THIRD] = 1
	}

	if (player:getAccountType() == ACCOUNT_TYPE_TUTOR) then
	local msg = [[:: Tutor Rules
		1 *> 3 Warnings you lose the job.
		2 *> Without parallel conversations with players in Help, if the player starts offending, you simply mute it.
		3 *> Be educated with the players in Help and especially in the Private, try to help as much as possible.
		4 *> Always be on time, if you do not have a justification you will be removed from the staff.
		5 *> Help is only allowed to ask questions related to tibia.
		6 *> It is not allowed to divulge time up or to help in quest.
		7 *> You are not allowed to sell items in the Help.
		8 *> If the player encounters a bug, ask to go to the website to send a ticket and explain in detail.
		9 *> Always keep the Tutors Chat open. (required).
		10 *> You have finished your schedule, you have no tutor online, you communicate with some CM in-game
		or ts and stay in the help until someone logs in, if you can.
		11 *> Always keep a good Portuguese in the Help, we want tutors who support, not that they speak a satanic ritual.
		12 *> If you see a tutor doing something that violates the rules, take a print and send it to your superiors. "
		- Commands -
		Mute Player: /mute nick, 90 (90 seconds)
		Unmute Player: /unmute nick.
		- Commands -]]
		player:popupFYI(msg)
	end

	-- Open channels
	if table.contains({TOWNS_LIST.DAWNPORT, TOWNS_LIST.DAWNPORT_TUTORIAL}, player:getTown():getId())then
		player:openChannel(3) -- World chat
	else
		player:openChannel(3) -- World chat
		player:openChannel(5) -- Advertsing main
	end

	-- Rewards
	local rewards = #player:getRewardList()
	if(rewards > 0) then
		player:sendTextMessage(MESSAGE_LOGIN, string.format("You have %d %s in your reward chest.",
		rewards, rewards > 1 and "rewards" or "reward"))
	end

	-- Update player id
	local stats = player:inBossFight()
	if stats then
		stats.playerId = player:getId()
	end

	if player:getStorageValue(Storage.combatProtectionStorage) < 1 then
		player:setStorageValue(Storage.combatProtectionStorage, 1)
		onMovementRemoveProtection(playerId, player:getPosition(), 10)
	end
	-- Set Client XP Gain Rate
	local baseExp = 100
	if Game.getStorageValue(GlobalStorage.XpDisplayMode) > 0 then
		baseExp = getRateFromTable(experienceStages, player:getLevel(), configManager.getNumber(configKeys.RATE_EXP))
	end

	local staminaMinutes = player:getStamina()
	local doubleExp = false --Can change to true if you have double exp on the server
	local staminaBonus = (staminaMinutes > 2340) and 150 or ((staminaMinutes < 840) and 50 or 100)
	if doubleExp then
		baseExp = baseExp * 2
	end
	player:setStaminaXpBoost(staminaBonus)
	player:setBaseXpGain(baseExp)

	if player:getStorageValue(Storage.isTraining) == 1 then --Reset exercise weapon storage
		player:setStorageValue(Storage.isTraining,0)
	end
	return true
end
playerLogin:register()
