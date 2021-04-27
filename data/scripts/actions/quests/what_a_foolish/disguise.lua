local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(10000)
condition:setOutfit({lookType = 65})

local whatFoolishDisguise = Action()
function whatFoolishDisguise.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:addCondition(condition)
	player:say('You are now disguised as a mummy for 10 seconds. Hurry up and scare the caliph!', TALKTYPE_MONSTER_SAY)
	return true
end

whatFoolishDisguise:id(7502)
whatFoolishDisguise:register()