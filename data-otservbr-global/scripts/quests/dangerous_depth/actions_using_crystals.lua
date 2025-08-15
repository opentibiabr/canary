local beastPositions = {
	[1] = Position(33677, 32333, 15),
	[2] = Position(33677, 32337, 15),
	[3] = Position(33685, 32333, 15),
	[4] = Position(33685, 32337, 15),
}

local machinePositions = {
	[1] = {
		[1] = Position(33672, 32331, 15),
		[2] = Position(33673, 32331, 15),
		[3] = Position(33674, 32331, 15),
		[4] = Position(33675, 32331, 15),
	},
	[2] = {
		[1] = Position(33676, 32339, 15),
		[2] = Position(33677, 32339, 15),
		[3] = Position(33678, 32339, 15),
		[4] = Position(33679, 32339, 15),
	},
	[3] = {
		[1] = Position(33680, 32330, 15),
		[2] = Position(33681, 32330, 15),
		[3] = Position(33682, 32330, 15),
		[4] = Position(33683, 32330, 15),
	},
	[4] = {
		[1] = Position(33684, 32339, 15),
		[2] = Position(33685, 32339, 15),
		[3] = Position(33686, 32339, 15),
		[4] = Position(33687, 32339, 15),
	},
	[5] = {
		[1] = Position(33688, 32332, 15),
		[2] = Position(33689, 32332, 15),
		[3] = Position(33690, 32332, 15),
		[4] = Position(33691, 32332, 15),
	},
}

local fieryHearts = {
	[1] = Position(33712, 32299, 15),
	[2] = Position(33715, 32301, 15),
	[3] = Position(33714, 32305, 15),
	[4] = Position(33710, 32305, 15),
	[5] = Position(33709, 32301, 15),
}

local aggressiveLavasIV = {
	[1] = Position(33648, 32295, 15),
	[2] = Position(33648, 32313, 15),
}

local aggressiveLavasVI = {
	[1] = Position(33712, 32296, 15),
	[2] = Position(33712, 32310, 15),
}

local function lavaHoles(i)
	local lavaHolesArray = {
		[1] = Position(33652, 32307, 15),
		[2] = Position(33644, 32307, 15),
		[3] = Position(33644, 32299, 15),
		[4] = Position(33652, 32299, 15),
	}
	local boss = false
	local positionCenter = Position(33648, 32302, 15)
	local spectator = Game.getSpectators(positionCenter, false, false, 20, 20, 20, 20)
	for _, creature in pairs(spectator) do
		if creature:isMonster() then
			if creature:getName():lower() == "the baron from below" or creature:getName():lower() == "the hungry baron from below" then
				boss = true
			end
		end
	end
	if boss == true then
		local position = lavaHolesArray[i]
		local desativado = Tile(position):getItemById(390)
		if desativado then
			desativado:transform(391)
			addEvent(function()
				local ativado = Tile(position):getItemById(391)
				if ativado then
					local c = Game.getPlayers()[1]
					c:say("BOOOOM!", TALKTYPE_MONSTER_SAY, false, false, position)
					for x = position.x - 4, position.x + 4 do
						for y = position.y - 4, position.y + 4 do
							for z = position.z, position.z do
								if Tile(Position(x, y, z)) then
									if Tile(Position(x, y, z)) then
										local sqm = Position(x, y, z)
										local creature = Tile(Position(x, y, z)):getTopCreature()
										local mwCheck = Tile(Position(x, y, z)):getItemById(2129)
										local wildCheck = Tile(Position(x, y, z)):getItemById(2130)
										if not (mwCheck or wildCheck) then
											if creature then
												if creature:isPlayer() then
													creature:addHealth(-(math.random(0, 1500)))
												end
											end
											sqm:sendMagicEffect(CONST_ME_HITBYFIRE)
										end
									end
								end
							end
						end
					end
					ativado:transform(390)
				end
			end, 3 * 1000)
			i = i + 1
			if i > 4 then
				i = 1
			end
		end
	end
	if boss == true then
		addEvent(lavaHoles, 15 * 1000, i)
	end
end

