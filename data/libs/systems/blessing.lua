Blessings = {}

Blessings.Credits = {
	Developer = "Charles (Cjaker), DudZ",
	Version = "2.0",
	lastUpdate = "08/04/2020",
	todo = {
		"Insert & Select query in blessings_history",
	},
}

Blessings.Config = {
	AdventurerBlessingLevel = configManager.getNumber(configKeys.ADVENTURERSBLESSING_LEVEL), -- Free full bless until level
	HasToF = not configManager.getBoolean(configKeys.TOGGLE_SERVER_IS_RETRO), -- Enables/disables twist of fate
	InquisitonBlessPriceMultiplier = 1.1, -- Bless price multiplier by henricus
	SkulledDeathLoseStoreItem = configManager.getBoolean(configKeys.SKULLED_DEATH_LOSE_STORE_ITEM), -- Destroy all items on store when dying with red/blackskull
}

Blessings.Types = {
	REGULAR = 1,
	ENHANCED = 2,
	PvP = 3,
}

Blessings.All = {
	[1] = { id = 1, name = "Twist of Fate", type = Blessings.Types.PvP },
	[2] = { id = 2, name = "The Wisdom of Solitude", charm = 10345, type = Blessings.Types.REGULAR, losscount = true, inquisition = true },
	[3] = { id = 3, name = "The Spark of the Phoenix", charm = 10341, type = Blessings.Types.REGULAR, losscount = true, inquisition = true },
	[4] = { id = 4, name = "The Fire of the Suns", charm = 10344, type = Blessings.Types.REGULAR, losscount = true, inquisition = true },
	[5] = { id = 5, name = "The Spiritual Shielding", charm = 10343, type = Blessings.Types.REGULAR, losscount = true, inquisition = true },
	[6] = { id = 6, name = "The Embrace of Tibia", charm = 10342, type = Blessings.Types.REGULAR, losscount = true, inquisition = true },
	[7] = { id = 7, name = "Heart of the Mountain", charm = 25360, type = Blessings.Types.ENHANCED, losscount = true, inquisition = false },
	[8] = { id = 8, name = "Blood of the Mountain", charm = 25361, type = Blessings.Types.ENHANCED, losscount = true, inquisition = false },
}

Blessings.LossPercent = {
	[0] = { item = 100, skill = 0 },
	[1] = { item = 70, skill = 8 },
	[2] = { item = 45, skill = 16 },
	[3] = { item = 25, skill = 24 },
	[4] = { item = 10, skill = 32 },
	[5] = { item = 0, skill = 40 },
	[6] = { item = 0, skill = 48 },
	[7] = { item = 0, skill = 56 },
	[8] = { item = 0, skill = 56 },
}

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
	if pre == nil then
		pre = ""
	else
		pre = pre .. " "
	end
	if pos == nil then
		pos = ""
	else
		pos = " " .. pos
	end
	if type(content) == "boolean" then
		logger.debug("[Blessings] START BOOL - {}", pre)
		logger.debug(content)
		logger.debug("[Blessings] END BOOL - {}", pos)
	else
		logger.debug("[Blessings] pre:[{}], content[{}], pos[{}]", pre, content, pos)
	end
end

