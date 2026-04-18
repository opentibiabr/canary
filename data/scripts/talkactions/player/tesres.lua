local talk = TalkAction("/resetall")

function talk.onSay(player, words, param)
    for i = 1000, 70000 do
        player:setStorageValue(i, -1)
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Todos storages resetados! Relogue.")
    return true
end

talk:groupType("god")
talk:register()
