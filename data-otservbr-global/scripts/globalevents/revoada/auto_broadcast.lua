local AutoBroadCast = GlobalEvent("text")

-- Lista de mensagens (pares PT/EN)
local messages = {
    "[PT] Visite nosso site: https://tabernaot.com.br/ \n[EN] Visit our site: https://tabernaot.com.br/",
    "[PT] Entre no nosso discord: https://discord.gg/tgqpMprb \n[EN] Join our Discord: https://discord.gg/tgqpMprb",
    "[PT] Torne-se VIP e ganhe acesso a areas exclusivas, bonus de XP e loot, alem de outras vantagens. \n[EN] Become VIP and gain access to exclusive areas, XP and loot bonuses, and other advantages.",
    "[PT] A cada hora online voce recebe taberna coins para usar na store! \n[EN] For every hour online, you receive taberna coins to use in the store!",
    "[PT] Ajude-nos a manter o servidor online! Realize uma doacao e tenha acesso a bonus exclusivos de loot, XP e muito mais. \n[EN] Help us keep the server online! Donate to gain exclusive bonuses for loot, XP, and more.",
    "[PT] Se encontrar um bug, nos avise! Voce sera recompensado. Nao se aproveite deles! \n[EN] If you find a bug, let us know! You will be rewarded. Do not exploit them!"
}

-- Última mensagem enviada (para evitar repetição)
local lastMessageIndex = nil

-- Função para enviar mensagens automáticas
local function sendBroadcastMessage()
    if #messages == 0 then
        print("Warning: No messages to broadcast.")
        return
    end

    local index
    repeat
        index = math.random(#messages)
    until index ~= lastMessageIndex -- Evitar repetição imediata

    lastMessageIndex = index
    Game.broadcastMessage(messages[index], MESSAGE_GAME_HIGHLIGHT)
end

function AutoBroadCast.onThink(interval, lastExecution)
    sendBroadcastMessage()
    return true
end

-- Configuração de intervalo (15 minutos)
AutoBroadCast:interval(900000) -- 900000 ms = 15 minutos
AutoBroadCast:register()
