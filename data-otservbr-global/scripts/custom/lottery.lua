local config = {
        rewards_id = {35285, 35286, 35287,35288,35289,35290, 3043}, -- possible reward items
        crystal_counts = {10,20,30,40,50,60,70,80,90,100}, -- table for crystal coins
        days = {--Day-Hour
                "Monday-08",
                "Monday-13",
                "Monday-19",
				
				-- Every 4 hours
				"Tuesday-01",
				"Tuesday-05",
                "Tuesday-09",
				"Tuesday-13",
				"Tuesday-17",

                "Tuesday-01",
				"Tuesday-05",
				"Tuesday-09",
				"Tuesday-10",
				"Tuesday-11",
				"Tuesday-12",
				"Tuesday-13",
				"Tuesday-14",
				"Tuesday-15",

                "Wednesday-08",
                "Wednesday-09",
                "Wednesday-10",
				"Wednesday-11",
                "Wednesday-12",
                "Wednesday-13",
				"Wednesday-14",
                "Wednesday-15",
                "Wednesday-16",
				"Wednesday-17",
                "Wednesday-18",
                "Wednesday-19",

                "Thursday-08",
                "Thursday-13",
                "Thursday-19",

                "Friday-01",
                "Friday-13",
				"Friday-16",
				"Friday-17",
				"Friday-18",
                "Friday-19",
				"Friday-20",
				"Friday-21",
				"Friday-22",

                "Saturday-21",
                "Saturday-21",
                "Saturday-21",

                "Sunday-08",
                "Sunday-13",
                "Sunday-19"
                }
        }
		
		
-- Used only if needed for multiple worlds	
local function getPlayerWorldId(self)
    if not(self:isPlayer()) then
        return false
    end
	local pid = self:getId()
    local worldPlayer = 0
    local result_plr = db.storeQuery("SELECT * FROM `players` WHERE `id` = "..pid..";")
	local resultId = 0
    if(result_plr ~= false) then
        worldPlayer = result_plr.getDataInt(resultId, "world_id")
		result.free(result_plr)
        return worldPlayer
    end
    return false
end

local lottery = GlobalEvent("Lottery")
function lottery.onThink(interval, lastExecution)

