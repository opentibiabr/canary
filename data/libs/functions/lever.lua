---@author @Glatharth
---@version 1.1
---@since 1.0
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
        end
    end
end