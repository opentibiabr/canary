--
--	Badge system created by @marcosvf132 for Canary repository. (OTBR)
--	Updated on 24/06/2022
--	To-Do list:
--	 - 'tournamentParticipation'
--	 - 'tournamentPoints'
--
if BadgeSystem == nil then
	BadgeSystem = {
		enabled = true,
		accountAge = {
			[1] = {name = "Fledegeling Hero", id = 1, amount = 1},
			[2] = {name = "Veteran Hero", id = 2, amount = 5},
			[3] = {name = "Senior Hero", id = 3, amount = 10},
			[4] = {name = "Ancient Hero", id = 4, amount = 15},
			[5] = {name = "Exalted Hero", id = 5, amount = 20},
		},
		loyalty = {
			[1] = {name = "Tibia Loyalist (Grade 1)", id = 6, amount = 100},
			[2] = {name = "Tibia Loyalist (Grade 2)", id = 7, amount = 1000},
			[3] = {name = "Tibia Loyalist (Grade 3)", id = 8, amount = 5000},
		},
		accountAllLevel = {
			[1] = {name = "Global Player (Grade 1)", id = 9, amount = 500},
			[2] = {name = "Global Player (Grade 2)", id = 10, amount = 1000},
			[3] = {name = "Global Player (Grade 3)", id = 11, amount = 2000},
		},
		accountAllVocations = {
			[1] = {name = "Master Class (Grade 1)", id = 12, amount = 100},
			[2] = {name = "Master Class (Grade 2)", id = 13, amount = 250},
			[3] = {name = "Master Class (Grade 3)", id = 14, amount = 500},
		},
		tournamentParticipation = {
			[1] = {name = "Freshman of the Tournament", id = 15, amount = 1},
			[2] = {name = "Regular of the Tournament", id = 16, amount = 5},
			[3] = {name = "Hero of the Tournament", id = 17, amount = 10},
		},
		tournamentPoints = {
			[1] = {name = "Tournament Competitor", id = 18, amount = 1000},
			[2] = {name = "Tournament Challenger", id = 19, amount = 2500},
			[3] = {name = "Tournament Master", id = 20, amount = 5000},
			[4] = {name = "Tournament Champion", id = 21, amount = 10000},
		},
		others = {
			--[1] = {name = "name", id = 0, isUnlocked = function(player)
			--	if not(player) then
			--		return false
			--	end
			--	return true
			--end},
		}
	}
	--
	do
		if not(BadgeSystem.enabled) then
			return
		end
		--
		for _, BadgeSystem_it in pairs(BadgeSystem) do
			if type(BadgeSystem_it) == "table" and #BadgeSystem_it > 0 then
				for __, it in pairs(BadgeSystem_it) do
					if it.id ~= nil then
						Game.registerPlayerBadges(it.id, it.name)
					end
				end
			end
		end
	end
end
--
-- Account age section
BadgeSystem.accountAgeFunction = function(player, amount)
	if not(player) then
		return false
	end

	return math.floor(player:getLoyaltyPoints() / 365) >= amount
end
--
-- Loyalty section
BadgeSystem.loyaltyFunction = function(player, amount)
	if not(player) then
		return false
	end

	return player:getLoyaltyPoints() >= amount
end
--
-- Account all level section
BadgeSystem.accountAllLevelFunction = function(player, amount)
	if not(player) then
		return false
	end

	local total = 0
	for _, accountData in ipairs(player:getAccountLevelVocation()) do
		total = total + accountData.level
	end

	return total >= amount
end
--
-- Account all vocations section
BadgeSystem.accountAllVocationsFunction = function(player, amount)
	if not(player) then
		return false
	end

	local knight, paladin, druid, sorcerer = false, false, false, false
	for _, accountData in ipairs(player:getAccountLevelVocation()) do
		if accountData.level >= amount then
			if accountData.vocation == VOCATION.ID.KNIGHT or accountData.vocation == VOCATION.ID.ELITE_KNIGHT then
				knight = true
			elseif accountData.vocation == VOCATION.ID.SORCERER or accountData.vocation == VOCATION.ID.MASTER_SORCERER then
				sorcerer = true
			elseif accountData.vocation == VOCATION.ID.PALADIN or accountData.vocation == VOCATION.ID.ROYAL_PALADIN then
				paladin = true
			elseif accountData.vocation == VOCATION.ID.DRUID or accountData.vocation == VOCATION.ID.ELDER_DRUID then
				druid = true
			end
		end
	end

	return knight and paladin and druid and sorcerer
end
--
-- Tournament participation section
BadgeSystem.tournamentParticipationFunction = function(player, skill)
	if not(player) then
		return false
	end

	-- To-Do
	return false
end
--
-- Tournament points section
BadgeSystem.tournamentPointsFunction = function(player, race)
	if not(player) then
		return false
	end

	-- To-Do
	return false
end
--
--
function Player.initializeBadgeSystem(self)
	if not(BadgeSystem.enabled) then
		return false
	end
	--
	-- Account age section
	if BadgeSystem.accountAge ~= nil and #(BadgeSystem.accountAge) > 0 then
		for _, it in pairs(BadgeSystem.accountAge) do
			if BadgeSystem.accountAgeFunction(self, it.amount) then
				self:addBadge(it.id)
			end
		end
	end
	--
	-- Loyalty section
	if BadgeSystem.loyalty ~= nil and #(BadgeSystem.loyalty) > 0 then
		for _, it in pairs(BadgeSystem.loyalty) do
			if BadgeSystem.loyaltyFunction(self, it.amount) then
				self:addBadge(it.id)
			end
		end
	end
	--
	-- Account all vocations section
	if BadgeSystem.accountAllLevel ~= nil and #(BadgeSystem.accountAllLevel) > 0 then
		for _, it in pairs(BadgeSystem.accountAllLevel) do
			if BadgeSystem.accountAllLevelFunction(self, it.amount) then
				self:addBadge(it.id)
			end
		end
	end
	--
	-- Tournament participation section
	if BadgeSystem.tournamentParticipation ~= nil and #(BadgeSystem.tournamentParticipation) > 0 then
		for _, it in pairs(BadgeSystem.tournamentParticipation) do
			if BadgeSystem.tournamentParticipationFunction(self, it.amount) then
				self:addBadge(it.id)
			end
		end
	end
	--
	-- Tournament points section
	if BadgeSystem.tournamentPoints ~= nil and #(BadgeSystem.tournamentPoints) > 0 then
		for _, it in pairs(BadgeSystem.tournamentPoints) do
			if BadgeSystem.tournamentPointsFunction(self, it.amount) then
				self:addBadge(it.id)
			end
		end
	end
	--
	-- Others section
	if BadgeSystem.others ~= nil and #(BadgeSystem.others) > 0 then
		for _, it in pairs(BadgeSystem.others) do
			if it.isUnlocked(self) then
				self:addBadge(it.id)
			end
		end
	end
	--
	--
	return true
end
--@endofthefile