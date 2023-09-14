local decayItems = {
	[2772] = 2773, [2773] = 2772
}
local slots = {
	-- aqui sao os slots da esteira, por onde os itens vao ir passando... podem ser adicionados quantos quiser...
	Position(1034, 958, 6), Position(1035, 958, 6), Position(1036, 958, 6), Position(1037, 958, 6),	Position(1038, 958, 6),
	Position(1039, 958, 6), Position(1040, 958, 6), Position(1041, 958, 6), Position(1042, 958, 6)
}

local itemtable = {
	--aqui pode ter ate 100 itens.. a chance nunca pode se repetir, ela deve ser de a 100...
	-- inserir os itens respeitando a ordem: [, [2], [3], ...  ate o ultimo [100]
	[1] = {id = 43895, chance = 1},  -- bag you covet
	[2] = {id = 5903, chance = 2}, -- Ferumbras' hat
	[3] = {id = 30317, chance = 3}, -- Ferumbras Puppet
	[4] = {id = 3393, chance = 4}, -- 
	[5] = {id = 3394, chance = 5},
	[6] = {id = 3437, chance = 6},
	[7] = {id = 3365, chance = 7},
	[8] = {id = 37164, chance = 8},
	[9] = {id = 31633, chance = 9},
	[10] = {id = 39546, chance = 10},
	[11] = {id = 34109, chance = 11},
	[12] = {id = 3555, chance = 12},
	[13] = {id = 37536, chance = 13},
	[14] = {id = 14674, chance = 14},
	[15] = {id = 10346, chance = 15},
	[16] = {id = 24395, chance = 16},
	[17] = {id = 39693, chance = 17},
	[18] = {id = 5908, chance = 18},
	[19] = {id = 13430, chance = 19},
	[20] = {id = 9598, chance = 20},
	[21] = {id = 9594, chance = 21},
	[22] = {id = 9599, chance = 22},
	[23] = {id = 9596, chance = 23},
	[24] = {id = 3043, chance = 24},
	[25] = {id = 3043, chance = 25},
	[26] = {id = 3043, chance = 26},
	[27] = {id = 3043, chance = 27},
	[28] = {id = 3043, chance = 28},
	[29] = {id = 3043, chance = 29},
	[30] = {id = 3043, chance = 30},
	[31] = {id = 3043, chance = 31},
	[32] = {id = 3043, chance = 32},
	[33] = {id = 3043, chance = 33},
	[34] = {id = 3043, chance = 34},
	[35] = {id = 3043, chance = 35},
	[36] = {id = 3043, chance = 36},
	[37] = {id = 3043, chance = 37},
	[38] = {id = 3043, chance = 38},
	[39] = {id = 3043, chance = 39},
	[40] = {id = 3043, chance = 40},
	[41] = {id = 3043, chance = 41},
	[42] = {id = 3043, chance = 42},
[43] = {id = 3043, chance = 43},
[44] = {id = 3043, chance = 44},
[45] = {id = 3043, chance = 45},
[46] = {id = 3043, chance = 46},
[47] = {id = 3043, chance = 47},
[48] = {id = 3043, chance = 48},
[49] = {id = 3043, chance = 49},
[50] = {id = 3043, chance = 50},
[51] = {id = 3043, chance = 51},
[52] = {id = 3043, chance = 52},
[53] = {id = 3043, chance = 53},
[54] = {id = 3043, chance = 54},
[55] = {id = 3043, chance = 55},
[56] = {id = 3043, chance = 56},
[57] = {id = 3043, chance = 57},
[58] = {id = 3043, chance = 58},
[59] = {id = 3043, chance = 59},
[60] = {id = 3043, chance = 60},
[61] = {id = 3043, chance = 61},
[62] = {id = 3043, chance = 62},
[63] = {id = 3043, chance = 63},
[64] = {id = 3043, chance = 64},
[65] = {id = 3043, chance = 65},
[66] = {id = 3043, chance = 66},
[67] = {id = 3043, chance = 67},
[68] = {id = 3043, chance = 68},
[69] = {id = 3043, chance = 69},
[70] = {id = 3043, chance = 70},
[71] = {id = 3043, chance = 71},
[72] = {id = 3043, chance = 72},
[73] = {id = 3043, chance = 73},
[74] = {id = 3043, chance = 74},
[75] = {id = 3043, chance = 75},
[76] = {id = 3043, chance = 76},
[77] = {id = 3043, chance = 77},
[78] = {id = 3043, chance = 78},
[79] = {id = 3043, chance = 79},
[80] = {id = 3043, chance = 80},
[81] = {id = 3043, chance = 81},
[82] = {id = 3043, chance = 82},
[83] = {id = 3043, chance = 83},
[84] = {id = 3043, chance = 84},
[85] = {id = 3043, chance = 85},
[86] = {id = 3043, chance = 86},
[87] = {id = 3043, chance = 87},
[88] = {id = 3043, chance = 88},
[89] = {id = 3043, chance = 89},
[90] = {id = 3043, chance = 90},
[91] = {id = 3043, chance = 91},
[92] = {id = 3043, chance = 92},
[93] = {id = 3043, chance = 93},
[94] = {id = 3043, chance = 94},
[95] = {id = 3043, chance = 95},
[96] = {id = 3043, chance = 96},
[97] = {id = 3043, chance = 97},
[98] = {id = 3043, chance = 98},
[99] = {id = 3043, chance = 99},
[100] = {id = 3043, chance = 100},


}

local function ender(cid, position)
	local player = Player(cid)
	local posicaofim = Position(1028, 958, 6) -- AQUI VAI APARECER A SETA, que define o item que o player ganhou
	local item = Tile(posicaofim):getTopDownItem()
	if item then
		local itemId = item:getId()
		posicaofim:sendMagicEffect(CONST_ME_TUTORIALARROW)
		player:addItem(itemId, 1)
	end
	local alavanca = Tile(position):getTopDownItem()
	if alavanca then
		alavanca:setActionId(18562) -- aqui volta o actionid antigo, para permitir uma proxima jogada...
	end
	if itemId == 3031 or itemId == 3043 then --checar se é o ID do item LENDARIO
		broadcastMessage("O player "..player:getName().." ganhou "..item:getName().."", MESSAGE_EVENT_ADVANCE) -- se for item raro mandar no broadcast
		
		for _, pid in ipairs(getPlayersOnline()) do
			if pid ~= cid then
				pid:say("O player "..player:getName().." ganhou "..item:getName().."", TALKTYPE_MONSTER_SAY) -- se nao for lendario, mandar uma mensagem comum
			end
		end
	end
end

local function delay(position, aux)
	local item = Tile(position):getTopDownItem()
	if item then
		local slot = aux + 1
		item:moveTo(slots[slot])
	end	
end

local function exec(cid)
	--calcular uma chance e atribuir um item
	local rand = math.random(1, 100)
	local aux, memo = 0, 0
	if rand >= 1 then
		for i = 1, #itemtable do
			local randitemid = itemtable[i].id
			local randitemchance = itemtable[i].chance
			if rand >= randitemchance then
				aux = aux + 1
				memo = randitemchance
			end
			
		end
	end
	-- Passo um: Criar um item no primeiro SLOT, e deletar se houver o item do ultimo slot.
	Game.createItem(itemtable[aux].id, 1, slots[1])
	slots[1]:sendMagicEffect(CONST_ME_POFF)
	local item = Tile(slots[#slots]):getTopDownItem()
	if item then
		item:remove()
	end
	--Passo dois: Mover itens para o proximo slot em todos os slots de 1 a 9 para o 2 > 10
	local maxslot = #slots-1
	local lastloop = 0
	for i = 1, maxslot do
			
		addEvent(delay, 1*1*60, slots[i], i)
	end
end

local newLottery = Action()

function newLottery.onUse(cid, item, fromPosition, itemEx, toPosition)
	local player = Player(cid)
	if not player then
		return false
	end
	if not player:removeItem(9219, 1) then -- PARA JOGAR o player precisa ter o item 5091, que representa um bilhete vendido na store ou em um npc....
		return false
	end
	
	item:transform(decayItems[item.itemid])
	item:decay()	
	--muda actionid do item para nao permitir executar duas instancias
	item:setActionId(18563)
	
	local segundos = 30
	local loopsize = segundos*2
	
	for i = 1, loopsize do
		addEvent(exec, 1*i*500, cid.uid)
	end
	addEvent(ender, (1*loopsize*500)+1000, cid.uid, fromPosition)
	
	return true
end

newLottery:aid(118562)
newLottery:register()
