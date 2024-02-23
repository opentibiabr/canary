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

local speedCondition = Condition(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, 729)

local distanceCondition = Condition(CONDITION_ATTRIBUTES)
distanceCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreDistance)
distanceCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
distanceCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
distanceCondition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 10)
distanceCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local fishingCondition = Condition(CONDITION_ATTRIBUTES)
fishingCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreFishing)
fishingCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
fishingCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
fishingCondition:setParameter(CONDITION_PARAM_SKILL_FISHING, 50)
fishingCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local foods = {
	[9079] = {
		healing = true,
		message = "Gulp.",
		appliedMessage = "Your health has been refilled.",
	},
	[9080] = {
		removeConditions = true,
		conditions = { CONDITION_POISON, CONDITION_FIRE, CONDITION_ENERGY, CONDITION_PARALYZE, CONDITION_DRUNK, CONDITION_DROWN, CONDITION_FREEZING, CONDITION_DAZZLED, CONDITION_CURSED, CONDITION_BLEEDING },
		message = "Chomp.",
		appliedMessage = "You feel better body condition.",
	},
	[9081] = {
		addConditions = true,
		condition = defenseCondition,
		message = "Gulp.",
		appliedMessage = "You feel less vulnerable.",
	},
	[9082] = {
		addConditions = true,
		condition = magicLevelCondition,
		message = "Chomp.",
		appliedMessage = "You feel smarter.",
	},
	[9083] = {
		message = "Slurp.",
		appliedMessage = "You don't really know what this did to you, but suddenly you feel very happy.",
		effectType = CONST_ME_HEARTS,
	},
	[9084] = {
		addConditions = true,
		condition = meleeCondition,
		message = "Yum.",
		appliedMessage = "You feel stronger.",
	},
	[9085] = {
		addConditions = true,
		condition = speedCondition,
		message = "Munch.",
		appliedMessage = "Your speed has been increased.",
	},
	[9086] = {
		mana = true,
		message = "Chomp.",
		appliedMessage = "Your mana has been refilled.",
	},
	[9087] = {
		addConditions = true,
		condition = distanceCondition,
		message = "Mmmm.",
		appliedMessage = "You feel more focused.",
	},
	[9088] = {
		addConditions = true,
		condition = fishingCondition,
		message = "Smack.",
		appliedMessage = "You felt fishing inspiration.",
	},
	[11584] = {
		coconutShrimpBake = true,
		itemSlot = CONST_SLOT_HEAD,
		itemId = 11585,
		message = "Yum.",
		appliedMessage = "Underwater walking speed increased.",
	},
	[11586] = {
		potOfBlackjack = true,
		message = "Gulp.",
		appliedMessage = "You take a gulp from the large bowl.",
		chanceToRemove = 5,
	},
}

local jeanPierreFoods = Action()

function jeanPierreFoods.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local food = foods[item.itemid]
	if not food then
		return true
	end

	if player:hasExhaustion("jean-pierre-foods") then
		player:say("You need to wait before using it again.", TALKTYPE_MONSTER_SAY)
		return true
	end

	if food.removeConditions then
		for _, conditionType in ipairs(food.conditions) do
			player:removeCondition(conditionType)
		end
	elseif food.healing then
		player:addHealth(player:getMaxHealth())
	elseif food.mana then
		player:addMana(player:getMaxMana())
	elseif food.addConditions then
		player:addCondition(food.condition)
	elseif food.coconutShrimpBake then
		local headItem = player:getSlotItem(food.itemSlot)
		if headItem and headItem.itemid == food.itemId then
			player:setExhaustion("coconut-shrimp-bake", 24 * 60 * 60)
		end
	elseif food.potOfBlackjack then
		if math.random(1, food.chanceToRemove) == food.chanceToRemove then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take the last gulp from the large bowl. No leftovers!")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take a gulp from the large bowl, but there's still some blackjack in it.")
		end
	end

	if food.effectType then
		player:getPosition():sendMagicEffect(food.effectType)
	else
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, food.appliedMessage)
	player:say(food.message, TALKTYPE_MONSTER_SAY)
	player:setExhaustion("jean-pierre-foods", 10 * 60)

	item:remove(1)
	return true
end

for index, value in pairs(foods) do
	jeanPierreFoods:id(index)
end

jeanPierreFoods:register()
