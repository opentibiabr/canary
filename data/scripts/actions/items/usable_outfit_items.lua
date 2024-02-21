local outfitConfig = {
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

	-- fire-fighter
	[39544] = { female = 1569, male = 1568, addon = 1, achievement = "Friendly Fire" },
	[39545] = { female = 1569, male = 1568, addon = 2, achievement = "Friendly Fire" },
}

local usableOutfitItems = Action()

function usableOutfitItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:isPremium() then
		player:sendCancelMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
		return true
	end

	local outfitInfo = outfitConfig[item.itemid]
	local looktype = player:getSex() == PLAYERSEX_FEMALE and outfitInfo.female or outfitInfo.male
	if not player:hasOutfit(looktype) then
		if outfitInfo.addon then
			player:sendCancelMessage("You need the outfit for this part.")
			return true
		end

		player:addOutfit(outfitInfo.female)
		player:addOutfit(outfitInfo.male)
		player:getPosition():sendMagicEffect(outfitInfo.effect)
		item:remove(1)
		return true
	end

	if player:hasOutfit(looktype, outfitInfo.addon) then
		player:sendCancelMessage("You already own this outfit part.")
		return true
	end

	player:addOutfitAddon(outfitInfo.female, outfitInfo.addon)
	player:addOutfitAddon(outfitInfo.male, outfitInfo.addon)
	player:getPosition():sendMagicEffect(outfitInfo.effect)

	if player:hasOutfit(looktype, 3) then
		player:addAchievement(outfitInfo.achievement)
	end

	item:remove(1)
	return true
end

for itemId, _ in pairs(outfitConfig) do
	usableOutfitItems:id(itemId)
end

usableOutfitItems:register()