local function sumonarLavasIV(i)
	local boss = false
	local positionCenter = Position(33648, 32302, 15)
	local spectator = Game.getSpectators(positionCenter, false, false, 20, 20, 20, 20)
	for _, creature in pairs(spectator) do
		if creature:isMonster() then
			if creature:getName():lower() == "the baron from below" or creature:getName():lower() == "the hungry baron from below" then
				boss = true
			end
		end
	end
	if boss == true then
		if i >= 1 then
			for j, position in pairs(aggressiveLavasIV) do
				position:sendMagicEffect(CONST_ME_TELEPORT)
			end
			i = i - 1
			addEvent(sumonarLavasIV, 2 * 1000, i)
		elseif i == 0 then
			for j, position in pairs(aggressiveLavasIV) do
				local lava = Game.createMonster("Aggressive Lava", position)
			end
			addEvent(sumonarLavasIV, 15 * 1000, 5)
		end
	end
end

local function sumonarLavasVI(i)
	local boss = false
	local positionCenter = Position(33712, 32303, 15)
	local spectator = Game.getSpectators(positionCenter, false, false, 20, 20, 20, 20)
	for _, creature in pairs(spectator) do
		if creature:isMonster() then
			if creature:getName():lower() == "the duke of the depths" or creature:getName():lower() == "the fire empowered duke" then
				boss = true
			end
		end
	end
	if boss == true then
		if i >= 1 then
			for j, position in pairs(aggressiveLavasVI) do
				position:sendMagicEffect(CONST_ME_TELEPORT)
			end
			i = i - 1
			addEvent(sumonarLavasVI, 2 * 1000, i)
		elseif i == 0 then
			for j, position in pairs(aggressiveLavasVI) do
				local lava = Game.createMonster("Aggressive Lava", position)
			end
			addEvent(sumonarLavasVI, 15 * 1000, 5)
		end
	end
end

local function sumonarFieryHearts()
	local boss = false
	local bossId
	local contagemHearts = 0
	local positionCenter = Position(33712, 32303, 15)
	local spectator = Game.getSpectators(positionCenter, false, false, 20, 20, 20, 20)
	for _, creature in pairs(spectator) do
		if creature:isMonster() then
			if creature:getName():lower() == "the duke of the depths" then
				boss = true
				bossId = Creature(creature:getId())
			end
		end
	end
	for _, heart in pairs(spectator) do
		if heart:isMonster() then
			if heart:getName():lower() == "fiery heart" then
				contagemHearts = contagemHearts + 1
			end
		end
	end
	if boss == true and contagemHearts == 0 then
		for _, position in pairs(fieryHearts) do
			fiery = Game.createMonster("Fiery Heart", position)
			if fiery then
				fiery:registerEvent("FieryHeartThink")
			end
		end
		local oldBossHealth = bossId:getHealth()
		bossId:setType("The Fire Empowered Duke")
		bossId:addHealth(-(bossId:getHealth() - oldBossHealth))
	end
	if boss == true then
		addEvent(sumonarFieryHearts, 40 * 1000)
	end
end

local function startMachines()
	local random = math.random(1, 5)
	local positionCenter = Position(33681, 32335, 15)
	local spectator = Game.getSpectators(positionCenter, false, false, 20, 20, 20, 20)
	local checagem = false
	for _, monster in pairs(spectator) do
		if monster:isMonster() then
			if monster:getName():lower() == "the count of the core" then
				checagem = true
				addEvent(function()
					for _, position in pairs(machinePositions[random]) do
						local machineOff = Tile(position):getItemById(31724)
						if machineOff then
							machineOff:remove()
							local machineOn = Game.createItem(31723, 1, position)
							addEvent(function()
								local a = machineOn:getPosition().y + 10
								local a_ = machineOn:getPosition().y - 10
								if random % 2 ~= 0 then
									for x = machineOn:getPosition().x, machineOn:getPosition().x do
										for y = machineOn:getPosition().y + 1, a do
											for z = machineOn:getPosition().z, machineOn:getPosition().z do
												if Tile(Position(x, y, z)) then
													if Tile(Position(x, y, z)) then
														local sqm = Position(x, y, z)
														local creature = Tile(Position(x, y, z)):getTopCreature()
														local mwCheck = Tile(Position(x, y, z)):getItemById(2129)
														local wildCheck = Tile(Position(x, y, z)):getItemById(2130)
														if not (mwCheck or wildCheck) then
															if creature then
																if creature:isMonster() then
																	if creature:getName():lower() == "the count of the core" then
																		creature:addHealth(math.random(3000, 5000))
																	end
																elseif creature:isPlayer() then
																	creature:addHealth(-(math.random(0, 1500)))
																end
															end
															sqm:sendMagicEffect(CONST_ME_HITBYFIRE)
														else
															a = machineOn:getPosition().y
														end
													end
												end
											end
										end
									end
								else
									for x = machineOn:getPosition().x, machineOn:getPosition().x do
										for y = a_, machineOn:getPosition().y - 1 do
											for z = machineOn:getPosition().z, machineOn:getPosition().z do
												if Tile(Position(x, y, z)) then
													if Tile(Position(x, y, z)) then
														local sqm = Position(x, y, z)
														local creature = Tile(Position(x, y, z)):getTopCreature()
														local mwCheck = Tile(Position(x, y, z)):getItemById(2129)
														local wildCheck = Tile(Position(x, y, z)):getItemById(2130)
														if not (mwCheck or wildCheck) then
															if creature then
																if creature:isMonster() then
																	if creature:getName():lower() == "the count of the core" then
																		creature:addHealth(math.random(3000, 5000))
																	end
																elseif creature:isPlayer() then
																	creature:addHealth(-(math.random(0, 1500)))
																end
															end
															sqm:sendMagicEffect(CONST_ME_HITBYFIRE)
														else
															a_ = machineOn:getPosition().y
														end
													end
												end
											end
										end
									end
								end
								addEvent(function()
									if machineOn then
										machineOn:transform(31724)
									end
								end, 1 * 1000)
							end, 2 * 1000)
						end
					end
				end, 6 * 1000)
			end
		end
	end
	if checagem == true then
		addEvent(startMachines, 6 * 1000)
	end
