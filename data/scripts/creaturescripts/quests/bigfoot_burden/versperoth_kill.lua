local teleportPosition = Position(33075, 31878, 12)

local function transformTeleport(open)
	local id = (open and 18462 or 1387)
	local teleportItem = Tile(teleportPosition):getItemById(id)
	if not teleportItem then
		return
	end

	teleportPosition:sendMagicEffect(CONST_ME_POFF)
	if open then
		teleportItem:transform(18463) -- can pass and summon versperoth
	else
		teleportItem:transform(18462) -- cannot summon versperoth
	end
end

local versperothKill = CreatureEvent("VersperothKill")
function versperothKill.onKill(creature, target)
	local config = warzoneConfig.findByName("Abyssador")
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'versperoth' then
		return true
	end

	Game.setStorageValue(GlobalStorage.BigfootBurden.Versperoth.Battle, 2)
	addEvent(Game.setStorageValue, 30 * 60 * 1000, GlobalStorage.BigfootBurden.Versperoth.Battle, 0)

	blood = Tile(teleportPosition):getItemById(2016)
	if blood then
		blood:remove()
	end
	local tp = Game.createItem(1387, 1, teleportPosition)
	if tp then
		tp:setActionId(45702)
	end

	addEvent(transformTeleport, 1 * 60 * 1000, false)
	addEvent(transformTeleport, 30 * 60 * 1000, true)
	addEvent(warzoneConfig.spawnBoss, 1 * 80 * 1000, config.boss, config.bossResp)
	addEvent(warzoneConfig.resetRoom, 30 * 60 * 1000, config, "You were teleported out by the gnomish emergency device.", true)
	return true
end

versperothKill:register()
