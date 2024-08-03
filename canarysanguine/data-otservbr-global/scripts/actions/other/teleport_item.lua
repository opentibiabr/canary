-- Script for items that teleport when giving use
-- Add a new item in the action_unique table at the correct range

local teleportItem = Action()

function teleportItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = TeleportItemUnique[item.uid]
	if setting then
		player:teleportTo(setting.destination)
		player:getPosition():sendMagicEffect(setting.effect)
	end
	return true
end

for uniqueRange = 15001, 20000 do
	teleportItem:uid(uniqueRange)
end

teleportItem:register()
