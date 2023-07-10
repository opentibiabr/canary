local travel = {
	{wagon = Position(32578, 31488, 9)}, -- start
	{wagon = Position(32577, 31508, 9), destination = Position(32611, 31513, 9)}, -- bridge stage after completion
	{wagon = Position(32628, 31514, 9), destination = Position(32652, 31507, 10)}, -- rubble stage after completion
	{wagon = Position(32694, 31495, 11), destination = Position(32661, 31495, 13)}, -- from third rail
	{wagon = Position(32696, 31495, 11), destination = Position(32704, 31507, 12)}, -- from forth rail
	{wagon = Position(32599, 31505, 13), destination = Position(32604, 31338, 11)}, -- city's entrance
	{wagon = Position(32603, 31339, 11), destination = Position(32600, 31504, 13)}, -- location exit
	{wagon = Position(32700, 31452, 13), destination = Position(32604, 31338, 11)}, -- corner maze room
	{wagon = Position(32570, 31508, 9), destination = Position(32580, 31487, 9), destination2 = Position(32578, 31507, 9)}, -- bridge stage
	{wagon = Position(32615, 31514, 9), destination = Position(32580, 31487, 9), destination2 = Position(32624, 31514, 9)}, -- rubble stage
	{wagon = Position(32651, 31508, 10), destination = Position(32580, 31487, 9)}, -- broken bridge
	{wagon = Position(32633, 31508, 10), destination = Position(32580, 31487, 9)}, -- stairs
	{wagon = Position(32693, 31502, 11), destination = Position(32580, 31487, 9)},  -- wagon station
	{wagon = Position(32688, 31472, 13), destination = Position(32580, 31487, 9)},  -- maze
	{wagon = Position(32683, 31508, 10), destination = Position(32692, 31501, 11)}, -- ladder
	{wagon = Position(32662, 31496, 13), destination = Position(32692, 31501, 11)}, -- to third rail
	{wagon = Position(32703, 31506, 12), destination = Position(32692, 31501, 11)}, -- to forth rail
	{wagon = Position(32692, 31495, 11), destination = Position(32687, 31470, 13)}, -- second rail
	{wagon = Position(32548, 31408, 11), destination = Position(32687, 31470, 13)}, -- infested tavern
	{wagon = Position(32700, 31449, 15), destination = Position(32687, 31470, 13)}, -- npc tehlim
	{wagon = Position(32720, 31488, 15), destination = Position(32687, 31470, 13)}, -- troll tribe's hideout
	{wagon = Position(32688, 31471, 13), destination = Position(32687, 31470, 13)} -- maze logic
}

local checkpoint = {
	[1] = Position(32566, 31505, 9), -- start checkpoint
	[2] = Position(32611, 31513, 9), -- rubble checkpoint
	[3] = Position(32652, 31507, 10), -- view checkpoint
	[4] = Position(32692, 31501, 11), -- station checkpoint
	[5] = Position(32687, 31470, 13), -- maze checkpoint
	[6] = Position(32687, 31470, 13), -- maze checkpoint
	[7] = Position(32687, 31470, 13), -- maze checkpoint
	[8] = Position(32687, 31470, 13) -- maze checkpoint
}

local wagonposin = {
	[1] = Position(32699, 31492, 11),
	[2] = Position(32702, 31492, 11),
	[3] = Position(32705, 31492, 11),
	[4] = Position(32708, 31492, 11),
	[5] = Position(32711, 31492, 11),
	[6] = Position(32714, 31492, 11),
	[7] = Position(32717, 31492, 11)
}

local wagonposout = {
	[1] = Position(32717, 31492, 11),
	[2] = Position(32715, 31492, 11),
	[3] = Position(32712, 31492, 11),
	[4] = Position(32709, 31492, 11),
	[5] = Position(32706, 31492, 11),
	[6] = Position(32703, 31492, 11),
	[7] = Position(32700, 31492, 11),
	[8] = Position(32699, 31492, 11)
}

