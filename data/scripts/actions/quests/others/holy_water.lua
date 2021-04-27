local doorPosition = Position(32260, 32791, 7)
local shadowNexusPosition = Position(33115, 31702, 12)
local effectPositions = {
	Position(33113, 31702, 12),
	Position(33116, 31702, 12)
}

local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local function nexusMessage(player, message)
	local spectators = Game.getSpectators(shadowNexusPosition, false, true, 3, 3)
	for i = 1, #spectators do
		player:say(message, TALKTYPE_MONSTER_YELL, false, spectators[i], shadowNexusPosition)
	end
end

local storages = {
	[4008] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave1,
	[4009] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave2,
	[4010] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave3,
	[4011] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave4,
	[4012] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave5,
	[4013] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave6,
	[4014] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave7,
	[4015] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave8,
	[4016] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave9,
	[4017] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave10,
	[4018] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave11,
	[4019] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave12,
	[4020] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave13,
	[4021] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave14,
	[4022] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave15,
	[4023] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave16
}

local config = {
	antler_talisman = 24664,
	sacred_antler_talisman = 24665
}

local othersHolyWater = Action()
function othersHolyWater.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if target.itemid == config.antler_talisman then
		item:transform(config.sacred_antler_talisman)
		item:remove(1)
		target:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You besprinkle the antler talisman with holy water. It glittlers faintly")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true
	end

	-- Eclipse
	if target.actionid == 2000 then
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_FIREAREA)
		-- The Inquisition Questlog- 'Mission 2: Eclipse'
		player:setStorageValue(Storage.TheInquisition.Mission02, 2)
		player:setStorageValue(Storage.TheInquisition.Questline, 5)
		return true

		-- Haunted Ruin
	elseif target.actionid == 2003 then
		if player:getStorageValue(Storage.TheInquisition.Questline) ~= 12 then
			return true
		end

		Game.createMonster('Pirate Ghost', toPosition)
		item:remove(1)

		-- The Inquisition Questlog- 'Mission 4: The Haunted Ruin'
		player:setStorageValue(Storage.TheInquisition.Questline, 13)
		player:setStorageValue(Storage.TheInquisition.Mission04, 2)

		local doorItem = Tile(doorPosition):getItemById(8697)
		if doorItem then
			doorItem:transform(8696)
		end
		addEvent(revertItem, 10 * 1000, doorPosition, 8696, 8697)
		return true
	end

	if target.actionid == 4007 and target.actionid == 4024 then
		local graveStorage = storages[target.actionid]
		if player:getStorageValue(graveStorage) == 1
		or player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline) ~= 3 then
			return false
		end

		player:setStorageValue(graveStorage, 1)

		local cStorage = player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.HolyWater)
		if cStorage < 14 then
			player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.HolyWater, math.max(0, cStorage) + 1)
		elseif cStorage == 14 then
			player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.HolyWater, -1)
			player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline, 4)
			item:transform(2006, 0)
		end

		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end

	-- Shadow Nexus
	if isInArray({8753, 8755, 8757}, target.itemid) then
		if target.itemid == 8757 then
			Game.setStorageValue(GlobalStorage.Inquisition, math.random(4,5))
		end
		target:transform(target.itemid + 1)
		target:setAttribute(ITEM_ATTRIBUTE_DURATION, 20000)
		target:decay()
		nexusMessage(player, player:getName() .. ' damaged the shadow nexus! You can\'t damage it while it\'s burning.')
		toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	elseif target.itemid == 8759 then
		if Game.getStorageValue(GlobalStorage.Inquisition) > 0 then
			Game.setStorageValue(GlobalStorage.Inquisition, (Game.getStorageValue(GlobalStorage.Inquisition)-1))
			if player:getStorageValue(Storage.TheInquisition.Questline) < 22 then
				-- The Inquisition Questlog- 'Mission 7: The Shadow Nexus'
				player:setStorageValue(Storage.TheInquisition.Mission07, 2)
				player:setStorageValue(Storage.TheInquisition.Questline, 22)
			end
			for i = 1, #effectPositions do
				effectPositions[i]:sendMagicEffect(CONST_ME_HOLYAREA)
			end
			nexusMessage(player, player:getName() .. ' destroyed the shadow nexus! In 10 seconds it will return to its original state.')
			item:remove(1)
			toPosition:sendMagicEffect(CONST_ME_HOLYAREA)
		else
			target:transform(8753)
		end
	end

	return true
end

othersHolyWater:id(7494)
othersHolyWater:register()