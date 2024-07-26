local theApeMiss9 = Action()

local amphoraStorages = {
	[40092] = Storage.Quest.U7_6.TheApeCity.TheLargeAmphoras1,
	[40093] = Storage.Quest.U7_6.TheApeCity.TheLargeAmphoras2,
	[40094] = Storage.Quest.U7_6.TheApeCity.TheLargeAmphoras3,
	[40095] = Storage.Quest.U7_6.TheApeCity.TheLargeAmphoras4,
}

local cooldownStorage = Storage.Quest.U7_6.TheApeCity.TheLargeAmphorasCooldown
local cooldownTime = 5 * 60

function theApeMiss9.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local uid = target:getUniqueId()
	local itemId = target.itemid

	if amphoraStorages[uid] and itemId == 4995 then
		local storage = amphoraStorages[uid]

		local storageValue = player:getStorageValue(storage)
		if storageValue > 0 then
			return false
		end

		player:setStorageValue(storage, 1)

		target:transform(4996)

		local allUsed = true
		for _, s in pairs(amphoraStorages) do
			if player:getStorageValue(s) < 1 then
				allUsed = false
				break
			end
		end

		if allUsed then
			player:setStorageValue(cooldownStorage, os.time())
		end

		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local specificPosition = Position(32858, 32526, 11)
	if itemId == 4850 and toPosition == specificPosition then
		if player:getStorageValue(Storage.Quest.U7_6.TheApeCity.Questline) ~= 17 then
			return false
		end

		if player:getStorageValue(Storage.Quest.U7_6.TheApeCity.SnakeDestroyer) == 1 then
			return false
		end

		player:setStorageValue(Storage.Quest.U7_6.TheApeCity.SnakeDestroyer, 1)
		item:remove()
		target:transform(4851)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	return false
end

theApeMiss9:id(4835)
theApeMiss9:register()
