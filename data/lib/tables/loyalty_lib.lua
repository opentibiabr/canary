local loyaltySystem = {
	enable = true,
	titles = {
		[1] = {name = "Scout of Tibia", points = 50},
		[2] = {name = "Sentinel of Tibia", points = 100},
		[3] = {name = "Steward of Tibia", points = 200},
		[4] = {name = "Warden of Tibia", points = 400},
		[5] = {name = "Squire of Tibia", points = 1000},
		[6] = {name = "	Warrior of Tibia", points = 2000},
		[7] = {name = "Keeper of Tibia", points = 3000},
		[8] = {name = "Guardian of Tibia", points = 4000},
		[9] = {name = "Sage of Tibia", points = 5000},
		[10] = {name = "Savant of Tibia", points = 6000},
		[11] = {name = "Enlightened of Tibia", points = 7000},
	},
	bonus = {
		[1] = {toPoints = 359, percentage = 0},
		[2] = {fromPoints = 360, toPoints = 719, percentage = 5},
		[3] = {fromPoints = 720, toPoints = 1079, percentage = 10},
		[4] = {fromPoints = 1080, toPoints = 1439, percentage = 15},
		[5] = {fromPoints = 1440, toPoints = 1799, percentage = 20},
		[6] = {fromPoints = 1800, toPoints = 2159, percentage = 25},
		[7] = {fromPoints = 2160, toPoints = 2519, percentage = 30},
		[8] = {fromPoints = 2520, toPoints = 2879, percentage = 35},
		[9] = {fromPoints = 2880, toPoints = 3239, percentage = 40},
		[10] = {fromPoints = 3240, toPoints = 3599, percentage = 45},
		[11] = {fromPoints = 3600, percentage = 50},
	}
}

function Player.initializeLoyaltySystem(self)
	if not(loyaltySystem.enable) then
		return true
	end

	-- Title
	local title = ""
	for _, titleTable in ipairs(loyaltySystem.titles) do
		if (self:getLoyaltyPoints() > titleTable.points) then
			title = titleTable.name
		end
	end
	self:setLoyaltyTitle(title)

	-- Bonus
	for _, bonusTable in ipairs(loyaltySystem.bonus) do
		local setPercentage = false
		if bonusTable.fromPoints ~= nil then
			setPercentage = self:getLoyaltyPoints() >= bonusTable.fromPoints
		end

		if bonusTable.toPoints ~= nil then
			setPercentage = self:getLoyaltyPoints() <= bonusTable.toPoints
		end

		if setPercentage then
			self:setLoyaltyBonus(bonusTable.percentage)
			break
		end
	end
	if self:getLoyaltyBonus() ~= 0 then
		self:sendTextMessage(MESSAGE_STATUS, "Due to your long-term loyalty to " .. SERVER_NAME .. ", you currently benefit from a " .. self:getLoyaltyBonus() .. "% bonus on all of your skills.")
	end

	return true
end