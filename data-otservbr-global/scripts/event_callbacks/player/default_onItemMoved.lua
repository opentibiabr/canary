local ec = EventCallback

function ec.onItemMoved(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if IsRunningGlobalDatapack() then
		-- Cults of Tibia begin
		local frompos = Position(33023, 31904, 14) -- Checagem
		local topos = Position(33052, 31932, 15) -- Checagem
		local removeItem = false
		if player:getPosition():isInRange(frompos, topos) and item:getId() == 23729 then
			local tileBoss = Tile(toPosition)
			if tileBoss and tileBoss:getTopCreature() and tileBoss:getTopCreature():isMonster() then
				if tileBoss:getTopCreature():getName():lower() == 'the remorseless corruptor' then
					tileBoss:getTopCreature():addHealth(-17000)
					tileBoss:getTopCreature():remove()
					local monster = Game.createMonster('The Corruptor of Souls', toPosition)
					if not monster then
						return
					end
					removeItem = true
					monster:registerEvent('CheckTile')
					if Game.getStorageValue('healthSoul') > 0 then
						monster:addHealth(-(monster:getHealth() - Game.getStorageValue('healthSoul')))
					end
					Game.setStorageValue('CheckTile', os.time()+30)
				elseif tileBoss:getTopCreature():getName():lower() == 'the corruptor of souls' then
					Game.setStorageValue('CheckTile', os.time()+30)
					removeItem = true
				end
			end
			if removeItem then
				item:remove(1)
			end
		end
		-- Cults of Tibia end
	end
end

ec:register(--[[0]])
