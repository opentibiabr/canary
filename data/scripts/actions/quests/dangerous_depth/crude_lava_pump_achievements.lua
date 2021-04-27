local transformid = {
	[30735] = 30737,
}

local function explosion(item)
	local centerPosition = item:getPosition()
	for x = centerPosition.x - 1, centerPosition.x + 1 do
		for y = centerPosition.y - 1, centerPosition.y + 1 do
			for z = centerPosition.z, centerPosition.z do
				if Tile(Position(x, y, z)) then
					if Tile(Position(x, y, z)) then
						local sqm = Position(x, y, z)
						sqm:sendMagicEffect(CONST_ME_FIREAREA)
					end
				end
			end
		end
	end
end

local dangerousDepthAchievements = Action()
function dangerousDepthAchievements.onUse(player, item)
	if not player then
		return true
	end

	explosion(item)

	local positionItem = item:getPosition()
	local WarzoneIV = Position(33673, 32304, 15)
	local WarzoneV = Position(33679, 32310, 15)
	local WarzoneVI = Position(33685, 32304, 15)

	if positionItem  == WarzoneIV then -- Warzone VI
		if player:getStorageValue(Storage.DangerousDepths.Bosses.TheBaronFromBelowAchiev) < 1 then
			player:addAchievement('Buried the Baron')
			player:setStorageValue(Storage.DangerousDepths.Bosses.TheBaronFromBelowAchiev, 1)
		end
	end

	if positionItem == WarzoneV then -- Warzone V
		if player:getStorageValue(Storage.DangerousDepths.Bosses.TheCountOfTheCoreAchiev) < 1 then
			player:addAchievement('His Days are Counted')
			player:setStorageValue(Storage.DangerousDepths.Bosses.TheCountOfTheCoreAchiev, 1)
		end
	end

	if positionItem == WarzoneVI then -- Warzone IV
		if player:getStorageValue(Storage.DangerousDepths.Bosses.TheDukeOfTheDepthsAchiev) < 1 then
			player:addAchievement('Duked It Out')
			player:setStorageValue(Storage.DangerousDepths.Bosses.TheDukeOfTheDepthsAchiev, 1)
		end
	end

	if player:getStorageValue(Storage.DangerousDepths.Bosses.LastAchievement) < 1 then
		if player:getStorageValue(Storage.DangerousDepths.Bosses.TheDukeOfTheDepthsAchiev) == 1 and  player:getStorageValue(Storage.DangerousDepths.Bosses.TheBaronFromBelowAchiev) == 1
			and player:getStorageValue(Storage.DangerousDepths.Bosses.TheCountOfTheCoreAchiev) == 1 then
			player:addAchievement('Death in the Depths')
			player:setStorageValue(Storage.DangerousDepths.Bosses.LastAchievement, 1)
		end
	end
	return true
end

dangerousDepthAchievements:aid(57303)
dangerousDepthAchievements:register()