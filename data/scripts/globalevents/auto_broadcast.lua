local AutoBroadCast = GlobalEvent("text")
function AutoBroadCast.onThink(interval, lastExecution)
    local messages = {

    "Usa el comando !reward y recibe una training weapon a partir de nivel 40!",
    "No olvides ponerte tus Addons solo con el npc Addoner para obtener Buffs!",
    --"Tibia coins! Contacta a algun administrador para adquirirlas!",
    "Revisa la seccion de Items Vip y Utilities en el Gamestore!",
	
}
    Game.broadcastMessage(messages[math.random(#messages)], MESSAGE_GAME_HIGHLIGHT) 
    return true
end
AutoBroadCast:interval(900000)  --900000 es el valor que tenia originalmente
AutoBroadCast:register()