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
	fromPos = Position(33415, 31426, 13),
	toPos = Position(33434, 31450, 13),
}

local function brothers_play()
	local baeloc = Creature("Sir Baeloc")
	local nictros = Creature("Sir Nictros")

	if baeloc then
		baeloc:say("Ah look my Brother! Challengers! After all this time finally a chance to prove our skills!")
		addEvent(function()
			local nictros = Creature("Sir Nictros")
			if nictros then
				nictros:say("Indeed! It has been a while! As the elder one I request the right of the first battle!")
			end
		end, 6 * 1000)
	end

	addEvent(function()
		local baeloc = Creature("Sir Baeloc")
		local nictros = Creature("Sir Nictros")
		if baeloc then
			baeloc:say("Oh, man! You always get the fun!")
			if nictros then
				nictros:teleportTo(Position(33426, 31437, 13))
				nictros:setMoveLocked(false)
			end
		end
	end, 12 * 1000)
end

local baeloc_fight = Action()

function baeloc_fight.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:doCheckBossRoom("Sir Baeloc", config.fromPos, config.toPos) then
		player:sendCancelMessage("The room is already in use. Please wait.")
		return true
	end

	local baeloc = Game.createMonster("Sir Baeloc", config.baelocPos, true, true)
	local nictros = Game.createMonster("Sir Nictros", config.nictrosPos, true, true)

	if baeloc then
		baeloc:setMoveLocked(true)
		baeloc:registerEvent("sir_baeloc_health")
		baeloc:registerEvent("brothers_summon")
	end

	if nictros then
		nictros:setMoveLocked(true)
		nictros:registerEvent("sir_nictros_health")
		nictros:registerEvent("brothers_summon")
	end

	addEvent(brothers_play, 4 * 1000)

	for x = 33424, 33428 do
		local playerTile = Tile(Position(x, 31413, 13)):getTopCreature()
		if playerTile and playerTile:isPlayer() then
			playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
			playerTile:teleportTo(config.newPosition)
			playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			playerTile:setStorageValue(config.timer, os.time() + 20 * 3600)
			playerTile:setStorageValue(config.room, os.time() + 30 * 60)
			playerTile:say("You have 30 minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.", TALKTYPE_MONSTER_SAY, false, playerTile)
		end
	end

	addEvent(clearForgotten, 30 * 60 * 1000, config.centerRoom, config.x, config.y, config.exitPos, config.room)

	return true
end

baeloc_fight:aid(14559)
baeloc_fight:register()
