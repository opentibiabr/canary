NpcTopic = {}

function NpcTopic:new(obj)
    if getmetatable(obj) == NpcTopic then return obj end

    obj = obj or {}
    obj = {
        current = obj.current or 0,
        previous = obj.previous or nil,
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end