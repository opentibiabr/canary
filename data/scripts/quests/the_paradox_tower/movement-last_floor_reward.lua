local setting = {
	[50308] = {
		position = {x = 32477, y = 31900, z = 1},
		storage = Storage.Quest.TheParadoxTower.Reward.Egg
	},
	[50309] = {
		position = {x = 32478, y = 31900, z = 1},
		storage = Storage.Quest.TheParadoxTower.Reward.Gold
	},
	[50310] = {
		position = {x = 32479, y = 31900, z = 1},
		storage = Storage.Quest.TheParadoxTower.Reward.Talon
	},
	[50311] = {
		position = {x = 32480, y = 31900, z = 1},
		storage = Storage.Quest.TheParadoxTower.Reward.Wand
	}
}

local lastFloorReward = MoveEvent()

function lastFloorReward.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- Checks the table on line 1
	local action = setting[item.actionid]
	if not action then
		return true
	end

	-- If already step in on the tile, nothing will happen
	if player:getStorageValue(action.storage) == 1 then
		return true
	end

	-- Sends the effect to the chest position
	Position(action.position):sendMagicEffect(CONST_ME_FIREAREA)
	-- Set the storage if reward, to "destroy" the chest
	player:setStorageValue(action.storage, 1)
	return true
end

for action, value in pairs(setting) do
	lastFloorReward:aid(action)
end

lastFloorReward:register()
