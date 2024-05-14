local config = {
	join = {
		minPlayers = 1, -- Minimum amount of players to join
		minLevel = 100, -- Minium level to join
	},

	gate = {
		{position = Position(1337, 1279, 7), itemId = 11567}, -- Gates
		{position = Position(1337, 1280, 7), itemId = 11567},
		{position = Position(1337, 1281, 7), itemId = 11567}, 
		{position = Position(1337, 1282, 7), itemId = 11567}, 
		{position = Position(1337, 1283, 7), itemId = 11567}, 
		{position = Position(1337, 1284, 7), itemId = 11567}, 
		
		{position = Position(1339, 1279, 7), itemId = 11567}, 
		{position = Position(1339, 1280, 7), itemId = 11567},
		{position = Position(1339, 1281, 7), itemId = 11567},
		{position = Position(1339, 1282, 7), itemId = 11567},
		{position = Position(1339, 1283, 7), itemId = 11567},
		{position = Position(1339, 1284, 7), itemId = 11567},
	},
	
	positions = {
		inside = { -- Castle Positions
			{fromPosition = Position(1284, 1214, 7), toPosition = Position(1417, 1323, 7)},
			{fromPosition = Position(1284, 1214, 6), toPosition = Position(1417, 1323, 6)},
			{fromPosition = Position(1284, 1214, 5), toPosition = Position(1417, 1323, 5)},
			{fromPosition = Position(1284, 1214, 4), toPosition = Position(1417, 1323, 4)},
		},
		
		entrancePosition = Position(1300, 1280, 6),

		exitPosition = Position(32369, 32241, 7), -- Temple Position
	},

	throne = {
		position = Position(1384, 1272, 4), -- Throne Position
	},

	areasSpawns = {
		{fromPosition = Position(1340, 1265, 7), toPosition = Position(1399, 1307, 7)}, 
	},

	timeThroneTick = 1,
	normalPontuation = 10,
	lastPontuation = 100,
	centerPosition = Position(1366, 1282, 7), -- Castle Center

	open = {
		-- If you don't want Casle not to open someday, just take the opentimes number below, and add it to daysOff. Example {2, 4, 5}
		daysOff = {},
		opentimes = {
			[1] = "20:00:00", -- Sunday
			[2] = "20:00:00", -- Monday
			[3] = "20:00:00", -- Tuesday
			[4] = "20:00:00", -- Wednesday
			[5] = "20:00:00", -- Thursday
			[6] = "20:00:00", -- Friday
			[7] = "20:00:00", -- Saturday
		},
		closein = 60, 
	},
}

if not Castle then
	Castle = { 
		guildsInside = { },
		dominateGuild = nil,
		thronePoints = 0,
		opened = true,
		pontuacao = 0,
		nextTick = 0,
		timeCastleOpen = 0,
		timeToClose = 0,
		daysOff = config.open.daysOff,
	}
end

function getTimeDiff(a, b)
	local ah, am, as = a:match("(%d+):(%d+):(%d+)")
	ah, am, as = tonumber(ah), tonumber(am), tonumber(as)
	local bh, bm, bs = b:match("(%d+):(%d+):(%d+)")
	bh, bm, bs = tonumber(bh), tonumber(bm), tonumber(bs)

	local atotal = ah * 60 * 60 + am * 60 + as
	local btotal = bh * 60 * 60 + bm * 60 + bs

	return btotal - atotal
end

function Castle.load(self)
	local day, now = os.date("%w") + 1, os.date("%H:%M:%S")
	local diff = 0	
	if now >= config.open.opentimes[day] then
		day = day % 7 + 1
		diff = diff + 24 * 60 * 60
	end		
	diff = diff + getTimeDiff(now, config.open.opentimes[day])

	safeAddEvent(function(self) self:open() end, 1 * 1000, self)

	if not self.dominateGuild then
		local resultId = db.storeQuery("SELECT `guild_id` FROM `castle_war` WHERE `active` = 1")
		if resultId then
			local guildId = result.getNumber(resultId, "guild_id")
			result.free(resultId)

			self.dominateGuild = guildId
			self:removePlayersFromCastleAreas()
		end
	end
end

function Castle.isOpen(self)
	return self.opened
end

function Castle.DominanteGuild(self)
	local resultId = db.storeQuery("SELECT `guild_id` FROM `castle_war` WHERE `active` = 1")
	if resultId then
		local guildId = result.getNumber(resultId, "guild_id")
		result.free(resultId)
		return resultId
	end
	
	return nil
end

