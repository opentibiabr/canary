local corymChests = MoveEvent()

function corymChests.onStepOut(creature, item, position, fromPosition)
	local HiddenThreats = Storage.Quest.U11_50.HiddenThreats
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getStorageValue(HiddenThreats.Rewards.keyFragment01) == 1
	and player:getStorageValue(HiddenThreats.Rewards.keyFragment02) == 1
	and player:getStorageValue(HiddenThreats.QuestLine) == 2 then
		player:setStorageValue(HiddenThreats.QuestLine, 3)
	end
	return true
end

corymChests:position({x = 33079, y = 32014, z = 13})
corymChests:position({x = 33079, y = 32015, z = 13})
corymChests:position({x = 33080, y = 32015, z = 13})
corymChests:position({x = 33032, y = 32050, z = 13})
corymChests:position({x = 33032, y = 32051, z = 13})
corymChests:register()
