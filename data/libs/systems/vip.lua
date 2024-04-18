-- Bonus mount and outfits
local outfits = {}
local mounts = {}

function Player.onRemoveVip(self)
	self:sendTextMessage(MESSAGE_ADMINISTRATOR, "Your VIP days ran out.")

	for _, outfit in ipairs(outfits) do
		self:removeOutfit(outfit)
	end

	for _, mount in ipairs(mounts) do
		self:removeMount(mount)
	end

	local playerOutfit = self:getOutfit()
	if table.contains(outfits, self:getOutfit().lookType) then
		if self:getSex() == PLAYERSEX_FEMALE then
			playerOutfit.lookType = 136
		else
			playerOutfit.lookType = 128
		end

		playerOutfit.lookAddons = 0
		self:setOutfit(playerOutfit)
	end

	self:kv():scoped("account"):remove("vip-system")
end

function Player.onAddVip(self, days, silent)
	if not silent then
		self:sendTextMessage(MESSAGE_ADMINISTRATOR, "You have received " .. days .. " VIP days.")
	end

	for _, outfit in ipairs(outfits) do
		self:addOutfitAddon(outfit, 3)
	end

	for _, mount in ipairs(mounts) do
		self:addMount(mount)
	end

	self:kv():scoped("account"):set("vip-system", true)
end

function CheckPremiumAndPrint(player, msgType)
	local msg

	if player:getVipDays() == 0xFFFF then
		msg = "You have infinite amount of VIP days left."
	else
		local playerVipTime = player:getVipTime()
		if playerVipTime < os.time() then
			msg = "You do not have VIP on your account."
		else
			msg = "You have " .. getFormattedTimeRemaining(playerVipTime) .. " of VIP time left."
		end
	end

	player:sendTextMessage(MESSAGE_ADMINISTRATOR, msg)
end
