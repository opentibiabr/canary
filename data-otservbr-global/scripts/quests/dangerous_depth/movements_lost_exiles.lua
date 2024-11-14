local lostExiles = MoveEvent()

function lostExiles.onStepIn(creature, position, fromPosition, toPosition)
	if not creature or not creature:isMonster() then
		return true
	end

	local pos = creature:getPosition()
	local fromPos = Position(pos.x - 5, pos.y - 5, pos.z)
	local toPos = Position(pos.x + 5, pos.y + 5, pos.z)
	if creature:getName():lower() == "captured dwarf" then
		for x = fromPos.x, toPos.x do
			for y = fromPos.y, toPos.y do
				for z = fromPos.z, toPos.z do
					if Tile(Position(x, y, z)) then
						if Tile(Position(x, y, z)) then
							local creature = Tile(Position(x, y, z)):getTopCreature()
							if creature then
								if creature:isPlayer() then
									if creature:getStorageValue(Storage.DangerousDepths.Dwarves.Home) == 1 then
										if creature:getStorageValue(Storage.DangerousDepths.Dwarves.Prisoners) < 3 then
											creature:setStorageValue(Storage.DangerousDepths.Dwarves.Prisoners, creature:getStorageValue(Storage.DangerousDepths.Dwarves.Prisoners) + 1)
											creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your escort has end.")
										end
									end
								end
							end
						end
					end
				end
			end
		end
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		creature:remove()
	end
	return true
end

lostExiles:type("stepin")
lostExiles:aid(57231)
lostExiles:register()
