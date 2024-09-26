-- ⓥⓐⓖⓞⓢⓖⓐⓜⓘⓝⓖ ⓢⓔⓡⓥⓘⓒⓘⓞⓢ ⓟⓡⓞⓖⓡⓐⓜⓐⓒⓘⓞⓝ 2006-2023

-- No revender este script.

-- Mi Discord :  https://discord.gg/22GBHzqFxG


local buffPointsCommand = TalkAction("!buffpoints")

function buffPointsCommand.onSay(player, words, param)
    -- Obtener la identificación del jugador
    local playerId = player:getGuid()

    -- Obtener puntos del jugador desde la base de datos (asumo que tienes una columna llamada 'buffpoints')
    local playerPointsQuery = db.storeQuery('SELECT `buffpoints` FROM `players` WHERE `id` =' .. playerId .. ' LIMIT 1;')
    local playerPoints = Result.getNumber(playerPointsQuery, "buffpoints")

    -- Mostrar la cantidad de puntos al jugador
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Tienes %i puntos de bonificacion.", playerPoints))
    
    return true
end

buffPointsCommand:groupType("normal")
buffPointsCommand:register()