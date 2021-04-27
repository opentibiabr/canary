local config = {
	-- soil guardian
	[18517] = {female = 514, male = 516, effect = CONST_ME_GREEN_RINGS},
	[18518] = {female = 514, male = 516, addon = 1, effect = CONST_ME_GREEN_RINGS, achievement = 'Funghitastic'},
	[18519] = {female = 514, male = 516, addon = 2, effect = CONST_ME_GREEN_RINGS, achievement = 'Funghitastic'},
	-- crystal warlord
	[18520] = {female = 513, male = 512, effect = CONST_ME_GIANTICE},
	[18521] = {female = 513, male = 512, addon = 1, effect = CONST_ME_GIANTICE, achievement = 'Crystal Clear'},
	[18522] = {female = 513, male = 512, addon = 2, effect = CONST_ME_GIANTICE, achievement = 'Crystal Clear'},
	-- makeshift warrior
	[30890] = {female = 1043, male = 1042},
	[30892] = {female = 1043, male = 1042, addon = 1, achievement = 'Cobbled and Patched'},
	[30891] = {female = 1043, male = 1042, addon = 2, achievement = 'Cobbled and Patched'}
}

local addons = Action()

function addons.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.itemid]
	if not useItem then
		return true
	end

	local looktype = player:getSex() == PLAYERSEX_FEMALE and useItem.female or useItem.male

	if useItem.addon then
		if not player:isPremium()
				or not player:hasOutfit(looktype)
				or player:hasOutfit(looktype, useItem.addon) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You own no premium account, lack the base outfit or already own this outfit part.')
			return true
		end

		player:addOutfitAddon(useItem.female, useItem.addon)
		player:addOutfitAddon(useItem.male, useItem.addon)
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		if player:hasOutfit(looktype, 3) then
			player:addAchievement(useItem.achievement)
		end
		item:remove()
	else
		if not player:isPremium() or player:hasOutfit(looktype) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You own no premium account or already own this outfit part.')
			return true
		end

		player:addOutfit(useItem.female)
		player:addOutfit(useItem.male)
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		item:remove()
	end
	return true
end

addons:id(18517, 18518, 18519, 18520, 18521, 18522, 30890, 30891, 30892)
addons:register()
