local vampireBrideKills = {}
local killCooldown = {}

local function checkAndTeleport(areaFromPos, areaToPos, teleportDest, spawnPos)
	local killCount = 0

	for x = areaFromPos.x, areaToPos.x do
		for y = areaFromPos.y, areaToPos.y do
			local killKey = string.format("%d,%d,%d", x, y, areaFromPos.z)
			if vampireBrideKills[killKey] then
				killCount = killCount + 1
			end
		end
	end

	if killCount >= 2 then
		local spectators = Game.getSpectators(areaFromPos, false, true, areaToPos.x - areaFromPos.x, areaToPos.x - areaFromPos.x, areaToPos.y - areaFromPos.y, areaToPos.y - areaFromPos.y)

		for _, spectator in ipairs(spectators) do
			if spectator:isPlayer() then
				spectator:teleportTo(teleportDest)
				teleportDest:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end

		Game.createMonster("Marziel", spawnPos)
		Game.createMonster("Vampire", Position(spawnPos.x - 1, spawnPos.y, spawnPos.z))

		vampireBrideKills = {}
		killCooldown = {}
	end
end

local VampireBrideDeath = CreatureEvent("VampireBrideDeath")

function VampireBrideDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamageKiller)
	local pos = creature:getPosition()
	local areaFromPos = Position(32936, 31456, 2)
	local areaToPos = Position(32944, 31464, 2)

	if pos.x >= areaFromPos.x and pos.x <= areaToPos.x and pos.y >= areaFromPos.y and pos.y <= areaToPos.y and pos.z == areaFromPos.z then
		local killKey = string.format("%d,%d,%d", pos.x, pos.y, pos.z)
		local currentTime = os.time()

		if not killCooldown[killKey] or (currentTime - killCooldown[killKey]) > 5 then
			killCooldown[killKey] = currentTime
			vampireBrideKills[killKey] = true
			checkAndTeleport(areaFromPos, areaToPos, Position(32940, 31460, 1), Position(32940, 31458, 1))
		end
	end

	return true
end

VampireBrideDeath:register()
