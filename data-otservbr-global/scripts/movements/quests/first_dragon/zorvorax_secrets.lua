local UniqueTable = {
	[25002] = {
		storage = Storage.FirstDragon.DesertTile,
		msg = "You enter the beautiful oasis. \
		By visiting this sacred site you're infused with the power of water bringing life to the desert."
	},
	[25003] = {
		storage = Storage.FirstDragon.StoneSculptureTile,
		msg = "You enter the circle of trees and flowers. \
		By visiting this sacred site you're infused with the power of nature and plants."
	},
	[25004] = {
		storage = Storage.FirstDragon.SuntowerTile,
		msg = "You entered the suntower of Ab'dendriel. \
		By visiting this sacred site you're infused with the power of the life-giving sun."
	}
}

local zorvoraxSecrets = MoveEvent()

function zorvoraxSecrets.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local setting = UniqueTable[item.actionid]
	if not setting then
		return true
	end

	if player:getStorageValue(setting.storage) < 1 then
		player:setStorageValue(setting.storage, 1)
		player:setStorageValue(Storage.FirstDragon.SecretsCounter, player:getStorageValue(Storage.FirstDragon.SecretsCounter) + 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.msg)
		return true
	end
	return true
end

for index, value in pairs(UniqueTable) do
	zorvoraxSecrets:aid(index)
end

zorvoraxSecrets:register()