local wagons = Action()
function wagons.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local destinations = {
		--Coal Room
		{
			teleportPos = Position(32692, 31501, 11),
			railCheck = Tile(Position(32688, 31469, 13)):getItemById(7124)
                        and Tile(Position(32690, 31465, 13)):getItemById(7122)
		},
		--Infested Tavern
		{
			teleportPos = Position(32549, 31407, 11),
			railCheck = Tile(Position(32688, 31469, 13)):getItemById(7124)
                        and Tile(Position(32690, 31465, 13)):getItemById(7125)
                        and Tile(Position(32684, 31464, 13)):getItemById(7123)
		},
		--Beregar
		{
			teleportPos = Position(32579, 31487, 9),
			railCheck = Tile(Position(32688, 31469, 13)):getItemById(7124)
                        and Tile(Position(32690, 31465, 13)):getItemById(7125)
                        and Tile(Position(32684, 31464, 13)):getItemById(7122)
                        and Tile(Position(32682, 31455, 13)):getItemById(7124)
		},
		--NPC Tehlim
		{
			teleportPos = Position(32701, 31448, 15),
			railCheck = Tile(Position(32688, 31469, 13)):getItemById(7124)
                        and Tile(Position(32690, 31465, 13)):getItemById(7125)
                        and Tile(Position(32684, 31464, 13)):getItemById(7122)
                        and Tile(Position(32682, 31455, 13)):getItemById(7121)
                        and Tile(Position(32687, 31452, 13)):getItemById(7125)
                        and Tile(Position(32692, 31453, 13)):getItemById(7126)
		},
		--Troll tribe's hideout
		{
			teleportPos = Position(32721, 31487, 15),
			railCheck = Tile(Position(32688, 31469, 13)):getItemById(7121)
                        and Tile(Position(32692, 31459, 13)):getItemById(7123)
                        and Tile(Position(32696, 31453, 13)):getItemById(7123)
		},
		--City's Entrance
		{
			teleportPos = Position(32600, 31504, 13),
			railCheck = Tile(Position(32688, 31469, 13)):getItemById(7123)
                        and Tile(Position(32695, 31464, 13)):getItemById(7123)
		}
	}
	local getstory = player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue)
	local story = (Storage.HiddenCityOfBeregar.RoyalRescue)
	local position = (Position(32571, 31508, 9))
	local tile = Tile(position)
	local tile2 = Tile(Position(32619, 31514, 9))
	for i = 1, #travel do
		local table = travel[i]
		if fromPosition == table.wagon and player:getStorageValue(Storage.HiddenCityOfBeregar.OreWagon) == 1 then
			if travel[i] == travel[1] then
				local targetPosition = checkpoint[player:getStorageValue(story)]
				if not targetPosition then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have permission to use this yet.")
					return true
				end
				player:teleportTo(targetPosition, true)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			elseif travel[i] == travel[9] then
				if not tile:getItemById(7122) then
					player:teleportTo(table.destination)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:say("You need to build a bridge to pass the gap.", TALKTYPE_MONSTER_SAY)
					return true
				end
				player:setStorageValue(story, 2)
				player:teleportTo(table.destination2)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:say("You safely passed the gap but your bridge collapsed behind you.", TALKTYPE_MONSTER_SAY)
				tile:getItemById(7122):transform(4597)
				Game.createItem(295, 1, position):setActionId(40021)
				Game.createItem(291, 1, position)
				return true
			elseif travel[i] == travel[10] then
				if not tile2:getItemById(5709) then
					player:setStorageValue(story, 3)
					player:teleportTo(table.destination2)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:say("You safely passed the tunnel.", TALKTYPE_MONSTER_SAY)
					Game.createItem(5709, 1, Position(32619, 31514, 9)):setActionId(40028) --rubble
					local archwayItem = Tile(Position(32617, 31514, 9)):getItemById(1624)
						if archwayItem then
							archwayItem:remove()
						end
					local wallItem = Tile(Position(32617, 31513, 9)):getItemById(1272)
						if wallItem then
							wallItem:remove()
						end
					Position(32621, 31514, 9):sendMagicEffect(CONST_ME_POFF)
					Position(32622, 31514, 9):sendMagicEffect(CONST_ME_POFF)
					return true
				else
					player:teleportTo(table.destination)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:say("You need to remove rubble to safely passed the tunnel.", TALKTYPE_MONSTER_SAY)
					return true
				end
			elseif travel[i] == travel[15] then
				if getstory == 3 then
					player:setStorageValue(story, 4)
				end
				player:teleportTo(table.destination)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			elseif travel[i] == travel[18] then
				if getstory == 4 then
					player:setStorageValue(story, 5)
				end
				player:teleportTo(table.destination)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			elseif travel[i] == travel[22] then
				for i = 1, #destinations do
					local table = destinations[i]
					if table.railCheck then
						player:teleportTo(table.teleportPos)
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						return true
					end
				end
			end
			player:teleportTo(table.destination)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
		if player:getStorageValue(Storage.HiddenCityOfBeregar.OreWagon) < 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't know how to use this yet.")
			return true
		end
	end
	for i = 1, #wagonposin do
		if	fromPosition == wagonposin[i] and i < #wagonposin then
			if Tile(Position(32699, 31492, 11)):getItemById(7921) then
				return true
			end
			local wagon = Tile(wagonposin[i]):getItemById(7131)
			wagon:remove()
			wagonposin[i]:sendMagicEffect(CONST_ME_POFF)
			wagon = Game.createItem(7131, 1, wagonposin[i+1]):setActionId(40023)
			wagonposin[i+1]:sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end		
	for i = 1, #wagonposout do
		if	fromPosition == wagonposout[i] and i < #wagonposout and Tile(wagonposout[i]):getItemById(7921) then
			local wagon = Tile(wagonposout[i]):getItemById(7131)
			wagon:remove()
			wagon = Tile(wagonposout[i]):getItemById(7921)
			wagon:remove()
			wagonposout[i]:sendMagicEffect(CONST_ME_POFF)
			wagon = Game.createItem(7131, 1, wagonposout[i+1])
			wagon = Game.createItem(7921, 1, wagonposout[i+1]):setActionId(40023)
			wagonposout[i+1]:sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end
end

wagons:aid(40023)
wagons:register()
