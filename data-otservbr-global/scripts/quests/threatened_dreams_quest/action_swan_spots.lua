local config = {
	rewardId = 26181,
	rewardCount = 5,
	cooldownTime = 72000,
}

local swanSpots = {
	["33458-32291-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown01,
	["33495-32315-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown02,
	["33470-32249-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown03,
	["33464-32228-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown04,
	["33531-32254-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown05,
	["33533-32253-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown05,
	["33549-32254-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown05,
	["33545-32246-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown05,
	["33541-32236-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown05,
	["33547-32222-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown06,
	["33500-32191-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown07,
	["33591-32196-7"] = Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCooldown08,
}

local swanfeather = Action()

function swanfeather.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission03.AnUnlikelyCouple) < 4 then
		return false
	end

	local posKey = toPosition.x .. "-" .. toPosition.y .. "-" .. toPosition.z
	local storageKey = swanSpots[posKey]
	if not storageKey then
		return false
	end

	if player:getFreeCapacity() < ItemType(config.rewardId):getWeight() * config.rewardCount then
		player:sendCancelMessage("You don't have enough capacity.")
		return false
	end

	local timeNow = os.time()
	local cooldownExpires = player:getStorageValue(storageKey)

	if cooldownExpires ~= -1 and timeNow < cooldownExpires then
		local timeLeft = cooldownExpires - timeNow
		local hours = math.floor(timeLeft / 3600)
		local minutes = math.floor((timeLeft % 3600) / 60)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You already pluck feathers from this pond. Come back in %d hours and %d minutes.", hours, minutes))
		return false
	end

	player:addItem(config.rewardId, config.rewardCount)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You pluck %d swan feathers.", config.rewardCount))
	player:setStorageValue(storageKey, timeNow + config.cooldownTime)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

swanfeather:id(25445)
swanfeather:register()
