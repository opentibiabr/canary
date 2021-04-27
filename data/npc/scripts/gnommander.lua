local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local speech = {
	"I'm the operating commander of the Spike, the latest great accomplishment of the gnomish race.",
	"The Spike is a crystal structure, created by our greatest crystal experts. It has grown from a crystal the size of my fist to the structure you see here and now.",
	"Of course this did not happen from one day to the other. It's the fruit of the work of several gnomish generations. Its purpose has changed in the course of time.",
	"At first it was conceived as a fast growing resource node. Then it was planned to become the prototype of a new type of high security base.",
	"Now it has become a military base and a weapon. With our foes occupied elsewhere, we can prepare our strike into the depths of the earth.",
	"This crystal can withstand extreme pressure and temperature, and it's growing deeper and deeper even as we speak.",
	"The times of the fastest growth have come to an end, however, and we have to slow down in order not to risk the structural integrity of the Spike. But we are on our way and have to do everything possible to defend the Spike."
}

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

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	if msgcontains(msg, 'commander') then
		return npcHandler:say('I\'m responsible for the security and reward heroes to our cause. If you are looking for missions, talk to Gnomilly, Gnombold and Gnomagery.', cid)
	end

	if msgcontains(msg, 'reward') then
		return npcHandler:say('I can sell special outfit parts. If your fame is high enough, you might be {worthy} of such a reward.', cid)
	end

	if msgcontains(msg, 'spike') then
		return npcHandler:say(speech, cid)
	end

	if msgcontains(msg, 'worthy') then
		if player:getFamePoints() < 100 then
			return npcHandler:say('You are not worthy of a special reward yet.', cid)
		end

		talkState[cid] = 'worthy'
		return npcHandler:say('You can acquire the {basic} outfit for 1000 Gold, the {first} addon for 2000 gold and the {second} addon for 3000 gold. Which do you want to buy?', cid)
	end

	if talkState[cid] == 'worthy' then
		if msgcontains(msg, 'basic') then
			if getPlayerLevel(cid) < 25 then
				talkState[cid] = nil
				return npcHandler:say('You do not have enough level yet.', cid)
			end

			if player:hasOutfit(player:getSex() == 0 and 575 or 574) then
				talkState[cid] = nil
				return npcHandler:say('You already have that outfit.', cid)
			end

			talkState[cid] = 'basic'
			return npcHandler:say('Do you want to buy the basic outfit for 1000 Gold?', cid)
		elseif msgcontains(msg, 'first') then
			if getPlayerLevel(cid) < 50 then
				talkState[cid] = nil
				return npcHandler:say('You do not have enough level yet.', cid)
			end

			if not player:hasOutfit(player:getSex() == 0 and 575 or 574) then
				talkState[cid] = nil
				return npcHandler:say('You do not have the Cave Explorer outfit.', cid)
			end

			if player:hasOutfit(player:getSex() == 0 and 575 or 574, 1) then
				talkState[cid] = nil
				return npcHandler:say('You already have that addon.', cid)
			end

			talkState[cid] = 'first'
			return npcHandler:say('Do you want to buy the first addon for 2000 Gold?', cid)
		elseif msgcontains(msg, 'second') then
			if getPlayerLevel(cid) < 80 then
				talkState[cid] = nil
				return npcHandler:say('You do not have enough level yet.', cid)
			end

			if not player:hasOutfit(player:getSex() == 0 and 575 or 574) then
				talkState[cid] = nil
				return npcHandler:say('You do not have the Cave Explorer outfit.', cid)
			end

			if player:hasOutfit(player:getSex() == 0 and 575 or 574, 2) then
				talkState[cid] = nil
				return npcHandler:say('You already have that addon.', cid)
			end

			talkState[cid] = 'second'
			return npcHandler:say('Do you want to buy the second addon for 3000 Gold?', cid)
		end
	end

	if talkState[cid] == 'basic' then
		if msgcontains(msg, 'yes') then
			if not player:removeMoney(1000) then
				talkState[cid] = nil
				return npcHandler:say('You do not have that money.', cid)
			end
		end
		player:removeFamePoints(100)
		player:addOutfit(player:getSex() == 0 and 575 or 574)
		talkState[cid] = nil
		return npcHandler:say('Here it is.', cid)
	elseif talkState[cid] == 'first' then
		if msgcontains(msg, 'yes') then
			if not player:removeMoney(2000) then
				talkState[cid] = nil
				return npcHandler:say('You do not have that money.', cid)
			end
		end
		player:removeFamePoints(100)
		player:addOutfitAddon(player:getSex() == 0 and 575 or 574, 1)
		talkState[cid] = nil
		return npcHandler:say('Here it is.', cid)
	elseif talkState[cid] == 'second' then
		if msgcontains(msg, 'yes') then
			if not player:removeMoney(3000) then
				talkState[cid] = nil
				return npcHandler:say('You do not have that money.', cid)
			end
		end
		player:removeFamePoints(100)
		player:addOutfitAddon(player:getSex() == 0 and 575 or 574, 2)
		talkState[cid] = nil
		return npcHandler:say('Here it is.', cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
