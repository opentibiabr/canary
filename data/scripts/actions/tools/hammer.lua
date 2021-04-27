function remove01()

local wood1 = Position(32647, 32216, 7)
			local wooda = Tile(wood1):getItemById(6475)
			if wooda then
			wooda:remove()
			local woods = Game.createItem(13170, 1, { x=32647, y=32216, z=7})
			woods:setActionId(42501)
			end
    return true
end


function remove02()

local wood11 = Position(32660, 32213, 7)
			local woodaa = Tile(wood11):getItemById(6475)
			if woodaa then
			woodaa:remove()
			local woodss = Game.createItem(13170, 1, { x=32660, y=32213, z=7}) -- 32660, 32213, 7
			woodss:setActionId(42502)
			end
    return true
end

function remove03()

local wood111 = Position(32644, 32183, 6)
			local woodaaa = Tile(wood111):getItemById(6474)
			if woodaaa then
			woodaaa:remove()
			local woodsss = Game.createItem(13172, 1, { x=32644, y=32183, z=6}) -- 32660, 32213, 7
			woodsss:setActionId(42503)
			end
    return true
end

function remove04()

local wood1111 = Position(32660, 32201, 7)
			local woodaaaa = Tile(wood1111):getItemById(6474)
			if woodaaaa then
			woodaaaa:remove()
			local woodssss = Game.createItem(13171, 1, { x=32660, y=32201, z=7}) --
			woodssss:setActionId(42504)
			end
    return true
end

function remove05()

local wood11111 = Position(32652, 32200, 5)
			local woodaaaaa = Tile(wood11111):getItemById(6474)
			if woodaaaaa then
			woodaaaaa:remove()
			local woodsssss = Game.createItem(13172, 1, { x=32652, y=32200, z=5}) --
			woodsssss:setActionId(42505)
			end
    return true
end

local hammer = Action()

function hammer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	local targetActionId = target:getActionId()
	-- Lay down the wood
	if targetActionId == 50109 then
		if player:getItemCount(5901) >= 3 and player:getItemCount(8309) >= 3 then
			player:removeItem(5901, 3)
			player:removeItem(8309, 3)
			player:say("KLING KLONG!", TALKTYPE_MONSTER_SAY)

			local bridge = Game.createItem(5770, 1, Position(32571, 31508, 9))
			if bridge then
				bridge:setActionId(50110)
			end
		end

	-- Lay down the rails
	elseif targetActionId == 50110 then
		if player:getItemCount(10033) >= 1 and player:getItemCount(10034) >= 2 and player:getItemCount(8309) >= 3 then
			player:removeItem(10033, 1)
			player:removeItem(10034, 2)
			player:removeItem(8309, 3)
			player:say("KLING KLONG!", TALKTYPE_MONSTER_SAY)

			local rails = Game.createItem(7122, 1, Position(32571, 31508, 9))
			if rails then
				rails:setActionId(50111)
			end
		end

		-- ROTTIMN START
	elseif targetActionId == 42501 then
			if player:getStorageValue(41600) == 3 and player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) < 6 then

			local wood1 = Position(32647, 32216, 7)
			local wooda = Tile(wood1):getItemById(13170)
			if wooda then
			wooda:remove()
			Game.createItem(6475, 1, { x=32647, y=32216, z=7})
			addEvent(remove01, 2*60*1000)
			end

			player:setStorageValue(Storage.RottinWoodAndMaried.RottinStart, player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) +1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You fixed this broken wall.")
			else player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already fixed many broken walls today.")
			end

			-- parte 2
			elseif targetActionId == 42502 then
			if player:getStorageValue(41600) == 3 and player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) < 6 then

			local wood11 = Position(32660, 32213, 7)
			local woodaa = Tile(wood11):getItemById(13170)
			if woodaa then
			woodaa:remove()
			Game.createItem(6475, 1, { x=32660, y=32213, z=7})
			addEvent(remove02, 2*60*1000)
			end

			player:setStorageValue(Storage.RottinWoodAndMaried.RottinStart, player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) +1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You fixed this broken wall.")
			else player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already fixed many broken walls today.")
			end

			-- parte 3
			elseif targetActionId == 42503 then
			if player:getStorageValue(41600) == 3 and player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) < 6 then
			local wood111 = Position(32644, 32183, 6)
			local woodaaa = Tile(wood111):getItemById(13172)
			if woodaaa then
			woodaaa:remove()
			Game.createItem(6474, 1, { x=32644, y=32183, z=6})
			addEvent(remove03, 2*60*1000)
			end

			player:setStorageValue(Storage.RottinWoodAndMaried.RottinStart, player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) +1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You fixed this broken wall.")
			else player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already fixed many broken walls today.")
			end

			-- parte 4
			elseif targetActionId == 42504 then
			if player:getStorageValue(41600) == 3 and player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) < 6 then
			local wood1111 = Position(32660, 32201, 7)
			local woodaaaa = Tile(wood1111):getItemById(13171)
			if woodaaaa then
			woodaaaa:remove()
			Game.createItem(6474, 1, { x=32660, y=32201, z=7})
			addEvent(remove04, 2*60*1000)
			end

			player:setStorageValue(Storage.RottinWoodAndMaried.RottinStart, player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) +1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You fixed this broken wall.")
			else player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already fixed many broken walls today.")
			end

			-- parte 5
			elseif targetActionId == 42505 then
			if player:getStorageValue(41600) == 3 and player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) < 6 then
			local wood11111 = Position(32652, 32200, 5)
			local woodaaaaa = Tile(wood11111):getItemById(13172)
			if woodaaaaa then
			woodaaaaa:remove()
			Game.createItem(6474, 1, { x=32652, y=32200, z=5})
			addEvent(remove05, 2*60*1000)
			end

			player:setStorageValue(Storage.RottinWoodAndMaried.RottinStart, player:getStorageValue(Storage.RottinWoodAndMaried.RottinStart) +1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You fixed this broken wall.")
			else player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already fixed many broken walls today.")
			end


		-- ROTTIM END
	else
		return false
	end

	return true
end

hammer:id(2557)
hammer:register()
