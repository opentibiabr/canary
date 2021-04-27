local config = {
	[1074] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 2, setValue = 3},
	[1075] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 3, setValue = 4},
	[1076] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 4, setValue = 5},
	[1077] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 5, setValue = 6},
	[1078] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 6, setValue = 7},
	[1079] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 7, setValue = 8},
	[1080] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 8, setValue = 9},
	[1081] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 9, setValue = 10},
	[1082] = {itemId = 17240, msg = "The Njey will appreciate your help.", storage = Storage.TheSecretLibrary.LiquidDeath, getValue = 10, setValue = 11},
}

local statuedeeplings = Action()

function statuedeeplings.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local key = config[item.uid]
		if key then
			if player:getStorageValue(key.storage) == key.getValue then
				if table.contains({key.itemId}, item.itemid) then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, key.msg)
					player:setStorageValue(key.storage, key.setValue)
				end
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Empty.")
			end
		end
	return true
end

for index, value in pairs(config) do
	statuedeeplings:uid(index)
end

statuedeeplings:register()
