local potionConditionsConfig = {
	[36724] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 5}}},
	[36726] = {1 * 60 * 60 * 1000},
	[36727] = {1 * 60 * 60 * 1000},
	[36728] = {1 * 60 * 60 * 1000},
	[36729] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_ABSORB_FIREPERCENT, 8}}},
	[36730] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_ABSORB_ICEPERCENT, 8}}},
	[36731] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_ABSORB_EARTHPERCENT, 8}}},
	[36732] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_ABSORB_ENERGYPERCENT, 8}}},
	[36733] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_ABSORB_HOLYPERCENT, 8}}},
	[36734] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_ABSORB_DEATHPERCENT, 8}}},
	[36735] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_ABSORB_PHYSICALPERCENT, 8}}},
	[36736] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_INCREASE_FIREPERCENT, 8}}},
	[36737] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_INCREASE_ICEPERCENT, 8}}},
	[36738] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_INCREASE_EARTHPERCENT, 8}}},
	[36739] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_INCREASE_ENERGYPERCENT, 8}}},
	[36740] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_INCREASE_HOLYPERCENT, 8}}},
	[36741] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_INCREASE_DEATHPERCENT, 8}}},
	[36742] = {1 * 60 * 60 * 1000, {{CONDITION_PARAM_INCREASE_PHYSICALPERCENT, 8}}},
}

local potionConditions = {}

local potionFunctions = {
	[36723] = function(player)
		for i=1, 200 do
			if player:hasCondition(CONDITION_SPELLCOOLDOWN, i) then
				player:removeCondition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, i)
				player:sendSpellCooldown(i, 0)
			end
		end
		for i=1, 8 do
			if player:hasCondition(CONDITION_SPELLGROUPCOOLDOWN, i) then
				player:removeCondition(CONDITION_SPELLGROUPCOOLDOWN, CONDITIONID_DEFAULT, i)
				player:sendSpellGroupCooldown(i, 0)
			end
		end
	end,
	[36725] = function(p) 
		p:setStamina(p:getStamina() + 60) 
	end,
}

for id, data in pairs(potionConditionsConfig) do
	potionConditions[id] = {}
	if data[1] then
		if data[2] then
			local condition = Condition(CONDITION_ATTRIBUTES, CONDITIONID_DEFAULT)
			condition:setParameter(CONDITION_PARAM_SUBID, id)
			condition:setParameter(CONDITION_PARAM_TICKS, data[1])
			if data[2] then
				for _, params in pairs(data[2]) do
					condition:setParameter(params[1], params[2])
				end
			end
			table.insert(potionConditions[id], condition)
		end
		local condition = Condition(CONDITION_TIBIADROMEPOTIONS, CONDITIONID_DEFAULT)
		condition:setParameter(CONDITION_PARAM_SUBID, id)
		condition:setParameter(CONDITION_PARAM_TICKS, data[1])
		table.insert(potionConditions[id], condition)
	end
end
		
		
			

local tibiaDromePotions = Action()

function tibiaDromePotions.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    if (not player) then
        return false
    end
	local itemID = item:getId()
	if player:getStorageValue(itemID) >= os.time() then
		player:sendCancelMessage("You can only use this potion once every 24 hours.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end
	
	if player:getCondition(CONDITION_TIBIADROMEPOTIONS, CONDITIONID_DEFAULT, itemID) then
		player:sendCancelMessage("You still have the effects from this potion.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:setStorageValue(itemID, os.time() + 24 * 60 * 60)
	item:remove(1)
	local potionConditions = potionConditions[itemID]
	if potionConditions then
		for _, condition in pairs(potionConditions) do
			player:addCondition(condition)
		end
	end
	local potionFunction = potionFunctions[itemID]
	if potionFunction then
		potionFunction(player)
	end
    return true
end

for itemid = 36723, 36742 do
	tibiaDromePotions:id(itemid)
end
tibiaDromePotions:register()