function Castle.open(self)
  	if isInArray(config.open.daysOff, os.date("%w") + 1) then
        local day, now = os.date("%w") + 1, os.date("%H:%M:%S")		
        local diff = 0
        day = day % 7 + 1
        diff = diff + 24 * 60 * 60
		diff = diff + getTimeDiff(now, config.open.opentimes[day])
		safeAddEvent(function(self) self:open() end, 1 * 1000, self)
        return true
	end
	
	if self.opened then
		return 
	end

	Game.broadcastMessage(string.format("[Castle War] The castle has been opened and will close in %d minutes.", config.open.closein), MESSAGE_GAME_HIGHLIGHT)
	
	safeAddEvent(function(self) self:close() end, config.open.closein * 60 * 1000, self)
	self.opened = true	
	self.timeToClose = os.time() + (config.open.closein * 60)
	self:gate()

	-- Chamar a fun��o do trono
	self.pontuacao = config.normalPontuation
	safeAddEvent(function(self) self:throne() end, config.timeThroneTick * 60 * 1000, self)

	self.nextTick = os.time() + (config.timeThroneTick * 60)
end

function Castle.throne(self)
	if not self.opened then
		return
	end

	self.timeCastleOpen = self.timeCastleOpen + config.timeThroneTick
	self.nextTick = os.time() + (config.timeThroneTick * 60)

	safeAddEvent(function(self) self:throne() end, config.timeThroneTick * 60 * 1000, self)

	local tile = Tile(config.throne.position)
	if not tile then 
		return 
	end

	local playerTile = tile:getTopCreature()
	if not playerTile then
		return
	end
	
	local guild = playerTile:getGuild()
	if not guild then
		playerTile:teleportTo(config.positions.exitPosition)
		playerTile:sendTextMessage(MESSAGE_OFFLINE_TRAINING, "How did you get in here? It wasn't even supposed to be here.")
		return 
	end

	local guildId = guild:getId()
	local insideGuild = self.guildsInside[guildId]
	if not insideGuild then
		self.guildsInside[guildId] = {
			name = guild:getName(),
			thronePoints = 0
		}

		insideGuild = self.guildsInside[guildId]
	end

	local dominant = self:getDominantGuild()
	if dominant then
		if dominant == guild then
			playerTile:say("Dominant Guild!", TALKTYPE_MONSTER_SAY)
		end
	end

	self.guildsInside[guildId].thronePoints = self.guildsInside[guildId].thronePoints + self.pontuacao
	local thronePoints = self.guildsInside[guildId].thronePoints
	if (thronePoints ~= 0 and self.pontuacao ~= config.lastPontuation) then
		local broadcastMessage = string.format("[Castle War] - The guild %s is on top of the throne! Score: %d", insideGuild.name, thronePoints)

		Game.broadcastMessage(broadcastMessage, MESSAGE_GAME_HIGHLIGHT)
	end
	
	if self.pontuacao ~= config.lastPontuation then
		if self.timeCastleOpen == config.open.closein - config.timeThroneTick then
			self.pontuacao = config.lastPontuation
		end
	end
	
	if thronePoints >= config.lastPontuation then
		self:dominate()
		self:finish()
		self:gate()
		self:removePlayersFromCastleAreas()
		local dominant = self:getDominantGuild()
		Game.broadcastMessage(string.format("[Castle War]: The castle was closed %s", dominant and ("and the guild that dominates is " .. dominant:getName() .. ".") or ''), MESSAGE_GAME_HIGHLIGHT)
	end

	return true
end

function Castle.close(self)
	if not self.opened then
		return
	end

	-- Fecha o castelo
	local day, now = os.date("%w") + 1, os.date("%H:%M:%S")
	local diff = 0
	if now >= config.open.opentimes[day] then
		day = day % 7 + 1
		diff = diff + 24 * 60 * 60
	end

	diff = diff + getTimeDiff(now, config.open.opentimes[day])

	self:throne(true)

	self:dominate()
	self:finish()
	self:gate()
	self:removePlayersFromCastleAreas()
	local dominant = self:getDominantGuild()
	Game.broadcastMessage(string.format("[Castle War]: The castle was closed %s", dominant and ("and the guild that dominates is " .. dominant:getName() .. ".") or ''), MESSAGE_GAME_HIGHLIGHT)
end

