---@author @Glatharth
---@version 5.4
Lever = {}
setmetatable(Lever, {
	__call = function(self)
		local lever_data = {
            positions = {},
            info_positions = nil,
            condition = function() return true end,
            teleport_player_func = function() return true end,
        }
		return setmetatable(lever_data, {__index = Lever})
	end
})

---@return table
function Lever.getPositions(self)
    return self.positions
end

--[[
    lever:setPositions(table[ table[pos = Position(), teleport = Position(), effect = CONST_ME_ (int)] ])

    | Method   | Type              | Usage                                                | Default           |
    |----------|-------------------|------------------------------------------------------|-------------------|
    | pos      | Position(x, y, z) | Sets the position of the player                      | nil               |
    | teleport | Position(x, y, z) | Sets the position where the player will teleport     | nil               |
    | effect   | CONST_ME_ (int)   | Sets the effect it will do when the player teleports | CONST_ME_TELEPORT |

    local players = {
       {pos = Position(x, y, z), teleport = Position(x, y, z), effect = CONST_ME_TELEPORT},
       {pos = Position(x1, y1, z1), teleport = Position(x1, y1, z1), effect = CONST_ME_TELEPORT},
    }
    lever:setPositions(players)
]]
---@param positions table
---@return nil
function Lever.setPositions(self, positions) -- Sets the positions of players to be teleported when activating the lever
    if type(positions) ~= "table" then
        positions = {positions}
    end
    self.positions = positions
end

---@return nil|table
---@return nil
function Lever.getInfoPositions(self)
    return self.info_positions
end

--[[
    lever:setCondition(function(creature))

    lever:setCondition(function(creature)
        if creature and creature:isPlayer() then
            return true
        end
    end)
]]
---@param func function
---@return nil
function Lever.setCondition(self, func) -- A condition will be set for all players, if any player does not meet this condition, none of the players will be teleported
    self.condition = func
end

---@return any
function Lever.getCondition(self, ...)
    return self.condition(...)
end

--[[
    lever:setTeleportPlayerFunc(function(creature))

    lever:setTeleportPlayerFunc(function(creature)
        if creature and creature:isPlayer() then
            creature:say('YUP!!', TALKTYPE_MONSTER_SAY)
            return true
        end
    end)
]]
---@param func function
---@return nil
function Lever.setTeleportPlayerFunc(self, func) -- After players are teleported, this function will be executed.
    self.teleport_player_func = func
end

---@return any
function Lever.getTeleportPlayerFunc(self, ...)
    return self.teleport_player_func(...)
end

---@generic Positions
---@return Positions
function Lever.checkPositions(self) -- Will check all positions defined in setPositions() and will collect all information, they can be get in getInfoPositions()
    local positions = self:getPositions()
    if not positions then
        error("Positions: not setted")
        return nil
    end
    local array = {}
    for i, v in pairs(positions) do
        local tile = Tile(v.pos)
        local creature = tile:getBottomCreature()
        local item = tile:getItems()
        local ground = tile:getGround()
        local actionID = ground:getActionId()
        local uniqueID = ground:getUniqueId()
        table.insert(array, {
            tile = tile,
            creature = creature,
            teleport = v.teleport,
            effect = v.effect and CONST_ME_TELEPORT,
            item = item,
            ground = ground,
            actionID = actionID,
            uniqueID = uniqueID,
        })
    end
    self.info_positions = array
    return array
end

---@return boolean
function Lever.checkConditions(self) -- It will check the conditions defined in setCondition()
    local info = self:getInfoPositions()
    if not info then
        error("Necessary informations from positions")
        return false
    end
    for i, v in pairs(info) do
        v.condition = self:getCondition(v.creature)
        if v.condition == false then
            return v.condition
        end
    end
    return true
end

---@return nil
function Lever.teleportPlayers(self) -- It will teleport all players to the positions defined in setPositions()
    local info = self:getInfoPositions()
    if not info then
        return false
    end

    for i, v in pairs(info) do
        local player = v.creature
        if player then
            player:teleportTo(v.teleport)
            player:getPosition():sendMagicEffect(v.effect)
            self:getTeleportPlayerFunc(player)
        end
    end
end

