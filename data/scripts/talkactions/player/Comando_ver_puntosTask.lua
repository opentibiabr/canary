local buffPointsCommand = TalkAction("!taskpoints")

function buffPointsCommand.onSay(player, words, param)
    -- Obtener la identificación del jugador
    local playerId = player:getGuid()

    -- Obtener puntos del jugador desde la base de datos (asumo que tienes una columna llamada 'puntostask')
    local playerPointsQuery = db.storeQuery('SELECT `puntostask` FROM `players` WHERE `id` =' .. playerId .. ' LIMIT 1;')
    local playerPoints = Result.getNumber(playerPointsQuery, "puntostask")

    -- Mostrar la cantidad de puntos al jugador
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Tienes %i Task Points.", playerPoints))
    
    return true
end

buffPointsCommand:groupType("normal")
buffPointsCommand:register()