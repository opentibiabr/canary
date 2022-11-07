---@author @Glatharth
---@version 1.2
---@since 1.0
Spectators = {}
setmetatable(Spectators, {
	__call = function(self)
		local spectators_data = {
            only_player = true,
            multi_floor = false,
            blacklist_pos = {},
            creature_detect = {}
		}
		return setmetatable(spectators_data, {__index = Spectators})
	end
})


function Spectators.getOnlyPlayer(self)
    return self.only_player
end

function Spectators.setOnlyPlayer(self, boolean)
    self.only_player = boolean
end

function Spectators.getMultiFloor(self)
    return self.multi_floor
end

function Spectators.setMultiFloor(self, boolean)
    self.multi_floor = boolean
end

function Spectators.setCreatureDetect(self, creatures)
    self.creature_detect = creatures
end

function Spectators.getCreatureDetect(self)
    return self.creature_detect
end

function Spectators.removeCreatureDetect(self)
    self.creature_detect = {}
end

function Spectators.setRemoveDestination(self, destination)
    self.remove_destination = destination
end

function Spectators.getRemoveDestination(self)
    return self.remove_destination
end

function Spectators.setCheckPosition(self, position)
    if position.from and position.to then
        self.check_position = position
    else
        error("Error set position.")
    end
end

function Spectators.getCheckPosition(self)
    return self.check_position
end

function Spectators.getBlacklistPos(self)
    return self.blacklist_pos
end

function Spectators.setBlacklistPos(self, list)
    if type(list) == "table" then
        self.blacklist_pos = list
    else
        error("List is not a table")
    end
end

function Spectators.convertPosToRange(self)
    local pos = self:getCheckPosition()
    return {
        x = (pos.to.x - pos.from.x) / 2,
        y = (pos.to.y - pos.from.y) / 2,
        z = pos.from.z
    }
end

function Spectators.convertPos(self)
    local pos = self:getCheckPosition()
    local range = self:convertPosToRange()
    return Position(
        pos.from.x + range.x,
        pos.from.y + range.y,
        range.z
    )
end

function Spectators.checkCreatureBlacklistPos(self, creature)
    local creature_pos = creature:getPosition()
    for _, v in pairs(self:getBlacklistPos()) do
        if creature_pos.x >= v.from.x and creature_pos.x <= v.to.x then
            if creature_pos.y >= v.from.y and creature_pos.y <= v.to.y then
                return true
            end
        end
    end
    return false
end

function Spectators.removeMonsters(self)
    if self:getCreatureDetect() then
        for _, v in pairs(self:getCreatureDetect()) do
            if v:isMonster() then
                v:remove()
            end
        end
    end
end

function Spectators.removePlayer(self, player)
    if player then
        if player:isPlayer() then
            local destination = self:getRemoveDestination()
            if destination then
                player:teleportTo(destination)
            else
                player:teleportTo(player:getTown():getTemplePosition())
                player:remove()
            end
        end
    end
end

function Spectators.removePlayers(self, players)
    local creature_remove = players or self:getCreatureDetect()
    for _, v in pairs(creature_remove) do
        self:removePlayer(v)
    end
end

function Spectators.check(self, pos)
    if pos ~= nil then
        self:setCheckPosition(pos)
    end
    local range = self:convertPosToRange()
    pos = self:convertPos()
    local specs = Game.getSpectators(pos, self:getMultiFloor(), self:getOnlyPlayer(), range.x, range.x, range.y, range.y)
    self:setCreatureDetect(specs)
    return specs
end

function Spectators.getPlayers(self)
    local count = 0
    if not self:getCreatureDetect() then
        error('Not creature detect')
        return nil
    end
    for _, v in pairs(self:getCreatureDetect()) do
        if v:isPlayer() then
            count = count + 1
        end
    end
    return count
end

function Spectators.clearCreaturesCache(self)
    self:removeCreatureDetect()
end