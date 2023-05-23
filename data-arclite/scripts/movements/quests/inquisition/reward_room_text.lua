local textPos = {
	{x = 32318, y = 32251, z = 9},
	{x = 32319, y = 32251, z = 9},
	{x = 32320, y = 32251, z = 9}}

local rewardRoomText = MoveEvent()

function rewardRoomText.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player or player:getStorageValue(Storage.TheInquisition.RewardRoomText) == 1 then
		return true
	end

	player:setStorageValue(Storage.TheInquisition.RewardRoomText, 1)
	player:say("You can choose exactly one of these chests. Choose wisely!", TALKTYPE_MONSTER_SAY)
	return true
end

for a = 1, #textPos do
	rewardRoomText:position(textPos[a])
end
rewardRoomText:register()
