local internalNpcName = "Walter Jaeger"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 957,
	lookHead = 78,
	lookBody = 5,
	lookLegs = 5,
	lookFeet = 115,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

--
--	To-Do: Task hunting points history
--
local config = {
	enable = true,
	topics = {
		outfit = 1000,
		mount = 2000,
		trophy = 3000,
		furniture = 4000
	},
	outifts = {
		[1] = {
			name = "Falconer",
			looktype = {
				male = 1282, female = 1283
			},
			points = {
				base = 100000,
				addons = {
					first = 35000, second = 35000
				}
			}
		}
	},
	mounts = {
		[1] = {
			name = "Antelope",
			id = 163,
			points = 145000
		}
	},
	trophies = {
		[1] = {
			name = "gozzler trophy",
			id = 32751,
			points = 3000
		},
		[2] = {
			name = "bronze hunter trophy",
			id = 32754,
			points = 3000
		},
		[3] = {
			name = "sea serpent trophy",
			id = 32752,
			points = 15000
		},
		[4] = {
			name = "silver hunter trophy",
			id = 32755,
			points = 15000
		},
		[5] = {
			name = "many faces trophy",
			id = 36749,
			points = 50000
		},
		[6] = {
			name = "hellflayer trophy",
			id = 32753,
			points = 80000
		},
		[7] = {
			name = "gold hunter trophy",
			id = 32756,
			points = 80000
		},
		[8] = {
			name = "brachiodemon trophy",
			id = 36748,
			points = 80000
		}
	},
	furniture = {
		--[1] = {
		--	name = "bone bed",
		--	id = 32799,
		--	points = 35000
		--},
		[1] = {
			name = "falcon pet",
			id = 36750,
			points = 135000
		},
	}
}

local function getOfferIndex(name, offer, topic)
	for index, offerTable in ipairs(offer) do
		if name:lower() == (offerTable.name):lower() then
			return index + topic
		end
	end

	return 0
end

