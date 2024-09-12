local config = AscendingFerumbrasConfig

local function clearFerumbrasRoom()
	local spectators = Game.getSpectators(config.bossPos, false, false, 20, 20, 20, 20)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(config.exitPosition)
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say("Time out! You were teleported out by strange forces.", TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
end

local ferumbrasAscendantLever = Action()
function ferumbrasAscendantLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		if player:getPosition() ~= config.leverPos then
			return true
		end

		for x = 33269, 33271 do
			for y = 31477, 31481 do
				local playerTile = Tile(Position(x, y, 14)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					if not playerTile:canFightBoss("Ferumbras Mortal Shell") then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You or a member in your team have to wait %d days to face Ferumbras again!", config.days))
						item:transform(8912)
						return true
					end
				end
			end
		end

		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's someone fighting with Ferumbras.")
				return true
			end
		end

		local spectators = Game.getSpectators(config.bossPos, false, false, 15, 15, 15, 15)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:isMonster() then
				spectator:remove()
			end
		end

		for x = 33269, 33271 do
			for y = 31477, 31481 do
				local playerTile = Tile(Position(x, y, 14)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPos)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setBossCooldown("Ferumbras Mortal Shell", os.time() + config.days * 24 * 3600)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have %d minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.", config.time))
					addEvent(clearFerumbrasRoom, config.time * 60 * 1000, player:getId(), config.centerRoom, config.range, config.range, config.exitPosition)

					for b = 1, config.maxSummon do
						local xrand = math.random(-10, 10)
						local yrand = math.random(-10, 10)
						local position = Position(33392 + xrand, 31473 + yrand, 14)
						if not Game.createMonster(config.summonName, position) then
							logger.error("[ferumbrasAscendantLever.onUse] can't create monster {}, on position {}", config.summonName, position:toString())
						end
					end

					Game.createMonster(config.bossName, config.bossPos, true, true)
					item:transform(8912)
				end
			end
		end
	elseif item.itemid == 8912 then
		item:transform(8911)
		return true
	end
end

ferumbrasAscendantLever:uid(1021)
ferumbrasAscendantLever:register()
