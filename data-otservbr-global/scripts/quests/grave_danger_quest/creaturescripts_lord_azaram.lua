local config = {
	centerRoom = Position(33424, 31472, 13),
	newPosition = Position(33424, 31478, 13),
	exitPos = Position(32190, 31819, 8),
	x = 10,
	y = 10,
	timer = Storage.Quest.U12_20.GraveDanger.Bosses.LordAzaram.Timer,
	room = Storage.Quest.U12_20.GraveDanger.Bosses.LordAzaram.Room,
	soulPos = Position(33426, 31471, 13),
	bossPos = Position(33423, 31471, 13),
	tainted = {
		Position(33422, 31470, 13),
		Position(33427, 31470, 13),
		Position(33422, 31476, 13),
		Position(33427, 31476, 13),
	},
	fromPos = Position(33414, 31463, 13),
	toPos = Position(33433, 31481, 13),
}

local function removeTainted()
	local spectators = Game.getSpectators(config.centerRoom, false, false, config.x, config.x, config.y, config.y)
	for _, creature in pairs(spectators) do
		if creature:isMonster() and creature:getName():lower() == "tainted soul splinter" then
			creature:remove()
		end
	end
	return true
end

local azaram_health = CreatureEvent("azaram_health")

function azaram_health.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	local players = Game.getSpectators(config.centerRoom, false, true, config.x, config.x, config.y, config.y)
	for _, player in pairs(players) do
		if player:isPlayer() then
			if player:getStorageValue(config.timer) < os.time() then
				player:setStorageValue(config.timer, os.time() + 20 * 3600)
			end
			if player:getStorageValue(config.room) < os.time() then
				player:setStorageValue(config.room, os.time() + 30 * 60)
			end
		end
	end

	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local health = creature:getMaxHealth() * 0.10
	local damageStorage = creature:getStorageValue(1)
	if damageStorage == -1 then
		creature:setStorageValue(1, 0)
	end

	creature:setStorageValue(1, damageStorage + primaryDamage)
	local stor = creature:getStorageValue(1)
	if stor >= health then
		local bossTile = Tile(config.bossPos)
		if bossTile and bossTile:isWalkable() then
			creature:teleportTo(config.bossPos)
		end
		creature:setStorageValue(1, 0)
		local soul = Creature("Azaram's Soul")
		if soul then
			soul:teleportTo(config.centerRoom)
			for _, pos in pairs(config.tainted) do
				Game.createMonster("Tainted Soul Splinter", pos, true, true)
			end
		end
	end
	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

azaram_health:register()

local azaram_summon = CreatureEvent("azaram_summon")

function azaram_summon.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local chance = math.random(1, 100)
	if chance < 90 then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local position = Position(math.random(config.fromPos.x, config.toPos.x), math.random(config.fromPos.y, config.toPos.y), config.fromPos.z)
	local tile = Tile(position)
	if tile and tile:isWalkable() then
		local topThing = tile:getTopCreature()
		if topThing then
			local newPosition = topThing:getClosestFreePosition(topThing:getPosition(), true)
			if newPosition then
				Game.createMonster("Condensed Sin", newPosition, false, true)
			end
		else
			Game.createMonster("Condensed Sin", position, false, true)
		end
	end
	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

azaram_summon:register()

local soul_heal = CreatureEvent("soul_heal")

function soul_heal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not attacker or not attacker:isPlayer() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	if primaryType == COMBAT_HEALING then
		local health = (creature:getHealth() / creature:getMaxHealth()) * 100
		local healStorage = creature:getStorageValue(2)
		if healStorage == -1 then
			creature:setStorageValue(2, 0)
		end

		if health < 100 and health >= healStorage * 15 then
			creature:setStorageValue(2, healStorage + 1)
			if config.soulPos:isWalkable() then
				creature:teleportTo(config.soulPos)
			end
			removeTainted()
			local boss = Creature("Lord Azaram")
			if boss and config.centerRoom:isWalkable() then
				boss:teleportTo(config.centerRoom)
			end
		end
	end
	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

soul_heal:register()