function Castle.dominate(self)
	local guilds = self:getGuildsPointsHighscore()
	local winnerGuild = guilds[1]
	if not winnerGuild then
		print("Castle War sem novo vencedor!")
		return true
	end

	local newDominantId = winnerGuild.guildId
	local newThronePoints = winnerGuild.thronePoints
	local newDominantName = winnerGuild.guildName

	if newDominantId ~= self.dominateGuild then
		db.query("UPDATE `castle_war` SET `active` = 0 WHERE `active` = 1")
		db.query(string.format('INSERT INTO `castle_war` (`guild_id`, `guild_name`, `timestamp`, `throne_points`, `active`) VALUES (%d, %s, %d, %d, %d)', newDominantId, db.escapeString(newDominantName), os.time(), newThronePoints, 1))

		Game.broadcastMessage(string.format('[Castle War] - The guild that dominates the Castle War is the %s!', newDominantName), MESSAGE_GAME_HIGHLIGHT)

		self.dominateGuild = newDominantId
	elseif newDominantId == self.dominateGuild then
		Game.broadcastMessage(string.format('[Castle War] - The guild %s continues the owner of the Castle!', self:getDominantName()), MESSAGE_GAME_HIGHLIGHT)
	end

	local guildsPoints = self:getGuildsPointsHighscore()
	local str = ''
	for i, info in ipairs(guildsPoints) do
		if i >= 4 then
			break
		end

		local thronePoints = info.thronePoints
		local tmpGuild = Guild(info.guildId)
		if tmpGuild then
			str = string.format('%s%s - Points: %d\n', str, info.guildName, thronePoints)
		end
	end

	for _, tmpPlayer in ipairs(Game.getPlayers()) do
		for _, tmpPlayer in ipairs(Game.getPlayers()) do
			for _, area in pairs(config.areasSpawns) do				
				if (isInRange(tmpPlayer:getPosition(), area.fromPosition, area.toPosition)) then
				
					local guild = tmpPlayer:getGuild()
					if guild and self.dominateGuild ~= guild then
						local safePosition = tmpPlayer:getTown():getTemplePosition()
						tmpPlayer:teleportTo(safePosition)
					end
				end
			end
		end			
	end

	if str ~= '' then
		local playersCastle = self:playersInCastle()
		for _, tmpPlayer in ipairs(playersCastle) do
			tmpPlayer:sendTextMessage(MESSAGE_EVENT_ORANGE, string.format('Castle Score:\n%s', str))
		end
	end
end

function Castle.playersInCastleGuild(self, guildIdDominant)
	local ret = { }
	for _, tmpPlayer in ipairs(Game.getPlayers()) do
		local guild = tmpPlayer:getGuild()
		if guild then
			local guildId = guild:getId()	
			for _, area in pairs(config.positions.inside) do		
				if (isInRange(tmpPlayer:getPosition(), area.fromPosition, area.toPosition)) then
					if guildId == guildIdDominant then
						table.insert(ret, tmpPlayer)
					end
				end
			end
		end
	end

	return ret
end

function Castle.playersInCastle(self)
	local ret = { }
	for _, tmpPlayer in ipairs(Game.getPlayers()) do	
		for _, area in pairs(config.positions.inside) do		
			if (isInRange(tmpPlayer:getPosition(), area.fromPosition, area.toPosition)) then		
				table.insert(ret, tmpPlayer)
			end
		end
	end

	return ret
end

function Castle.gate(self)
	for _, gate in pairs(config.gate) do
		local wallItem = Tile(gate.position):getItemById(gate.itemId)
		if wallItem then
			wallItem:remove()
			gate.position:sendMagicEffect(CONST_ME_POFF)
		else
			Game.createItem(gate.itemId, 1, gate.position)
		end
	end
end

function Castle.playerIsInCastle(self, player)
	local playersCastle = self:playersInCastle()
	if next(playersCastle) ~= nil then
		for i = 1, #playersCastle do
			local tmpPlayer = playersCastle[i]
			if tmpPlayer == player then
				return true
			end
		end
	end

	return false
end

function Castle.finish(self)
	if not self.opened then
		return
	end

	local playersCastle = self:playersInCastle()
	if next(playersCastle) ~= nil then
		for i = 1, #playersCastle do
			local player = playersCastle[i]
			if player then
				player:teleportTo(config.positions.exitPosition)
				player:sendTextMessage(MESSAGE_EVENT_ORANGE, "[Castle War] The castle was closed and you were teleported to Thais.")
			end
		end
	end

	Game.broadcastMessage("[Castle War] The castle was closed.", MESSAGE_GAME_HIGHLIGHT)

	self.guildsInside = { }
	self.opened = false
	self.timeToClose = 0
	self.pontuacao = 0
	self.nextTick = 0
	self.timeCastleOpen = 0
end

function Castle.getDominanteNameLogin()
	local query = db.storeQuery("SELECT `guild_name` FROM `castle_war` WHERE `active` = 1")
	if query then
		local guildId = result.getString(query, "guild_name")
		result.free(query)
		return guildId
	end
	
	return "Nenhuma"
end

function Castle.getDominantName(self)
	local dominant = self:getDominantGuild()
	if dominant then
		return dominant:getName()
	end

	return ''
end

function Castle.getDominantGuild(self)
	if not self.dominateGuild then
		return nil
	end

	local dominant = Guild(self.dominateGuild)
	if not dominant then
		return nil
	end

	return dominant
end

function Castle.isGuildInside(self, guild)
	if not guild then
		return false
	end

	local guilId = guild:getId()
	if not self.guildsInside[guildId] then
		return false
	end

	return true
