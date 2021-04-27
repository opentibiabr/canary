local team = {}

-- FUNCTIONS

local function shuffleTable(t, count, ri, rj)
	ri = ri or 1
	rj = rj or #t
	for x = 1, count or 1 do
		for i = rj, ri + 1, -1 do
			local j = math.random(ri, rj)
			t[i], t[j] = t[j], t[i]
		end
	end
end

local function doCheckArea()
	--Room 1
	local upConer = {x = 32133, y = 31341, z = 14}       -- upLeftCorner
	local downConer = {x = 32174, y = 31375, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k = upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								return true
							end
						end
					end
				end
			end
		end
	end

	--Room 2
    local upConer2 = {x = 32140, y = 31340, z = 15}       -- upLeftCorner
	local downConer2 = {x = 32174, y = 31375, z = 15}     -- downRightCorner

	for f=upConer2.x, downConer2.x do
		for g=upConer2.y, downConer2.y do
        	for h= upConer2.z, downConer2.z do
		        local room = {x=f, y=g, z=h}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								return true
							end
						end
					end
				end
			end
		end
	end

	if spawningCharge == true then
		return true
	end

	return false
end

local function clearArea()
	--Room 1
	local upConer = {x = 32133, y = 31341, z = 14}       -- upLeftCorner
	local downConer = {x = 32174, y = 31375, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k= upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								c:teleportTo({x = 32092, y = 31330, z = 12})
							elseif isMonster(c) then
								c:remove()
							end
						end
					end
				end
			end
		end
	end

	--Room 2
    local upConer2 = {x = 32140, y = 31340, z = 15}       -- upLeftCorner
	local downConer2 = {x = 32174, y = 31375, z = 15}     -- downRightCorner

	for f=upConer2.x, downConer2.x do
		for g=upConer2.y, downConer2.y do
        	for h=upConer2.z, downConer2.z do
		        local room = {x=f, y=g, z=h}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								c:teleportTo({x = 32092, y = 31330, z = 12})
							elseif isMonster(c) then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	team = {}
	stopEvent(areaHeart1)
	stopEvent(areaHeart2)
	stopEvent(areaHeart3)
end

function teleportToCrackler()
	shuffleTable(team, 2, ri, rj) -- Embaralha a tabela para dar um random teleport

	--Room 1
	local upConer = {x = 32142, y = 31341, z = 14}       -- upLeftCorner
	local downConer = {x = 32176, y = 31375, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k= upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if c == team[1] or c == team[2] then
								c:teleportTo({x = c:getPosition().x, y = c:getPosition().y, z = c:getPosition().z + 1})
								c:say("A shift in polarity switches creatures with coresponding polarity into another phase of existence!", TALKTYPE_MONSTER_YELL, isInGhostMode, pid, {x = 32158, y = 31355, z = 14})
							end
						end
					end
				end
			end
		end
	end
	areaHeart3 = addEvent(teleportToCharger, 10000)
end

function teleportToCharger()
	--Room 1
	local upConer = {x = 32142, y = 31341, z = 15}       -- upLeftCorner
	local downConer = {x = 32176, y = 31375, z = 15}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k= upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								c:teleportTo({x = c:getPosition().x, y = c:getPosition().y, z = c:getPosition().z - 1})
							end
						end
					end
				end
			end
		end
	end
	areaHeart2 = addEvent(teleportToCrackler, 25000)
end
-- FUNCTIONS END

local heartDestructionCharges = Action()
function heartDestructionCharges.onUse(player, item, fromPosition, itemEx, toPosition)

	local config = {
		playerPositions = {
			Position(32091, 31327, 12),
			Position(32092, 31327, 12),
			Position(32093, 31327, 12),
			Position(32094, 31327, 12),
			Position(32095, 31327, 12)
		},

		newPos = {x = 32135, y = 31363, z = 14},
	}

	local pushPos = {x = 32091, y = 31327, z = 12}

	if item.actionid == 14320 then
		if item.itemid == 9825 then
			if player:getPosition().x == pushPos.x and player:getPosition().y == pushPos.y and player:getPosition().z == pushPos.z then

				local storePlayers, playerTile = {}
				for i = 1, #config.playerPositions do
					playerTile = Tile(config.playerPositions[i]):getTopCreature()
					if isPlayer(playerTile) then
						storePlayers[#storePlayers + 1] = playerTile
					end
				end

				if doCheckArea() == false then
					clearArea()

					local players

					for i = 1, #storePlayers do
						players = storePlayers[i]
						table.insert(team, players) -- Insert players on table to get a random teleport
						config.playerPositions[i]:sendMagicEffect(CONST_ME_POFF)
						players:teleportTo(config.newPos)
						Position(config.newPos):sendMagicEffect(11)
					end

					areaHeart1 = addEvent(clearArea, 15 * 60000)
					areaHeart2 = addEvent(teleportToCrackler, 25000)

					Game.setStorageValue(14321, 0) -- Overcharge Count

					spawningCharge = false

					Game.createMonster("Charger", {x = 32151, y = 31356, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32154, y = 31353, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32153, y = 31361, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32158, y = 31362, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32161, y = 31360, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32156, y = 31357, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32159, y = 31354, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32163, y = 31356, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32162, y = 31352, z = 14}, false, true)
					Game.createMonster("Charger", {x = 32158, y = 31350, z = 14}, false, true)

					Game.createMonster("Overcharge", {x = 32152, y = 31355, z = 15}, false, true)
					Game.createMonster("Overcharge", {x = 32154, y = 31360, z = 15}, false, true)
					Game.createMonster("Overcharge", {x = 32160, y = 31360, z = 15}, false, true)
					Game.createMonster("Overcharge", {x = 32162, y = 31356, z = 15}, false, true)
					Game.createMonster("Overcharge", {x = 32158, y = 31352, z = 15}, false, true)
				else
					player:sendTextMessage(19, "Someone is in the area.")
				end
			else
				return true
			end
		end
		item:transform(item.itemid == 9825 and 9826 or 9825)
	end

	return true
end

heartDestructionCharges:aid(14320)
heartDestructionCharges:register()