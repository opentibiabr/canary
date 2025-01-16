local battlefield = {
	config = {
		storage = GlobalStorage.BattleEventMapLoaded,
		totalPlayers = 50,
		minPlayers = 2,
		enableMC = true,
		started = false,
		warning = 0,
		timeToStart = 1, -- In minutes
		minutesToEnd = 30, -- In minutes
		portalId = 25053,
		portalPosition = Position(32342, 32220, 7),
		endPosition = Position(32345, 32222, 7),
		winnerItemId = ITEM_TABERNA_COIN, -- taberna coins
		winnerItemAmount = 100,
		winnerItemName = configManager.getString(configKeys.TOURNAMENT_COINS_NAME):lower(),
		barrierId = 1608,
		barrierPositions = {
			-- bridge
			Position(1042, 1050, 6),
			Position(1042, 1051, 6),
			Position(1042, 1052, 6),
			Position(1042, 1053, 6),
			-- walls 1
			Position(1035, 1036, 6),
			Position(1035, 1037, 6),
			Position(1035, 1038, 6),
			Position(1035, 1039, 6),
			Position(1035, 1040, 6),
			-- walls 2
			Position(1046, 1036, 6),
			Position(1046, 1037, 6),
			Position(1046, 1038, 6),
			Position(1046, 1039, 6),
			Position(1046, 1040, 6),
		},
	},

	functions = {
		queueEvent = function(self, time)
			time = time - 1
			if time > 0 then
				Game.broadcastMessage(string.format("Battle Field Event is starting in %d minute%s!", time, time > 1 and "s" or ""), MESSAGE_STATUS_WARNING)
				addEvent(self.functions.queueEvent, 1 * 60 * 1000, self, time) -- check every minute until check players
			else
				local black, white = self.functions.aux.getTotalTeamPlayers(self)
				if black + white >= self.config.minPlayers then
					self.functions.startBattlefield(self)
				else
					self.functions.stopEvent(self, true)
				end
			end
		end,
		startEvent = function(self)
			if Game.getStorageValue(self.config.storage) < 1 then
				Game.loadMap(DATA_DIRECTORY .. "/world/battefield_event/battle-area.otbm")
				Game.setStorageValue(self.config.storage, 1)
			end

			self.functions.aux.removeTpAndItems(self, { self.config.portalPosition })
			self.eventtp = Game.createItem(self.config.portalId, 1, self.config.portalPosition)
			self.eventtp:setActionId(17555)
			self.functions.queueEvent(self, self.config.timeToStart + 1)
			-- create barriers
			for i, position in pairs(self.config.barrierPositions) do
				Game.createItem(self.config.barrierId, 1, position)
			end
			Game.broadcastMessage("The portal to Battle Field Event was opened inside Thais depot.", MESSAGE_STATUS_WARNING)
			--cleanMap()
		end,
		stopEvent = function(self, npe)
			self.functions.aux.removeTpAndItems(self, { self.config.portalPosition })
			local winner
			if npe then
				Game.broadcastMessage("The Battle Field Event was canceled due not enough players.", MESSAGE_STATUS_WARNING)
			else
				Game.broadcastMessage("The Battle Field Event was finished.", MESSAGE_STATUS_WARNING)
				self.config.started = false
				local black, white = self.functions.aux.getTotalTeamPlayers(self)
				if black == white or (black + white) == 0 then
					Game.broadcastMessage("We have a DRAW. No one won this event.", MESSAGE_STATUS_WARNING)
				else
					winner = black > white and "black" or "white"
					Game.broadcastMessage(string.format("Congratulations to the Team %s for win this event! All players of team won %d %s!", winner:gsub("^%l", string.upper), self.config.winnerItemAmount, self.config.winnerItemName), MESSAGE_STATUS_WARNING)
				end
			end

			for k, player in pairs(self.teams.players) do
				local playerObject = Player(player.pid)
				if playerObject then
					playerObject:setHealth(playerObject:getMaxHealth())
					playerObject:teleportTo(self.config.endPosition)
					playerObject:setOutfit(player.outfit)
					if not npe and player.team == winner then
						playerObject:addItem(self.config.winnerItemId, self.config.winnerItemAmount)
					end
				end
			end
			--cleanMap()
			self = bBattlefield
		end,
		enterEvent = function(self, pid, fromPosition)
			local player = Player(pid)
			if not player then
				return true
			end

			if #self.teams.players >= self.config.totalPlayers then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The event reach the max of players.")
				return true
			end

			--todo remove
			if not self.config.enableMC and self.functions.aux.checkIfPlayerIsAlreadyInEvent(self, pid) then
				player:teleportTo(fromPosition)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "MC's are not allowed.")
				return true
			end

			self.functions.aux.selectTeamToPlayer(self, player)
		end,
		startBattlefield = function(self)
			self.functions.aux.removeTpAndItems(self, { self.config.portalPosition })
			self.functions.aux.removeTpAndItems(self, self.config.barrierPositions)
			self.config.started = true
			self.config.time = os.time() + self.config.minutesToEnd * 60 * 1000
			Game.broadcastMessage("Battle Field Event was started!", MESSAGE_STATUS_WARNING)
		end,

		aux = {
			removePlayerFromEvent = function(self, pid)
				local newPlayers = {}
				for k, player in pairs(self.teams.players) do
					if player.pid ~= pid then
						table.insert(newPlayers, player)
					end
				end
				self.teams.players = newPlayers
				return true
			end,
			checkIfPlayerIsAlreadyInEvent = function(self, pid)
				for k, player in pairs(self.teams.players) do
					local pObj = Player(player.pid)
					local ownpObj = Player(pid)
					if player.pid == pid or (pObj and ownpObj and pObj:getIp() == ownpObj:getIp()) then
						return player
					end
				end
				return false
			end,
			getTotalTeamPlayers = function(self)
				local black = 0
				local white = 0
				for k, player in pairs(self.teams.players) do
					black = player.team == "black" and black + 1 or black
					white = player.team == "white" and white + 1 or white
				end
				return black, white
			end,
			selectTeamToPlayer = function(self, player)
				local black, white = self.functions.aux.getTotalTeamPlayers(self)

				if black == 0 and white == 0 then
					table.insert(self.teams.players, {
						pid = player:getId(),
						team = "black",
						outfit = player:getOutfit(),
					})
					player:setOutfit({ lookType = self.teams.black.outfit.lookType, lookFeet = self.teams.black.outfit.lookFeet, lookBody = self.teams.black.outfit.lookBody, lookLegs = self.teams.black.outfit.lookLegs, lookHead = self.teams.black.outfit.lookHead, lookAddons = 0 })
					player:teleportTo(self.teams.black.initialPos)
				elseif black > white then
					table.insert(self.teams.players, {
						pid = player:getId(),
						team = "white",
						outfit = player:getOutfit(),
					})
					player:setOutfit({ lookType = self.teams.white.outfit.lookType, lookFeet = self.teams.white.outfit.lookFeet, lookBody = self.teams.white.outfit.lookBody, lookLegs = self.teams.white.outfit.lookLegs, lookHead = self.teams.white.outfit.lookHead, lookAddons = 0 })
					player:teleportTo(self.teams.white.initialPos)
				else
					table.insert(self.teams.players, {
						pid = player:getId(),
						team = "black",
						outfit = player:getOutfit(),
					})
					player:setOutfit({ lookType = self.teams.black.outfit.lookType, lookFeet = self.teams.black.outfit.lookFeet, lookBody = self.teams.black.outfit.lookBody, lookLegs = self.teams.black.outfit.lookLegs, lookHead = self.teams.black.outfit.lookHead, lookAddons = 0 })
					player:teleportTo(self.teams.black.initialPos)
				end

				player:getPosition():sendMagicEffect(CONST_ME_STORM)
				Game.broadcastMessage("The player " .. player:getName() .. " entered in Battle Field Event.", MESSAGE_STATUS_WARNING)
			end,
			removeTpAndItems = function(self, positions)
				-- remove all tiles
				for i, pos in pairs(positions) do
					logger.info(string.format("x: %s, y: %s, z: %s", pos.x, pos.y, pos.z))
					local tile = Tile(pos)
					if tile then
						logger.info("achou tile")
						local items = tile:getItems()
						if items then
							logger.info("achou items")
							for i = 1, #items do
								items[i]:remove()
								logger.info("removed")
							end
						end
					end
				end
				self.eventtp = nil
			end,
		},
	},

	teams = {
		players = {},
		["black"] = {
			outfit = {
				lookType = 968,
				lookHead = 94,
				lookBody = 94,
				lookLegs = 94,
				lookFeet = 94,
				lookAddons = 0,
				lookMount = 0,
			},
			initialPos = Position(1032, 1052, 6),
		},
		["white"] = {
			outfit = {
				lookType = 968,
				lookHead = 85,
				lookBody = 85,
				lookLegs = 85,
				lookFeet = 85,
				lookAddons = 0,
				lookMount = 0,
			},
			initialPos = Position(1050, 1052, 6),
		},
	},
}

