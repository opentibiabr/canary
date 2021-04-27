local UniqueTable = {
	[40011] = {
		storage = Storage.InsectoidCell.Reward1,
		reward = 15572
	},
	[40012] = {
		storage = Storage.InsectoidCell.Reward2,
		reward = 15572
	},
	[40013] = {
		storage = Storage.InsectoidCell.Reward3,
		reward = 15572
	},
	[40014] = {
		storage = Storage.InsectoidCell.Reward4,
		reward = 15572
	},
	[40015] = {
		storage = Storage.InsectoidCell.Reward5,
		reward = 15572
	},
	[40016] = {
		storage = Storage.InsectoidCell.Reward6,
		reward = 15572
	},
	[40017] = {
		storage = Storage.InsectoidCell.Reward7,
		reward = 15572
	},
	[40018] = {
		storage = Storage.InsectoidCell.Reward8,
		reward = 15572
	},
	[40019] = {
		storage = Storage.InsectoidCell.Reward9,
		reward = 15572
	},
	[40020] = {
		storage = Storage.InsectoidCell.Reward10,
		reward = 15572
	},
	[40021] = {
		storage = Storage.InsectoidCell.Reward11,
		reward = 15572
	},
	[40022] = {
		storage = Storage.InsectoidCell.Reward12,
		reward = 15572
	},
	[40023] = {
		storage = Storage.InsectoidCell.Reward13,
		reward = 15572
	},
	[40024] = {
		storage = Storage.InsectoidCell.Reward14,
		reward = 15572
	},
	[40025] = {
		storage = Storage.InsectoidCell.Reward15,
		reward = 15572
	},
	[40026] = {
		storage = Storage.InsectoidCell.Reward16,
		reward = 15572
	}
}

local gooeyMass = Action()

function gooeyMass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = UniqueTable[item.uid]
	if setting then
		if player:getStorageValue(setting.storage) < os.time() then
			local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
			if backpack and backpack:getEmptySlots(true) >= 1 then
				if (player:getFreeCapacity() / 100) > getItemWeight(setting.reward) then
					player:addItem(setting.reward)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. getItemName(setting.reward) .. ".")
					player:setStorageValue(setting.storage, os.time() + 7 * 24 * 60 * 60) -- 7 days
					return true
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. getItemName(setting.reward) .. ". Weighing " .. getItemWeight(setting.reward) .. " oz it is too heavy.")
				end
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. getItemName(setting.reward) .. ", but you have no room to take it")
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The ".. getItemName(setting.itemId) .. " is empty.")
		end
	end
	return true
end

for index, value in pairs(UniqueTable) do
	gooeyMass:uid(index)
end

gooeyMass:register()
