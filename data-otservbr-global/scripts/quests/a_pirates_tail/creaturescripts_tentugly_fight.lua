local STORAGE_BOSS_ID = 100000
local STORAGE_TENTACLE_ID = 100001
local STORAGE_PASSED_PHASE = 100002

local TIP_DAMAGE_THRESHOLD = 1000
local TIP_CORPSE_ID = 35136
local LAST_POSITION_ATTR = "tentugly_lastposition"
local BOSS_NAME = "Tentugly's Head"
local TIP_NAME = "Tentugly Tentacle Tip"
local BODY_NAME = "Tentugly Tentacle Body"

local TENTACLE_CONFIG = {
	{
		bodyPositions = {
			Position(33723, 31186, 7),
			Position(33723, 31187, 7),
			Position(33723, 31188, 7),
			Position(33723, 31189, 7),
			Position(33723, 31190, 7),
		},
		tipPosition = Position(33723, 31185, 7),
		tipSprite = 35106,
		bodySprite = 35112,
		lastPosition = {
			position = Position(33723, 31191, 7),
			spriteAlive = 35109,
			spriteDead = 35110,
		},
	},
	{
		bodyPositions = {
			Position(33731, 31179, 7),
			Position(33732, 31179, 7),
			Position(33733, 31179, 7),
			Position(33734, 31179, 7),
			Position(33735, 31179, 7),
		},
		tipPosition = Position(33730, 31179, 7),
		tipSprite = 35117,
		bodySprite = 35126,
		lastPosition = {
			position = Position(33736, 31179, 7),
			spriteAlive = 35119,
			spriteDead = 35120,
		},
	},
	{
		bodyPositions = {
			Position(33727, 31185, 7),
		},
		tipPosition = Position(33727, 31184, 7),
		tipSprite = 35106,
		bodySprite = 35112,
		lastPosition = {
			position = Position(33727, 31186, 7),
			spriteAlive = 35109,
			spriteDead = 35110,
		},
	},
	{
		bodyPositions = {
			Position(33724, 31180, 7),
			Position(33725, 31180, 7),
		},
		tipPosition = Position(33723, 31180, 7),
		tipSprite = 35117,
		bodySprite = 35126,
		lastPosition = {
			position = Position(33726, 31180, 7),
			spriteAlive = 35119,
			spriteDead = 35120,
		},
	},
	{
		bodyPositions = {
			Position(33718, 31180, 7),
			Position(33718, 31179, 7),
			Position(33718, 31178, 7),
			Position(33718, 31177, 7),
		},
		tipPosition = Position(33718, 31181, 7),
		tipSprite = 35116,
		bodySprite = 35112,
		lastPosition = {
			position = Position(33718, 31176, 7),
			spriteAlive = 35109,
			spriteDead = 35107,
		},
	},
	{
		bodyPositions = {
			Position(33714, 31181, 6),
			Position(33714, 31180, 6),
			Position(33714, 31179, 6),
			Position(33714, 31178, 6),
			Position(33714, 31177, 6),
		},
		tipPosition = Position(33714, 31182, 6),
		tipSprite = 35116,
		bodySprite = 35112,
		lastPosition = {
			position = Position(33714, 31176, 6),
			spriteAlive = 35112,
			spriteDead = 35107,
		},
	},
	{
		bodyPositions = {
			Position(33716, 31181, 6),
			Position(33716, 31182, 6),
		},
		tipPosition = Position(33716, 31180, 6),
		tipSprite = 35106,
		bodySprite = 35112,
		lastPosition = {
			position = Position(33716, 31183, 6),
			spriteAlive = 35109,
			spriteDead = 35110,
		},
	},
	{
		bodyPositions = {
			Position(33726, 31182, 6),
			Position(33726, 31181, 6),
			Position(33726, 31180, 6),
			Position(33726, 31179, 6),
			Position(33726, 31178, 6),
			Position(33726, 31177, 6),
		},
		tipPosition = Position(33726, 31183, 6),
		tipSprite = 35116,
		bodySprite = 35112,
		lastPosition = {
			position = Position(33726, 31176, 6),
			spriteAlive = 35112,
			spriteDead = 35107,
		},
	},
	{
		bodyPositions = {
			Position(33718, 31187, 6),
			Position(33718, 31188, 6),
			Position(33718, 31189, 6),
			Position(33718, 31190, 6),
		},
		tipPosition = Position(33718, 31186, 6),
		tipSprite = 35106,
		bodySprite = 35112,
		lastPosition = {
			position = Position(33718, 31191, 6),
			spriteAlive = 35109,
			spriteDead = 35110,
		},
	},
}

