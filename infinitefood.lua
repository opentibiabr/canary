local setting = {
	--[itemid] = {foodvalue, saytext}
	[44204] = { 2400, "Mmmm, delicious chicken!" }, -- chicken | 300 = 1hr, 2400 = 8hrs
	[44205] = { 2400, "Mmmm, delicious pizza!" }, -- pizza | 300 = 1hr, 2400 = 8hrs
}

local food = Action()

function food.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemFood = setting[item.itemid]
	if not itemFood then
		return false
	end
	
	local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition and math.floor(condition:getTicks() / 1000 + (itemFood[1] * 12)) >= 1200 then
		player:sendTextMessage(MESSAGE_FAILURE, "You are full.")
		return true
	end

	player:feed(itemFood[1] * 12)
	player:say(itemFood[2], TALKTYPE_MONSTER_SAY)
	item:remove(0)
	player:updateSupplyTracker(item)
	player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_EAT, player:isInGhostMode() and nil or player)
	player:getPosition():sendMagicEffect(CONST_ME_YELLOWENERGY)
	return true
end

for index, value in pairs(setting) do
	food:id(index)
end

food:register()