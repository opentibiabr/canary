local config = {
	centerRoom = Position(33424, 31439, 13),
	newPosition = Position(33425, 31431, 13),
	exitPos = Position(33290, 32474, 9),
	x = 12,
	y = 12,
	baelocPos = Position(33422, 31428, 13),
	nictrosPos = Position(33427, 31428, 13),
	timer = Storage.Quest.U12_20.GraveDanger.Bosses.BaelocNictros.Timer,
	room = Storage.Quest.U12_20.GraveDanger.Bosses.BaelocNictros.Room,
	fromPos = Position(33418, 31434, 13),
	toPos = Position(33431, 31445, 13),
}

local brothers_summon = CreatureEvent("brothers_summon")

function brothers_summon.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	local chance = math.random(1, 100)
	local position = Position(math.random(config.fromPos.x, config.toPos.x), math.random(config.fromPos.y, config.toPos.y), config.fromPos.z)
	local tile = Tile(position)

	if chance >= 90 then
		if tile:isWalkable(false, false, false, true, false) then
			local summon = creature:getName():lower() == "sir nictros" and "Squire Of Nictros" or "Retainer Of Baeloc"
			Game.createMonster(summon, position, false, true)
		end
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

brothers_summon:register()

local sir_nictros_health = CreatureEvent("sir_nictros_health")

function sir_nictros_health.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
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

	if primaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	local health = creature:getMaxHealth() * 0.60
	local brother_diff = (creature:getHealth() / creature:getMaxHealth()) * 100
	local brother = Creature("Sir Baeloc")

	if brother then
		if brother_diff < 55 then
			local brother_percent = (brother:getHealth() / brother:getMaxHealth()) * 100
			if (brother_percent - brother_diff) > 5 then
				creature:addHealth(28000)
			end
		end
	end

	creature:setStorageValue(1, creature:getStorageValue(1) + primaryDamage + secondaryDamage)
	if creature:getStorageValue(2) < 1 and creature:getStorageValue(1) >= health then
		creature:setStorageValue(2, 1)
		creature:say("Now it's your chance for entertaiment, dear brother!")
		creature:teleportTo(config.nictrosPos)
		creature:setMoveLocked(true)
		local baeloc = Creature("Sir Baeloc")
		if baeloc then
			baeloc:teleportTo(Position(33424, 31436, 13))
			baeloc:setMoveLocked(false)
		end
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

sir_nictros_health:register()

local sir_baeloc_health = CreatureEvent("sir_baeloc_health")

function sir_baeloc_health.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if primaryType == COMBAT_HEALING then
		return primaryDamage, primaryType, -secondaryDamage, secondaryType
	end

	local health = creature:getMaxHealth() * 0.60
	local brother_diff = (creature:getHealth() / creature:getMaxHealth()) * 100
	local brother = Creature("Sir Nictros")

	if brother then
		if brother_diff < 55 then
			local brother_percent = (brother:getHealth() / brother:getMaxHealth()) * 100
			if (brother_percent - brother_diff) > 5 then
				creature:addHealth(28000)
			end
		end
	end

	creature:setStorageValue(1, creature:getStorageValue(1) + primaryDamage + secondaryDamage)

	if creature:getStorageValue(2) < 1 and creature:getStorageValue(1) >= health then
		creature:setStorageValue(2, 1)
		creature:say("Join me in battle my brother. Let's share the fun!")
		local nictros = Creature("Sir Nictros")
		if nictros then
			nictros:teleportTo(Position(33426, 31438, 13))
			nictros:setMoveLocked(false)
		end
	end

	return primaryDamage, primaryType, -secondaryDamage, secondaryType
end

sir_baeloc_health:register()
