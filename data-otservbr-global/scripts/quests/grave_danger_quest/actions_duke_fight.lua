local config = {
	centerRoom = Position(33456, 31472, 13),
	newPosition = Position(33456, 31478, 13),
	exitPos = Position(32344, 32168, 12),
	x = 10,
	y = 10,
	timer = Storage.Quest.U12_20.GraveDanger.Bosses.DukeKrule.Timer,
	room = Storage.Quest.U12_20.GraveDanger.Bosses.DukeKrule.Room,
	transformCD = Storage.Quest.U12_20.GraveDanger.Bosses.DukeKrule.TransformCD,
	fromPos = Position(33415, 31426, 13),
	toPos = Position(33434, 31450, 13),
}

local duke_water = Combat()
duke_water:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
duke_water:setArea(createCombatArea(AREA_CIRCLE3X3))

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	local target = tile:getTopCreature()
	if tile then
		if target and target:isPlayer() and target:getOutfit().lookType == 49 then
			doTargetCombatHealth(0, target, COMBAT_ICEDAMAGE, -1500, -2000)
		end
	end
end

duke_water:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local duke_fire = Combat()
duke_fire:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
duke_fire:setArea(createCombatArea(AREA_CIRCLE3X3))

function onTargetTile(cid, pos)
	local tile = Tile(pos)
	local target = tile:getTopCreature()
	if tile then
		if target and target:isPlayer() and target:getOutfit().lookType == 286 then
			doTargetCombatHealth(0, target, COMBAT_FIREDAMAGE, -1500, -2000)
		end
	end
end

duke_fire:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function hitArea(creature)
	local player = Player(creature)

	if player then
		if player:getStorageValue(config.transformCD) <= os.time() then
			if player:getOutfit().lookType == 49 then
				local var = { type = 1, number = creature }
				duke_fire:execute(player, var)
				player:setStorageValue(config.transformCD, os.time() + 3)
				addEvent(hitArea, 3 * 1000, creature)
			elseif player:getOutfit().lookType == 286 then
				local var = { type = 1, number = creature }
				duke_water:execute(player, var)
				player:setStorageValue(config.transformCD, os.time() + 3)
				addEvent(hitArea, 3 * 1000, creature)
			end
		end
	end

	return true
end

local function transformPlayers(id)
	local spectators = Game.getSpectators(config.centerRoom, false, true, config.x, config.x, config.y, config.y)
	local form = { 49, 286 }
	local boss = Creature("Duke Krule")

	if boss and boss:getStorageValue(1) == id then
		if #spectators > 0 then
			for _, player in pairs(spectators) do
				doSetCreatureOutfit(player, { lookType = form[math.random(#form)] }, 30 * 1000)
				addEvent(hitArea, 3 * 1000, player:getId())
			end
			addEvent(transformPlayers, 36 * 1000, id)
		end
	end

	return true
end

local duke_fight = Action()

function duke_fight.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:doCheckBossRoom("Duke Krule", config.fromPos, config.toPos) then
		player:sendCancelMessage("The room is already in use. Please wait.")
		return true
	end

	local spectators = Game.getSpectators(config.centerRoom, false, true, config.x, config.x, config.y, config.y)

	if player:getPosition() ~= Position(33455, 31493, 13) then
		player:sendCancelMessage("Sorry, not possible.")
		return true
	end

	if #spectators > 0 then
		player:say("The room is occupied by another team, please wait.", TALKTYPE_MONSTER_SAY, false, player)
		return true
	end

	local boss = Game.createMonster("Duke Krule", config.centerRoom, true, true)
	local id = os.time()
	boss:setStorageValue(1, id)
	addEvent(transformPlayers, 30 * 1000, id)

	for x = 33455, 33459 do
		local playerTile = Tile(Position(x, 31493, 13)):getTopCreature()
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

duke_fight:aid(14560)
duke_fight:register()
