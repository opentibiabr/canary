local addPoints = TalkAction("/addbuffpoints")

function addPoints.onSay(player, words, param)
    -- Verificar si el jugador tiene permisos de dios
    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end

    -- Verificar si se proporcionó el nombre del jugador y la cantidad de puntos
    if param == "" then
        player:sendCancelMessage("Se requieren el nombre del jugador y la cantidad de puntos.")
        return false
    end

    local split = param:split(",")
    local name = split[1]
    local points = tonumber(split[2])

    -- Verificar si el jugador está en línea
    local targetPlayer = Player(name)
    if not targetPlayer then
        player:sendCancelMessage("El jugador ".. string.titleCase(name) .." no está en línea.")
        return false
    end

    -- Verificar si la cantidad de puntos es válida
    if not points or points <= 0 then
        player:sendCancelMessage("Cantidad de puntos inválida.")
        return false
    end

    -- Agregar puntos al jugador
    targetPlayer:setStorageValue("points", targetPlayer:getStorageValue("points") + points)

    -- Actualizar la base de datos con los nuevos puntos
    local accountId = targetPlayer:getAccountId()
    db.query("UPDATE players SET buffpoints = buffpoints + " .. points .. " WHERE account_id = '" .. accountId .. "';")

    -- Mensajes de éxito
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Se han agregado ".. points .." puntos al jugador ".. targetPlayer:getName() ..".")
    targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Has recibido ".. points .." puntos de ".. player:getName() ..".")

    -- Registro en el log
    Spdlog.info("".. player:getName() .." ha agregado ".. points .." puntos a ".. targetPlayer:getName() ..".")
    return true
end

addPoints:separator(" ")
addPoints:groupType("god")
addPoints:register()
