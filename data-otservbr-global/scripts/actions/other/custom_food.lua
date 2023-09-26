local foods = {
	[30006] = {60 , "Gulp."},
}

local custom_food = Action()
function custom_food.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemFood = foods[item.itemid]
	if not itemFood then
		return false
	end
	local player_conditions = {
		CONDITION_HASTE,
		CONDITION_BLEEDING,
		CONDITION_POISON,
		CONDITION_FIRE,
		CONDITION_BLEEDING,
		CONDITION_ENERGY,
		CONDITION_DROWN,
		CONDITION_FREEZING,
		CONDITION_CURSED,
		CONDITION_DAZZLED
	}
	for i = 1, #player_conditions do
		local owncondition = player_conditions[i]
		if player:hasCondition(owncondition) then
				player:removeCondition(owncondition)
		end
end
	local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition and math.floor(condition:getTicks() / 1000 + (itemFood[1] * 12)) >= 1200 then
		player:sendTextMessage(MESSAGE_FAILURE, "You are full.")
		return true
	end
	player:feed(itemFood[1] * 12)
	player:say(itemFood[2], TALKTYPE_MONSTER_SAY)
	player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_EAT, player:isInGhostMode() and nil or player)
	return true
end

for index, value in pairs(foods) do
	custom_food:id(index)
end

custom_food:register()
