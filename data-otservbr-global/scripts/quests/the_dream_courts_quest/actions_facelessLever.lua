local transform = {
	[9110] = 9111,
	[9111] = 9110
}

local leverInfo = {
	[1] = {
		bossName = "Faceless Bane",
		bossPosition = Position(33617, 32561, 13),
		leverPosition = Position(33637, 32562, 13),
		pushPosition = Position(33638, 32562, 13),
		leverFromPos = Position(33638, 32562, 13),
		leverToPos = Position(33642, 32562, 13),
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.facelessTimer,
		roomFromPosition = Position(33606, 32552, 13),
		roomToPosition = Position(33631, 32572, 13),
		teleportTo = Position(33617, 32567, 13),
		typePush = "x",
		exitPosition = Position(33619, 32522, 15),
		globalTimer = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.facelessTimer
	},
}

local actions_facelessLever = Action()

function actions_facelessLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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
						if leverTable.typePush == "x" then
							for i = leverTable.leverFromPos.x, leverTable.leverToPos.x do
								local newPos = Position(i, leverTable.leverFromPos.y, leverTable.leverFromPos.z)
								local creature = Tile(newPos):getTopCreature()

								if creature and creature:isPlayer() then
									creature:teleportTo(leverTable.teleportTo)
									creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
									creature:setStorageValue(leverInfo.storageTimer, os.time() + 20*60*60)
									table.insert(playersTable, creature:getId())
								end
							end
						elseif leverTable.typePush == "y" then
							for i = leverTable.leverFromPos.y, leverTable.leverToPos.y do

								local newPos = Position(leverTable.leverFromPos.x, i, leverTable.leverFromPos.z)
								local creature = Tile(newPos):getTopCreature()

								if creature and creature:isPlayer() then
									creature:teleportTo(leverTable.teleportTo)
									creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
									creature:setStorageValue(leverInfo.storageTimer, os.time() + 20*60*60)
									table.insert(playersTable, creature:getId())
								end
							end
						end

						local monster = Game.createMonster(leverTable.bossName, leverTable.bossPosition, true, true)

						if monster then
							if leverTable.bossName:lower() == "faceless bane" then
								monster:registerEvent("facelessThink")
								Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.facelessTiles, 0)
							end

							monster:registerEvent("dreamCourtsDeath")
						end

						addEvent(kickPlayersAfterTime, 30*60*1000, playersTable, leverTable.roomFromPosition, leverTable.roomToPosition, leverTable.exitPosition)
					end
				end
			end
		end
	end

	item:transform(transform[item.itemid])

	return true
end

actions_facelessLever:aid(23110)
actions_facelessLever:register()
