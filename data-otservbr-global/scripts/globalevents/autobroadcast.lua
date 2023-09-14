local autoBroadcast = GlobalEvent("AutoBroadcast")
function autoBroadcast.onThink(interval, lastExecution)
    local messages = 
	{
	"Salve, esse e o MerakiGlobal! Sejam bem vindos!",
    "[DONATES]: Atraves do QR code no site ou no PIX (19)935006810 Felipe Ruani - Nubank. Enviar comprovante para o mesmo whatsapp",
	"[FORGE]: A Forja de bolso da store permite que vc use o sistema de forja em qualquer lugar a qualquer hora",
	"[INFORMACAO]: Cada 1h Online, Voce recebe 1 online coins (Free) ou 2 online coins (VIP), utilizadas para negociar itens com o Meraki Trader no DP de Thais",
	"[INFORMACAO]: ATENCAO! Caso o Player Fique 5 dias sem logar, Perde a casa automaticamente! E script nao adianta reclamar e chorar, nao tem como abrir excecao",
	"[EVENTOS]: Evento Castle Guild x Guild, o ultimo a clicar na coroa ate as 21horas ganha o castelo e todos da guild vencedora ganham +25% de XP e a possibilidade de cacar em uma hunt exclusiva com chance de drop de itens sanguine",
	"[EVENTOS]: Boss Meraki, todos os dias as 15:00 e as 20:30, chance de drop de rares e itens VIP",
	"[DISCORD]: Acesse Nosso Discord : https://discord.gg/ZDRvQdNu",
	"[WHATSAPP]: Acesse Nosso Grupo no Whatsapp : https://chat.whatsapp.com/I6SJKXdLNn0HDz6SeEE2tR",
	"[RAIDS]: Ferumbras Todo dia 15 de cada mes, drop unique de hat",
	"[INFORMACAO]: Siga a Twitch do God F e participe de promocoes e eventos surpresa, canal : https://www.twitch.tv/gamerroceiro",
	"[INFORMACAO]: Nao Toleramos falta de respeito dentro de nosso servidor, ofensas, racismo, divulgacao geral em banimento imediato! ",
	"[INFORMACAO]: Duvidas? Sugestoes? Acesse os canais disponiveis em nosso discord ",
    "[INFORMACAO]: E permitida utilizacao de bot/macro (o servidor e pvp, faca por sua conta e risco) em apenas 1 char, entrar pvp ou cacar de MC e insta ban ",   
	"[COMANDOS]: Digite: !bless, Para Fazer Todas as Bless, Funciona SOMENTE EM AREA PZ! ",
	"[INFORMACAO]: Somos um servidor serio no qual o Staff nao influencia no game,somente para suporte de bugs etc.. entao nao perca seu tempo pedindo items ou para trocar de items!! Pois isso nao faz parte de nossa conduta, Obrigado. ",
	"[FORGE]: Slivers voce podera encontrar as criatuas influenciadas no mapa usando a magia exiva moe res.",
	"[INFORMACAO]: Nao nos Responsabilizamos Por Contas/Items Perdidos Nesse Server, Tome Cuidado Com Quem Voce Anda e o Que Faz!;D ",
	"[INFORMACAO]: O teleport cube te da acesso a sala de hunts exclusiva e varios outros locais",
	"[INFORMACAO]: Double donate de 01/09/2023 a 08/09/2023 as 23:59:59",
	"[INFORMACAO]: Use o comando !emote on para reduzir o spam de magias",
	"[INFORMACAO]: Use o comando !promotion para comprar sua promotion depois do lvl 20",
	"[INFORMACAO]: Use o comando !bp 'escolher cor' para comprar uma backpack, ex: !bp blue",
	"[INFORMACAO]: Quanto maior seu fist fighting mais rapido voce vai hitar, use qualquer exercise wand para treinar fist em um dummy",
	}

    Game.broadcastMessage(messages[math.random(#messages)], MESSAGE_EVENT_ADVANCE)
    return true
end

autoBroadcast:interval(600000) --10 minutes
autoBroadcast:register()