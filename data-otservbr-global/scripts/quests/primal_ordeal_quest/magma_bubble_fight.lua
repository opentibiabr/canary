local magicFieldId = 39232
local chargedFlameId = 39230
local heatedCrystalId = 39168
local cooledCrystalId = 39169

local overheatedZone = Zone("fight.magma-bubble.overheated")
local bossZone = Zone("boss.magma-bubble")
local spawnZone = Zone("fight.magma-bubble.spawn")

-- top left
overheatedZone:addArea({ x = 33634, y = 32891, z = 15 }, { x = 33645, y = 32898, z = 15 })
overheatedZone:addArea({ x = 33634, y = 32886, z = 15 }, { x = 33648, y = 32892, z = 15 })

-- top right
overheatedZone:addArea({ x = 33651, y = 32890, z = 15 }, { x = 33670, y = 32896, z = 15 })
overheatedZone:addArea({ x = 33664, y = 32896, z = 15 }, { x = 33671, y = 32899, z = 15 })

-- bottom left
overheatedZone:addArea({ x = 33635, y = 32911, z = 15 }, { x = 33643, y = 32929, z = 15 })
overheatedZone:addArea({ x = 33644, y = 32921, z = 15 }, { x = 33647, y = 32928, z = 15 })

-- central area where monsters/boss spawns
spawnZone:addArea({ x = 33647, y = 32900, z = 15 }, { x = 33659, y = 32913, z = 15 })

local encounter = Encounter("Magma Bubble", {
	zone = bossZone,
	spawnZone = spawnZone,
	timeToSpawnMonsters = "2s",
})

function encounter:onReset(position)
	encounter:removeMonsters()
end

encounter:addRemoveMonsters():autoAdvance()
encounter:addBroadcast("You've entered the volcano."):autoAdvance("1s")

encounter:addSpawnMonsters({
	{
		name = "The End of Days",
		amount = 3,
		event = "fight.magma-bubble.TheEndOfDaysHealth",
	},
	{
		name = "Magma Crystal",
		event = "fight.magma-bubble.MagmaCrystalDeath",
		positions = {
			Position(33647, 32891, 15),
			Position(33647, 32926, 15),
			Position(33670, 32898, 15),
		},
	},
})

encounter:addRemoveMonsters():autoAdvance()
encounter:addBroadcast("The whole Volcano starts to vibrate! Prepare yourself!"):autoAdvance("3s")

encounter:addSpawnMonsters({
	{
		name = "The End of Days",
		amount = 8,
		event = "fight.magma-bubble.TheEndOfDaysDeath",
	},
})

encounter:addRemoveMonsters():autoAdvance()
encounter:addBroadcast("You've upset the volcano and now it's going to take its revenge!"):autoAdvance("3s")

encounter
	:addSpawnMonsters({
		{
			name = "Magma Bubble",
			event = "fight.magma-bubble.MagmaBubbleDeath",
			positions = {
				Position(33654, 32909, 15),
			},
		},
	})
	:autoAdvance("10s")

for i = 0, 4 do
	local stage = encounter:addSpawnMonsters({
		{ name = "Unchained Fire", amount = 5 },
	})

	if i < 4 then
		stage:autoAdvance("45s")
	end
end

encounter:register()

local function addShieldStack(player)
	local currentIcon = player:getIcon("magma-bubble")
	if not currentIcon or currentIcon.category ~= CreatureIconCategory_Quests or currentIcon.icon ~= CreatureIconQuests_GreenShield then
		player:setIcon("magma-bubble", CreatureIconCategory_Quests, CreatureIconQuests_GreenShield, 5)
		return true
	end
	player:setIcon("magma-bubble", CreatureIconCategory_Quests, CreatureIconQuests_GreenShield, currentIcon.count + 5)
end

local function tickShields(player)
	local currentIcon = player:getIcon("magma-bubble")
	if not currentIcon or currentIcon.category ~= CreatureIconCategory_Quests or currentIcon.icon ~= CreatureIconQuests_GreenShield then
		return 0
	end
	if currentIcon.count <= 0 then
		player:removeIcon("magma-bubble")
		return 0
	end
	local newCount = currentIcon.count - 1
	player:setIcon("magma-bubble", CreatureIconCategory_Quests, CreatureIconQuests_GreenShield, newCount)
	return newCount
end

local overheatedDamage = GlobalEvent("self.magma-bubble.overheated.onThink")
function overheatedDamage.onThink(interval, lastExecution)
	local players = overheatedZone:getPlayers()
	for _, player in ipairs(players) do
		if player:getHealth() <= 0 then
			goto continue
		end
		local shields = tickShields(player)
		if shields > 0 then
			local effect = CONST_ME_BLACKSMOKE
			if shields > 20 then
				effect = CONST_ME_GREENSMOKE
			elseif shields > 10 then
				effect = CONST_ME_YELLOWSMOKE
			elseif shields > 5 then
				effect = CONST_ME_REDSMOKE
			elseif shields > 1 then
				effect = CONST_ME_PURPLESMOKE
			end
			player:getPosition():sendMagicEffect(effect)
		else
			local damage = player:getMaxHealth() * 0.6 * -1
			doTargetCombatHealth(0, player, COMBAT_AGONYDAMAGE, damage, damage, CONST_ME_NONE)
		end
		::continue::
	end
	return true