--[[
    lever:setPositions(key, value)

    | Method | Type | Usage   | Default |
    |--------|------|---------|---------|
    | key    | int  | Storage | nil     |
    | value  | int  | Value   | nil     |

    lever:setStorageAllPlayers(10000, 1)
]]
---@generic Storage
---@param key Storage
---@param value number
---@return nil
function Lever.setStorageAllPlayers(self, key, value) -- Will set storage on all players
    local info = self:getInfoPositions()
    if not info then
        error("Necessary information from players")
        return false
    end

    for i, v in pairs(info) do
        local player = v.creature
        if player then
            player:setStorageValue(key, value)
            player:sendBosstiaryCooldownTimer()
        end
    end
end

--[[
local config = {
	boss = {
		name = "Faceless Bane",
		position = Position(33617, 32561, 13)
	}
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60, -- In second
	timeToDefeatBoss = 20 * 60, -- In second
	playerPositions = {
		{ pos = Position(33638, 32562, 13), teleport = Position(33617, 32567, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33639, 32562, 13), teleport = Position(33617, 32567, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33640, 32562, 13), teleport = Position(33617, 32567, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33641, 32562, 13), teleport = Position(33617, 32567, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33642, 32562, 13), teleport = Position(33617, 32567, 13), effect = CONST_ME_TELEPORT }
	},
	specPos = {
		from = Position(33607, 32553, 13),
		to = Position(33627, 32570, 13)
	},
	condition = function(creature)
		return true
	end, -- If it is nil the condition will be default
	exit = Position(33618, 32523, 15),
	storage = Storage.Quest.U12_00.TheDreamCourts.FacelessBaneTime
}
]]

---@generic Player
---@param player Player
---@param config table
---@return boolean
function CreateDefaultLeverBoss(player, config) -- This function is to suppress all default lever systems for boss
	if config.playerPositions[1].pos ~= player:getPosition() then
		return false
	end

	local spec = Spectators()
	spec:setOnlyPlayer(false)
	spec:setRemoveDestination(config.exit)
	spec:setCheckPosition(config.specPos)
	spec:check()

	if spec:getPlayers() > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's someone fighting with " .. config.boss.name .. ".")
		return true
	end

	local lever = Lever()
	lever:setPositions(config.playerPositions)
	if type(config.condition) == "function" then
		lever:setCondition(config.condition())
	else
		lever:setCondition(function(creature)
			if not creature or not creature:isPlayer() then
				return true
			end
			if config.requiredLevel and creature:getLevel() < config.requiredLevel then
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level " .. config.requiredLevel .. " or higher.")
				return false
			end
			if config.storage and creature:getStorageValue(config.storage) > os.time() then
				local info = lever:getInfoPositions()
				for _, v in pairs(info) do
					local newPlayer = v.creature
					if newPlayer then
						newPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait " .. string.diff(config.timeToFightAgain) .. " to face ".. config.boss.name .." again!")
						if newPlayer:getStorageValue(config.storage) > os.time() then
							newPlayer:getPosition():sendMagicEffect(CONST_ME_POFF)
						end
					end
				end
				return false
			end
			return true
		end)
	end
	lever:checkPositions()
	if lever:checkConditions() then
		spec:removeMonsters()
		local monster = Game.createMonster(config.boss.name, config.boss.position, true, true)
		if not monster then
			return true
		end
		lever:teleportPlayers()
		if config.storage then
			lever:setStorageAllPlayers(config.storage, os.time() + config.timeToFightAgain)
		elseif config.timeToFightAgain then
			error("Not found config.storage")
		end
		addEvent(function()
			local old_players = lever:getInfoPositions()
			spec:clearCreaturesCache()
			spec:setOnlyPlayer(true)
			spec:check()
			local player_remove = {}
			for i, v in pairs(spec:getCreatureDetect()) do
				for _, v_old in pairs(old_players) do
					if v_old.creature == nil or v_old.creature:isMonster() then
						break
					end
					if v:getName() == v_old.creature:getName() then
						table.insert(player_remove, v_old.creature)
						break
					end
				end
			end
			spec:removePlayers(player_remove)
		end, config.timeToDefeatBoss * 1000)
		return true
	end
	return false
end
