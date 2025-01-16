local effects = {
	{ position = Position(32068, 31899, 6), text = "Bem Vindo(a) ao taberna Server!!" }, -- aviso em dawnport
	--{ position = Position(32072, 31902, 6), text = "No nosso servidor contamos com sistema de recompensa por level. Bom jogo!" }, -- aviso em dawnport
	{ position = Position(32071, 31901, 5), text = "Do you wish be a rooker player? Talk with me!" }, -- aviso de rook
	--{ position = Position(32317, 32211, 6), text = 'Use " !reward " para conseguir sua varinha de treino gratis!', effect = CONST_ME_FIREAREA }, -- aviso barco thais
	--{ position = Position(32369, 32241, 7), text = 'Sejam Todos Bem Vindo', effect = CONST_ME_STUN }, -- templo thais
	{ position = Position(32378, 32240, 7), text = "EVENTOS !!", effect = 54 }, -- templo thais
	{ position = Position(32364, 32232, 7), text = "TRAINERS", effect = 62 }, -- templo thais
	{ position = Position(32362, 31785, 7), text = "TRAINERS", effect = 62 }, -- templo carlin
	{ position = Position(33221, 31818, 7), text = "TRAINERS", effect = 62 }, -- templo edron
	{ position = Position(32961, 32074, 8), text = "TRAINERS", effect = 62 }, -- templo venore
	{ position = Position(33210, 32453, 1), text = "TRAINERS", effect = 62 }, -- templo darashia
	{ position = Position(33196, 32849, 8), text = "TRAINERS", effect = 62 }, -- templo ank
	{ position = Position(32319, 32818, 7), text = "TRAINERS", effect = 62 }, -- templo lb
	{ position = Position(32785, 31249, 5), text = "TRAINERS", effect = 62 }, -- templo yalahar
	{ position = Position(33521, 32358, 7), text = "TRAINERS", effect = 62 }, -- templo roshamuul
	--{ position = Position(32374, 32236, 7), text = "ILHA TRADE !!", effect = 1 }, --templo thais
	--{ position = Position(32374, 32236, 7), text = "", effect = 2 }, -- ilha trade tp thais
	--{ position = Position(32379, 32247, 7), text = "SUPER ROLETA !!", effect = 36 },
	--{ position = Position(958, 1016, 6), text = "SUPER ROLETA 100 TC" },
--	{ position = Position(949, 1018, 6), text = "EXIT !!" }, -- saída super roleta
	--{ position = Position(32371, 32247, 7), text = "MEGA ROLETA !!", effect = 52 }, -- templo thais
	--{ position = Position(1118, 1044, 0), text = "MEGA ROLETA 200 TC" },
--	{ position = Position(1119, 1051, 0), text = "EXIT !!" }, -- saída mega roulet
--	{ position = Position(32357, 32245, 7), text = "IMBUEMENTS !!", effect = CONST_ME_FIREAREA },
	--{ position = Position(32364, 32236, 7), text = "HUNTS !!", effect = 71 }, -- tp thais
	--{ position = Position(32252, 32301, 12), text = 'GNOMPRONA HUNT!', effect = 71 }, -- tp hunts
	--{ position = Position(32540, 30939, 7), text = 'HUNTS VIP !', effect = 71 }, -- não existe
	--{ position = Position(33831, 31992, 7), text = 'SOULWAR HUNT!', effect = 71 }, -- não existe
	--{ position = Position(32364, 32234, 7), text = "BOSSES !!", effect = 40 }, -- tp thais
	--{ position = Position(31930, 32282, 7), text = "TEMPLO THAIS" }, -- tp bosses
	--{ position = Position(31882, 32285, 7), text = "TEMPLO THAIS" }, -- tp bosses 1 andar esquerda
	--{ position = Position(31882, 32285, 7), text = '2 Andar', effect = 40 }, -- tp bosses 1 andar esquerda
	--{ position = Position(31882, 32285, 7), text = "1 Andar" }, -- tp bosses 2 andar esquerda
	--{ position = Position(32261, 32261, 11), text = "TEMPLO THAIS" }, -- tp bosses 2 andar (caminho)
	--{ position = Position(32294, 32261, 11), text = "TEMPLO THAIS" }, -- tp bosses 2 andar (caminho)
	--{ position = Position(32308, 32259, 11), text = "TEMPLO THAIS" }, -- tp bosses 2 andar direita
	--{ position = Position(31893, 32239, 7), text = "TEMPLO THAIS" }, -- tp hunts
	--{ position = Position(32368, 32244, 7), text = "AREA VIP", effect = 61 },
	--{ position = Position(32369, 32244, 7), text = "", effect = 61 },
	--{ position = Position(32370, 32244, 7), text = "AREA VIP", effect = 61 },
	{ position = Position(1052, 1047, 6), text = "Use command [!snowball shoot] to use ice balls into enemies!" },
	--	{ position = Position(967, 974, 8), text = "QUEST LEVEL 999 + !!" },
	--	{ position = Position(967, 975, 8), text = "QUEST LEVEL 999 + !!" },
	--	{ position = Position(32347, 32231, 7), text = 'Acesso Dummies', effect = CONST_ME_FIREAREA },
	--	{ position = Position(32357, 32226, 7), text = 'Acesso Dummies', effect = CONST_ME_FIREAREA },
	--	{ position = Position(32369, 32245, 7), text = "QUEST LVL 500 +", effect = CONST_ME_FIREAREA },
	--	{ position = Position(32318, 31941, 7), text = "Welcome to Cassino Isle!", effect = 12 },
	--	{ position = Position(32350, 32231, 7), text = "CASSINO ISLE", effect = 29 },
	--{ position = Position(32360, 32239, 7), text = "REMOVE BAGS !!", effect = 38 },
--	{ position = Position(32357, 32237, 7), text = "VIP ITEMS BUYER !!", effect = 38 },
	--	{ position = Position(32378, 32239, 7), text = "Adventurer's Isle!", effect = 54 },
	--{ position = Position(32349, 32223, 7), text = 'Castle War', effect = 62 }, -- dp thais
	--{ position = Position(32349, 32224, 7), text = 'Castle War', effect = 62 }, -- dp thais
	--{ position = Position(32347, 32335, 8), text = 'Hunts !!' }, -- castle war
	--{ position = Position(32348, 32335, 8), text = '', effect = 40 }, -- castle war
	--{ position = Position(32349, 32335, 8), text = '', effect = 40 }, -- castle war
	--{ position = Position(32356, 32335, 8), text = 'Exit !!' }, -- castle war
	--{ position = Position(32357, 32335, 8), text = '', effect = 40 }, -- castle war
	{ position = Position(32363, 32237, 7), text = "DUNGEON !!", effect = 40 }, -- templo thais
	--{ position = Position(991, 992, 8), text = "TEMPLO THAIS !!" },
	--{ position = Position(991, 980, 8), text = "HUNT LVL 1K + !!" },
--	{ position = Position(984, 990, 7), text = "HUNTS !!" },
--	{ position = Position(981, 992, 7), text = "DUMMY TREINO !!" },
--	{ position = Position(977, 979, 7), text = "HUNTS !!" },
--	{ position = Position(970, 973, 8), text = "DP E REWARD CHEST !!" },
--	{ position = Position(1002, 994, 5), text = "REVOADA CITY !!" }, -- area vip
--	{ position = Position(32375, 32246, 8), text = "QUEST FINDER" }, -- revoada city
--	{ position = Position(2089, 1934, 8), text = "EXIT !!" }, -- tp hunts
--	{ position = Position(2074, 1908, 7), text = "TEMPLE THAIS !!" }, -- revoada city
--	{ position = Position(32379, 32246, 8), text = "QUEST FINDER" }, -- revoada city

	--{ position = Position(32372, 32231, 7), text = "-1-" },
	--{ position = Position(32371, 32231, 7), text = "-2-" },
	--{ position = Position(32373, 32231, 7), text = "-3-" },
}

local tileEffect = GlobalEvent("TileEffect")
function tileEffect.onThink(interval)
	for i = 1, #effects do
		local settings = effects[i]
		local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
		if #spectators > 0 then
			if settings.text then
				for i = 1, #spectators do
					spectators[i]:say(settings.text, TALKTYPE_MONSTER_SAY, false, spectators[i], settings.position)
				end
			end
			if settings.effect then
				settings.position:sendMagicEffect(settings.effect)
			end
		end
	end
	return true
end

tileEffect:interval(5000)
tileEffect:register()
