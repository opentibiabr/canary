---@class BossLever
---@field private name string
---@field private bossPosition Position
---@field private createBoss function
---@field private timeToFightAgain number
---@field private timeToDefeat number
---@field private minPlayers number
---@field private timeAfterKill number
---@field private requiredLevel number
---@field private disabled boolean
---@field private onUseExtra function
---@field private _position Position
---@field private _uid number
---@field private _aid number
---@field private playerPositions {pos: Position, teleport: Position}[]
---@field private area {from: Position, to: Position}
---@field private monsters {name: string, pos: Position}[]
---@field private exitTeleporter Position
---@field private exit Position
---@field private encounter Encounter
---@field private timeoutEvent Event
---@field private disableCooldown boolean
BossLever = {}

--[[
local config = {
	boss = {
		name = "Faceless Bane",
		position = Position(33617, 32561, 13)
	}
	requiredLevel = 250,
	timeToFightAgain = 10 * 60 * 60, -- In seconds
	minPlayers = 4,
	playerPositions = {
		{ pos = Position(33638, 32562, 13), teleport = Position(33617, 32567, 13) },
		{ pos = Position(33639, 32562, 13), teleport = Position(33617, 32567, 13) },
		{ pos = Position(33640, 32562, 13), teleport = Position(33617, 32567, 13) },
		{ pos = Position(33641, 32562, 13), teleport = Position(33617, 32567, 13) },
		{ pos = Position(33642, 32562, 13), teleport = Position(33617, 32567, 13) },
	},
	specPos = {
		from = Position(33607, 32553, 13),
		to = Position(33627, 32570, 13)
	},
	onUseExtra = function(player, infoPositions)
		player:teleportTo(Position(33618, 32523, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end,
	exit = Position(33618, 32523, 15),
}
]]
setmetatable(BossLever, {
	---@param self BossLever
	---@param config table
	__call = function(self, config)
		local boss = config.boss
		if not boss then
			error("BossLever: boss is required")
		end
		return setmetatable({
			name = boss.name:lower(),
			encounter = config.encounter,
			bossPosition = boss.position,
			timeToFightAgain = config.timeToFightAgain or configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN),
			timeToDefeat = config.timeToDefeat or configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_DEFEAT),
			timeAfterKill = config.timeAfterKill or 60,
			requiredLevel = config.requiredLevel or 0,
			createBoss = boss.createFunction,
			disabled = config.disabled,
			minPlayers = config.minPlayers or 1,
			playerPositions = config.playerPositions,
			onUseExtra = config.onUseExtra or function() end,
			exitTeleporter = config.exitTeleporter,
			exit = config.exit,
			area = config.specPos,
			monsters = config.monsters or {},
			disableCooldown = config.disableCooldown,
			_position = nil,
			_uid = nil,
			_aid = nil,
		}, { __index = BossLever })
	end,
})

---@param self BossLever
---@param position Position
---@return BossLever
function BossLever:position(position)
	self._position = position
	return self
end

---@param self BossLever
---@param uid number
---@return BossLever
function BossLever:uid(uid)
	self._uid = uid
	return self
end

---@param self BossLever
---@param aid number
---@return BossLever
function BossLever:aid(aid)
	self._aid = aid
	return self
end

function BossLever:kvScope()
	local mType = MonsterType(self.name)
	if not mType then
		error("BossLever: boss name is invalid")
	end
	return "boss.cooldown." .. toKey(tostring(mType:raceId()))
end

---@param self BossLever
---@param player Player
---@return number
function BossLever:lastEncounterTime(player)
	if not player or self.disableCooldown then
		return 0
	end
	return player:getBossCooldown(self.name)
end

---@param self BossLever
---@param time number
---@return boolean
function BossLever:setLastEncounterTime(time)
	local info = self.lever:getInfoPositions()
	if not info then
		logger.error("BossLever:setLastEncounterTime - lever:getInfoPositions() returned nil")
		return false
	end
	for _, v in pairs(info) do
		if v.creature then
			local player = v.creature:getPlayer()
			if player then
				player:setBossCooldown(self.name, time)
			end
		end
	end
	return true
end

