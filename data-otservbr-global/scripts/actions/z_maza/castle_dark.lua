-- config
local castle_dark = {}

local config  = {
	castle_darkName = "Castle",
	startTime = '20:30:00', -- Hours:minutes:seconds
	levelToEnter = 300,
	
	-- tp
	teleportSpawnPosition = Position(1062, 1007, 7),
	tpDentroCastle = Position(34211, 30794, 6),
	teleportId = 1949,
	teleportUniqueId = 56820,
	kickCastle = Position(1062, 1017, 7),
}




-- config end

castle_dark.closeEvent = function(self)

		-- remove tp
		Tile(config.teleportSpawnPosition):getItemById(config.teleportId):remove() 
		
		-- // limpeza do castle_dark
		addEvent(clearPlayers, 0, Position(34194, 30727, 1), Position(34328, 30835, 1), config.kickCastle)
		addEvent(clearPlayers, 0, Position(34194, 30727, 2), Position(34328, 30835, 2), config.kickCastle)
		addEvent(clearPlayers, 0, Position(34194, 30727, 3), Position(34328, 30835, 3), config.kickCastle)
		addEvent(clearPlayers, 0, Position(34194, 30727, 4), Position(34328, 30835, 4), config.kickCastle)
		addEvent(clearPlayers, 0, Position(34194, 30727, 5), Position(34328, 30835, 5), config.kickCastle)
		addEvent(clearPlayers, 0, Position(34194, 30727, 6), Position(34328, 30835, 6), config.kickCastle)
		addEvent(clearPlayers, 0, Position(34194, 30727, 7), Position(34328, 30835, 7), config.kickCastle)
	
end

castle_dark.initEvent = function(self)

	addEvent(function() 
			Game.broadcastMessage("[EVENT] The ".. config.castle_darkName .." will open in 60 seconds.", MESSAGE_STATUS_WARNING)
		end, 1000)
		
		addEvent(function() 
			Game.broadcastMessage("[EVENT] The ".. config.castle_darkName .." will open in 50 seconds.", MESSAGE_STATUS_WARNING)
		end, 10000)
		
		addEvent(function() 
			Game.broadcastMessage("[EVENT] The ".. config.castle_darkName .." will open in 40 seconds.", MESSAGE_STATUS_WARNING)
		end, 20000)
		
		addEvent(function() 
			Game.broadcastMessage("[EVENT] The ".. config.castle_darkName .." will open in 30 seconds.", MESSAGE_STATUS_WARNING)
		end, 30000)
		
		addEvent(function() 
			Game.broadcastMessage("[EVENT] The ".. config.castle_darkName .." will open in 20 seconds.", MESSAGE_STATUS_WARNING)
		end, 40000)
		
		addEvent(function() 
			Game.broadcastMessage("[EVENT] The ".. config.castle_darkName .." will open in 10 seconds.", MESSAGE_STATUS_WARNING)
		end, 50000)
		
		addEvent(function()
			Game.broadcastMessage("[EVENT] The ".. config.castle_darkName .." opened, 1 hora open!", MESSAGE_STATUS_WARNING)
			
			-- criar tp
			local teleportItem = Game.createItem(config.teleportId, 1, config.teleportSpawnPosition)
			teleportItem:setActionId(config.teleportUniqueId)
			Teleport(teleportItem.uid):setDestination(config.tpDentroCastle)
		end, 60000)
		
		addEvent(function()
			Game.broadcastMessage("[EVENT] The ".. config.castle_darkName .." closed!", MESSAGE_STATUS_WARNING)
			castle_dark:closeEvent()
		end, 3600000) -- 1 hora
end

local castleDarkStart = TalkAction("/startCastle")

function castleDarkStart.onSay(player, words, param)
	if not player:getGroup():getAccess() then return true end
    if player:getAccountType() < ACCOUNT_TYPE_GOD then return false end	castle_dark.initEvent() return true end
castleDarkStart:register()

--globalevents
local iniciarcastle_dark = GlobalEvent('castle_darkStart')
function iniciarcastle_dark.onTime(interval)
    castle_dark:initEvent()
    return true
end
iniciarcastle_dark:time(config.startTime)
iniciarcastle_dark:register()

-- movements
local entercastle_dark = MoveEvent('entercastle_dark')
function entercastle_dark.onStepIn(player, item, position, fromPosition)
	
	if not player:getGuild() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao tem guild!")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(fromPosition)
		return false
	end
	if player:getLevel() < levelToEnter then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao tem level " .. config.levelToEnter .. "+!")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(fromPosition)
		return false
	end
	
    if not item:getId() == config.teleportId then
        return true
    end
	
    Game.broadcastMessage(player:getName() .. ' entrou no ' .. config.castle_darkName, MESSAGE_ADMINISTRADOR)
    return true
end
entercastle_dark:uid(config.teleportUniqueId)
entercastle_dark:register()

-- action
local castle_darkAction = Action()

function castle_darkAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if not player:getGuild() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao tem guild!")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	
	local storageWait = 23565
	
	if player:getStorageValue(storageWait) >= os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Espere para clicar novamente!")
		return false
	end
	
	player:setStorageValue(storageWait, os.time() + 5)
	
	local resultGuildDark = db.storeQuery("SELECT `guild` FROM `castle_dark` order by `data` desc limit 1")
	local guildNameDark = result.getString(resultGuildDark, "guild")
	if guildNameDark == player:getGuild():getName() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja e dono do castle!")
		return false
	end
	
	
	local name = player:getName()
	local guild = player:getGuild() 
    local guildname = guild:getName()    

	local data = os.date()

	if not guild then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao tem guild!")
		return false
	end	
		
		-- item:remove(1)
		Game.broadcastMessage(' O player ' .. name .. ' da guild ' .. guildname .. ', ganhou o ' .. config.castle_darkName ..'! Horario: ' .. data .. '.', MESSAGE_ADMINISTRADOR)
		db.query('TRUNCATE table `castle_dark`')

		
		player:getPosition():sendMagicEffect(7)
		
		db.query("INSERT INTO `castle_dark` (`name`, `guild`, `data`) VALUES ('" .. name .. "', '" .. guildname .."', '" .. data .."');")
		
	return true
end

castle_darkAction:uid(56821)
castle_darkAction:register()


-- movement
local castleMoveHunt = MoveEvent()
function castleMoveHunt.onStepIn(creature, item, position, fromPosition)

	local player = creature:getPlayer()
	
	if not player:getGuild() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao tem guild!")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(fromPosition)
		return false
	end

	local resultGuild = db.storeQuery("SELECT `guild` FROM `castle_dark` order by `data` desc limit 1")
    if resultGuild ~= false then

    local guildName2 = result.getString(resultGuild, "guild")
	result.free(resultGuild)

	local guild = player:getGuild() 
    local guildname = guild:getName()


	if not nil and guildName2 ~= guildname then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Apenas membros da guild dona do castle podem passar!")
		player:teleportTo(fromPosition)
	end

	return guildName2
    end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Castle nao foi dominado ainda!")
		player:teleportTo(fromPosition)
	return true
end

castleMoveHunt:type("stepin")
castleMoveHunt:aid(56831)
castleMoveHunt:register()


-- movement check guild
local castleMoveCheck = MoveEvent()
function castleMoveCheck.onStepIn(creature, item, position, fromPosition)

	local player = creature:getPlayer()
	
	if not player:getGuild() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao tem guild!")
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(config.kickCastle)
		return false
	end
end

castleMoveCheck:type("stepin")
castleMoveCheck:aid(56832)
castleMoveCheck:register()