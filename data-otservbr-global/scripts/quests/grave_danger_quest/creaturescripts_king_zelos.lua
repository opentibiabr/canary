local config = {
	centerRoom = Position(33443, 31545, 13),
	newPosition = Position(33436, 31572, 13),
	exitPos = Position(32172, 31917, 8),
	x = 30,
	y = 30,
	summons = {
		{
			name = "Rewar The Bloody",
			pos = Position(33463, 31562, 13),
		},
		{
			name = "The Red Knight",
			pos = Position(33423, 31562, 13),
		},
		{
			name = "Magnor Mournbringer",
			pos = Position(33463, 31529, 13),
		},
		{
			name = "Nargol the Impaler",
			pos = Position(33423, 31529, 13),
		},
		{
			name = "King Zelos",
			pos = Position(33443, 31545, 13),
		},
	},
	timer = Storage.Quest.U12_20.GraveDanger.Bosses.KingZelos.Timer,
	room = Storage.Quest.U12_20.GraveDanger.Bosses.KingZelos.Room,
	fromPos = Position(33414, 31520, 13),
	toPos = Position(33474, 31574, 13),
}

local zelos_damage = CreatureEvent("zelos_damage")

function zelos_damage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if primaryType ~= COMBAT_HEALING then
		local storage = creature:getStorageValue(1)

		if storage < 800 then
			primaryDamage = (primaryDamage + secondaryDamage) - ((primaryDamage + secondaryDamage) * (storage / 800))
			secondaryDamage = 0
		else
			primaryDamage = (primaryDamage + secondaryDamage) - ((primaryDamage + secondaryDamage) * 0.99)
			secondaryDamage = 0
		end
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

zelos_damage:register()

local zelos_init = CreatureEvent("zelos_init")

function zelos_init.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local knights = { "Nargol The Impaler", "Magnor Mournbringer", "The Red Knight", "Rewar The Bloody", "Shard Of Magnor", "Regenerating Mass" }

	for _, knight in pairs(knights) do
		local boss = Creature(knight)
		if boss and boss:getId() ~= creature:getId() then
			return true
		end
	end

	local zelos = Creature("King Zelos")

	if zelos then
		local eq = os.time() - zelos:getStorageValue(1)

		zelos:setStorageValue(1, eq)
	end

	return true
end

zelos_init:register()

local blood_explode = Combat()
local area = createCombatArea(AREA_SQUARE1X1)
blood_explode:setArea(area)

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	local target = tile:getTopCreature()
	if tile then
		if target and target:getId() ~= cid:getId() then
			if target:isMonster() and target:getName():lower() == "the red knight" or target:isPlayer() then
				doTargetCombatHealth(0, target, COMBAT_DROWNDAMAGE, -20000, -25000)
			end
		end
	end
end

blood_explode:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local blood_death = CreatureEvent("blood_death")

function blood_death.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local var = { type = 1, number = creature:getId() }

	blood_explode:execute(creature, var)

	return true
end

blood_death:register()

local nargol_death = CreatureEvent("nargol_death")

function nargol_death.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	Game.createMonster("Regenerating Mass", Position(33423, 31529, 13), false, true)

	addEvent(function()
		local mass = Creature("Regenerating Mass")
		if mass then
			mass:remove()
			Game.createMonster("Nargol The Impaler", Position(33423, 31529, 13), false, true)
		end
	end, 30 * 1000)

	return true
end

nargol_death:register()

local shard_explode = Combat()
shard_explode:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)

local area = createCombatArea(AREA_CIRCLE2X2)
shard_explode:setArea(area)

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	local target = tile:getTopCreature()

	if tile then
		if target and target:isPlayer() then
			doTargetCombatHealth(0, target, COMBAT_LIFEDRAIN, -2000, -2500)
		end
	end
end

shard_explode:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local shard_death = CreatureEvent("shard_death")

function shard_death.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local var = { type = 1, number = creature:getId() }

	shard_explode:execute(creature, var)

	return true
end

shard_death:register()

local magnor_death = CreatureEvent("magnor_death")

function magnor_death.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local id = os.time()

	for i = 1, 4 do
		local shards = Game.createMonster("Shard Of Magnor", creature:getClosestFreePosition(creature:getPosition(), true))
		shards:beginSharedLife(id)
		shards:registerEvent("SharedLife")
		shards:registerEvent("shard_death")
	end

	return true
end

magnor_death:register()

local fetter_death = CreatureEvent("fetter_death")

function fetter_death.onDeath(creature)
	local targetMonster = creature:getMonster()

	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local boss = Creature("Rewar The Bloody")

	if boss then
		boss:setStorageValue(2, boss:getStorageValue(2) - 1)

		if boss:getStorageValue(2) <= 0 then
			boss:setType("Rewar The Bloody")
		end
	end

	return true
end

fetter_death:register()

local rewar_the_bloody = CreatureEvent("rewar_the_bloody")

rewar_the_bloody:type("healthchange")

function rewar_the_bloody.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if primaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	local health = creature:getMaxHealth() * 0.05

	creature:setStorageValue(1, creature:getStorageValue(1) + primaryDamage + secondaryDamage)

	if creature:getStorageValue(1) >= health then
		creature:setStorageValue(1, 0)
		creature:setStorageValue(2, 0)

		local fetters = math.random(1, 3)
		local fromPos, toPos = Position(33458, 31556, 13), Position(33467, 31566, 13)

		for i = 1, fetters do
			local position = Position(math.random(fromPos.x, toPos.x), math.random(fromPos.y, toPos.y), fromPos.z)
			local fetter = Game.createMonster("Fetter", position, true, true)
			if fetter then
				creature:setStorageValue(2, creature:getStorageValue(2) + 1)
			end
		end
		creature:setType("Rewar The Bloody Inv")
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

rewar_the_bloody:register()
