Blessings = {}

Blessings.Credits = {
	Developer = "Charles (Cjaker), DudZ",
	Version = "2.0",
	lastUpdate = "08/04/2020",
	todo = {
		"Insert & Select query in blessings_history",
		"Add unfair fight reductio (convert the get killer is pvp fight with getDamageMap of dead player)",
		"Gamestore buy blessing",
		"Test ank print text",
		"Test all functions",
		"Test henricus prices/blessings",
		"Add data \\movements\\scripts\\quests\\cults of tibia\\icedeath.lua blessing information",
		"WotE data\\movements\\scripts\\quests\\wrath of the emperor\\realmTeleport.lua has line checking if player has bless 1??? wtf",
		"add blessings module support npc\\lib\\npcsystem\\modules.lua",
		"Fix store buying bless",
		"Check if store is inside lua or source..."
	}
}

Blessings.Config = {
	AdventurerBlessingLevel = 0, -- Free full bless until level
	HasToF = false, -- Enables/disables twist of fate
	InquisitonBlessPriceMultiplier = 1.1, -- Bless price multiplied by henricus
	SkulledDeathLoseStoreItem = true, -- Destroy all items on store when dying with red/blackskull
	InventoryGlowOnFiveBless = true, -- Glow in yellow inventory items when the player has 5 or more bless,
	Debug = false -- Prin debug messages in console if enabled
}

dofile('data/modules/scripts/blessings/assets.lua')

--[=====[
--
-- Table structure `blessings_history`
--

CREATE TABLE IF NOT EXISTS `blessings_history` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `blessing` tinyint(4) NOT NULL,
  `loss` tinyint(1) NOT NULL,
  `timestamp` int(11) NOT NULL,
  CONSTRAINT `blessings_history_pk` PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--]=====]

Blessings.DebugPrint = function(content, pre, pos)
	if not Blessings.Config.Debug then
		return
	end
	if pre == nil then
		pre = ""
	else
		pre = pre.. " "
	end
	if pos == nil then
		pos = ""
	else
		pos = " " .. pos
	end
	if type(content) == "boolean" then
		Spdlog.debug(string.format("[Blessings] START BOOL - %s", pre))
		Spdlog.debug(content)
		Spdlog.debug(string.format("[Blessings] END BOOL - %s", pos))
	else
		Spdlog.debug(string.format("[Blessings] pre:[%s], content[%s], pos[%s]",
			pre, content, pos))
	end
end

Blessings.C_Packet = {
	OpenWindow = 0xCF
}

Blessings.S_Packet  = {
	BlessDialog = 0x9B,
	BlessStatus = 0x9C
}

function onRecvbyte(player, msg, byte)
	if (byte == Blessings.C_Packet.OpenWindow) then
		Blessings.sendBlessDialog(player)
	end
end

