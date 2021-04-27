local config = {
	[8062] = {text = 'This mission stinks ... and now you do as well!', condition = true, transformId = 7477},
	[6065] = {text = 'You carefully gather the quara ink', transformId = 7489},
	[20514] = {text = 'You carefully gather the stalker blood.', transformId = 7488}
}

local poisonField = Condition(CONDITION_OUTFIT)
poisonField:setTicks(8000)
poisonField:setOutfit({lookTypeEx = 1496})

local whatFoolishFlask = Action()
function whatFoolishFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.itemid]
	if not targetItem then
		return false
	end

	if targetItem.condition then
		player:addCondition(poisonField)
	end

	player:say(targetItem.text, TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_HITBYPOISON)
	item:transform(targetItem.transformId)
	return true
end

whatFoolishFlask:id(7478)
whatFoolishFlask:register()