end

function Castle.dominanteName(self)
	local dominant = self:getDominantGuild()
	if not dominant then
		return false
	end

	return dominant:getName()
end

function Castle.entraceCastle(self, playerId)
	local player = Player(playerId)
	if not player then
		return false
	end

	local guild = player:getGuild()
	local dominant = self:getDominantGuild()
	if not guild then
		player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, "You cannot enter Castle War without a Guild.")
		return false
	end

	local checkToEnter = true
	if dominant and guild == dominant then
		checkToEnter = false
	end

	local minLevel = config.join.minLevel
	if (player:getLevel() < minLevel) then
		player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, string.format('You need to be at least level %d to join the Castle War.', minLevel))
		return false
	end
	
	if checkToEnter then
		if not self.opened then
			player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, "The Castle is currently closed to raids.")
			return false
		end

		local membersOnline = guild:getMembersOnline()
		if (#membersOnline < config.join.minPlayers) then
			player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, string.format('You need to have %d online members in your Guild. Currently only owns %d.', config.join.minPlayers, #membersOnline))
			return false
		end

		local avaiableMembersToEnter = 0
		for i = 1, #membersOnline do
			local member = membersOnline[i]
			if (avaiableMembersToEnter >= config.join.minPlayers) then
				break
			end

			if (member:getLevel() >= minLevel) then
				avaiableMembersToEnter = avaiableMembersToEnter + 1
			end
		end

		if (avaiableMembersToEnter < config.join.minPlayers) then	
			player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, string.format('Your guild needs to have %d members online in your Guild above level %d. Currently only owns %d.', config.join.minPlayers, minLevel, avaiableMembersToEnter))
			return false
		end

		local guildId = guild:getId()
		if not self.guildsInside[guildId] then
			self.guildsInside[guildId] = {
				name = guild:getName(),
				thronePoints = 0
			}
		end
	end

	return true
end

function Castle.getGuildsPointsHighscore(self)
	local t = { }
	for guildId, info in pairs(self.guildsInside) do
		t[#t + 1] = {guildId = guildId, thronePoints = info.thronePoints, guildName = info.name}
	end

	table.sort(t, function(lhs, rhs) return lhs.thronePoints > rhs.thronePoints end)
	return t
end

function Castle.onTalkaction(self, player)
	if not self:isOpen() then
		player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, "Castle War is currently closed.")
		return false
	end

	if not next(self.guildsInside) then
		player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, "Currently no Guild has entered the Castle War yet.")
		return false
	end

	local nextTick = self.nextTick - os.time()
	local nextPontuacao =  self.pontuacao
	local timeToClose = self.timeToClose - os.time()

	local str = string.format('%s left for the next throne score, and will give %d point%s. The castle will close in %s.\nGuilds within Castle War are:\n', showTimeLeft(nextTick, true), nextPontuacao, nextPontuacao ~= 1 and 's' or '', showTimeLeft(timeToClose, true))
	
	local guildsPoints = self:getGuildsPointsHighscore()
	local playersCastle = self:playersInCastle()
	
	for i, info in pairs(guildsPoints) do
		local thronePoints = info.thronePoints
		local tmpGuild = Guild(info.guildId)
		if tmpGuild then
			local membersInCastle = { }
			for _, tmpPlayer in ipairs(playersCastle) do
				local hasGuild = tmpPlayer:getGuild()
				if hasGuild then
					if hasGuild == tmpGuild then
						if not isInArray(membersInCastle, tmpPlayer:getId()) then
							table.insert(membersInCastle, tmpPlayer:getId())
						end
					end
				end
			end

			str = string.format('%s- %s [Points: %d - Members in the Castle: %d]\n', str, info.guildName, thronePoints, #membersInCastle)
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ORANGE, str)
	return false
end

function Castle.removePlayersFromCastleAreas(self)
	local dominant = self:getDominantGuild()
	for _, tmpPlayer in pairs(Game.getPlayers()) do
		for _, area in pairs(config.areasSpawns) do				
			if (isInRange(tmpPlayer:getPosition(), area.fromPosition, area.toPosition)) then
				local guild = tmpPlayer:getGuild()
				local sendTemple = false
				if guild and dominant then
					if guild:getId() == dominant:getId() then
						sendTemple = false
					else
						sendTemple = true
					end
				else
					sendTemple = true
				end
				
				if sendTemple then
					local templePosition = tmpPlayer:getTown():getTemplePosition()
					tmpPlayer:teleportTo(templePosition)
					templePosition:sendMagicEffect(CONST_ME_TELEPORT, tmpPlayer)
					break
				end
			end
		end
	end

	safeAddEvent(function(self) self:removePlayersFromCastleAreas() end, 30000, self)
end