local instances = {}
local fightGeneration = 1

local function isActiveInstance(bossId, generation)
	if generation ~= fightGeneration then
		return nil
	end
	local instance = instances[bossId]
	if not instance or instance.generation ~= generation then
		return nil
	end
	return instance
end

local function isTentacleMonster(creature)
	if not creature or not creature:isMonster() then
		return false
	end
	local name = creature:getName()
	return name == TIP_NAME or name == BODY_NAME
end

local function removeCreatureIfTentacle(tile)
	if not tile then
		return
	end
	local creature = tile:getTopCreature()
	if isTentacleMonster(creature) then
		creature:remove()
	end
end

local function updateLastPositionSprite(position, spriteId, oppositeSpriteId)
	if not position or not spriteId then
		return
	end

	local tile = Tile(position)
	if not tile then
		return
	end

	local items = tile:getItems()
	if items then
		for _, item in ipairs(items) do
			local customAttr = item:getCustomAttribute(LAST_POSITION_ATTR)
			if customAttr or item:getId() == oppositeSpriteId or item:getId() == spriteId then
				item:remove()
			end
		end
	end

	local spriteItem = Game.createItem(spriteId, 1, position)
	if spriteItem then
		spriteItem:setCustomAttribute(LAST_POSITION_ATTR, 1)
	end
end

local function restoreLastPositionSprites()
	for _, config in ipairs(TENTACLE_CONFIG) do
		local lastPosition = config.lastPosition
		if lastPosition then
			updateLastPositionSprite(lastPosition.position, lastPosition.spriteDead, lastPosition.spriteAlive)
		end
	end
end

local function removeTentacleCreatures()
	for _, config in ipairs(TENTACLE_CONFIG) do
		removeCreatureIfTentacle(Tile(config.tipPosition))
		for _, bodyPos in ipairs(config.bodyPositions) do
			removeCreatureIfTentacle(Tile(bodyPos))
		end
	end
end

local function areAllTentaclesDead(instance)
	if not instance or not instance.tentacles then
		return true
	end
	for _ in pairs(instance.tentacles) do
		return false
	end
	return true
end

local function bindTipMonster(tipMonster, bossId, tentacleId, tipSprite)
	tipMonster:setOutfit({ lookTypeEx = tipSprite })
	tipMonster:setStorageValue(STORAGE_BOSS_ID, bossId)
	tipMonster:setStorageValue(STORAGE_TENTACLE_ID, tentacleId)
end

local function spawnTipAt(position, bossId, tentacleId, tipSprite)
	local tile = Tile(position)
	if not tile then
		return nil
	end

	local existing = tile:getTopCreature()
	if isTentacleMonster(existing) then
		existing:remove()
	end

	local tipMonster = Game.createMonster(TIP_NAME, position, false, true)
	if not tipMonster then
		return nil
	end
	bindTipMonster(tipMonster, bossId, tentacleId, tipSprite)
	return tipMonster
end

local function spawnTentacleBody(generation, bossId, x, y, z, spriteId)
	if not isActiveInstance(bossId, generation) then
		return
	end

	local pos = Position(x, y, z)
	local tile = Tile(pos)
	if not tile then
		return
	end

	local existing = tile:getTopCreature()
	if isTentacleMonster(existing) then
		existing:remove()
	end

	local bodyMonster = Game.createMonster(BODY_NAME, pos, false, true)
	if bodyMonster then
		bodyMonster:setOutfit({ lookTypeEx = spriteId })
	end
end