end

overheatedDamage:interval(1000)
overheatedDamage:register()

local crystalsCycle = GlobalEvent("self.magma-bubble.crystals.onThink")
function crystalsCycle.onThink(interval, lastExecution)
	local zoneItems = bossZone:getItems()
	local minCooled = 2
	local crystals = {}
	for _, item in ipairs(zoneItems) do
		if item:getId() == cooledCrystalId or item:getId() == heatedCrystalId then
			table.insert(crystals, item)
		end
	end
	local shouldChange = math.random(1, 100) <= 50
	if shouldChange and #crystals > 0 then
		local item = crystals[math.random(1, #crystals)]
		local newItemId = item:getId() == cooledCrystalId and heatedCrystalId or cooledCrystalId
		item:transform(newItemId)
	end
	local cooledCount = 0
	local heatedCyrstas = {}
	for _, item in ipairs(zoneItems) do
		if item:getId() == cooledCrystalId then
			cooledCount = cooledCount + 1
		elseif item:getId() == heatedCrystalId then
			table.insert(heatedCyrstas, item)
		end
	end
	if cooledCount < minCooled then
		for _ = 1, minCooled - cooledCount do
			local index = math.random(1, #heatedCyrstas)
			local item = heatedCyrstas[index]
			if item then
				table.remove(heatedCyrstas, index)
				item:transform(cooledCrystalId)
			end
		end
	end
	return true
end

crystalsCycle:interval(4000)
crystalsCycle:register()

local function randomPosition(positions)
	local destination = positions[math.random(1, #positions)]
	local tile = destination:getTile()
	while not tile or not tile:isWalkable(false, false, false, false, true) do
		destination = positions[math.random(1, #positions)]
		tile = destination:getTile()
	end
	return destination
end

local chargedFlameAction = Action()
function chargedFlameAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end
	if not target or not target:isItem() then
		return false
	end
	if target:getId() ~= cooledCrystalId then
		return false
	end
	target:transform(heatedCrystalId)
	local positions = {
		Position(toPosition.x - 1, toPosition.y, toPosition.z),
		Position(toPosition.x + 1, toPosition.y, toPosition.z),
		Position(toPosition.x, toPosition.y - 1, toPosition.z),
		Position(toPosition.x, toPosition.y + 1, toPosition.z),
		Position(toPosition.x - 1, toPosition.y - 1, toPosition.z),
		Position(toPosition.x + 1, toPosition.y + 1, toPosition.z),
		Position(toPosition.x - 1, toPosition.y + 1, toPosition.z),
		Position(toPosition.x + 1, toPosition.y - 1, toPosition.z),
	}
	local position = randomPosition(positions)
	position:sendMagicEffect(CONST_ME_FIREAREA)
	local field = Game.createItem(magicFieldId, 1, position)
	field:decay()
	item:remove()
end

chargedFlameAction:id(chargedFlameId)
chargedFlameAction:register()

local shieldField = MoveEvent()
function shieldField.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if not encounter:isInZone(player:getPosition()) then
		return false
	end
	item:remove()
	addShieldStack(player)
end

shieldField:type("stepin")
shieldField:id(magicFieldId)
shieldField:register()

local theEndOfDaysHealth = CreatureEvent("fight.magma-bubble.TheEndOfDaysHealth")
function theEndOfDaysHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local newHealth = creature:getHealth() - primaryDamage - secondaryDamage
	if newHealth <= creature:getMaxHealth() * 0.5 then
		creature:setHealth(creature:getMaxHealth())
		encounter:spawnMonsters({ name = "Lava Creature", amount = 8 })
		return false
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

theEndOfDaysHealth:register()

local magmaCrystalDeath = CreatureEvent("fight.magma-bubble.MagmaCrystalDeath")
function magmaCrystalDeath.onDeath()
	-- The monster count is only updated AFTER the event is called, so we need to subtract 1
	local crystals = encounter:countMonsters("magma crystal") - 1
	if crystals == 0 then
		encounter:nextStage()
	else
		encounter:broadcast(MESSAGE_EVENT_ADVANCE, "A magma crystal has been destroyed! " .. crystals .. " remaining.")
	end
end

magmaCrystalDeath:register()

local endOfDaysDeath = CreatureEvent("fight.magma-bubble.TheEndOfDaysDeath")
function endOfDaysDeath.onDeath()
	-- The monster count is only updated AFTER the event is called, so we need to subtract 1
	local monsters = encounter:countMonsters("the end of days") - 1
	if monsters == 0 then
		encounter:nextStage()
	end
end

endOfDaysDeath:register()

local magmaBubbleDeath = CreatureEvent("fight.magma-bubble.MagmaBubbleDeath")
function magmaBubbleDeath.onDeath()
	encounter:reset()
end

magmaBubbleDeath:register()

local zoneEvent = ZoneEvent(bossZone)
function zoneEvent.afterEnter(_zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:setIcon("magma-bubble", CreatureIconCategory_Quests, CreatureIconQuests_GreenShield, 0)
end

function zoneEvent.afterLeave(_zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:removeIcon("magma-bubble")
end

zoneEvent:register()