end

local function summonBeasts(i)
	local position = Position(randomarea)
	if i >= 1 then
		for j, position in pairs(beastPositions) do
			position:sendMagicEffect(CONST_ME_TELEPORT)
		end
		i = i - 1
		addEvent(summonBeasts, 2 * 1000, i)
	elseif i == 0 then
		for j, position in pairs(beastPositions) do
			local beast = Game.createMonster("Ember Beast", position)
		end
	end
end

local function checarSala(qnt)
	local temBoss = false
	local hpBoss
	local position = Position(33681, 32334, 15)
	local spectators = Game.getSpectators(position, false, false, 20, 20, 20, 20)
	for _, checagem in pairs(spectators) do
		if checagem:isMonster() then
			if checagem:getName():lower() == "the count of the core" then
				temBoss = true
				hpBoss = (checagem:getHealth() / checagem:getMaxHealth()) * 100
			end
		end
	end
	local contagemBeast = 0
	for _, checagem2 in pairs(spectators) do
		if checagem2:isMonster() then
			if checagem2:getName():lower() == "ember beast" then
				contagemBeast = contagemBeast + 1
			end
		end
	end
	if temBoss == true then
		if contagemBeast > 0 then
			for _, spectator in pairs(spectators) do
				if spectator:isMonster() then
					if spectator:getName():lower() == "ember beast" then
						if hpBoss < 70 then
							qnt = qnt - 1
							spectator:remove()
							for _, boss in pairs(spectators) do
								if boss:isMonster() then
									if boss:getName():lower() == "the count of the core" then
										boss:say("The count absorbs he power of the beast and becomes stronger.", TALKTYPE_MONSTER_YELL)
										boss:addHealth(math.random(0, 15000))
									end
								end
							end
							break
						end
					end
				end
			end
			if temBoss == true then
				addEvent(checarSala, 60 * 1000, qnt)
			end
		end
	end
end

local function startWarzoneIV()
	addEvent(function()
		Game.createMonster("The Baron From Below", Position(33648, 32303, 15))
		addEvent(sumonarLavasIV, 15 * 1000, 5)
		addEvent(lavaHoles, 15 * 1000, 1)
	end, 10 * 1000)
end

local function startWarzoneV()
	addEvent(function()
		local monstro = Game.createMonster("The Count Of The Core", Position(33681, 32334, 15))
		if monstro then
			monstro:registerEvent("SnailSlimeThink")
		end
		summonBeasts(5)
		addEvent(startMachines, 10 * 1000)
		addEvent(checarSala, 30 * 1000, 4)
	end, 5 * 1000)
end

local function startWarzoneVI()
	addEvent(function()
		local monstro = Game.createMonster("The Duke Of The Depths", Position(33712, 32303, 15))
		if monstro then
			monstro:registerEvent("FieryHeartThink")
		end
		addEvent(sumonarFieryHearts, 30 * 1000)
		addEvent(sumonarLavasVI, 15 * 1000, 5)
	end, 10 * 1000)
end

