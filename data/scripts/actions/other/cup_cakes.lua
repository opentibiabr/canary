local data = {
[31719] = {
	Type = "mana",
	ExhaustStor = Storage.BlueberryCupcake,
	timestamp = 10
	},
[31720] = {
	Type = "health",
	ExhaustStor = Storage.StrawberryCupcake,
	timestamp = 10
	},
[31721] = {
	Type = "skill",
	ExhaustStor = Storage.LemonCupcake,
	timestamp = 10
	}
}

local lemon = Condition(CONDITION_ATTRIBUTES)
lemon:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
lemon:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 10)

local cupCakes = Action()

function cupCakes.onUse(player, item, fromPos, itemEx, toPos)
local foundItem = data[item.itemid]
	if not(foundItem) then
		return
	end
	if (player:getStorageValue(foundItem.ExhaustStor)) < os.time() then
		if foundItem.Type == "mana" then
			player:addMana(player:getMaxMana())	
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your mana has been refilled.")
		elseif foundItem.Type == "health" then
			player:addHealth(player:getMaxHealth())
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your health has been refilled.")
		elseif foundItem.Type == "skill" then
			player:addCondition(lemon)
			player:sendTextMessage(MESSAGE_FAILURE, "You feel more focused.")
		end
		player:say("Mmmm.",TALKTYPE_ORANGE_1)
		item:remove(1)
		player:setStorageValue(foundItem.ExhaustStor, os.time() + (foundItem.timestamp * 60))	
	else
		player:sendTextMessage(MESSAGE_FAILURE, "You need to wait before using it again.")
	end
	return true
end

cupCakes:id(31719, 31720, 31721)
cupCakes:register()
