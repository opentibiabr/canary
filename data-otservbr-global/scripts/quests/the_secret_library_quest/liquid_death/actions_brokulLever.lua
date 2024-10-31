local transform = {
	[2772] = 2773,
	[2773] = 2772,
}

local leverInfo = {
	[1] = {
		bossName = "Brokul",
		bossPosition = Position(33483, 31437, 15),
		leverPosition = Position(33522, 31464, 15),
		pushPosition = Position(33522, 31465, 15),
		leverFromPos = Position(33520, 31465, 15),
		leverToPos = Position(33524, 31465, 15),
		storageTimer = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.BrokulTimer,
		teleportTo = Position(33484, 31446, 15),
		globalTimer = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.BrokulTimerGlobal,
		roomFromPosition = Position(33472, 31427, 15),
		roomToPosition = Position(33496, 31450, 15),
		exitPosition = Position(33528, 31464, 14),
	},
}

local function clearBossRoom(fromPos, toPos)
	local spectators = Game.getSpectators(fromPos, false, false, 0, 0, 0, 0, toPos)
	for _, spec in pairs(spectators) do
		if not spec:isPlayer() then
			spec:remove()
		end
	end
end

local function isBossInRoom(fromPos, toPos, bossName)
	local hasBoss = false
	local hasPlayers = false
	local spectators = Game.getSpectators(fromPos, false, false, 0, 0, 0, 0, toPos)

	for _, spec in pairs(spectators) do
		if spec:isPlayer() then
			hasPlayers = true
		elseif spec:isMonster() and spec:getName():lower() == bossName:lower() then
			hasBoss = true
		end
	end

	return hasBoss, hasPlayers
end

local actions_liquid_brokulLever = Action()

function actions_liquid_brokulLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local playersTable = {}
	local iPos = item:getPosition()
	local pPos = player:getPosition()

	if item.itemid == 2772 then
		for i = 1, #leverInfo do
			if iPos == leverInfo[i].leverPosition then
				local leverTable = leverInfo[i]
				if pPos == leverTable.pushPosition then
					local hasBoss, hasPlayers = isBossInRoom(leverTable.roomFromPosition, leverTable.roomToPosition, leverTable.bossName)

					if hasPlayers then
						player:sendCancelMessage("The room is already occupied by other players.")
						return true
					elseif hasBoss then
						clearBossRoom(leverTable.roomFromPosition, leverTable.roomToPosition)
					end

					local playerCount = 0
					for i = leverTable.leverFromPos.x, leverTable.leverToPos.x do
						local newPos = Position(i, leverTable.leverFromPos.y, leverTable.leverFromPos.z)
						local creature = Tile(newPos):getTopCreature()
						if creature and creature:isPlayer() then
							if creature:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline) >= 6 then
								playerCount = playerCount + 1
								table.insert(playersTable, creature:getId())
							else
								creature:sendCancelMessage("You are not qualified to face the boss.")
							end
						end
					end

					if playerCount < 5 then
						player:sendCancelMessage("You need 5 qualified players for this challenge.")
						return true
					end

					for _, playerId in ipairs(playersTable) do
						local creature = Creature(playerId)
						if creature then
							creature:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.BrokulTimer, os.time() + 20 * 60 * 60)
							creature:teleportTo(leverTable.teleportTo, true)
							creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						end
					end

					local monster = Game.createMonster(leverTable.bossName, leverTable.bossPosition)
					addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, leverTable.roomFromPosition, leverTable.roomToPosition, leverTable.exitPosition)
				end
			end
		end
	end

	item:transform(transform[item.itemid])
	return true
end

actions_liquid_brokulLever:aid(4901)
actions_liquid_brokulLever:register()
