local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

-- ID, Count, Price
local eventShopItems = {
	["stamina refill low"] = {1000, 1, 10},
	["stamina refill medium"] = {1000, 1, 20},
	["stamina refill high"] = {1000, 1, 30},
	["blood herb"] = {2798, 10, 3}
}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	msg = string.lower(msg)
	if (msg == "ofertas") then
		local answerOffers = ""
		for i, v in pairs(eventShopItems) do
			answerOffers = answerOffers.. " {" ..i.."} (" ..v[2].. "x) - " ..v[3].." event token(s) |"
		end
		npcHandler:say("Eu troco os itens: " ..answerOffers, cid)
	elseif (msg == "event shop") then
		npcHandler:say("Entre no nosso site, clique em {Events} => {Events Shop}.", cid)
	end

	if (eventShopItems[msg]) then
		npcHandler.topic[cid] = 0
		local itemId, itemCount, itemPrice = eventShopItems[msg][1], eventShopItems[msg][2], eventShopItems[msg][3]
		if (player:getItemCount(26143) > 0) then
			npcHandler:say("Deseja comprar o item {" ..msg.. "} por " ..itemPrice.. "x?", cid)
			npcHandler.topic[cid] = msg
		else
			npcHandler:say("Voc� n�o tem " ..itemPrice.. " {Event Token(s)}!", cid)
			return true
		end
	end

	if (eventShopItems[npcHandler.topic[cid]]) then
		local itemId, itemCount, itemPrice = eventShopItems[npcHandler.topic[cid]][1], eventShopItems[npcHandler.topic[cid]][2], eventShopItems[npcHandler.topic[cid]][3]
		if (msg == "no" or
			msg == "n�o") then
			npcHandler:say("Ent�o qual item deseja comprar?", cid)
			npcHandler.topic[cid] = 0
		elseif (msg == "yes" or
				msg == "sim") then
			if (player:getItemCount(26143) > 0) then
				npcHandler:say("Voc� comprou o Item {" ..npcHandler.topic[cid].."} " ..itemCount.. "x por " ..itemPrice.. " {Event Token(s)}!", cid)
				player:removeItem(26143, itemPrice)
				player:addItem(itemId, itemCount)
			end
		end
	end
end

local voices = { {text = 'Troco itens por Event Tokens, venha ver minhas ofertas!'} }
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, 'Ol�, |PLAYERNAME|! Caso n�o me conhe�a, v� no site e clique em {Event Shop}. Deseja trocar seus Event Tokens? fale {ofertas}.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Foi �timo negociar com voc�, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Foi �timo negociar com voc�, |PLAYERNAME|.')
npcHandler:addModule(FocusModule:new())
