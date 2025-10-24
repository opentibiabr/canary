local premiumCategoryName = "Premium Time"
local premiumOfferName = "Premium Time"

if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
	premiumCategoryName = "VIP Shop"
	premiumOfferName = "VIP"
end

local premiumDescription =
	"<i>Enhance your gaming experience by gaining additional abilities and advantages:</i>\n\n&#8226; access to Premium areas\n&#8226; use Tibia's transport system (ships, carpet)\n&#8226; more spells\n&#8226; rent houses\n&#8226; found guilds\n&#8226; offline training\n&#8226; larger depots\n&#8226; and many more\n\n{usablebyallicon} valid for all characters on this account\n{activated}"

if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
	local vipBonusExp = configManager.getNumber(configKeys.VIP_BONUS_EXP)
	local vipBonusLoot = configManager.getNumber(configKeys.VIP_BONUS_LOOT)
	local vipBonusSkill = configManager.getNumber(configKeys.VIP_BONUS_SKILL)
	local vipStayOnline = configManager.getBoolean(configKeys.VIP_STAY_ONLINE)

	premiumDescription = "<i>Enhance your gaming experience by gaining advantages:</i>\n\n"
	if vipBonusExp > 0 then
		premiumDescription = premiumDescription .. "&#8226; +" .. vipBonusExp .. "% experience rate\n"
	end
	if vipBonusSkill > 0 then
		premiumDescription = premiumDescription .. "&#8226; +" .. vipBonusSkill .. "% skill training speed\n"
	end
	if vipBonusLoot > 0 then
		premiumDescription = premiumDescription .. "&#8226; +" .. vipBonusLoot .. "% loot\n"
	end
	if vipStayOnline then
		premiumDescription = premiumDescription .. "&#8226; stay online idle without getting disconnected\n"
	end
	premiumDescription = premiumDescription .. "\n{usablebyallicon} valid for all characters on this account\n{activated}"
end

return {
	icons = { "Category_PremiumTime.png" },
	name = premiumCategoryName,
	rookgaard = true,
	state = GameStore.States.STATE_NONE,
	offers = {
		{
			icons = { "Premium_Time_30.png" },
			name = string.format("30 Days of %s", premiumOfferName),
			price = 250,
			id = 3030,
			validUntil = 30,
			description = premiumDescription,
			type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
		},
		{
			icons = { "Premium_Time_90.png" },
			name = string.format("90 Days of %s", premiumOfferName),
			price = 750,
			id = 3090,
			validUntil = 90,
			description = premiumDescription,
			type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
		},
		{
			icons = { "Premium_Time_180.png" },
			name = string.format("180 Days of %s", premiumOfferName),
			price = 1500,
			id = 3180,
			validUntil = 180,
			description = premiumDescription,
			type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
		},
		{
			icons = { "Premium_Time_360.png" },
			name = string.format("360 Days of %s", premiumOfferName),
			price = 3000,
			id = 3360,
			validUntil = 360,
			description = premiumDescription,
			type = GameStore.OfferTypes.OFFER_TYPE_PREMIUM,
		},
	},
}
