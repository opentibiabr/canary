local gravediggerSacrifice = Action()
function gravediggerSacrifice.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission74) == 1 then --and player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) < 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission74) < 1 then
		local skullItem = Tile(Position(33015, 32418, 11)):getItemById(21476)
		if skullItem then
			skullItem:remove()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The scroll burns to dust. The magic stutters. Omrabas\' soul flees to his old hideaway.')
			player:removeItem(21251, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission74, 1)
			Game.createMonster("Chicken", Position(33015, 32418, 11))
		end
		else player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Teste')
	end
	return true
end

gravediggerSacrifice:id(21251)
gravediggerSacrifice:register()

-- SE DER RUIM AI EM CIMA, COLOCAR ESSE:

--function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	--if player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) == 1 then --and player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) < 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission74) < 1 then
		--local skullItem = Tile(Position(33015, 32418, 11)):getItemById(21476)
		--if skullItem then
		--	skullItem:remove()
		--	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The scroll burns to dust. The magic stutters. Omrabas\' soul flees to his old hideaway.')
		--	player:removeItem(21251, 1)
			--player:setStorageValue(Storage.GravediggerOfDrefia.Mission73, 1)
		--	Game.createMonster("Chicken", Position(33015, 32418, 11))
		--end
		--else player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Teste')
	--end
	--return true
--end
