local config = {
	outfits = {},
	mounts = {},
}

function Player.onRemoveVip(self)
	self:sendTextMessage(MESSAGE_ADMINISTRATOR, "Your VIP status has expired. All VIP benefits have been removed.")

	for _, outfit in ipairs(config.outfits) do
		self:removeOutfit(outfit)
	end

	for _, mount in ipairs(config.mounts) do
		self:removeMount(mount)
	end

	local playerOutfit = self:getOutfit()
	if table.contains(config.outfits, playerOutfit.lookType) then
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
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have been granted %s days of VIP status.", days))
	end

	for _, outfit in ipairs(config.outfits) do
		self:addOutfitAddon(outfit, 3)
	end

	for _, mount in ipairs(config.mounts) do
		self:addMount(mount)
	end

	self:kv():scoped("account"):set("vip-system", true)
end

function CheckPremiumAndPrint(player, msgType)
	if player:getVipDays() == 0xFFFF then
		player:sendTextMessage(msgType, "You have an unlimited VIP status.")
		return true
	end

	local playerVipTime = player:getVipTime()
	if playerVipTime < os.time() then
		player:sendTextMessage(msgType, "Your VIP status is currently inactive.")
		return true
	end

	player:sendTextMessage(msgType, string.format("You have %s of VIP time remaining.", getFormattedTimeRemaining(playerVipTime)))
end
