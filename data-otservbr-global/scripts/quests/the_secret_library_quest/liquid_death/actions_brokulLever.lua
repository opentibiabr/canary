local transform = {
	[9110] = 9111,
	[9111] = 9110,
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

local actions_liquid_brokulLever = Action()

function actions_liquid_brokulLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local playersTable = {}
	local iPos = item:getPosition()
	local pPos = player:getPosition()

	if item.itemid == 9110 then
		for i = 1, #leverInfo do
			if iPos == leverInfo[i].leverPosition then
				local leverTable = leverInfo[i]
				if pPos == leverTable.pushPosition then
					if doCheckBossRoom(player:getId(), leverTable.bossName, leverTable.roomFromPosition, leverTable.roomToPosition) then
						for i = leverTable.leverFromPos.x, leverTable.leverToPos.x do
							local newPos = Position(i, leverTable.leverFromPos.y, leverTable.leverFromPos.z)
							local creature = Tile(newPos):getTopCreature()
							if creature and creature:isPlayer() then
								creature:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.BrokulTimer, os.time() + 20 * 60 * 60)
								creature:teleportTo(leverTable.teleportTo, true)
								creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
								table.insert(playersTable, creature:getId())
							end
						end
						local monster = Game.createMonster(leverTable.bossName, leverTable.bossPosition)
						addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, leverTable.roomFromPosition, leverTable.roomToPosition, leverTable.exitPosition)
					end
				end
			end
		end
	end

	item:transform(transform[item.itemid])

	return true
end

actions_liquid_brokulLever:aid(4901)
actions_liquid_brokulLever:register()
