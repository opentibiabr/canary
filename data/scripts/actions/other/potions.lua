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

local antidote = Combat()
antidote:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
antidote:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
antidote:setParameter(COMBAT_PARAM_DISPEL, CONDITION_POISON)
antidote:setParameter(COMBAT_PARAM_AGGRESSIVE, false)
antidote:setParameter(COMBAT_PARAM_TARGETCASTERORTOPMOST, true)

local exhaust = Condition(CONDITION_EXHAUST_HEAL)
exhaust:setParameter(CONDITION_PARAM_TICKS, (configManager.getNumber(configKeys.EX_ACTIONS_DELAY_INTERVAL) - 1000))
-- 1000 - 100 due to exact condition timing. -100 doesn't hurt us, and players don't have reminding ~50ms exhaustion.

local function magicshield(player)
local condition = Condition(CONDITION_MANASHIELD)
condition:setParameter(CONDITION_PARAM_TICKS, 60000)
condition:setParameter(CONDITION_PARAM_MANASHIELD, math.min(player:getMaxMana(), 300 + 7.6 * player:getLevel() + 7 * player:getMagicLevel()))
player:addCondition(condition)
end

local potions = {
	[6558] = {
		transform = {
			id = {7588, 7589}
		},
		effect = CONST_ME_DRAWBLOOD
	},
	[7439] = {
		vocations = {
			VOCATION.CLIENT_ID.KNIGHT
		},
		condition = berserk,
		effect = CONST_ME_MAGIC_RED,
		description = "Only knights may drink this potion.",
		text = "You feel stronger."
	},
	[7440] = {
		vocations = {
			VOCATION.CLIENT_ID.SORCERER,
			VOCATION.CLIENT_ID.DRUID
		},
		condition = mastermind,
		effect = CONST_ME_MAGIC_BLUE,
		description = "Only sorcerers and druids may drink this potion.",
		text = "You feel smarter."
	},
	[7443] = {
		vocations = {
			VOCATION.CLIENT_ID.PALADIN
		},
		condition = bullseye,
		effect = CONST_ME_MAGIC_GREEN,
		description = "Only paladins may drink this potion.",
		text = "You feel more accurate."
	},
	[40398] = {
		vocations = {
			VOCATION.CLIENT_ID.SORCERER,
			VOCATION.CLIENT_ID.DRUID
		},
		level = 14,
		func = magicshield,
		effect = CONST_ME_ENERGYAREA,
		description = "Only sorcerers and druids of level 14 or above may drink this potion.",
	},
	[7588] = {
		health = {
			250,
			350
		},
		vocations = {
			VOCATION.CLIENT_ID.PALADIN,
			VOCATION.CLIENT_ID.KNIGHT
		},
		level = 50,
		flask = 7634,
		description = "Only knights and paladins of level 50 or above may drink this fluid."
	},
	[7589] = {
		mana = {
			115,
			185
		},
		level = 50,
		flask = 7634,
		description = "Only players of level 50 or above may drink this fluid."
	},
	[7590] = {
		mana = {
			150,
			250
		},
		vocations = {
			VOCATION.CLIENT_ID.SORCERER,
			VOCATION.CLIENT_ID.DRUID,
			VOCATION.CLIENT_ID.PALADIN
		},
		level = 80,
		flask = 7635,
		description = "Only sorcerers, druids and paladins of level 80 or above may drink this fluid."
	},
	[7591] = {
		health = {
			425,
			575
		},
		vocations = {
			VOCATION.CLIENT_ID.KNIGHT
		},
		level = 80,
		flask = 7635,
		description = "Only knights of level 80 or above may drink this fluid."
	},
	[7618] = {
		health = {
			125,
			175
		},
		flask = 7636
	},
	[7620] = {
		mana = {
			75,
			125
		},
		flask = 7636
	},
	[8472] = {
		health = {
			250,
			350
		},
		mana = {
			100,
			200
		},
		vocations = {
			VOCATION.CLIENT_ID.PALADIN
		},
		level = 80,
		flask = 7635,
		description = "Only paladins of level 80 or above may drink this fluid."
	},
	[8473] = {
		health = {650, 850},
		vocations = {
			VOCATION.CLIENT_ID.KNIGHT
		},
		level = 130,
		flask = 7635,
		description = "Only knights of level 130 or above may drink this fluid."
	},
	[8474] = {
		combat = antidote,
		flask = 7636
	},
	[8704] = {
		health = {
			60,
			90
		},
		flask = 7636
	},
	[26029] = {
		mana = {
			425,
			575
		},
		vocations = {
			VOCATION.CLIENT_ID.SORCERER,
			VOCATION.CLIENT_ID.DRUID
		},
		level = 130,
		flask = 7635,
		description = "Only druids and sorcerers of level 130 or above may drink this fluid."
	},
	[26030] = {
		health = {
			420,
			580
		},
		mana = {
			250,
			350
		},
		vocations = {
			VOCATION.CLIENT_ID.PALADIN
		},
		level = 130,
		flask = 7635,
		description = "Only paladins of level 130 or above may drink this fluid."
	},
	[26031] = {
		health = {
			875,
			1125
		},
		vocations = {
			VOCATION.CLIENT_ID.KNIGHT
		},
		level = 200,
		flask = 7635,
		description = "Only knights of level 200 or above may drink this fluid."
	}
}

