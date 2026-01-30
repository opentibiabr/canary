local config = {
	boss = {
		name = "The Unwelcome",
		createFunction = function()
			local pos1 = Position(33705, 31539, 14)
			local pos2 = Position(33708, 31539, 14)

			-- Spawn The Unwelcome immediately
			local theUnwelcome = Game.createMonster("The Unwelcome", pos2)
			if not theUnwelcome then
				print("Failed to spawn The Unwelcome.")
				return
			end

			local id = os.time()
			theUnwelcome:beginSharedLife(id)
			theUnwelcome:registerEvent("SharedLife")
			pos2:sendMagicEffect(CONST_ME_TELEPORT)

			-- Delay Brother Worm spawn by 20 seconds (20000 ms)
			addEvent(function()
				local brotherWorm = Game.createMonster("Brother Worm", pos1)
				if not brotherWorm then
					print("Failed to spawn Brother Worm.")
					return
				end

				local id = os.time()
				brotherWorm:beginSharedLife(id)
				brotherWorm:registerEvent("SharedLife")
				pos1:sendMagicEffect(CONST_ME_TELEPORT)
			end, 20000)
			return true
		end,
	},
	timeToFightAgain = 20 * 60 * 60, -- 20 hours
	requiredLevel = 250,
	playerPositions = {
		{ pos = Position(33736, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33737, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33738, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33739, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33740, 31537, 14), teleport = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33699, 31529, 14),
		to = Position(33719, 31546, 14),
	},
	exit = Position(33611, 31528, 10),
}

local lever = BossLever(config)
lever:position(Position(33735, 31537, 14))
lever:register()