---@param player Player
---@return boolean
function BossLever:onUse(player)
	local monsterName = MonsterType(self.name):getName()
	local isParticipant = false
	for _, v in ipairs(self.playerPositions) do
		if Position(v.pos) == player:getPosition() then
			isParticipant = true
		end
	end
	if not isParticipant then
		return false
	end

	if self.disabled then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The boss is temporarily disabled.")
		return true
	end

	local zone = self:getZone()
	if zone:countPlayers(IgnoredByMonsters) > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's already someone fighting with " .. monsterName .. ".")
		return true
	end

	self.lever = Lever()
	local lever = self.lever
	lever:setPositions(self.playerPositions)
	lever:setCondition(function(creature)
		if not creature or not creature:isPlayer() then
			return true
		end

		local isAccountNormal = creature:getAccountType() < ACCOUNT_TYPE_GAMEMASTER
		if isAccountNormal and creature:getLevel() < self.requiredLevel then
			local message = "All players need to be level " .. self.requiredLevel .. " or higher."
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			return false
		end

		local infoPositions = lever:getInfoPositions()
		if creature:getGroup():getId() < GROUP_TYPE_GOD and isAccountNormal and self:lastEncounterTime(creature) > os.time() then
			for _, posInfo in pairs(infoPositions) do
				local currentPlayer = posInfo.creature
				if currentPlayer then
					local lastEncounter = self:lastEncounterTime(currentPlayer)
					local currentTime = os.time()
					if lastEncounter and currentTime < lastEncounter then
						local timeLeft = lastEncounter - currentTime
						local timeMessage = Game.getTimeInWords(timeLeft) .. " to face " .. self.name .. " again!"
						local message = "You have to wait " .. timeMessage

						if currentPlayer ~= player then
							player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A member in your team has to wait " .. timeMessage)
						end

						currentPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
						currentPlayer:getPosition():sendMagicEffect(CONST_ME_POFF)
					end
				end
			end
			return false
		end

		return self.onUseExtra(creature, infoPositions) ~= false
	end)

	lever:checkPositions()
	if #lever:getPlayers() < self.minPlayers then
		lever:executeOnPlayers(function(creature)
			local message = string.format("You need %d qualified players for this challenge.", self.minPlayers)
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		end)
		return false
	end
	if lever:checkConditions() then
		zone:removeMonsters()
		for _, monster in pairs(self.monsters) do
			Game.createMonster(monster.name, monster.pos, true, true)
		end
		if self.createBoss then
			if not self.createBoss() then
				return true
			end
		elseif self.bossPosition then
			logger.debug("BossLever:onUse - creating boss: {}", self.name)
			local monster = Game.createMonster(self.name, self.bossPosition, true, true)
			if not monster then
				return true
			end
			monster:registerEvent("BossLeverOnDeath")
		end
		lever:teleportPlayers()
		if self.encounter then
			local encounter = Encounter(self.encounter)
			encounter:reset()
			encounter:start()
		end
		self:setLastEncounterTime(os.time() + self.timeToFightAgain)
		if self.timeoutEvent then
			stopEvent(self.timeoutEvent)
			self.timeoutEvent = nil
		end
		self.timeoutEvent = addEvent(function(zn)
			zn:refresh()
			zn:removePlayers()
		end, self.timeToDefeat * 1000, zone)
	end
	return true
end

---@param Zone
function BossLever:getZone()
	return Zone("boss." .. toKey(self.name))
end

---@param self BossLever
---@return boolean
function BossLever:register()
	local missingParams = {}
	if not self.name then
		table.insert(missingParams, "boss.name")
	end
	if not self.playerPositions then
		table.insert(missingParams, "playerPositions")
	end
	if not self.area then
		table.insert(missingParams, "specPos")
	end
	if not self.exit then
		table.insert(missingParams, "exit")
	end
	if not self._position and not self._uid and not self._aid then
		table.insert(missingParams, "position or uid or aid")
	end
	if #missingParams > 0 then
		local name = self.name or "unknown"
		logger.error("BossLever:register() - boss with name {} missing parameters: {}", name, table.concat(missingParams, ", "))
		return false
	end

	local zone = self:getZone()

	zone:addArea(self.area.from, self.area.to)
	zone:blockFamiliars()
	zone:setRemoveDestination(self.exit)

	local action = Action()
	action.onUse = function(player)
		self:onUse(player)
	end
	if self._position then
		action:position(self._position)
	end
	if self._uid then
		action:uid(self._uid)
	end
	if self._aid then
		action:aid(self._aid)
	end
	action:register()
	BossLever[self.name] = self

	if self.exitTeleporter then
		SimpleTeleport(self.exitTeleporter, self.exit)
	end
	return true
end