local flaskPotion = Action()

function flaskPotion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if type(target) == "userdata" and not target:isPlayer() then
		return false
	end

	-- Delay potion
	if not playerDelayPotion[player:getId()] then
		playerDelayPotion[player:getId()] = 0
	end
	if playerDelayPotion[player:getId()] > os.mtime() then
		player:sendTextMessage(MESSAGE_FAILURE, Game.getReturnMessage(RETURNVALUE_YOUAREEXHAUSTED))
		return true
	end

	local potion = potions[item:getId()]
	if potion.level and player:getLevel() < potion.level or potion.vocations and not table.contains(potion.vocations, player:getVocation():getClientId()) and not (player:getGroup():getId() >= 2) then
		player:say(potion.description, MESSAGE_POTION)
		return true
	end

	if player:getCondition(CONDITION_EXHAUST_HEAL) then
		player:sendTextMessage(MESSAGE_FAILURE, Game.getReturnMessage(RETURNVALUE_YOUAREEXHAUSTED))
		return true
	end

	if potion.health or potion.mana or potion.combat then
		if potion.health then
			doTargetCombatHealth(0, target, COMBAT_HEALING, potion.health[1], potion.health[2], CONST_ME_MAGIC_BLUE)
		end

		if potion.mana then
			doTargetCombatMana(0, target, potion.mana[1], potion.mana[2], CONST_ME_MAGIC_BLUE)
		end

		if potion.combat then
			potion.combat:execute(target, Variant(target:getId()))
		end

		player:addAchievementProgress('Potion Addict', 100000)
		target:say("Aaaah...", MESSAGE_POTION)
		player:addItem(potion.flask, 1)
		player:addCondition(exhaust)
		player:setStorageValue(38412, player:getStorageValue(38412)+1)
	end

	-- Delay potion
	playerDelayPotion[player:getId()] = os.mtime() + 500
	
	if potion.func then
		potion.func(player)
		if potion.text then
			player:say(potion.text, MESSAGE_POTION)
		end
		player:getPosition():sendMagicEffect(potion.effect)
	end

	if potion.condition then
		player:addCondition(potion.condition)
		player:say(potion.text, MESSAGE_POTION)
		player:getPosition():sendMagicEffect(potion.effect)
	end

	if potion.transform then
		if item:getCount() >= 1 then
			item:remove(1)
			player:addItem(potion.transform.id[math.random(#potion.transform.id)], 1)
			item:getPosition():sendMagicEffect(potion.effect)
			return true
		end
	end

	if not configManager.getBoolean(configKeys.REMOVE_POTION_CHARGES) then
		return true
	end

	player:updateSupplyTracker(item)
	item:remove(1)
	return true
end

for index, value in pairs(potions) do
	flaskPotion:id(index)
end

flaskPotion:register()
