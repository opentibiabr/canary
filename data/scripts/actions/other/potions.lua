local berserk = Condition(CONDITION_ATTRIBUTES)
berserk:setParameter(CONDITION_PARAM_TICKS, 10 * 60 * 1000)
berserk:setParameter(CONDITION_PARAM_SKILL_MELEE, 5)
berserk:setParameter(CONDITION_PARAM_SKILL_SHIELD, -10)
berserk:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local mastermind = Condition(CONDITION_ATTRIBUTES)
mastermind:setParameter(CONDITION_PARAM_TICKS, 10 * 60 * 1000)
mastermind:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 3)
mastermind:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local bullseye = Condition(CONDITION_ATTRIBUTES)
bullseye:setParameter(CONDITION_PARAM_TICKS, 10 * 60 * 1000)
bullseye:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 5)
bullseye:setParameter(CONDITION_PARAM_SKILL_SHIELD, -10)
bullseye:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local setting = {
	[236] = {
		health = {250, 350},
		vocations = {
			VOCATION.BASE_ID.KNIGHT,
			VOCATION.BASE_ID.PALADIN
		},
		level = 50,
		flask = 283,
		description = "Only knights and paladins of level 50 or above may drink this fluid."
	},
	[237] = {
		mana = {115, 185},
		vocations = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID,
			VOCATION.BASE_ID.PALADIN
		},
		level = 50,
		flask = 283,
		description = "Only sorcerers, druids and paladins of level 50 or above may drink this fluid."
	},
	[238] = {
		mana = {150, 250},
		vocations = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		},
		level = 80,
		flask = 284,
		description = "Only druids and sorcerers of level 80 or above may drink this fluid."
	},
	[239] = {
		health = {425, 575},
		vocations = {
			VOCATION.BASE_ID.KNIGHT
		},
		level = 80,
		flask = 284,
		description = "Only knights of level 80 or above may drink this fluid."
	},
	[266] = {
		health = {125, 175},
		flask = 285
	},
	[268] = {
		mana = {75, 125},
		flask = 285
	},
	[6558] = {
		transform = {
			id = {236, 237}
		},
		effect = CONST_ME_DRAWBLOOD
	},
	[7439] = {
		condition = berserk,
		vocations = {
			VOCATION.BASE_ID.KNIGHT
		},
		effect = CONST_ME_MAGIC_RED,
		description = "Only knights may drink this potion.", text = "You feel stronger."
	},
	[7440] = {
		condition = mastermind,
		vocations = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		},
		effect = CONST_ME_MAGIC_BLUE,
		description = "Only sorcerers and druids may drink this potion.", text = "You feel smarter."
	},
	[7443] = {
		condition = bullseye,
		vocations = {
			VOCATION.BASE_ID.PALADIN
		},
		effect = CONST_ME_MAGIC_GREEN,
		description = "Only paladins may drink this potion.", text = "You feel more accurate."
	},
	[7642] = {
		health = {250, 350}, mana = {100, 200},
		vocations = {
			VOCATION.BASE_ID.PALADIN
		},
		level = 80,
		flask = 284,
		description = "Only paladins of level 80 or above may drink this fluid."
	},
	[7643] = {
		health = {650, 850},
		vocations = {
			VOCATION.BASE_ID.KNIGHT
		},
		level = 130,
		flask = 284,
		description = "Only knights of level 130 or above may drink this fluid."
	},
	[7644] = {
		antidote = true,
		flask = 285
	},
	[7876] = {
		health = {60, 90},
		flask = 285
	},
	[23373] = {
		mana = {425, 575},
		vocations = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		},
		level = 130,
		flask = 284,
		description = "Only druids and sorcerers of level 130 or above may drink this fluid."
	},
	[23374] = {
		health = {420, 580}, mana = {250, 350},
		vocations = {
			VOCATION.BASE_ID.PALADIN
		},
		level = 130,
		flask = 284,
		description = "Only paladins of level 130 or above may drink this fluid."
	},
	[23375] = {
		health = {875, 1125},
		vocations = {
			VOCATION.BASE_ID.KNIGHT
		},
		level = 200,
		flask = 284,
		description = "Only knights of level 200 or above may drink this fluid."
	}
}

local potions = Action()

function potions.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if type(target) == "userdata" and not target:isPlayer() then
		return false
	end

	local potion = setting[item:getId()]
	if potion.level and player:getLevel() < potion.level or potion.vocations and not table.contains(potion.vocations, player:getVocation():getBaseId()) then
		player:say(potion.description, TALKTYPE_MONSTER_SAY)
		return true
	end

	if potion.condition then
		player:addCondition(potion.condition)
		player:say(potion.text, TALKTYPE_MONSTER_SAY)
		player:getPosition():sendMagicEffect(potion.effect)
	elseif potion.transform then
		item:transform(potion.transform[math.random(#potion.transform)])
		item:getPosition():sendMagicEffect(potion.effect)
		return true
	else
		if potion.health then
			doTargetCombatHealth(player, target, COMBAT_HEALING, potion.health[1], potion.health[2])
		end

		if potion.mana then
			doTargetCombatMana(0, target, potion.mana[1], potion.mana[2])
		end

		if potion.antidote then
			target:removeCondition(CONDITION_POISON)
		end

		player:addItem(potion.flask)
		target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end

	if not configManager.getBoolean(configKeys.REMOVE_POTION_CHARGES) then
		return true
	end

	player:updateSupplyTracker(item)
	item:remove(1)
	return true
end

for index, value in pairs(setting) do
    potions:id(index)
end

potions:register()
