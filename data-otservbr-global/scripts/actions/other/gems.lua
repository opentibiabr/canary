local lionsRockSanctuaryPos = Position(33073, 32300, 9)
local lionsRockSanctuaryRockId = 1852
local lionsRockSanctuaryFountainId = 6389

local shrine = {
	-- ice shrine
	[3029] = {
		targetAction = 15001,
		-- shrinePosition = {x = 32194, y = 31418, z = 2}, -- read-only
		destination = { x = 33430, y = 32278, z = 7 },
		effect = CONST_ME_ICEATTACK,
	},
	-- fire shrine
	[3030] = {
		targetAction = 15002,
		-- shrinePosition = {x = 32910, y = 32338, z = 15}, -- read-only
		destination = { x = 33586, y = 32263, z = 7 },
		effect = CONST_ME_MAGIC_RED,
	},
	-- earth shrine
	[3032] = {
		targetAction = 15003,
		-- shrinePosition = {x = 32973, y = 32225, z = 7}, -- read-only
		destination = { x = 33539, y = 32209, z = 7 },
		effect = CONST_ME_SMALLPLANTS,
	},
	[3033] = {
		targetAction = 15004,
		-- shrinePosition = {x = 33060, y = 32713, z = 5}, -- read-only
		destination = { x = 33527, y = 32301, z = 4 },
		effect = CONST_ME_ENERGYHIT,
	},
}

local lionsRock = {
	[25006] = {
		itemId = 21441,
		itemPos = { x = 33069, y = 32298, z = 9 },
		storage = Storage.Quest.U10_70.LionsRock.Questline,
		value = 6,
		item = 3030,
		fieldId = 2123,
		message = "You place the ruby on the small socket. A red flame begins to burn.",
		effect = CONST_ME_MAGIC_RED,
	},
	[25007] = {
		itemId = 21442,
		itemPos = { x = 33069, y = 32302, z = 9 },
		storage = Storage.Quest.U10_70.LionsRock.Questline,
		value = 7,
		item = 3029,
		fieldId = 21463,
		message = "You place the sapphire on the small socket. A blue flame begins to burn.",
		effect = CONST_ME_MAGIC_BLUE,
	},
	[25008] = {
		itemId = 21440,
		itemPos = { x = 33077, y = 32302, z = 9 },
		storage = Storage.Quest.U10_70.LionsRock.Questline,
		value = 8,
		item = 3033,
		fieldId = 7465,
		message = "You place the amethyst on the small socket. A violet flame begins to burn.",
		effect = CONST_ME_PURPLESMOKE,
	},
	[25009] = {
		itemId = 21437,
		itemPos = { x = 33077, y = 32298, z = 9 },
		storage = Storage.Quest.U10_70.LionsRock.Questline,
		value = 9,
		item = 9057,
		fieldId = 21465,
		message = "You place the topaz on the small socket. A yellow flame begins to burn.",
		effect = CONST_ME_BLOCKHIT,
	},
}

local gems = Action()

function gems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local questStorage = player:getStorageValue(Storage.Quest.U10_70.LionsRock.Questline)
	if questStorage == 10 or questStorage == 11 then
		player:setStorageValue(Storage.Quest.U10_70.LionsRock.Questline, 6)
	end

	-- Small emerald for Kilmaresh quest
	-- see data\scripts\quests\kilmaresh\1-fafnars-wrath\7-four-masks.lua
	if item.itemid == 3032 and target.uid == 40032 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) >= 1 and not testFlag(player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.FourMasks), 4) then
		player:addItem(31371, 1) -- Ivory mask
		item:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You hear a *click*. You can now lift the floor tile and discover a secret compartment. A mask made of ivory lies in it.")
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor, player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.Favor) + 1)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.FourMasks, setFlag(player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.FourMasks), 4))
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Sixth.IvoryMask, 1)
		return true
		-- Enchanted helmet of the ancients
	elseif player:getItemCount(3030) >= 1 and target.itemid == 3229 then
		target:transform(3230)
		target:decay()
		item:remove(1)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	end

	-- Gems teleport to feyrist
	local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
	for index, value in pairs(shrine) do
		if target.actionid == value.targetAction then
			if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 16 then
				if item.itemid == index then
					player:teleportTo(value.destination)
					player:getPosition():sendMagicEffect(value.effect)
					item:remove(1)
					return true
				else
					player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
					return true
				end
			else
				player:say("When the time comes, '" .. item:getName() .. "' will be accepted at this shrine.")
				return true
			end
		end
	end

	-- Use gems in the tile of lions rock quest
	local setting = lionsRock[target.uid]
	if not setting then
		return false
	end

	-- Reset lion's fields
	local function lionsRockFieldReset()
		local gemSpot = Tile(setting.itemPos):getItemById(setting.fieldId)
		if gemSpot then
			player:setStorageValue(Storage.Quest.U10_70.LionsRock.LionsRockFields, player:getStorageValue(Storage.Quest.U10_70.LionsRock.LionsRockFields) - 1)
			gemSpot:remove()
			return true
		end
	end

	-- Check if all lion's fields are set
	local function checkLionsRockFields(storage)
		if player:getStorageValue(Storage.Quest.U10_70.LionsRock.LionsRockFields) == 3 then
			local stone = Tile(lionsRockSanctuaryPos):getItemById(lionsRockSanctuaryRockId)
			if stone then
				stone:transform(lionsRockSanctuaryFountainId)
				lionsRockSanctuaryPos:sendMagicEffect(CONST_ME_THUNDER)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Something happens at the center of the room ...")
				player:setStorageValue(storage, 10)
				return true
			end
		end
	end

	-- Delay to create lion's field
	local function lionsRockCreateField(itemPos, fieldId, storage)
		local gemSpot = Tile(itemPos):getItemById(fieldId)
		if not gemSpot then
			Game.createItem(fieldId, 1, itemPos)
			player:setStorageValue(Storage.Quest.U10_70.LionsRock.LionsRockFields, player:getStorageValue(Storage.Quest.U10_70.LionsRock.LionsRockFields) + 1)
			checkLionsRockFields(storage)
			return true
		end
	end

	if player:getStorageValue(setting.storage) == setting.value then
		if setting.item == item.itemid then
			local gemSpot = Tile(setting.itemPos):getItemById(setting.fieldId)
			if not gemSpot then
				toPosition:sendMagicEffect(setting.effect)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.message)
				item:remove(1)
				player:setStorageValue(setting.storage, setting.value + 1)
				addEvent(lionsRockCreateField, 2 * 1000, setting.itemPos, setting.fieldId, setting.storage)
				addEvent(lionsRockFieldReset, 60 * 1000)
				return true
			end
		end
	end

	return false
end

for index, value in pairs(shrine) do
	gems:id(index)
end
gems:register()
