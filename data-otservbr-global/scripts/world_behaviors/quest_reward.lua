local executeReward = dofile(DATA_DIRECTORY .. "/lib/core/world_quest_reward.lua")
local reward = WorldBehavior("quest.reward", 1)

local function rewardList(values)
	if not values then
		return nil
	end
	local result = {}
	for index, value in ipairs(values) do
		result[index] = { value.itemId, value.count }
	end
	return result
end

function reward.onUse(context, player, item, fromPosition, target, toPosition, isHotkey)
	local setting = { itemId = context:parameter("emptyItemId") or context:object():getInitialItemId() }
	for _, name in ipairs({ "storage", "useKV", "questName", "container", "keyAction", "isKey", "weight", "timerStorage", "time" }) do
		setting[name] = context:parameter(name)
	end
	setting.reward = rewardList(context:parameter("reward"))
	setting.randomReward = rewardList(context:parameter("randomReward"))
	if setting.randomReward and #setting.reward == 0 then
		setting.reward[1] = {}
	end
	local text = context:parameter("rewardText")
	return executeReward(player, item, setting, text and { text = text }, context:parameter("achievement"))
end

reward:register()
