local gnomesOrdnanceEnd = MoveEvent()

function gnomesOrdnanceEnd.onStepIn(creature, position, fromPosition, toPosition)
	if not creature or not creature:isMonster() then
		return true
	end

	local pos = creature:getPosition()
	local fromPos = Position(pos.x - 5, pos.y - 5, pos.z)
	local toPos = Position(pos.x + 5, pos.y + 5, pos.z)
	if creature and creature:getName():lower() == "lost gnome" then
		for x = fromPos.x, toPos.x do
			for y = fromPos.y, toPos.y do
				for z = fromPos.z, toPos.z do
					if Tile(Position(x, y, z)) then
						if Tile(Position(x, y, z)) then
							local c = Tile(Position(x, y, z)):getTopCreature()
							if c then
								if c:isPlayer() then
									if c:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) == 2 then
										if c:getStorageValue(Storage.DangerousDepths.Gnomes.GnomesCount) < 5 then
											c:setStorageValue(Storage.DangerousDepths.Gnomes.GnomesCount, c:getStorageValue(Storage.DangerousDepths.Gnomes.GnomesCount) + 1)
											c:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your escort has end.")
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
	elseif creature and creature:getName():lower() == "gnome pack crawler" then
		for x = fromPos.x, toPos.x do
			for y = fromPos.y, toPos.y do
				for z = fromPos.z, toPos.z do
					if Tile(Position(x, y, z)) then
						if Tile(Position(x, y, z)) then
							local c = Tile(Position(x, y, z)):getTopCreature()
							if c then
								if c:isPlayer() then
									if c:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) == 2 then
										if c:getStorageValue(Storage.DangerousDepths.Gnomes.CrawlersCount) < 3 then
											c:setStorageValue(Storage.DangerousDepths.Gnomes.CrawlersCount, c:getStorageValue(Storage.DangerousDepths.Gnomes.CrawlersCount) + 1)
											c:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your escort has end.")
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

gnomesOrdnanceEnd:type("stepin")
gnomesOrdnanceEnd:aid(57242)
gnomesOrdnanceEnd:register()