local function spawnTentacleTip(generation, bossId, tentacleIndex)
	local instance = isActiveInstance(bossId, generation)
	if not instance then
		return
	end

	local config = TENTACLE_CONFIG[tentacleIndex]
	if not config then
		return
	end

	local tentacleId = bossId * 1000 + tentacleIndex
	local tentacleData = instance.tentacles[tentacleId]
	if not tentacleData then
		return
	end

	local tipMonster = spawnTipAt(config.tipPosition, bossId, tentacleId, config.tipSprite)
	if not tipMonster then
		return
	end

	tentacleData.tipMonsterId = tipMonster:getId()
	if config.lastPosition then
		updateLastPositionSprite(config.lastPosition.position, config.lastPosition.spriteAlive, config.lastPosition.spriteDead)
	end
end

local function spawnTentuglyTentacles(bossId, generation)
	local instance = isActiveInstance(bossId, generation)
	if not instance then
		return
	end

	for tentacleIndex, config in ipairs(TENTACLE_CONFIG) do
		local tentacleId = bossId * 1000 + tentacleIndex
		instance.tentacles[tentacleId] = {
			tentacleIndex = tentacleIndex,
			currentTipIndex = 1,
			accumulatedDamage = 0,
			tipMonsterId = 0,
			tipSprite = config.tipSprite,
		}

		for bodyIndex, bodyPos in ipairs(config.bodyPositions) do
			addEvent(spawnTentacleBody, bodyIndex * 50, generation, bossId, bodyPos.x, bodyPos.y, bodyPos.z, config.bodySprite)
		end

		addEvent(spawnTentacleTip, (#config.bodyPositions + 1) * 50 + 100, generation, bossId, tentacleIndex)
	end
end

local function removeBossById(generation, creatureId)
	if generation ~= fightGeneration then
		return
	end
	local boss = Monster(creatureId)
	if boss then
		boss:remove()
	end
end

local function respawnTentuglyBoss(bossId)
	local instance = instances[bossId]
	if not instance then
		return
	end

	local generation = instance.generation
	if generation ~= fightGeneration then
		instances[bossId] = nil
		return
	end

	removeTentacleCreatures()

	local bossPosition = Position(instance.bossX, instance.bossY, instance.bossZ)
	local respawnHealth = math.floor(instance.bossMaxHealth * 0.5)
	local boss = Game.createMonster(BOSS_NAME, bossPosition, false, true)
	if boss then
		boss:setHealth(respawnHealth)
		boss:setStorageValue(STORAGE_PASSED_PHASE, 1)
		boss:registerEvent("TentuglysHeadDeath")
		boss:registerEvent("TentuglyHealthChange")
		boss:registerEvent("BossLeverOnDeath")
		bossPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end

	instances[bossId] = nil
end

local function spawnNextTip(generation, bossId, tentacleId, x, y, z)
	local instance = isActiveInstance(bossId, generation)
	if not instance then
		return
	end

	local tentacleData = instance.tentacles[tentacleId]
	if not tentacleData then
		return
	end

	local nextPosition = Position(x, y, z)
	local tile = Tile(nextPosition)
	if not tile then
		return
	end

	local bodyMonster = tile:getTopCreature()
	if bodyMonster and bodyMonster:isMonster() then
		local monsterName = bodyMonster:getName()
		if monsterName == BODY_NAME then
			bodyMonster:setType(TIP_NAME)
			bodyMonster:setHealth(TIP_DAMAGE_THRESHOLD)
			bodyMonster:setMaxHealth(TIP_DAMAGE_THRESHOLD)
			bindTipMonster(bodyMonster, bossId, tentacleId, tentacleData.tipSprite)
			bodyMonster:registerEvent("TentuglyTentacleHealthChange")
			tentacleData.tipMonsterId = bodyMonster:getId()
			return
		elseif monsterName == TIP_NAME then
			bindTipMonster(bodyMonster, bossId, tentacleId, tentacleData.tipSprite)
			bodyMonster:registerEvent("TentuglyTentacleHealthChange")
			tentacleData.tipMonsterId = bodyMonster:getId()
			return
		end
	end

	local tipMonster = spawnTipAt(nextPosition, bossId, tentacleId, tentacleData.tipSprite)
	if tipMonster then
		tentacleData.tipMonsterId = tipMonster:getId()
	end
end

local function processTentacleTipDeath(bossId, tentacleId, tipMonster)
	local instance = instances[bossId]
	if not instance then
		return
	end

	local tentacleData = instance.tentacles[tentacleId]
	if not tentacleData then
		return
	end

	local tipPosition = tipMonster:getPosition()
	tipMonster:remove()

	local corpse = Game.createItem(TIP_CORPSE_ID, 1, tipPosition)
	if corpse then
		corpse:decay()
	end

	tentacleData.currentTipIndex = tentacleData.currentTipIndex + 1

	local config = TENTACLE_CONFIG[tentacleData.tentacleIndex]
	if not config then
		instance.tentacles[tentacleId] = nil
		if areAllTentaclesDead(instance) then
			respawnTentuglyBoss(bossId)
		end
		return
	end

	if tentacleData.currentTipIndex <= #config.bodyPositions + 1 then
		local nextPosition = config.bodyPositions[tentacleData.currentTipIndex - 1]
		if nextPosition then
			addEvent(spawnNextTip, 100, instance.generation, bossId, tentacleId, nextPosition.x, nextPosition.y, nextPosition.z)
		end
		return
	end

	if config.lastPosition then
		updateLastPositionSprite(config.lastPosition.position, config.lastPosition.spriteDead, config.lastPosition.spriteAlive)
	end

	instance.tentacles[tentacleId] = nil
	if areAllTentaclesDead(instance) then
		respawnTentuglyBoss(bossId)
	end
end

TentuglyFight = TentuglyFight or {}

function TentuglyFight.reset()
	fightGeneration = fightGeneration + 1
	instances = {}
	restoreLastPositionSprites()
	removeTentacleCreatures()
end

local tentuglyHealthChange = CreatureEvent("TentuglyHealthChange")

function tentuglyHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature or not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if creature:getName() ~= BOSS_NAME then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local monster = creature:getMonster()
	if not monster then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if monster:getStorageValue(STORAGE_PASSED_PHASE) == 1 then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local bossId = creature:getId()
	if instances[bossId] then
		return false
	end

	local damageAmount = 0
	if primaryType ~= COMBAT_HEALING then
		damageAmount = damageAmount + math.abs(primaryDamage)
	else
		damageAmount = damageAmount - math.abs(primaryDamage)
	end
	if secondaryType ~= COMBAT_HEALING then
		damageAmount = damageAmount + math.abs(secondaryDamage)
	else
		damageAmount = damageAmount - math.abs(secondaryDamage)
	end

	local healthAfterDamage = creature:getHealth() - damageAmount
	if healthAfterDamage < 0 then
		healthAfterDamage = 0
	end

	if healthAfterDamage > creature:getMaxHealth() * 0.5 then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local position = creature:getPosition()
	instances[bossId] = {
		generation = fightGeneration,
		bossX = position.x,
		bossY = position.y,
		bossZ = position.z,
		bossMaxHealth = creature:getMaxHealth(),
		tentacles = {},
	}

	spawnTentuglyTentacles(bossId, fightGeneration)
	addEvent(removeBossById, 100, fightGeneration, bossId)
	return false
end

tentuglyHealthChange:register()

local tentuglyTentacleHealthChange = CreatureEvent("TentuglyTentacleHealthChange")

function tentuglyTentacleHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature or not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if creature:getName() ~= TIP_NAME then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local monster = creature:getMonster()
	if not monster then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local bossId = monster:getStorageValue(STORAGE_BOSS_ID)
	local tentacleId = monster:getStorageValue(STORAGE_TENTACLE_ID)
	if bossId < 1 or tentacleId < 1 then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local instance = instances[bossId]
	if not instance or instance.generation ~= fightGeneration or not instance.tentacles or not instance.tentacles[tentacleId] then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local tentacleData = instance.tentacles[tentacleId]
	local totalDamage = 0
	if primaryType ~= COMBAT_HEALING then
		totalDamage = totalDamage + math.abs(primaryDamage)
	end
	if secondaryType ~= COMBAT_HEALING then
		totalDamage = totalDamage + math.abs(secondaryDamage)
	end

	tentacleData.accumulatedDamage = tentacleData.accumulatedDamage + totalDamage
	if tentacleData.accumulatedDamage < TIP_DAMAGE_THRESHOLD then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	tentacleData.accumulatedDamage = tentacleData.accumulatedDamage - TIP_DAMAGE_THRESHOLD
	processTentacleTipDeath(bossId, tentacleId, creature)
	return false
end

tentuglyTentacleHealthChange:register()
