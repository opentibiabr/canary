-- The Rookie Guard Quest

-- Handle avoid spam (message and arrow) in mission tiles
function isTutorialNotificationDelayed(player)
	-- Check delay
	if player:getStorageValue(Storage.TheRookieGuard.TutorialDelay) - os.time() <= 0 then
		-- Reset delay
		player:setStorageValue(Storage.TheRookieGuard.TutorialDelay, os.time() + 4)
		return false
	end
	return true
end

-- Missions shared tiles (Handled together due not possible more than one MoveEvent per action id)

local missionTiles = {
	-- North exit
	[50312] = {
		{
			mission = Storage.TheRookieGuard.Mission02,
			states = {1, 2, 3, 4},
			message = "This road is the main access of the village. You might want to finish your business here first."
		},
		{
			mission = Storage.TheRookieGuard.Mission03,
			states = {1},
			message = "This road is the main access of the village. You might want to finish your business here first."
		}
	},
	-- North bridge exit
	[50319] = {
		{
			mission = Storage.TheRookieGuard.Mission04,
			states = {2},
			message = "Follow the path to the east to find Hyacinth's little house.",
			arrowPosition = {x = 32096, y = 32169, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission06,
			states = {2},
			message = "Follow the path east, and when it splits, head north-east to find the wolf forest.",
			arrowPosition = {x = 32094, y = 32169, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission09,
			states = {1},
			message = "Follow the path to the north past the hill to reach the troll caves.",
			arrowPosition = {x = 32091, y = 32166, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission10,
			states = {1},
			extra = {
				storage = Storage.TheRookieGuard.Sarcophagus,
				state = -1
			},
			message = "Follow the way to the east and go south to reach the graveyard.",
			arrowPosition = {x = 32095, y = 32169, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission11,
			states = {1},
			message = "To reach the wasps' nests follow the path to the north and cross the bridge to the west as if you wanted to reach the spiders.",
			arrowPosition = {x = 32090, y = 32165, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission12,
			states = {2},
			extra = {
				storage = Storage.TheRookieGuard.AcademyChest,
				state = 1
			},
			message = "Follow the path to the north, cross the bridge to the south and walk west to reach the orc fortress.",
			arrowPosition = {x = 32091, y = 32166, z = 7}
		}
	},
	[50321] = {
		{
			mission = Storage.TheRookieGuard.Mission04,
			states = {2},
			message = "This is not the way to Hyacinth. Stay on the path a little more to the south to find Hyacinth's little house."
		},
		{
			mission = Storage.TheRookieGuard.Mission10,
			states = {1},
			extra = {
				storage = Storage.TheRookieGuard.Sarcophagus,
				state = -1
			},
			message = "This is not the way to the crypt. Go south to reach the graveyard."
		}
	},
	-- Outer east
	[50323] = {
		{
			mission = Storage.TheRookieGuard.Mission05,
			states = {1},
			message = "This is not the way to the tarantula's lair. Head northwest and go up the little ramp."
		},
		{
			mission = Storage.TheRookieGuard.Mission09,
			states = {1},
			message = "This is not the way to the troll caves. Follow the path to the north past the hill to reach them.",
			arrowPosition = {x = 32091, y = 32166, z = 7}
		}
	},
	-- North-west drawbridge
	[50325] = {
		{
			mission = Storage.TheRookieGuard.Mission05,
			states = {1},
			message = "Walk to the north and down the stairs to reach the tarantula's lair.",
			arrowPosition = {x = 32069, y = 32145, z = 6}
		},
		{
			mission = Storage.TheRookieGuard.Mission11,
			states = {1},
			message = "Take the southern stairs down the bridge to go to the wasps' lair.",
			arrowPosition = {x = 32068, y = 32149, z = 6}
		}
	},
	-- Academy entrance
	[50335] = {
		{
			mission = Storage.TheRookieGuard.Mission07,
			states = {1},
			extra = {
				storage = Storage.TheRookieGuard.LibraryChest,
				state = -1
			},
			message = "The library vault is below the academy. Go north and head down several stairs until you find a quest door.",
			arrowPosition = {x = 32097, y = 32197, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission08,
			states = {1},
			message = "The bank is below the academy. Go north and head down the stairs and to the right.",
			arrowPosition = {x = 32097, y = 32197, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission12,
			states = {1},
			extra = {
				storage = Storage.TheRookieGuard.AcademyChest,
				state = -1
			},
			message = "You don't have the bag with the items yet. Open the door in the basement of the academy to the left of Paulie to get them!",
			arrowPosition = {x = 32097, y = 32197, z = 7}
		}
	},
	-- Academy downstairs
	[50336] = {
		{
			mission = Storage.TheRookieGuard.Mission07,
			states = {1},
			extra = {
				storage = Storage.TheRookieGuard.LibraryChest,
				state = -1
			},
			message = "Head through the northern door and follow the hallways to find the library vault.",
			arrowPosition = {x = 32095, y = 32188, z = 8}
		},
		{
			mission = Storage.TheRookieGuard.Mission08,
			states = {1},
			message = "Go to the right to find the bank and talk to Paulie.",
			arrowPosition = {x = 32100, y = 32191, z = 8}
		}
	},
	-- North-west drawbridge south downstairs
	[50351] = {
		{
			mission = Storage.TheRookieGuard.Mission11,
			states = {1},
			message = "Follow the path to the west to find the wasps' lair.",
			arrowPosition = {x = 32063, y = 32159, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission12,
			states = {2},
			extra = {
				storage = Storage.TheRookieGuard.AcademyChest,
				state = 1
			},
			message = "Follow the path to the west to reach the orc fortress.",
			arrowPosition = {x = 32063, y = 32159, z = 7}
		}
	},
	-- Orc land entrance
	[50352] = {
		{
			mission = Storage.TheRookieGuard.Mission11,
			states = {1},
			message = "This is not the way to the wasps' lair. Choose the northern path to reach it.",
			arrowPosition = {x = 32003, y = 32148, z = 7}
		},
		{
			mission = Storage.TheRookieGuard.Mission12,
			states = {2},
			extra = {
				storage = Storage.TheRookieGuard.AcademyChest,
				state = 1
			},
			message = "You're entering orcland."
		}
	}
}

-- Missions tutorial tiles

local missionGuide = MoveEvent()

function missionGuide.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local tile = missionTiles[item.actionid]
	-- Check mission cases for the tile
	for i = 1, #tile do
		local missionState = player:getStorageValue(tile[i].mission)
		local extraState = tile[i].extra == nil or player:getStorageValue(tile[i].extra.storage) == tile[i].extra.state
		-- Check if the tile is active
		if missionState ~= -1 and table.find(tile[i].states, missionState) and extraState then
			-- Check delayed notifications (message/arrow)
			if not isTutorialNotificationDelayed(player) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tile[i].message)
				if tile[i].arrowPosition then
					Position(tile[i].arrowPosition):sendMagicEffect(CONST_ME_TUTORIALARROW)
				end
			end
			break
		end
	end
	return true
end

for index, value in pairs(missionTiles) do
	missionGuide:aid(index)
end
missionGuide:register()