local bBattlefield = battlefield

----------------------------------------------------------------------------------------

-- Move events
local battleFieldEventEnter = MoveEvent()
function battleFieldEventEnter.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	battlefield.functions.enterEvent(battlefield, creature:getId(), fromPosition)
	position:sendMagicEffect(CONST_ME_WATERSPLASH)
	return true
end

battleFieldEventEnter:type("stepin")
battleFieldEventEnter:aid(17555)
battleFieldEventEnter:register()

-- Leave battlefield
local battleFieldEventLeave = MoveEvent()
function battleFieldEventLeave.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local playerInEvent = battlefield.functions.aux.checkIfPlayerIsAlreadyInEvent(battlefield, creature:getId())
	if playerInEvent then
		battlefield.functions.aux.removePlayerFromEvent(battlefield, creature:getId())
		position:sendMagicEffect(CONST_ME_WATERSPLASH)
		creature:teleportTo(battlefield.config.endPosition)
		creature:getPosition():sendMagicEffect(CONST_ME_WATERSPLASH)
		creature:setOutfit(playerInEvent.outfit)
		creature:setHealth(creature:getMaxHealth())
	end
	return true
end

battleFieldEventLeave:type("stepin")
battleFieldEventLeave:aid(17556)
battleFieldEventLeave:register()

