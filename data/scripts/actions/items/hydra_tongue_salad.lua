local conditionsToRemove = {
	CONDITION_POISON,
	CONDITION_FIRE,
	CONDITION_ENERGY,
	CONDITION_PARALYZE,
	CONDITION_DRUNK,
	CONDITION_DROWN,
	CONDITION_FREEZING,
	CONDITION_DAZZLED,
	CONDITION_CURSED,
	CONDITION_BLEEDING,
}

local hydraTongueSalad = Action()

function hydraTongueSalad.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("jean-pierre-foods") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	for _, conditionType in ipairs(conditionsToRemove) do
		player:removeCondition(conditionType)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel better body condition.")
	player:say("Chomp.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("jean-pierre-foods", 10 * 60)
	item:remove(1)
	return true
end

hydraTongueSalad:id(9080)
hydraTongueSalad:register()
