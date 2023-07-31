local config = {
	activationMessage = 'You have received %s VIP days.',
	activationMessageType = MESSAGE_EVENT_ADVANCE,

	expirationMessage = 'Your VIP days ran out.',
	expirationMessageType = MESSAGE_STATUS_WARNING,

	outfits = {},
	mounts = {},
}

function Player.onRemoveVip(self)
	self:sendTextMessage(config.expirationMessageType, config.expirationMessage)

	for _, outfit in ipairs(config.outfits) do
		self:removeOutfit(outfit)
	end

	for _, mount in ipairs(config.mounts) do
		self:removeMount(mount)
	end

	local playerOutfit = self:getOutfit()
	if table.contains(config.outfits, self:getOutfit().lookType) then
		if self:getSex() == PLAYERSEX_FEMALE then
			playerOutfit.lookType = 136
		else
			playerOutfit.lookType = 128
		end
		playerOutfit.lookAddons = 0
		self:setOutfit(playerOutfit)
	end

	self:setStorageValue(Storage.VipSystem.IsVip, 0)
end

function Player.onAddVip(self, days)
	self:sendTextMessage(config.activationMessageType, string.format(config.activationMessage, days))

	for _, outfit in ipairs(config.outfits) do
		self:addOutfitAddon(outfit, 3)
	end

	for _, mount in ipairs(config.mounts) do
		self:addMount(mount)
	end

	self:setStorageValue(Storage.VipSystem.IsVip, 1)
end