Blessings.PlayerDeath = function(player, corpse, killer)
	local hasAol = (player:getSlotItem(CONST_SLOT_NECKLACE) and player:getSlotItem(CONST_SLOT_NECKLACE):getId() == ITEM_AMULETOFLOSS)
	local hasSkull = table.contains({ SKULL_RED, SKULL_BLACK }, player:getSkull())
	local currBlessCount = player:getBlessings()

	if hasSkull then
		Blessings.DropLoot(player, corpse, 100, true)
	elseif #currBlessCount < 5 and not hasAol then
		local equipLossChance = Blessings.LossPercent[#currBlessCount].item
		Blessings.DropLoot(player, corpse, equipLossChance)
	end

	if not player:getSlotItem(CONST_SLOT_BACKPACK) then
		player:addItem(ITEM_BAG, 1, false, CONST_SLOT_BACKPACK)
	end

	return true
end

Blessings.DropLoot = function(player, corpse, chance, skulled)
	local multiplier = 100
	math.randomseed(os.time())
	chance = chance * multiplier
	Blessings.DebugPrint("DropLoot chance " .. chance)
	for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local item = player:getSlotItem(i)
		if item then
			local thisChance = item:isContainer() and chance or (chance / 10)
			local thisRandom = math.random(100 * multiplier)

			Blessings.DebugPrint(thisChance / multiplier .. "%" .. " | thisRandom " .. thisRandom / multiplier .. "%", "DropLoot item " .. item:getName() .. " |")
			if skulled or thisRandom <= thisChance then
				Blessings.DebugPrint("Dropped " .. item:getName())
				item:moveTo(corpse)
			end
		end
	end

	if skulled and Blessings.Config.SkulledDeathLoseStoreItem then
		local inbox = player:getStoreInbox()
		local toBeDeleted = {}
		if inbox and inbox:getSize() > 0 then
			for i = 0, inbox:getSize() do
				local item = inbox:getItem(i)
				if item then
					toBeDeleted[#toBeDeleted + 1] = item.uid
				end
			end
			if #toBeDeleted > 0 then
				for i, v in pairs(toBeDeleted) do
					local item = Item(v)
					if item then
						item:remove()
					end
				end
			end
		end
	end
end

-- Blessing Helpers --
Blessings.getCommandFee = function(cost)
	local fee = configManager.getNumber(configKeys.BUY_BLESS_COMMAND_FEE) or 0
	return cost + cost * (((fee > 100 and 100) or fee) / 100)
end

Blessings.getBlessingCost = function(level, byCommand, enhanced)
	if byCommand == nil then
		byCommand = false
	end

	if enhanced == nil then
		enhanced = false
	end

	local cost
	if level <= 30 then
		cost = 2000
	elseif level >= 120 then
		local base_cost = enhanced and 26000 or 20000
		local multiplier = enhanced and 100 or 75
		cost = base_cost + multiplier * (level - 120)
	else
		local multiplier = enhanced and 260 or 200
		cost = multiplier * (level - 20)
	end

	return byCommand and Blessings.getCommandFee(cost) or cost
end

Blessings.getPvpBlessingCost = function(level, byCommand)
	if byCommand == nil then
		byCommand = false
	end

	local cost
	if level <= 30 then
		cost = 2000
	elseif level >= 270 then
		cost = 50000
	else
		cost = (level - 20) * 200
	end

	return byCommand and Blessings.getCommandFee(cost) or cost
end

Blessings.useCharm = function(player, item)
	for index, value in pairs(Blessings.All) do
		if item.itemid == value.charm then
			if not value then
				return true
			end

			if player:hasBlessing(value.id) then
				player:say("You already possess this blessing.", TALKTYPE_MONSTER_SAY)
				return true
			end

			player:addBlessing(value.id, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.name .. " protects you.")
			player:getPosition():sendMagicEffect(CONST_ME_LOSEENERGY)
			item:remove(1)
			return true
		end
	end
end

Blessings.checkBless = function(player)
	local result = "Received blessings:"
	for k, v in pairs(Blessings.All) do
		result = player:hasBlessing(k) and result .. "\n" .. v.name or result
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 20 > result:len() and "No blessings received." or result)
	return true
end

Blessings.doAdventurerBlessing = function(player)
	if player:getLevel() > Blessings.Config.AdventurerBlessingLevel then
		return true
	end

	player:addMissingBless(true, true)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have adventurer's blessings for being level lower than " .. Blessings.Config.AdventurerBlessingLevel .. "!")
	player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
	return true
end

Blessings.getInquisitionPrice = function(player)
	-- Find how many missing bless we have and give out the price
	inquifilter = function(b)
		return b.inquisition
	end

	donthavefilter = function(p, b)
		return not p:hasBlessing(b)
	end

	local missing = #player:getBlessings(inquifilter, donthavefilter)
	local totalBlessPrice = Blessings.getBlessingCost(player:getLevel(), false) * missing * Blessings.Config.InquisitonBlessPriceMultiplier
	return missing, totalBlessPrice
end

Blessings.BuyAllBlesses = function(player)
	if not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) and (player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)) then
		player:sendCancelMessage("You can't buy bless while in battle.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	donthavefilter = function(p, b)
		return not p:hasBlessing(b)
	end

	local hasToF = Blessings.Config.HasToF and player:hasBlessing(1) or true
	local missingBless = player:getBlessings(nil, donthavefilter)
	local missingBlessAmt = #missingBless + (hasToF and 0 or 1)
	local totalCost = 0

	for _, bless in ipairs(missingBless) do
		totalCost = totalCost + Blessings.getBlessingCost(player:getLevel(), true, bless.id >= 7)
	end

	if missingBlessAmt == 0 then
		player:sendCancelMessage("You are already blessed.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	if not hasToF then
		totalCost = totalCost + Blessings.getPvpBlessingCost(player:getLevel(), true)
	end

	if player:removeMoneyBank(totalCost) then
		metrics.addCounter("balance_decrease", totalCost, {
			player = player:getName(),
			context = "blessings",
		})

		for _, bless in ipairs(missingBless) do
			player:addBlessing(bless.id, 1)
		end

		player:sendCancelMessage(string.format("You received the remaining %d blesses for a total of %d gold.", missingBlessAmt, totalCost))
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	else
		player:sendCancelMessage(string.format("You don't have enough money. You need %d to buy all blesses.", totalCost))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end

	return true
end

function Player.getBlessings(self, filter, hasblessingFilter)
	local blessings = {}
	if filter == nil then
		filter = function(b)
			return b.losscount
		end
	end

	if hasblessingFilter == nil then
		hasblessingFilter = function(p, b)
			return p:hasBlessing(b)
		end
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
	self:sendBlessStatus()
end
