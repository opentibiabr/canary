local initial_player_position = Position(32673, 32087, 8)
local sacrifice_position = Position(32673, 32086, 8)
local arena_position = Position(32673, 32077, 8)
local boss_position = Position(32672, 32079, 8)

function getPitCreatures()

	local ret = {}
	local specs = Game.getSpectators(arena_position, false, false, 6, 6, 6, 6)
	for i = 1, #specs do
		ret[#ret + 1] = specs[i]
	end

	return ret
end

function getPitOccupant(ignoredPlayer)
	local creatures = getPitCreatures()
	for i = 1, #creatures do
		if creatures[i]:isPlayer() and creatures[i]:getId() ~= ignoredPlayer:getId() then
			return creatures[i]
		end
	end

	return nil
end

function is_arena_clean()
	local creatures = getPitCreatures()
	for i = 1, #creatures do
		if creatures[i] and creatures[i]:isMonster() then
			return false
		end
	end
	return true
end

function ResetArena()
	local creatures = getPitCreatures()
	for i = 1, #creatures do
		if creatures[i] and creatures[i]:isMonster() then
			creatures[i]:remove()
		end
	end
end

local othersDesert = Action()
function othersDesert.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	item:transform(item.itemid == 2772 and 2773 or 2772)

	if item.itemid ~= 2772 then
		return true
	end
	
	local chest_storage = 65532
	local chest_storage_two = 65531
	if player:getStorageValue(chest_storage) > 0 and player:getStorageValue(chest_storage_two) > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already fight Seneferu.")
		return true
	end
	
	local position = player:getPosition()
	local occupant = getPitOccupant(player)
	if occupant then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, occupant:getName() .. " is currently in fighting for the treasure!")
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local creature = Tile(initial_player_position):getTopCreature()
	if not creature or not creature:isPlayer() or creature ~= player then
		player:sendCancelMessage("You need to fight yourself.")
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local vocationId = creature:getVocation():getBaseId()
	local sacrificeId = vocationId == VOCATION.BASE_ID.SORCERER and 3059 or
	vocationId == VOCATION.BASE_ID.DRUID and 3585 or
	vocationId == VOCATION.BASE_ID.PALADIN and 3349 or
	vocationId == VOCATION.BASE_ID.KNIGHT and 3264

	local sacrificeItem = Tile(sacrifice_position):getItemById(sacrificeId)
	if not sacrificeItem then
		player:sendCancelMessage(creature:getName() .. ", where's your sacrifice?")
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	else
		ResetArena()
		player:say("FIGHT!", TALKTYPE_MONSTER_SAY)
		sacrificeItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(arena_position)
		arena_position:sendMagicEffect(CONST_ME_TELEPORT)
		Game.createMonster("Seneferu", boss_position, false, true)
		return true
	end
end

othersDesert:uid(65534)
othersDesert:register()


local reward_position = Position(32671, 32067, 8)
local is_dragon_death = MoveEvent()
function is_dragon_death.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local is_arena_clean = is_arena_clean()
	if not is_arena_clean then
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	else
		player:teleportTo(reward_position)
		reward_position:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
end

is_dragon_death:type("stepin")
is_dragon_death:uid(65533)
is_dragon_death:register()


local enemy_position = Position(32668, 32091, 8)
local enemy_position_2 = Position(32668, 32087, 8)
local enemy_position_3 = Position(32678, 32088, 8)
local enemy_position_4 = Position(32678, 32087, 8)

local spawn_mummies = MoveEvent()
function spawn_mummies.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(65530) > 0 then
		position:sendMagicEffect(CONST_ME_POFF)
	else
		player:setStorageValue(65530, 1)
		
		Game.createItem(2118, 1, Position(32670, 32090, 8))
		Game.createItem(2118, 1, Position(32670, 32094, 8))
		Game.createItem(2118, 1, Position(32676, 32090, 8))
		Game.createItem(2118, 1, Position(32676, 32094, 8))
		
		Game.createMonster("Mummy", enemy_position, false, true)
		Game.createMonster("Mummy", enemy_position_2, false, true)
		Game.createMonster("Ghoul", enemy_position_3, false, true)
		Game.createMonster("Ghoul", enemy_position_4, false, true)
	end
end

spawn_mummies:type("stepin")
spawn_mummies:uid(65530)
spawn_mummies:register()


logger.info("Peregrinaje desert script loaded")