----------------------------------------------------------------------------------------

-- Start
-- Talk Actions
local BattleFieldEvent = TalkAction("!battlefield")
function BattleFieldEvent.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- create log
	logCommand(player, words, param)

	battlefield.functions.startEvent(battlefield)

	return true
end

BattleFieldEvent:groupType("god")
BattleFieldEvent:register()

-- Cancel
local BattleFieldEventCancel = TalkAction("!battlefieldc")
function BattleFieldEventCancel.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- create log
	logCommand(player, words, param)

	battlefield.functions.stopEvent(battlefield)

	return true
end

BattleFieldEventCancel:groupType("god")
BattleFieldEventCancel:register()

----------------------------------------------------------------------------------------

-- OnPrepareDeath
local battleFieldDeath = CreatureEvent("battlefield_PrepareDeath")
function battleFieldDeath.onPrepareDeath(player, killer)
	if player then
		local playerInEvent = battlefield.functions.aux.checkIfPlayerIsAlreadyInEvent(battlefield, player:getId())
		if playerInEvent then
			battlefield.functions.aux.removePlayerFromEvent(battlefield, player:getId())
			player:teleportTo(battlefield.config.endPosition)
			player:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
			player:setOutfit(playerInEvent.outfit)
			player:setHealth(player:getMaxHealth())
			if killer then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You was killed by " .. killer:getName() .. " in Battle Field Event.")
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You was killed in Battle Field Event.")
			end
			return false
		end
	end
	return true
end

battleFieldDeath:register()
----------------------------------------------------------------------------------------

-- OnLogout
local battlefieldLogout = CreatureEvent("battlefield_Logout")
function battlefieldLogout.onLogout(player)
	if battlefield.config.started then
		if player then
			player:teleportTo(battlefield.config.endPosition)
			battlefield.functions.aux.removePlayerFromEvent(battlefield, player:getId())
		end
	end
	return true
end

battlefieldLogout:register()

----------------------------------------------------------------------------------------

-- Global Event
local battleFieldGlobalEvent = GlobalEvent("battleFieldGlobalEvent")
function battleFieldGlobalEvent.onThink(interval)
	if battlefield.config.started then
		local black, white = battlefield.functions.aux.getTotalTeamPlayers(battlefield)
		if black == 0 or white == 0 then
			battlefield.functions.stopEvent(battlefield)
		elseif battlefield.config.time <= os.time() then
			battlefield.functions.stopEvent(battlefield)
		end
	end
	return true
end

battleFieldGlobalEvent:interval(4000)
--battleFieldGlobalEvent:register()
----------------------------------------------------------------------------------------
