MONSTER_HUNT = {
	list = {"demon", "grim reaper", "rotworm", "dragon", "cyclops"},
	days = {--Day-Hour

                "Monday-10",
				"Monday-22",

				"Wednesday-10",
				"Wednesday-22",

				"Thursday-11",
				"Thursday-22",

				"Friday-10", 
				"Friday-22",
				
				"Saturday-10",
				"Saturday-22",
				
				"Sunday-11",
				"Sunday-22",
	},
	messages = {
		prefix = "[Monster Hunt] ",
		warnInit1 = "The event will start in %d minute%s. Your objective is to kill the selected creature as much as possible.",
		warnInit2 = "The event will start in %d minute%s.",
		init = "The chosen creature is %s. You have 1 hour to kill as much as you can! Enjoy!",
		warnEnd = "Lasting %d minute%s to end the event. Hurry up!",
		final = "The player %s won the event! Congratulations!!",
		noWinner = "There was no winner at this moment.",
		noWinnerOnline = "The winner was offline! No winners online, better luck next time!",
		noWinnerOnline2 = "The winner was offline! Second place received the reward!",
		reward = "You received your reward!",
		tournaments_reward = "You received transferable coins!",
		kill = "You already killed {%d} %s.",
	},
	rewards = {
		{id = 3043, count = 100},
	},
	storages = {
		monster = 891641,
		player = 891642,
		started = 891643,
		killer = 891644,
	},
	players = { },
}

function MONSTER_HUNT:initEvent()


	-- SET STORAGE OF ONLINE PLAYERS TO 0
	local players = Game.getPlayers()
	if #players > 0 then

		for i = 1, #players do
			local player = Player(players[i])
			player:setStorageValue(MONSTER_HUNT.storages.player, 0)
			player:setStorageValue(MONSTER_HUNT.storages.killer, 0)
		end
	
	end
	
	-- ADD QUERY TO SET 0 
	db.query(string.format("UPDATE `player_storage` SET `value` = %d WHERE `key` = %d", 0, MONSTER_HUNT.storages.player))
	db.query(string.format("UPDATE `player_storage` SET `value` = %d WHERE `key` = %d", 0, MONSTER_HUNT.storages.killer))
	
	Game.setStorageValue(MONSTER_HUNT.storages.monster, 0)
	Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.warnInit1:format(5, "s"))
	addEvent(function()
		Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.warnInit2:format(3, "s"))
	end, 2 * 60 * 1000)
	addEvent(function()
		Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.warnInit2:format(1, ""))
	end, 4 * 60 * 1000)
	addEvent(function()
		local rand = math.random(#MONSTER_HUNT.list)
		Game.setStorageValue(MONSTER_HUNT.storages.monster, rand)
		Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.init:format(MONSTER_HUNT.list[rand]))
	end, 5 * 60 * 1000)
	
	-- FINALIZAR EVENTO 
	
	addEvent(function()
		MONSTER_HUNT:endEvent()
	end, 55 * 60 * 1000)
	-- change 5 * 60 * 100 to 55 (to run by 1 hour)
	
	return true
end

function MONSTER_HUNT:endEvent()
	Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.warnEnd:format(5, "s"))
	addEvent(function()
		Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.warnEnd:format(3, "s"))
	end, 2 * 60 * 1000)
	addEvent(function()
		Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.warnEnd:format(1, ""))
	end, 4 * 60 * 1000)
	addEvent(function()
		if #MONSTER_HUNT.players == nil or #MONSTER_HUNT.players <= 0 then
			Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.noWinner)
				-- ADD QUERY TO SET 0 
			db.query(string.format("UPDATE `player_storage` SET `value` = %d WHERE `key` = %d", -1, MONSTER_HUNT.storages.player))
			db.query(string.format("UPDATE `player_storage` SET `value` = %d WHERE `key` = %d", -1, MONSTER_HUNT.storages.killer))
			-- RESTART AND RESET STARTED STORAGE
			Game.setStorageValue(MONSTER_HUNT.storages.monster, -1)
			Game.setStorageValue(MONSTER_HUNT.storages.started, -1)

			Spdlog.info("[HUNT EVENT] - Ended Hunt Event!")
			return true
		end
		table.sort(MONSTER_HUNT.players, function(a,b) return a[2] > b[2] end)

		local player = Player(MONSTER_HUNT.players[1][1])
		if player then
			Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.final:format(player:getName()))
			player:setStorageValue(MONSTER_HUNT.storages.player, -1)
			
			if player:addTransferableCoins(300) then
				player:getPosition():sendMagicEffect(30)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.tournaments_reward)
				db.query(string.format("INSERT INTO `store_history`(`account_id`, `mode`, `description`, `coin_type`, `coin_amount`, `time`) VALUES (%s, %s, %s, %s, %s, %s)", player:getAccountId(), "0", db.escapeString("[Monster Hunt] - Winner"), "1", "300", os.time()))
			end
		else
			Game.broadcastMessage(MONSTER_HUNT.messages.prefix .. MONSTER_HUNT.messages.noWinnerOnline)
		end
		for a, b in pairs(MONSTER_HUNT.players) do
			local player = Player(b[1])
			if player then
				player:setStorageValue(MONSTER_HUNT.storages.player, -1)
				player:setStorageValue(MONSTER_HUNT.storages.killer, -1)
				MONSTER_HUNT.players[a] = nil
			end
		end
		-- ADD QUERY TO SET 0 
		db.query(string.format("UPDATE `player_storage` SET `value` = %d WHERE `key` = %d", -1, MONSTER_HUNT.storages.player))
		db.query(string.format("UPDATE `player_storage` SET `value` = %d WHERE `key` = %d", -1, MONSTER_HUNT.storages.killer))
		
		-- RESTART AND RESET STARTED STORAGE
		Game.setStorageValue(MONSTER_HUNT.storages.monster, -1)
		Game.setStorageValue(MONSTER_HUNT.storages.started, -1)
		Spdlog.info("[HUNT EVENT] - Ended Hunt Event!")
	end, 5 * 60 * 1000)
	return true
end