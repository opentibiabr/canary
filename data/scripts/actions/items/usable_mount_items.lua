local config = {
	[23538] = { name = "vortexion", mountId = 94, tameMessage = "You receive the permission to ride a sparkion." }, -- vibrant egg
	[23684] = { name = "neon sparkid", mountId = 98, tameMessage = "You receive the permission to ride a neon sparkid." }, -- crackling egg
	[23685] = { name = "vortexion", mountId = 99, tameMessage = "You receive the permission to ride a vortexion." }, -- menacing egg
	[32629] = { name = "haze", mountId = 162, achievement = "Nothing but Hot Air", tameMessage = "You are now versed to ride the haze!" }, -- spectral scrap of cloth
},

local usableItemMounts = Action()

function usableItemMounts.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:isPremium() then
		player:sendCancelMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
		return true
	end

	local useItem = config[item.itemid]
	if player:hasMount(useItem.mountId) then
		return false
	end

	if useItem.achievement then
		player:addAchievement(useItem.achievement)
	end

	if table.contains({23538, 23684, 23685}, item.itemid) then
		local storage = player:getStorageValue(PlayerStorageKeys.vortexTamer)
		player:setStorageValue(PlayerStorageKeys.vortexTamer, storage + 1)
		if storage == 1 then
			player:addAchievement("Vortex Tamer")
		end
	end

	player:addMount(useItem.mountId)
	player:addAchievement("Natural Born Cowboy")
	player:say(useItem.tameMessage, TALKTYPE_MONSTER_SAY)
	item:remove(1)
	return true
end

for k, v in pairs(config) do
	usableItemMounts:id(k)
end

usableItemMounts:register()
