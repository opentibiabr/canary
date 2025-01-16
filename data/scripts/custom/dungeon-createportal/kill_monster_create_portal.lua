local bosses = {
	["dungeon black knight"] = {
		message = "The soul of black knight generated a portal!",
		config = {
			toPos = Position(1108, 1095, 10),
			portalTime = 2, -- minutes
		},
	},
	["dungeon demon"] = {
		message = "You have defeated a Demon!",
		config = {
			toPos = Position(1093, 1027, 10),
			portalTime = 2, -- minutes
		},
	},
	["hurak revoltz minion"] = {
		message = "You have defeated Hurak's son!",
	},
	["hurak revoltz wife"] = {
		message = "You have defeated Hurak's wife!",
		config = {
			toPos = not DungeonConfig.hurakIsDead and DungeonConfig.hurakPos or DungeonConfig.hurakExit,
		},
	},
	["hurak revoltz"] = {
		message = "Congratulations.. You have defeated Hurak Revoltz !!",
		config = {
			toPos = DungeonConfig.hurakExit,
		},
	},
}
------------------------------------------------------------------

local function spectatorStartCountdown(time, position)
	local spectators = Game.getSpectators(position, false, false, 10, 10, 10, 10)
	if #spectators > 0 then
		for i = 1, #spectators do
			if time > 1 then
				spectators[i]:say("" .. time .. "", TALKTYPE_MONSTER_SAY, false, spectators[i], position)
			else
				spectators[i]:say("Time out!", TALKTYPE_MONSTER_SAY, false, spectators[i], position)
				break
			end
		end
	end

	local portal = Tile(position):getItemById(DungeonConfig.portalId)
	if portal then
		addEvent(spectatorStartCountdown, 1000, time - 1, position)
	end
end

------------------ Create portal after death ------------------
local killMonsterCreatePortal = CreatureEvent("DungeonBossDeath")
function killMonsterCreatePortal.onDeath(creature)
	local bossName = creature:getName():lower()
	if not table.contains({ "dungeon black knight", "dungeon demon", "hurak revoltz", "hurak revoltz minion", "hurak revoltz wife" }, bossName) then
		return false
	end

	local boss = bosses[bossName]

	local pos = creature:getPosition()
	if Tile(pos):getItemById(DungeonConfig.portalId) then
		removePortalDungeon(pos)
	end

	local item = Game.createItem(DungeonConfig.portalId, 1, pos)
	if item:isTeleport() and bossName ~= "hurak revoltz minion" then
		item:setDestination(boss.config.toPos)
	end

	local timeToRemove = 0
	if bossName == "hurak revoltz" then
		timeToRemove = 30
		DungeonConfig.hurakIsDead = true
	elseif table.contains({ "dungeon black knight", "dungeon demon" }, bossName) then
		timeToRemove = boss.config.portalTime * 60
	elseif bossName == "hurak revoltz minion" then
		timeToRemove = 10
		item:setActionId(49987)
	elseif bossName == "hurak revoltz wife" then
		item:setActionId(49988)
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if boss.message then
			player:say(boss.message, TALKTYPE_MONSTER_SAY, false, true, player:getPosition())
		end
	end)

	if bossName ~= "hurak revoltz wife" then
		if bossName ~= "hurak revoltz minion" then
			addEvent(spectatorStartCountdown, 500, timeToRemove, pos)
		end
		addEvent(removePortalDungeon, timeToRemove * 1000, pos)
	end

	return true
end

killMonsterCreatePortal:register()

------------------ Player enter in minion tp ------------------
local mecanicTp = MoveEvent()
function mecanicTp.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if item.actionid == 49987 then
		local positions = updateDungeonSlot(player:getGuid(), true)
		clearRoom(positions[2], 10, 10)
		local monster = Game.createMonster("Hurak Revoltz Wife", positions[2], false, true)
		if not monster then
			logger.error("Hurak Revoltz Wife not created to player {}", player:getName())
			return true
		end
		player:teleportTo(positions[1], true)
	elseif item.actionid == 49988 then
		local bossPos = updateDungeonSlot(player:getGuid(), false)
		if DungeonConfig.hurakIsDead then
			bossPos = DungeonConfig.hurakExit
		end
		player:teleportTo(bossPos, true)
	end

	removePortalDungeon(item:getPosition())

	return true
end

mecanicTp:type("stepin")
mecanicTp:aid(49987, 49988)
mecanicTp:register()
