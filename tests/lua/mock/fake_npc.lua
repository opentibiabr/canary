FakeNpc = {}
function FakeNpc:new()
    obj = obj or {}

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function FakeNpc:isPlayerInteractingOnTopic(player, topic)
    return player.topic == topic
end

function FakeNpc:setPlayerInteraction(player, topic)
    player.topic = topic
end

function FakeNpc:removePlayerInteraction(player, topic)
    player.topic = nil
end

function FakeNpc:talk(player, message)
    player.reply = message
end