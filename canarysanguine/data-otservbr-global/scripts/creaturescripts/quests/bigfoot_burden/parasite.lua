local positionsWall = {
	{ x = 33098, y = 31979, z = 11 },
	{ x = 33098, y = 31978, z = 11 },
	{ x = 33098, y = 31977, z = 11 },
	{ x = 33098, y = 31976, z = 11 },
}

local function recreateCrystals(c)
	for i = 1, #positionsWall do
		local crystal = Tile(positionsWall[i]):getItemById(c.wall) or nil
		if not item then
			Game.createItem(c.wall, 1, positionsWall[i])
		end
	end

	local spectators = Game.getSpectators(Position(33099, 31977, 11), false, false, 1, 1, 1, 2)
	for i = 1, #spectators do
		if spectators[i]:isPlayer() then
			local specPos = spectators[i]:getPosition()
			spectators[i]:teleportTo(Position(specPos.x - 2, specPos.y, specPos.z))
		else
			spectators[i]:getPosition():sendMagicEffect(CONST_ME_POFF)
			spectators[i]:remove()
		end
	end
end

local parasiteWarzone = CreatureEvent("ParasiteDeath")
function parasiteWarzone.onDeath(creature)
	local master = creature:getMaster()
	if not master or master:isPlayer() then
		return false
	end

	local pos = creature:getPosition()
	if pos.x ~= 33097 or pos.y > 31979 or pos.y < 31976 or pos.z ~= 11 then
		return false
	end

	local config = warzoneConfig.findByName("Gnomevil")
	if config.locked then
		creature:say("It seems that someone has already destroyed the walls in the last 30 minutes.", TALKTYPE_MONSTER_SAY)
		return false
	end

	if config.wall < 16171 and config.wall >= 16169 then
		for i = 1, #positionsWall do
			local crystal = Tile(positionsWall[i]):getItemById(config.wall)
			if crystal then
				Tile(positionsWall[i]):getItemById(config.wall):remove()
				Game.createItem(config.wall + 1, 1, positionsWall[i])
			end
		end
		config.wall = config.wall + 1
	elseif config.wall == 16171 then
		for i = 1, #positionsWall do
			local crystal = Tile(positionsWall[i]):getItemById(config.wall)
			if crystal then
				Tile(positionsWall[i]):getItemById(config.wall):remove()
			end
		end
		config.wall = 16169
		addEvent(recreateCrystals, 1 * 60 * 1000, config)
		addEvent(warzoneConfig.spawnBoss, 1 * 60 * 1000, config.boss, config.bossResp)
		addEvent(warzoneConfig.resetRoom, 30 * 60 * 1000, config, "You were teleported out by the gnomish emergency device.", true)
	end
	return true
end

parasiteWarzone:register()
