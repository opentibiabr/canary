local config = {
	-- yellow
	[1085] = {
		itemId = 32642,
		msg = "Success",
		storage = Storage.TheSecretLibrary.Mota,
		getValue = 4,
		setValue = 5,
		basin = 2605
	},
	-- green
	[1086] = {
		itemId = 32641,
		msg = "Success",
		storage = Storage.TheSecretLibrary.Mota,
		getValue = 5,
		setValue = 6,
		basin = 2605
	},
	-- red
	[1087] =
	{itemId = 32643,
		msg = "Success",
		storage = Storage.TheSecretLibrary.Mota,
		getValue = 6,
		setValue = 7,
		basin = 2605
	}
}

local energyBasin = Action()

function energyBasin.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = config[item.uid]
		if setting then
			if player:getStorageValue(setting.storage) == setting.getValue then
				player:removeItem(setting.itemId, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.msg)
				player:setStorageValue(setting.storage, setting.setValue)
			else
				player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			end
		end
	return true
end

for index, value in pairs(config) do
	energyBasin:uid(index)
end

energyBasin:register()
