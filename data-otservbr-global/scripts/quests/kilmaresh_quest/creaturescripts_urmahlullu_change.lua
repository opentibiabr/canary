local timetochange = 60 --in seconds
local time = os.time()

local healthMultiplier = configManager.getFloat(configKeys.RATE_BOSS_HEALTH)

--base urmahlullu have 515000/515000 hp, next form 400000/515000,
-- next form 300000/515000, next form 200000/515000, and last 100000/515000

local urmahlulluChanges = CreatureEvent("UrmahlulluChanges")

local stages = {
	{ name = "Urmahlullu the Immaculate", health = 515000 * healthMultiplier },
	{ name = "Wildness of Urmahlullu", health = 400000 * healthMultiplier },
	{ name = "Urmahlullu the Tamed", health = 300000 * healthMultiplier },
	{ name = "Wisdom of Urmahlullu", health = 200000 * healthMultiplier },
	{ name = "Urmahlullu the Weakened", health = 100000 * healthMultiplier },
}

local changeEvent = nil
local revertEvent = nil

local function revert(cid, name)
	local creature = Creature(cid, name)
	if not creature then
		return
	end

	if creature:getName() == name then
		return
	end

	local position = creature:getPosition()
	creature:remove()
	local monster = Game.createMonster(name, position, true, true)
	if not monster then
		return
	end
	if name ~= stages[5].name then
		changeEvent = nil
		revertEvent = addEvent(revert, timetochange * 1000, creature:getId(), stages[1].name)
	else
		changeEvent = nil
		revertEvent = nil
	end
end

local function changeStage(cid, stage)
	changeEvent = nil
	local creature = Creature(cid)
	if not creature then
		return
	end

	local position = creature:getPosition()
	local previousName = creature:getName()
	creature:remove()
	local newCreature = Game.createMonster(stage, position, true, true)
	if not newCreature then
		return
	end
	revertEvent = addEvent(revert, timetochange * 1000, newCreature:getId(), previousName)
end

function urmahlulluChanges.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local name = creature:getName()
	local nextStageIndex = 1
	for i, stage in ipairs(stages) do
		if stage.name == name then
			nextStageIndex = i + 1
			break
		end
	end

	if nextStageIndex > #stages then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local stage = stages[nextStageIndex]
	if creature:getHealth() <= stage.health and not changeEvent then
		if revertEvent then
			stopEvent(revertEvent)
		end
		revertEvent = nil
		changeEvent = addEvent(changeStage, SCHEDULER_MIN_TICKS, creature:getId(), stage.name)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

urmahlulluChanges:register()
