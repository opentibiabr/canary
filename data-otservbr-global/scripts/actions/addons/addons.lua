local config = {
	-- soil guardian
	[16252] = { female = 514, male = 516, effect = CONST_ME_GREEN_RINGS },
	[16253] = { female = 514, male = 516, addon = 1, effect = CONST_ME_GREEN_RINGS, achievement = "Funghitastic" },
	[16254] = { female = 514, male = 516, addon = 2, effect = CONST_ME_GREEN_RINGS, achievement = "Funghitastic" },
	-- crystal warlord
	[16255] = { female = 513, male = 512, effect = CONST_ME_GIANTICE },
	[16256] = { female = 513, male = 512, addon = 1, effect = CONST_ME_GIANTICE, achievement = "Crystal Clear" },
	[16257] = { female = 513, male = 512, addon = 2, effect = CONST_ME_GIANTICE, achievement = "Crystal Clear" },
	-- makeshift warrior
	[27655] = { female = 1043, male = 1042 },
	[27657] = { female = 1043, male = 1042, addon = 1, achievement = "Cobbled and Patched" },
	[27656] = { female = 1043, male = 1042, addon = 2, achievement = "Cobbled and Patched" },
	-- hand of the inquisition
	[31738] = { female = 1244, male = 1243, addon = 1, effect = CONST_ME_HOLYAREA, achievement = "Inquisition's Arm" },
	[31737] = { female = 1244, male = 1243, addon = 2, effect = CONST_ME_HOLYAREA, achievement = "Inquisition's Arm" },
	-- poltergeist
	[32630] = { female = 1271, male = 1270, addon = 1, effect = CONST_ME_BLUE_GHOST, achievement = "Mainstreet Nightmare" },
	[32631] = { female = 1271, male = 1270, addon = 2, effect = CONST_ME_BLUE_GHOST, achievement = "Mainstreet Nightmare" },
	-- rascoohan
	[35595] = { female = 1372, male = 1371, addon = 1, achievement = "Honorary Rascoohan" },
	[35695] = { female = 1372, male = 1371, addon = 2, achievement = "Honorary Rascoohan" },
}

local addons = Action()

function addons.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.itemid]
	if not useItem then
		return true
	end

	local looktype = player:getSex() == PLAYERSEX_FEMALE and useItem.female or useItem.male

	if useItem.addon then
		if not player:isPremium() or not player:hasOutfit(looktype) or player:hasOutfit(looktype, useItem.addon) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You own no premium account, lack the base outfit or already own this outfit part.")
			return true
		end

		player:addOutfitAddon(useItem.female, useItem.addon)
		player:addOutfitAddon(useItem.male, useItem.addon)
		player:getPosition():sendMagicEffect(useItem.effect or CONST_ME_GIFT_WRAPS)
		if player:hasOutfit(looktype, 3) then
			if useItem.achievement then
				player:addAchievement(useItem.achievement)
			end
		end
		item:remove()
	else
		if not player:isPremium() or player:hasOutfit(looktype) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You own no premium account or already own this outfit part.")
			return true
		end

		player:addOutfit(useItem.female)
		player:addOutfit(useItem.male)
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		item:remove()
	end
	return true
end

local ids = {}
for value in pairs(config) do
	table.insert(ids, value)
end

addons:id(unpack(ids))
addons:register()