Blessings.sendBlessStatus = function(player, curBless)
	-- why not using ProtocolGame::sendBlessStatus ?
	local msg = NetworkMessage()
	msg:addByte(Blessings.S_Packet.BlessStatus)
	callback = function(k) return true end
	if curBless == nil then
		curBless = player:getBlessings(callback) -- ex: {1, 2, 5, 7}
	end
	Blessings.DebugPrint(#curBless, "sendBlessStatus curBless")
	local bitWiseCurrentBless = 0
	local blessCount = 0

	for i = 1, #curBless do
		if curBless[i].losscount then
			blessCount = blessCount + 1
		end
		if (not curBless[i].losscount and Blessings.Config.HasToF) or curBless[i].losscount then
			bitWiseCurrentBless = bit.bor(bitWiseCurrentBless, Blessings.BitWiseTable[curBless[i].id])
		end
	end

	if blessCount > 5 and Blessings.Config.InventoryGlowOnFiveBless then
		bitWiseCurrentBless = bit.bor(bitWiseCurrentBless, 1)
	end

	msg:addU16(bitWiseCurrentBless)
	msg:addByte(blessCount >= 7 and 3 or (blessCount > 0 and 2 or 1)) -- Bless dialog button colour 1 = Disabled | 2 = normal | 3 = green

	-- if #curBless >= 5 then
	-- 	msg:addU16(1) -- TODO ?
	-- else
	-- 	msg:addU16(0)
	-- end

	msg:sendToPlayer(player)
end

Blessings.sendBlessDialog = function(player)
	-- TODO: Migrate to protocolgame.cpp
	local msg = NetworkMessage()
	msg:addByte(Blessings.S_Packet.BlessDialog)

	callback = function(k) return true end
	local curBless = player:getBlessings()

	msg:addByte(Blessings.Config.HasToF and #Blessings.All or (#Blessings.All - 1)) -- total blessings
	for k = 1, #Blessings.All do
		v = Blessings.All[k]
		if v.type ~= Blessings.Types.PvP or Blessings.Config.HasToF then
			msg:addU16(Blessings.BitWiseTable[v.id])
			msg:addByte(player:getBlessingCount(v.id))
			msg:addByte(0) -- Store Blessings Count
		end
	end

	local promotion = (player:isPremium() and player:isPromoted()) and 30 or 0
	local PvPminXPLoss = Blessings.LossPercent[#curBless].skill + promotion
	local PvPmaxXPLoss = PvPminXPLoss
	if Blessings.Config.HasToF then
		PvPmaxXPLoss = math.floor(PvPminXPLoss * 1.15)
	end
	local PvEXPLoss = PvPminXPLoss

	local playerAmulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	local haveSkull = player:getSkull() >= 4
	hasAol = (playerAmulet and playerAmulet:getId() == ITEM_AMULETOFLOSS)

	equipLoss = Blessings.LossPercent[#curBless].item
	if haveSkull then
		equipLoss = 100
	elseif hasAol then
		equipLoss = 0
	end

	msg:addByte(2) -- BYTE PREMIUM (only work with premium days)
	msg:addByte(promotion) -- XP Loss Lower POR SER PREMIUM
	msg:addByte(PvPminXPLoss) -- XP/Skill loss min pvp death
	msg:addByte(PvPmaxXPLoss) -- XP/Skill loss max pvp death
	msg:addByte(PvEXPLoss) -- XP/Skill pve death
	msg:addByte(equipLoss) -- Equip container lose pvp death
	msg:addByte(equipLoss) -- Equip container pve death

	msg:addByte(haveSkull and 1 or 0) -- is red/black skull
	msg:addByte(hasAol and 1 or 0)


	-- History
	local historyAmount = 1
	msg:addByte(historyAmount) -- History log count
	for i = 1, historyAmount do
		msg:addU32(os.time()) -- timestamp
		msg:addByte(0) -- Color message (1 - Red | 0 = White loss)
		msg:addString("Blessing Purchased") -- History message
	end

	msg:sendToPlayer(player)
end

Blessings.getBlessingsCost = function(level)
	if level <= 30 then
		return 2000
	elseif level >= 120 then
		return 20000
	else
		return (level - 20) * 200
	end
end

Blessings.getPvpBlessingCost = function(level)
	if level <= 30 then
		return 2000
	elseif level >= 270 then
		return 50000
	else
		return (level - 20) * 200
	end
end

Blessings.useCharm = function(player, item)
	for index, value in pairs(Blessings.All) do
		if item.itemid == value.charm then
			if not value then
				return true
			end

			if player:hasBlessing(value.id) then
				player:say('You already possess this blessing.', TALKTYPE_MONSTER_SAY)
				return true
			end

			player:addBlessing(value.id, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.name .. ' protects you.')
			player:getPosition():sendMagicEffect(CONST_ME_LOSEENERGY)
			item:remove(1)
			return true
		end
	end
end

Blessings.checkBless = function(player)
	local result, bless = 'Received blessings:'
	for k, v in pairs(Blessings.All) do
		result = player:hasBlessing(k) and result .. '\n' .. v.name or result
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 20 > result:len() and 'No blessings received.' or result)
	return true
end

Blessings.doAdventurerBlessing = function(player)
	if player:getLevel() > Blessings.Config.AdventurerBlessingLevel then
		return true
	end
	player:addMissingBless(true, true)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE,'You received adventurers blessings for you being level lower than ' .. Blessings.Config.AdventurerBlessingLevel .. '!')
	player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
	return true
end

Blessings.getInquisitionPrice = function(player)
	-- Find how many missing bless we have and give out the price
	inquifilter = function(b) return b.inquisition end
	donthavefilter = function(p, b) return not p:hasBlessing(b) end
	local missing = #player:getBlessings(filter, donthavefilter)
	local totalBlessPrice = Blessings.getBlessingsCost(player:getLevel()) * missing * Blessings.Config.InquisitonBlessPriceMultiplier
	return missing, totalBlessPrice
end

Blessings.DropLoot = function(player, corpse, chance, skulled)
	local multiplier = 100 -- Improve the loot randomness spectrum
	math.randomseed(os.time()) -- Improve the loot randomness spectrum
	chance = chance * multiplier
	Blessings.DebugPrint(chance, "DropLoot chance")
	for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local item = player:getSlotItem(i)
		if item then
			local thisChance = chance
			local thisRandom = math.random(100*multiplier)
			if not item:isContainer() then
				thisChance = chance/10
			end
			Blessings.DebugPrint(thisChance/multiplier .. "%" .. " | thisRandom "..thisRandom/multiplier.."%", "DropLoot item "..item:getName() .. " |")
			if skulled or thisRandom <= thisChance then
				Blessings.DebugPrint("Dropped "..item:getName())
				item:moveTo(corpse)
			end
		end
	end
	if skulled and Blessings.Config.SkulledDeathLoseStoreItem then
		local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
		local inboxsize = inbox:getSize() - 1
		for i = 0, inboxsize do
			inbox:getItem(i):destroy()
		end
	end
end

Blessings.ClearBless = function(player, killer, currentBless)
	Blessings.DebugPrint(#currentBless, "ClearBless #currentBless")
	local hasToF = Blessings.Config.HasToF and player:hasBlessing(1) or false
	if hasToF and killer (killer:isPlayer() or (killer:getMaster() and killer:getMaster():isPlayer())) then -- TODO add better check if its pvp or pve
		player:removeBlessing(1)
		return
	end
	for i = 1, #currentBless do

		Blessings.DebugPrint(i, "ClearBless curBless i", " | "..currentBless[i].name)
		player:removeBlessing(currentBless[i].id, 1)
	end
end


Blessings.BuyAllBlesses = function(player)
	if not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) and (player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT))  then
		player:sendCancelMessage("You can't buy bless while in battle.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return
	end

	local blessCost = Blessings.getBlessingsCost(player:getLevel())
	local PvPBlessCost = Blessings.getPvpBlessingCost(player:getLevel())
	local hasToF = Blessings.Config.HasToF and player:hasBlessing(1) or true
	donthavefilter = function(p, b) return not p:hasBlessing(b) end
	local missingBless = player:getBlessings(nil,donthavefilter)
	local missingBlessAmt = #missingBless + (hasToF and 0 or 1)
	local totalCost = blessCost * #missingBless

	if missingBlessAmt == 0 then
		player:sendCancelMessage("You are already blessed.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return
	end
	if not hasToF then
		totalCost = totalCost + PvPBlessCost
	end

	if player:removeMoneyNpc(totalCost) then
		for i, v in ipairs(missingBless) do
			player:addBlessing(v.id, 1)
		end
		player:sendCancelMessage("You received the remaining " .. missingBlessAmt .. " blesses for a total of " .. totalCost .." gold.")
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	else
		player:sendCancelMessage("You don't have enough money. You need " .. totalCost .. " to buy all blesses.", cid)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end

end

Blessings.PlayerDeath = function(player, corpse, killer)
	local hasToF = Blessings.Config.HasToF and player:hasBlessing(1) or false
	local hasAol = (player:getSlotItem(CONST_SLOT_NECKLACE) and player:getSlotItem(CONST_SLOT_NECKLACE):getId() == ITEM_AMULETOFLOSS)
	local haveSkull = isInArray({SKULL_RED, SKULL_BLACK}, player:getSkull())
	local curBless = player:getBlessings()

	if haveSkull then  -- lose all bless + drop all items
		Blessings.DropLoot(player, corpse, 100, true)
	elseif #curBless < 5 and not hasAol then -- lose all items
		local equipLoss = Blessings.LossPercent[#curBless].item
		Blessings.DropLoot(player, corpse, equipLoss)
	elseif #curBless < 5 and hasAol and not hasToF then
		player:removeItem(ITEM_AMULETOFLOSS, 1, -1, false)
	end
	--Blessings.ClearBless(player, killer, curBless) IMPLEMENTED IN SOURCE BECAUSE THIS WAS HAPPENING BEFORE SKILL/EXP CALCULATIONS


	if not player:getSlotItem(CONST_SLOT_BACKPACK) then
		player:addItem(ITEM_BAG, 1, false, CONST_SLOT_BACKPACK)
	end

	return true
end

function Player.getBlessings(self, filter, hasblessingFilter)
	local blessings = {}
	if filter == nil then
		filter = function(b) return b.losscount end
	end

	if hasblessingFilter == nil then
		hasblessingFilter = function(p, b) return p:hasBlessing(b) end
	end
	for k, v in pairs(Blessings.All) do
		if filter(v) and hasblessingFilter(self, k) then
			table.insert(blessings, v)
		end
	end
	return blessings
end

function Player.addMissingBless(self, all, tof)
	if all == nil then
		all = true
	end
	if tof == nil then
		tof = false
	elseif tof then
		tof = tof and Blessings.Config.HasToF
	end
	for k, v in pairs(Blessings.All) do
		if all or (v.type == Blessings.Types.REGULAR) or (tof and v.type == Blessings.Types.PvP) then
			if not self:hasBlessing(k) then
				self:addBlessing(k, 1)
			end
		end
	end
	Blessings.sendBlessStatus(self)
end
