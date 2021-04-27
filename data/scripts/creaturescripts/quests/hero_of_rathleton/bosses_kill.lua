local bosses = {
	['deep terror'] = {
		teleportPos = Position(33749, 31952, 14),
		nextpos = Position(33740, 31940, 15),
		globaltimer = GlobalStorage.HeroRathleton.DeepRunning},
	['empowered glooth horror'] = {
		teleportPos = Position(33545, 31955, 15),
		nextpos = Position(33534, 31955, 15),
		globaltimer = GlobalStorage.HeroRathleton.HorrorRunning},
	['professor maxxen'] = {
		teleportPos = Position(33718, 32047, 15),
		nextpos = Position(33707, 32107, 15),
		globaltimer = GlobalStorage.HeroRathleton.MaxxenRunning}
}

local function checkHorror()
	local spectators = Game.getSpectators(Position(33555, 31956, 15), false, false, 13, 13, 13, 13)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isMonster() then
			if spectator:getName():lower() == 'empowered glooth horror' and spectator:getHealth() >= 1 then
				return true
			elseif spectator:getName():lower() == 'strong glooth horror' and spectator:getHealth() >= 1 then
				return true
			elseif spectator:getName():lower() == 'feeble glooth horror' and spectator:getHealth() >= 1 then
				return true
			elseif spectator:getName():lower() == 'weakened glooth horror' and spectator:getHealth() >= 1 then
				return true
			elseif spectator:getName():lower() == 'glooth horror' and spectator:getHealth() >= 1 then
				return true
			end
		end
	end
	return false
end

local function revertTeleport(position, itemId, transformId, destination)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
		item:setDestination(destination)
	end
end

local rathletonBossKill = CreatureEvent("RathletonBossKill")
function rathletonBossKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end
	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end
	if targetMonster:getName():lower() == 'empowered glooth horror' then
		if checkHorror() == true then
			return true
		end
	end

	local teleport = Tile(bossConfig.teleportPos):getItemById(1387)
	if not teleport then return true end
	local teleportPos = bossConfig.teleportPos
	local oldPos = teleport:getDestination()
	local newPos = bossConfig.nextpos
	if teleport then
		teleport:transform(25417)
		targetMonster:getPosition():sendMagicEffect(CONST_ME_THUNDER)
		teleport:setDestination(newPos)
		addEvent(revertTeleport, 2 * 60 * 1000, teleportPos, 25417, 1387, oldPos)
		Game.setStorageValue(bossConfig.globaltimer, 0)
	end
	return true
end

rathletonBossKill:register()
