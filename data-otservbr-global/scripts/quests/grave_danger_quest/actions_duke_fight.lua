local config = {
	boss = {
		name = "Duke Krule",
		createFunction = function()
			local boss = Game.createMonster("Duke Krule", Position(33456, 31473, 13), true, true)
			boss:setStorageValue(1, os.time())
			return boss
		end,
	},
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33455, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33456, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33457, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33458, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33459, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33447, 31464, 13),
		to = Position(33464, 31481, 13),
	},
	exit = Position(32347, 32167, 12),
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

config.onUseExtra = function()
	local config = {
		centerRoom = Position(33456, 31472, 13),
		x = 10,
		y = 10,
		transformCD = Storage.Quest.U12_20.GraveDanger.Bosses.DukeKrule.TransformCD,
	}
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
	addEvent(transformPlayers, 30 * 1000, os.time())
end

local lever = BossLever(config)
lever:position({ x = 33454, y = 31493, z = 13 })
lever:register()
