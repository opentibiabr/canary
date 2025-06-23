local autoBroadcast = GlobalEvent("autoBroadcast")
local interval = 10 -- Minutes

-- Contador global para controlar qual mensagem será enviada
local currentMessageIndex = 1

function autoBroadcast.onThink(interval, lastExecution)
    local players = Game.getPlayers()
    if not players then
        return true
    end

    function Player:sendColoredMessage(message)
        local grey = 3003
        local blue = 3043
        local green = 3415
        local purple = 36792
        local yellow = 34021

        local msg = message:gsub("{grey|", "{" .. grey .. "|"):gsub("{blue|", "{" .. blue .. "|"):gsub("{green|", "{" .. green .. "|"):gsub("{purple|", "{" .. purple .. "|"):gsub("{yellow|", "{" .. yellow .. "|")
        return self:sendTextMessage(MESSAGE_LOOT, msg)
    end

    local messages = {
        string.format("{blue|[REWARD]}: Type !reward to receive your daily reward!"),
        string.format("{purple|[DISCORD]}: Join our Discord server: https://discord.gg/UDeVwQ2BYg"),
        string.format("{blue|[SECURITY]}: Find a list of valid GM/CM/GOD/Tutors in our website!"),
        string.format("{yellow|[VIP]}: Consider buying VIP and help our server to succeed."),
        string.format("{blue|[FLASK SYSTEM]}: Type !vials on/off to automatically remove vials and say goodbye to the annoying vials!"),
    }
    currentMessageIndex = math.random(#messages)
    -- Envia a mensagem atual para todos os jogadores
    for _, player in ipairs(players) do
        player:sendColoredMessage(messages[currentMessageIndex], MESSAGE_EVENT_ADVANCE)
    end

    return true
end

autoBroadcast:interval(interval * 60 * 1000)
autoBroadcast:register()