-- Only start a next Lottery if players online
	local players = Game.getPlayers()

	if #players > 0 and #config.rewards_id > 0 then
	
		-- select one random player that is online
		local uid = math.random(1, #players)
		-- when crystals, whe randomize possible values inside crstal_counts table
		local crystalcount = config.crystal_counts[math.random(1, #config.crystal_counts)]
		
		-- Get Actual Minute and compare with globalStorage for the last Minute Random Time
		local MinutesNow = tonumber(os.date("%M"))
		local StorageMinute = tonumber(Game.getStorageValue(LOTTERY_STORAGE_MINUTE))
		local finished = tonumber(Game.getStorageValue(LOTTERY_STORAGE_FINISHED))
		local finishedHour = tonumber(Game.getStorageValue(LOTTERY_STORAGE_FINISHEDHOUR))
		
		-- verify if is set finishedHour
		if finishedHour == nil or finishedHour <= 0 then
			Game.setStorageValue(LOTTERY_STORAGE_FINISHEDHOUR, tonumber(os.date("%H")) - 1)
		end
		
		-- verify if is in time in Hour
		if table.find(config.days, os.date("%A-%H")) then
		
			--
			if finishedHour == tonumber(os.date("%H")) then
				--Spdlog.warn("[LOTTERY SYSTEM] - Already sorted hour. Waiting Next Hour.")
				return true		
			end
			-- CHECK IF MINUTE Random Exists if not, generate one (used for first time after startup)
			-- Possible change it to 
			if StorageMinute == nil or StorageMinute <= 0 then
				Game.setStorageValue(LOTTERY_STORAGE_MINUTE, tonumber(math.random(1,59)))
				StorageMinute = tonumber(Game.getStorageValue(LOTTERY_STORAGE_MINUTE))
				Spdlog.warn("[LOTTERY] - Next Minute Generated! " .. StorageMinute .. " Minute is the next Lottery.")
				return true
			end
		
			if not (StorageMinute == MinutesNow) then
				if MinutesNow >= StorageMinute then
					Game.setStorageValue(LOTTERY_STORAGE_FINISHEDHOUR, tonumber(os.date("%H")))
					--Spdlog.warn("[LOTTERY] - It's time but minute already passed.")
					return true
				end
				--Spdlog.warn("[LOTTERY] - It's time but not at minute yet.")
				return true	
			else		
				local query = db.query or db.executeQuery
				local random_item = config.rewards_id[math.random(1, #config.rewards_id)]
				local item = ItemType(random_item)
				local itemWeight = item:getWeight()
				local qntItem = 0

				if item:getId() == 3043 then 
					qntItem = crystalcount 
					itemWeight = item:getWeight() * crystalcount
				else 
					qntItem = 0 
				end
				
				local item_name = item:getName()
				local data = os.date("%d/%m/%Y - %H:%M:%S")
		   
				if uid and random_item and players[uid] then
					local winner = Player(players[uid])
					
					--[[
					--if winner:getAccountType() >= ACCOUNT_TYPE_GOD or uid == 1 or uid == 2 then
					if winner:getAccountType() >= ACCOUNT_TYPE_GOD then
						Spdlog.warn("[LOTTERY SYSTEM] - ADM selected, choosing another user.")
						local random2 = math.random(1, #players)
						winner = Player(players[random2])
						if winner:getAccountType() >= ACCOUNT_TYPE_GOD then
							Spdlog.warn("[LOTTERY SYSTEM] - ADM selected again, cancelling lottery.")
							Game.setStorageValue(LOTTERY_STORAGE_MINUTE, tonumber(math.random(1,59)))
							Game.setStorageValue(LOTTERY_STORAGE_FINISHEDHOUR, tonumber(os.date("%H")))
							return true
						end
					end
					]]--
				   
					if(random_item == 3043) then
						if winner:getFreeCapacity() > itemWeight or not(winner:addItem(random_item, qntItem) == RETURNVALUE_CONTAINERNOTENOUGHROOM) then
							winner:addItem(random_item, qntItem)
							Spdlog.info("[LOTTERY] Winner: " .. winner:getName() .. ", Reward: " .. crystalcount .."x " .. item:getPluralName() .. " ! Congratulations!")
							--Game.broadcastMessage("[LOTTERY] Winner: " .. winner:getName() .. ", Reward: " .. crystalcount .."x " .. item:getPluralName() .. " ! Congratulations!", MESSAGE_GAME_HIGHLIGHT) 
							Game.broadcastMessage(string.format("{%d|%s} The winner is %s ! He had won {%d|%d}x %s. Congratulations!", MESSAGE_COLOR_YELLOW, "[LOTTERY]", winner:getName(), MESSAGE_COLOR_YELLOW, crystalcount, item:getPluralName()), MESSAGE_LOOT)
							query("INSERT INTO `lottery` (`name`, `item`, `qnt`, `item_name`, `date`) VALUES ('".. winner:getName() .."', '".. random_item .."', '"..qntItem.. "', '".. item_name .."', '".. data .."');")
						else
							sendMailbox(winner:getId(), random_item, qntItem)
							--winner:addItem(random_item, qntItem)
							Spdlog.info("[LOTTERY] Winner: " .. winner:getName() .. ", Reward: " .. crystalcount .."x " .. item:getPluralName() .. " ! Congratulations!")
							--Game.broadcastMessage("[LOTTERY] Winner: " .. winner:getName() .. ", Reward: " .. crystalcount .."x " .. item:getPluralName() .. " ! Congratulations!", MESSAGE_GAME_HIGHLIGHT) 
							Game.broadcastMessage(string.format("{%d|%s} The winner is %s ! He had won {%d|%d}x %s. Congratulations!", MESSAGE_COLOR_YELLOW, "[LOTTERY]", winner:getName(), MESSAGE_COLOR_YELLOW, crystalcount, item:getPluralName()), MESSAGE_LOOT)
							query("INSERT INTO `lottery` (`name`, `item`, `qnt`, `item_name`, `date`) VALUES ('".. winner:getName() .."', '".. random_item .."', '"..qntItem.. "', '".. item_name .."', '".. data .."');")
						end
					else
						if winner:getFreeCapacity() > itemWeight or not(winner:addItem(random_item, qntItem) == RETURNVALUE_CONTAINERNOTENOUGHROOM) then
							winner:addItem(random_item, qntItem)
							Spdlog.info("[LOTTERY] Winner: " .. winner:getName() .. ", Reward: " .. item:getName() .. "! Congratulations!")
							--Game.broadcastMessage("[LOTTERY] Winner: " .. winner:getName() .. ", Reward: " .. item:getName() .. "! Congratulations!")
							Game.broadcastMessage(string.format("{%d|%s} The winner is %s ! He had won {%d|%s}. Congratulations!", MESSAGE_COLOR_YELLOW, "[LOTTERY]", winner:getName(), MESSAGE_COLOR_YELLOW, item:getName()), MESSAGE_LOOT)
							query("INSERT INTO `lottery` (`name`, `item`, `qnt`, `item_name`, `date`) VALUES ('".. winner:getName() .."', '".. random_item .."', '1', '".. item_name .."', '".. data .."');")
						else
							sendMailbox(winner:getId(), random_item, qntItem)
							--winner:addItem(random_item, qntItem)
							Spdlog.info("[LOTTERY] Winner: " .. winner:getName() .. ", Reward: " .. item:getName() .. "! Congratulations!")
							--Game.broadcastMessage("[LOTTERY] Winner: " .. winner:getName() .. ", Reward: " .. item:getName() .. "! Congratulations!")
							Game.broadcastMessage(string.format("{%d|%s} The winner is %s ! He had won {%d|%s}. Congratulations!", MESSAGE_COLOR_YELLOW, "[LOTTERY]", winner:getName(), MESSAGE_COLOR_YELLOW, item:getName()), MESSAGE_LOOT)
							query("INSERT INTO `lottery` (`name`, `item`, `qnt`, `item_name`, `date`) VALUES ('".. winner:getName() .."', '".. random_item .."', '1', '".. item_name .."', '".. data .."');")
						end
					end
				else
					Spdlog.info("[LOTTERY] - No Players Online. Skipping.")
				end
				-- GENERATE NEXT RANDOM MINUTE
				Game.setStorageValue(LOTTERY_STORAGE_MINUTE, tonumber(math.random(1,59)))
				Game.setStorageValue(LOTTERY_STORAGE_FINISHEDHOUR, tonumber(os.date("%H")))
				--Spdlog.warn("[LOTTERY SYSTEM] - Next Minute Generated! XX:" .. tonumber(Game.getStorageValue(LOTTERY_STORAGE_MINUTE)) .. " is the next Lottery.")
			end
		end
	else
		-- No players online, so generate next Minute and set Actual Hour as Completed.
		--Game.setStorageValue(LOTTERY_STORAGE_MINUTE, tonumber(math.random(1,59)))
		--Game.setStorageValue(LOTTERY_STORAGE_FINISHEDHOUR, tonumber(os.date("%H")) - 1)
		--Spdlog.info("[LOTTERY SYSTEM] - No Players Online. Next Lottery at "..tonumber(Game.getStorageValue(LOTTERY_STORAGE_MINUTE)).. " minutes. Actual Hour of Lottery: "..tonumber(Game.getStorageValue(LOTTERY_STORAGE_FINISHEDHOUR)))
	end
return true
end

lottery:interval(60000) --1 minutes
lottery:register()