local function getOffersString(offer, showPrice)
	local string = ""

	if #offer == 0 then
		return string
	end

	for index, offerTable in ipairs(offer) do
		string = string .. "{" .. offerTable.name .. "}"

		if showPrice and type(offerTable.points) == "number" then
			string = string .. " (" .. tostring(offerTable.points) .. " HTP)"
		end

		if index ~= #offer then
			string = string .. ", "
		elseif index == (#offer - 1) then
			string = string .. " and "
		end
	end

	return string
end

local function getOfferByName(name, offer, topic)
	if offer == nil or #offer == 0 then
		return nil
	end

	for index, offerTable in ipairs(offer) do
		if name:lower() == (offerTable.name):lower() then
			if topic == config.topics.outfit then
				return {	offerId = index,
						name = offerTable.name,
						offerTopic = topic,
						base = offerTable.points.base,
						firstAddon = offerTable.points.addons.first,
						secondAddon = offerTable.points.addons.second,
						male = offerTable.looktype.male,
						female = offerTable.looktype.female
					}
			elseif topic == config.topics.mount then
				return {	offerId = index,
						name = offerTable.name,
						offerTopic = topic,
						value = offerTable.points,
						mountId = offerTable.id
					}
			elseif topic == config.topics.trophy or topic == config.topics.furniture then
				return {	offerId = index,
						name = offerTable.name,
						offerTopic = topic,
						value = offerTable.points,
						itemId = offerTable.id
					}
			end
		end
	end

	return nil
end

local function getOfferByIndex(offerIndex, offer, topic)
	if offer == nil or #offer == 0 then
		return nil
	end

	for index, offerTable in ipairs(offer) do
		if index == offerIndex then
			if topic == config.topics.outfit then
				return {	offerId = index,
						name = offerTable.name,
						offerTopic = topic,
						base = offerTable.points.base,
						firstAddon = offerTable.points.addons.first,
						secondAddon = offerTable.points.addons.second,
						male = offerTable.looktype.male,
						female = offerTable.looktype.female
					}
			elseif topic == config.topics.mount then
				return {	offerId = index,
						name = offerTable.name,
						offerTopic = topic,
						value = offerTable.points,
						mountId = offerTable.id
					}
			elseif topic == config.topics.trophy or topic == config.topics.furniture then
				return {	offerId = index,
						name = offerTable.name,
						offerTopic = topic,
						value = offerTable.points,
						itemId = offerTable.id
					}
			end
		end
	end

	return nil
end

local function getOfferString(name, offer, topic)
	local string = ""
	if offer == nil or #offer == 0 then
		return string
	end

	local offerTable = getOfferByName(name, offer, topic)
	if offerTable == nil then
		return string
	end

	if topic == config.topics.outfit then
		string = "The {base} " .. offerTable.name .. " outfit costs " .. tostring(offerTable.base) .. " HTP, the {first} addon " .. tostring(offerTable.firstAddon) .. " HTP and the {second} addon " .. tostring(offerTable.secondAddon) .. " HTP."
	elseif topic == config.topics.mount then
		string = "The {" .. offerTable.name .. "} mount costs " .. tostring(offerTable.value) .. " HTP."
	end

	return string
end

local function processItemInboxPurchase(player, name, id)
	if not(player) then
		return false
	end

	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	if inbox and inbox:getEmptySlots() > 0 then
		local decoKit = inbox:addItem(23398, 1)
		if decoKit then
			decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "You bought this item with the Walter Jaeger.\nUnwrap it in your own house to create a <" .. name .. ">.")
			decoKit:setCustomAttribute("unWrapId", id)
			return true
		end
	end

	return false
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	if MsgContains(message, "rewards") then
		npcHandler:say({
			"Finishing prey hunting tasks will give you hunting task points (HTP). These can be exchanged for items of the following categories: {outfit}, {mount}, {trophies} and {furniture}. ...",
			"Please note, that all items will be put into your Store inbox!"
		}, npc, creature, 100)
		npcHandler:setTopic(playerId, 1)

	elseif MsgContains(message, "tasks") then
		npcHandler:say("Prey hunting tasks should reduce the number of certain monsters. And if you fulfil them successfully I will show my appreciation and give you some {rewards} in exchange of hunting task points.", npc, creature)
		npcHandler:setTopic(playerId, 0)

	elseif MsgContains(message, "have") then
		npcHandler:say("Right now you have " .. player:getTaskHuntingPoints() .. " HTP.", npc, creature)
		npcHandler:setTopic(playerId, 0)

	-- Add task hunting points history here.
	--elseif MsgContains(message, "spent") then
	--	npcHandler:say("You have already spent " .. nil .. " HTP.", npc, creature)
	--	npcHandler:setTopic(playerId, 0)

	-- Rewards topic
	elseif npcHandler:getTopic(playerId) == 1 then
		if not(config.enable) then
			npcHandler:say("Sorry, i have no offer to make for you today.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "outfit") then
			if config == nil or config.outifts == nil or #(config.outifts) == 0 then
				npcHandler:say("I have no outfit offer to make.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("I offer you the " .. getOffersString(config.outifts, false) .. " outfit" .. (#(config.outifts) >= 1 and "s." or "."), npc, creature)
				npcHandler:setTopic(playerId, config.topics.outfit)
			end
		elseif MsgContains(message, "mount") then
			if config == nil or config.mounts == nil or #(config.mounts) == 0 then
				npcHandler:say("I have no mount offer to make.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("I offer you the " .. getOffersString(config.mounts, false) .. " mount" .. (#(config.mounts) >= 1 and "s." or "."), npc, creature)
				npcHandler:setTopic(playerId, config.topics.mount)
			end
		elseif MsgContains(message, "trophies") then
			if config == nil or config.trophies == nil or #(config.trophies) == 0 then
				npcHandler:say("I have no trophie offer to make.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("I offer you the " .. getOffersString(config.trophies, true) .. ".", npc, creature)
				npcHandler:setTopic(playerId, config.topics.trophy)
			end
		elseif MsgContains(message, "furniture") then
			if config == nil or config.furniture == nil or #(config.furniture) == 0 then
				npcHandler:say("I have no furniture offer to make.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("I offer you the " .. getOffersString(config.furniture, true) .. ".", npc, creature)
				npcHandler:setTopic(playerId, config.topics.furniture)
			end
		end

	-- Offer topics
	elseif npcHandler:getTopic(playerId) > 1 then
		if npcHandler:getTopic(playerId) == config.topics.outfit then
			if config ~= nil and config.outifts ~= nil and #(config.outifts) > 0 then
				npcHandler:say(getOfferString(message, config.outifts, npcHandler:getTopic(playerId)), npc, creature)
				npcHandler:setTopic(playerId, getOfferIndex(message, config.outifts, npcHandler:getTopic(playerId)))
			end
		elseif npcHandler:getTopic(playerId) == config.topics.mount then
			if config ~= nil and config.mounts ~= nil and #(config.mounts) > 0 then
				npcHandler:say(getOfferString(message, config.mounts, npcHandler:getTopic(playerId)), npc, creature)
				npcHandler:setTopic(playerId, getOfferIndex(message, config.mounts, npcHandler:getTopic(playerId)))
			end
		elseif npcHandler:getTopic(playerId) == config.topics.trophy then
			if config ~= nil and config.trophies ~= nil and #(config.trophies) > 0 then
				local offerTable = getOfferByName(message, config.trophies, npcHandler:getTopic(playerId))
				if offerTable ~= nil then
					if player:getTaskHuntingPoints() >= offerTable.value then
						if processItemInboxPurchase(player, offerTable.name, offerTable.itemId) and player:removeTaskHuntingPoints(offerTable.value) then
							npcHandler:say("Here you have it.", npc, creature)
						else
							npcHandler:say("Sorry, but you don't have enough slots on your inbox or capacity.", npc, creature)
						end
					else
						npcHandler:say("Sorry, but you don't have enough hunting task points.", npc, creature)
					end
				else
					return true
				end
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == config.topics.furniture then
			if config ~= nil and config.furniture ~= nil and #(config.furniture) > 0 then
				local offerTable = getOfferByName(message, config.furniture, npcHandler:getTopic(playerId))
				if offerTable ~= nil then
					if player:getTaskHuntingPoints() >= offerTable.value then
						if processItemInboxPurchase(player, offerTable.name, offerTable.itemId) and player:removeTaskHuntingPoints(offerTable.value) then
							npcHandler:say("Here you have it.", npc, creature)
						else
							npcHandler:say("Sorry, but you don't have enough slots on your inbox or capacity.", npc, creature)
						end
					else
						npcHandler:say("Sorry, but you don't have enough hunting task points.", npc, creature)
					end
				else
					return true
				end
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) > config.topics.outfit and npcHandler:getTopic(playerId) < config.topics.mount then
			if config ~= nil and config.outifts ~= nil and #(config.outifts) > 0 then
				local offerTable = getOfferByIndex(npcHandler:getTopic(playerId) - config.topics.outfit, config.outifts, config.topics.outfit)
				if offerTable ~= nil then
					if MsgContains(message, "base") then
						local points = offerTable.base
						if player:hasOutfit(offerTable.male) or player:hasOutfit(offerTable.female) then
							npcHandler:say("You already have this outfit.", npc, creature)
						elseif player:removeTaskHuntingPoints(points) then
							-- Add task hunting points history here.
							player:addOutfit(offerTable.male)
							player:addOutfit(offerTable.female)
							npcHandler:say("Here you have it.", npc, creature)
						end
					elseif MsgContains(message, "first") then
						local points = offerTable.firstAddon
						if not(player:hasOutfit(offerTable.male)) or not(player:hasOutfit(offerTable.female)) then
							npcHandler:say("First you need to buy the base addon to unlock this addon.", npc, creature)
						elseif player:hasOutfit(offerTable.male, 1) or player:hasOutfit(offerTable.female, 1) then
							npcHandler:say("You already have this addon.", npc, creature)
						elseif player:removeTaskHuntingPoints(points) then
							-- Add task hunting points history here.
							player:addOutfitAddon(offerTable.male, 1)
							player:addOutfitAddon(offerTable.female, 1)
							npcHandler:say("Here you have it.", npc, creature)
						else
							npcHandler:say("Sorry, but you don't have enough hunting task points.", npc, creature)
						end
					elseif MsgContains(message, "second") then
						local points = offerTable.secondAddon
						if not(player:hasOutfit(offerTable.male)) or not(player:hasOutfit(offerTable.female)) then
							npcHandler:say("First you need to buy the base addon to unlock this addon.", npc, creature)
						elseif player:hasOutfit(offerTable.male, 2) or player:hasOutfit(offerTable.female, 2) then
							npcHandler:say("You already have this addon.", npc, creature)
						elseif player:removeTaskHuntingPoints(points) then
							-- Add task hunting points history here.
							player:addOutfitAddon(offerTable.male, 2)
							player:addOutfitAddon(offerTable.female, 2)
							npcHandler:say("Here you have it.", npc, creature)
						else
							npcHandler:say("Sorry, but you don't have enough hunting task points.", npc, creature)
						end
					else
						return true
					end
				else
					return true
				end
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) > config.topics.mount and npcHandler:getTopic(playerId) < config.topics.trophy then
			if config ~= nil and config.mounts ~= nil and #(config.mounts) > 0 then
				local offerTable = getOfferByIndex(npcHandler:getTopic(playerId) - config.topics.mount, config.mounts, config.topics.mount)
				if offerTable ~= nil then
					local points = offerTable.value
					if player:hasMount(offerTable.mountId) then
						npcHandler:say("You already have this mount.", npc, creature)
					elseif player:removeTaskHuntingPoints(points) then
						-- Add task hunting points history here.
						player:addMount(offerTable.mountId)
						npcHandler:say("Here you have it.", npc, creature)
					end
				else
					return true
				end
			end
			npcHandler:setTopic(playerId, 0)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Good hunting! I can offer you some lovely {rewards} for finishing prey hunting tasks! Furthermore I can tell you how many hunting task points (HTP) you actually {have} and you have already {spent}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Keep on hunting!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Keep on hunting!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
