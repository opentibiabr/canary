local versperothPosition = Position(33075, 31878, 12)

local function removeMinion(mid)
	local monster = Monster(mid)
	if monster then
		monster:getPosition():sendMagicEffect(CONST_ME_POFF)
		monster:remove()
	end
end

local function executeVersperothBattle(mid)
	if Game.getStorageValue(GlobalStorage.BigfootBurden.Versperoth.Battle) ~= 1 then
		return false
	end

	if mid then
		local monster = Monster(mid)
		if not monster then
			return false
		else
		end

		Game.setStorageValue(GlobalStorage.BigfootBurden.Versperoth.Health, monster:getHealth())
		monster:remove()
		local blood = Tile(versperothPosition):getItemById(2019)
		if blood then
			blood:remove()
		end

		local hole = Tile(versperothPosition):getItemById(18462)
		if not hole then
			Game.createItem(18462, 1, versperothPosition)
		end
		versperothPosition:sendMagicEffect(CONST_ME_POFF)

		local position, minionMonster
		for i = 1, 10 do
			position = Position(math.random(33070, 33081), math.random(31874, 31883), 12)
			minionMonster = Game.createMonster('Minion of Versperoth', position)
			position:sendMagicEffect(CONST_ME_TELEPORT)
			if minionMonster then
				addEvent(removeMinion, 20 * 1000, minionMonster.uid)
			end
		end
		addEvent(executeVersperothBattle, 10 * 1000)
		return
	end

	local monster = Game.createMonster('Versperoth', versperothPosition, false, true)
	if monster then
		local holee = Tile(versperothPosition):getItemById(18462)
		if holee then
			holee:remove()
		end
		versperothPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
		monster:setHealth(Game.getStorageValue(GlobalStorage.BigfootBurden.Versperoth.Health))
		addEvent(executeVersperothBattle, 20 * 1000, monster.uid)
	end
end

local versperothSpawn = MoveEvent()

function versperothSpawn.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorage.BigfootBurden.Versperoth.Battle) >= 1 then
		player:say("Versperoth has already been defeated in the last 30 minutes.", TALKTYPE_MONSTER_SAY)
		return true
	end
	player:teleportTo(Position(33072, 31877, 12))
	Game.setStorageValue(GlobalStorage.BigfootBurden.Versperoth.Battle, 1)
	Game.setStorageValue(GlobalStorage.BigfootBurden.Versperoth.Health, 100000)
	executeVersperothBattle()
	item:remove()
	return true
end

versperothSpawn:type("stepin")
versperothSpawn:id(18463)
versperothSpawn:register()
