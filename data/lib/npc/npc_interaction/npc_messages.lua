NpcMessages = {}

function NpcMessages:new(obj)
    if getmetatable(obj) == NpcMessages then return obj end

    obj = obj or {}
    obj = {
        reply = obj.reply or "",
        confirmation = obj.confirmation or "",
        cancellation = obj.cancellation or "",
        cannotExecute = obj.cannotExecute or "",
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end