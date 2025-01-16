function startGame(rounds)
	if rounds == 0 then
		if #CACHE_GAMEPLAYERS < SnowBallConfig.Event_MinPlayers then
			for _, p in ipairs(CACHE_GAMEPLAYERS) do
				Player(p):teleportTo(Player(p):getTown():getTemplePosition())
			end
			broadcastMessage("[Snowball Event]: The event was canceled due to not having at least " .. SnowBallConfig.Event_MinPlayers .. " players.", MESSAGE_EVENT_ADVANCE)
		else
			for _, p in ipairs(CACHE_GAMEPLAYERS) do
				Player(p):setStorageValue(SnowBallConfig.Storage.Value2, 0)
				Player(p):setStorageValue(SnowBallConfig.Storage.Value1, SnowBallConfig.Ammo_Configurations.Ammo_Start)
				Player(p):teleportTo(CACHE_GAMEAREAPOSITIONS[math.random(#CACHE_GAMEAREAPOSITIONS)])
			end
			broadcastMessage("[Snowball Event]: The event has closed. The game started.", MESSAGE_EVENT_ADVANCE)
			addEvent(Event_endGame, SnowBallConfig.Event_Duration * 60 * 1000)
		end

		Item(getTileItemById(SnowBallConfig.Area_Configurations.Position_EventTeleport, 1949).uid):remove(1)
		Item(getTileItemById(SnowBallConfig.Area_Configurations.Position_ExitWaitRoom, 1949).uid):remove(1)
		return true
	end

	if #CACHE_GAMEPLAYERS < SnowBallConfig.Event_MinPlayers then
		broadcastMessage("[Snowball Event]: Missing " .. rounds .. " minute(s) and " .. SnowBallConfig.Event_MinPlayers - #CACHE_GAMEPLAYERS .. " player(s) for the game start.", MESSAGE_EVENT_ADVANCE)
	else
		broadcastMessage("[Snowball Event]: Missing " .. rounds .. " minute(s) for the game start.", MESSAGE_EVENT_ADVANCE)
	end
	return addEvent(startGame, 60 * 1000, rounds - 1)
end

local snowball = GlobalEvent("Snowball")
function snowball.onTime(interval)
	if not SnowBallConfig.Event_Days[os.date("%w") + 1] then
		return true
	end

	CACHE_GAMEPLAYERS = {}

	local EventTeleport = Game.createItem(1949, 1, SnowBallConfig.Area_Configurations.Position_EventTeleport)
	EventTeleport:setActionId(10101)

	local ExitWaitRoom = Game.createItem(1949, 1, SnowBallConfig.Area_Configurations.Position_ExitWaitRoom)
	ExitWaitRoom:setActionId(10102)

	broadcastMessage("[Snowball Event]: The event has opened, go to the teleport in the temple of Thais to participate.", MESSAGE_EVENT_ADVANCE)
	addEvent(startGame, 60 * 1000, SnowBallConfig.Event_WaitGame)

	return true
end

snowball:time("02:20")
snowball:time("05:20")
snowball:time("08:20")
snowball:time("11:20")
snowball:time("14:20")
snowball:time("17:20")
snowball:time("20:20")
snowball:time("00:50")
snowball:register()