local dangerousDepthCrystals = Action()
function dangerousDepthCrystals.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	if not target or type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	if target:isCreature() then
		return false
	end

	local WarzoneVI = Position(33274, 32316, 15)
	local WarzoneIV = Position(33459, 32267, 15)
	local WarzoneV = Position(33323, 32109, 15)
	local geodeId = 27510
	local targetPosition = target:getPosition()

	if targetPosition == WarzoneIV and target:getId() == geodeId then -- Warzone 4 BOSS!!!
		if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneIV) < 30 then
			targetPosition:sendMagicEffect(CONST_ME_HITAREA)
			item:remove(1)
			if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneIV) < 0 then
				Game.setStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneIV, 0)
			end
			Game.setStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneIV, Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneIV) + 1)
			if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneIV) == 30 then
				local spectators = Game.getSpectators(targetPosition, false, true, 3, 3, 3, 3)
				for _, spectator in pairs(spectators) do
					if spectator:isPlayer() then
						spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This crystal geode is shaking from a battle nearby.")
					end
				end
				local stalagmites = Tile(Position(33460, 32267, 15)):getItemById(388)
				if stalagmites then
					stalagmites:remove()
					local teleport = Game.createItem(1949, 1, Position(33460, 32267, 15))
					teleport:setActionId(57243)
					addEvent(function()
						if teleport then
							teleport:remove(1)
							Game.createItem(388, 1, Position(33460, 32267, 15))
						end
					end, 8 * 1000)
					addEvent(clearForgotten, 30 * 60 * 1000, Position(33638, 32291, 15), Position(33675, 32313, 15), Position(33462, 32267, 15), Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneIV)
					startWarzoneIV()
				end
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The crystal geode can't carry any more crystals.")
		end
	end

	if targetPosition == WarzoneV and target:getId() == geodeId then -- Warzone 5 BOSS!!!
		if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneV) < 30 then
			targetPosition:sendMagicEffect(CONST_ME_HITAREA)
			item:remove(1)
			if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneV) < 0 then
				Game.setStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneV, 0)
			end
			Game.setStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneV, Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneV) + 1)
			if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneV) == 30 then
				local spectators = Game.getSpectators(targetPosition, false, true, 3, 3, 3, 3)
				for _, spectator in pairs(spectators) do
					if spectator:isPlayer() then
						spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This crystal geode is shaking from a battle nearby.")
					end
				end
				local stalagmites = Tile(Position(33324, 32109, 15)):getItemById(388)
				if stalagmites then
					stalagmites:remove()
					local teleport = Game.createItem(1949, 1, Position(33324, 32109, 15))
					teleport:setActionId(57243)
					addEvent(function()
						if teleport then
							teleport:remove(1)
							Game.createItem(388, 1, Position(33324, 32109, 15))
						end
					end, 8 * 1000)
					addEvent(clearForgotten, 30 * 60 * 1000, Position(33668, 32310, 15), Position(33695, 32343, 15), Position(33323, 32111, 15), Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneV)
					startWarzoneV()
				end
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The crystal geode can't carry any more crystals.")
		end
	end

	if targetPosition == WarzoneVI and target:getId() == geodeId then -- Warzone 6 BOSS!!!
		if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneVI) < 30 then
			targetPosition:sendMagicEffect(CONST_ME_HITAREA)
			item:remove(1)
			if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneVI) < 0 then
				Game.setStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneVI, 0)
			end
			Game.setStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneVI, Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneVI) + 1)
			if Game.getStorageValue(Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneVI) == 30 then
				local spectators = Game.getSpectators(targetPosition, false, true, 3, 3, 3, 3)
				for _, spectator in pairs(spectators) do
					if spectator:isPlayer() then
						spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This crystal geode is shaking from a battle nearby.")
					end
				end
				local stalagmites = Tile(Position(33275, 32316, 15)):getItemById(388)
				if stalagmites then
					stalagmites:remove()
					local teleport = Game.createItem(1949, 1, Position(33275, 32316, 15))
					teleport:setActionId(57243)
					addEvent(function()
						if teleport then
							teleport:remove(1)
							Game.createItem(388, 1, Position(33275, 32316, 15))
						end
					end, 8 * 1000)
					addEvent(clearForgotten, 30 * 60 * 1000, Position(33684, 32293, 15), Position(33724, 32314, 15), Position(33275, 32318, 15), Storage.Quest.U11_50.DangerousDepths.Geodes.WarzoneVI)
					startWarzoneVI()
				end
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The crystal geode can't carry any more crystals.")
		end
	end

	return true
end

dangerousDepthCrystals:id(27509)
dangerousDepthCrystals:register()
