-- Variaveis
CASTLE_KICK_POSITION = Position(32372, 32290, 7)
CASTLE_ENTRANCE_ACTIONID = 60167
CASTLE_THRONE_ACTIONID = 60168
CASTLE_ATALHOENTRADA_ACTIONID = 60169
TOWER_MONSTER_NAME = "Castle Tower"
TOWER_SPAWN_POSITIONS = {
	Position(32381, 32293, 8),
	Position(32381, 32294, 8),
	Position(32381, 32295, 8),
	Position(32381, 32296, 8),
	Position(32373, 32330, 8),
	Position(32373, 32331, 8),
	Position(32390, 32321, 8),
	Position(32390, 32322, 8),
	Position(32390, 32323, 8),
	Position(32361, 32340, 8),
	Position(32361, 32341, 8),
	Position(32361, 32342, 8),
	Position(32373, 32332, 8),
}

function getDominantGuildId()
	local scope = kv.scoped("castlewar")
	local dom = scope.get("dominant-guild")
	return dom
end

function setDominantGuild(guildId)
	local scope = kv.scoped("castlewar")
	scope.set("dominant-guild", guildId)
	if guildId > 0 then
		local dominantGuild = Guild(guildId)
		local message = "The guild " .. dominantGuild:getName() .. " successfully conquered the Castle."
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	end
end

function isInvadingCastle(_player)
	local playerKV = _player:kv()
	return playerKV:get("invading-castle")
end

function setInvadingCastle(_player, status)
	local playerKV = _player:kv()
	playerKV:set("invading-castle", status)
end

function checkDominantExist()
	local dominantId = getDominantGuildId()

	if dominantId == -1 then
		return nil
	end

	local dominantGuild = Guild(dominantId)
	if not dominantGuild then
		setDominantGuild(-1)
		return nil
	end
	return dominantGuild
end

function spawnCastleTowers()
	local zone = Zone("castlewar")
	zone:removeMonsters()
	for _, position in ipairs(TOWER_SPAWN_POSITIONS) do
		Game.createMonster(TOWER_MONSTER_NAME, position)
	end
end

function checkInvasionOccurring()
	local scope = kv.scoped("castlewar")
	local dom = scope.get("invasion-occurring")
	if dom == 1 then
		return true
	else
		return false
	end
end

function startInvasion()
	if checkInvasionOccurring() == false then
		local scope = kv.scoped("castlewar")
		scope.set("invasion-occurring", 1)
	end
	spawnCastleTowers()

	return true
end

function stopInvasion()
	local scope = kv.scoped("castlewar")
	scope.set("invasion-occurring", 0)
	local zone = Zone("castlewar")

	zone:removeMonsters()
	setCastleCooldown(10 * 60)
end

function broadcastAndStartInvasion(invaderGuildName)
	local dominant = checkDominantExist()
	if dominant ~= nil then
		local domGuildName = dominant:getName()
		local message = "The guild " .. invaderGuildName .. " is trying to invade the castle. Members of " .. domGuildName .. " DEFEND THE CASTLE NOW!"
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	end

	startInvasion()
end

function getCastleCooldown()
	local scope = kv.scoped("castlewar")
	if not scope then
		return false
	end
	return scope.get("castlecooldown") or 0
end

function setCastleCooldown(time)
	local scope = kv.scoped("castlewar")
	if not scope then
		return false
	end
	local result = scope.set("castlecooldown", os.time() + time)
	return result
end

function canEnterCastle()
	return getCastleCooldown() <= os.time()
end
