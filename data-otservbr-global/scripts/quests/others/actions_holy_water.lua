local doorPosition = Position(32260, 32791, 7)
local shadowNexusPosition = Position(33115, 31702, 12)
local effectPositions = {
	Position(33113, 31702, 12),
	Position(33116, 31702, 12),
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
	[4208] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave1,
	[4209] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave2,
	[4210] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave3,
	[4211] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave4,
	[4212] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave5,
	[4213] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave6,
	[4214] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave7,
	[4215] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave8,
	[4216] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave9,
	[4217] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave10,
	[4218] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave11,
	[4219] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave12,
	[4220] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave13,
	[4221] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave14,
	[4222] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave15,
	[4223] = Storage.Quest.U8_1.RestInHallowedGround.Graves.Grave16,
}

local config = {
	antler_talisman = 22008,
	sacred_antler_talisman = 22009,
}

local othersHolyWater = Action()

function othersHolyWater.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Transformação do Antler Talisman
	if target.itemid == config.antler_talisman then
		target:transform(config.sacred_antler_talisman)
		item:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You besprinkle the antler talisman with holy water. It glitters faintly.")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true

		-- Eclipse Quest
	elseif target.actionid == 2000 then
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_FIREAREA)
		player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission02, 2)
		player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Questline, 5)
		return true

		-- Haunted Ruin Quest
	elseif target.actionid == 2003 then
		if player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Questline) ~= 12 then
			return true
		end

		Game.createMonster("Pirate Ghost", toPosition)
		item:remove(1)
		player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Questline, 13)
		player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission04, 2)

		local doorItem = Tile(doorPosition):getItemById(7869)
		if doorItem then
			doorItem:transform(7868)
		end
		addEvent(revertItem, 10 * 1000, doorPosition, 7868, 7869)
		return true

		-- Rest in Hallowed Ground Quest
	elseif target.actionid >= 4208 and target.actionid <= 4223 then
		local graveStorage = storages[target.actionid]
		local questline = player:getStorageValue(Storage.Quest.U8_1.RestInHallowedGround.Questline)
		if player:getStorageValue(graveStorage) == 1 or questline ~= 3 then
			return false
		end

		player:setStorageValue(graveStorage, 1)

		local cStorage = player:getStorageValue(Storage.Quest.U8_1.RestInHallowedGround.HolyWater)
		if cStorage < 14 then
			player:setStorageValue(Storage.Quest.U8_1.RestInHallowedGround.HolyWater, math.max(0, cStorage) + 1)
		elseif cStorage == 14 then
			player:setStorageValue(Storage.Quest.U8_1.RestInHallowedGround.HolyWater, -1)
			player:setStorageValue(Storage.Quest.U8_1.RestInHallowedGround.Questline, 4)
			item:transform(2874, 0)
		end

		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true

		-- Shadow Nexus Quest
	elseif table.contains({ 7925, 7927, 7929 }, target.itemid) then
		if target.itemid == 7929 then
			Game.setStorageValue(GlobalStorage.Inquisition, math.random(4, 5))
		end
		local newShadowNexus = Game.createItem(target.itemid + 1, 1, shadowNexusPosition)
		if newShadowNexus then
			target:remove()
			newShadowNexus:decay()
		end
		nexusMessage(player, player:getName() .. " damaged the shadow nexus! You can't damage it while it's burning.")
		toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)

		-- Transformação do Shadow Nexus
	elseif target.itemid == 7931 then
		if Game.getStorageValue(GlobalStorage.Inquisition) > 0 then
			Game.setStorageValue(GlobalStorage.Inquisition, Game.getStorageValue(GlobalStorage.Inquisition) - 1)
			if player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Questline) < 22 then
				player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission07, 2)
				player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Questline, 22)
			end
			for i = 1, #effectPositions do
				effectPositions[i]:sendMagicEffect(CONST_ME_HOLYAREA)
			end
			nexusMessage(player, player:getName() .. " destroyed the shadow nexus! In 10 seconds it will return to its original state.")
			item:remove(1)
			player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Questline, 22)
			toPosition:sendMagicEffect(CONST_ME_HOLYAREA)
		else
			target:transform(7925)
		end
	end

	return true
end

othersHolyWater:id(133)
othersHolyWater:register()
