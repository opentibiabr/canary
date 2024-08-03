local autoBroadcast = GlobalEvent("AutoBroadcast")
function autoBroadcast.onThink(interval, lastExecution)
    local messages = {
--	"Bem Vindos ao Elera-War ",
--    "[DONATES]: Elera-War / @Eleraotserver ",
	"[FORGE]: Contamos com o novo Update Forge System igual global.",
	"[Task]: Digite !task, e escolha qual task voce deseja iniciar.",
	"[INFORMACAO]: ATENCAO! Caso o Player Fique 7 dias sem logar, Perde a casa automaticamente!",
	"[INFORMACAO]: Nao Toleramos falta de respeito com admins, xingamentos, racismo, divulgacao gera em banimento imediato! ",
    "[COMANDOS]: Digite: !commands, Para Exibir Todos Comandos Disponiveis ",   
	"[COMANDOS]: Digite: !bless, Para Fazer Todas as Bless, Funciona SOMENTE EM AREA PZ! ",
	"[INFORMACAO]: Somos um servidor serio no qual o Staff nao influencia no game,somente para suporte de bugs etc.. entao nao perca seu tempo pedindo items ou para trocar de items!! Pois isso nao faz parte de nossa conduta, Obrigado. ",
	"[FORGE]: Slivers voce podera encontrar as criatuas influenciadas no mapa usando a magia exiva moe res.",
	"[INFORMACAO]: Nao nos Responsabilizamos Por Contas/Items Perdidos Nesse Server, Tome Cuidado Com Quem Voce Anda e o Que Faz!;D ",
}

    Game.broadcastMessage(messages[math.random(#messages)], MESSAGE_EVENT_ADVANCE)
    return true
end

autoBroadcast:interval(600000) --10 minutes
autoBroadcast:register()