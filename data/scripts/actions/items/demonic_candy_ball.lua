local defenseCondition = Condition(CONDITION_ATTRIBUTES)
defenseCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreDefense)
defenseCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
defenseCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
defenseCondition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 10)
defenseCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local magicLevelCondition = Condition(CONDITION_ATTRIBUTES)
magicLevelCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreMagicLevel)
magicLevelCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
magicLevelCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
magicLevelCondition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 5)
magicLevelCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local meleeCondition = Condition(CONDITION_ATTRIBUTES)
meleeCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreMelee)
meleeCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
meleeCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
meleeCondition:setParameter(CONDITION_PARAM_SKILL_MELEE, 10)
meleeCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local distanceCondition = Condition(CONDITION_ATTRIBUTES)
distanceCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreDistance)
distanceCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
distanceCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
distanceCondition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 10)
distanceCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local speedCondition = Condition(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, 729)

local lightCondition = Condition(CONDITION_LIGHT)
lightCondition:setParameter(CONDITION_PARAM_LIGHT_LEVEL, 15)
lightCondition:setParameter(CONDITION_PARAM_LIGHT_COLOR, 154)
lightCondition:setTicks(60 * 60 * 1000)

local demonicCandyBall = Action()

function demonicCandyBall.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("special-foods-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	local availableConditions = { defenseCondition, magicLevelCondition, meleeCondition, distanceCondition, speedCondition }
	local randomConditionIndex = math.random(1, 4)

	if randomConditionIndex == 1 then
		player:addCondition(availableConditions[math.random(1, #availableConditions)])
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel stronger, but you have no idea what was increased.")
	elseif randomConditionIndex == 2 then
		player:addCondition(lightCondition)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel enlightened.")
	elseif randomConditionIndex == 3 then
		player:addCondition(condition_i)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You became invisible.")
	elseif randomConditionIndex == 4 then
		player:addHealth(player:getMaxHealth())
		player:addMana(player:getMaxMana())
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your vitality has been restored.")
	end

	player:say("Smack.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

demonicCandyBall:id(11587)
demonicCandyBall:register()
