local configQuest = {
	["fire"] = {
		itemId = 1857,
		beginPos = Position(32748, 31488, 8),
		fromPos = Position(32737, 31489, 8),
		toPos = Position(32761, 31512, 8),
		effect = CONST_ME_HITBYFIRE,
		firstTile = Position(32750, 31508, 8),
		secondTile = Position(32746, 31469, 8),
		storageBarkless = Storage.Quest.U11_40.CultsOfTibia.Barkless.Tar,
		msgs = {
			"As you enter the tar pits, you feel the heat around you rising dramatically. Survive the heat long enough to prove worthy.", -- on enter
			"Your body is heating up, the air around you is flickering.", -- 30/60 seconds
			"The heat is now unbearable, the blood in your body feels like lava. There's almost no strength left in you - act quickly!", -- 90 seconds
			"Embrace the stigma of bad fortune. The tar does not feel so hot anymore. You passed the tar trial.", -- step on the first tile
			"Your body reacts to this strange green substance as you reach out to touch it. You feel an urge for more of this energy.", -- step on the second tile
			"The tar covering you has cooled down and fell off for the most part. Your body is not heated up anymore.", -- didn't step in time
		},
	},
	["acid"] = {
		itemId = 4406,
		beginPos = Position(32693, 31478, 8),
		fromPos = Position(32647, 31479, 8),
		toPos = Position(32710, 31519, 8),
		effect = CONST_ME_YELLOW_RINGS,
		firstTile = Position(32680, 31485, 8),
		secondTile = Position(32664, 31504, 8),
		storageBarkless = Storage.Quest.U11_40.CultsOfTibia.Barkless.Sulphur,
		msgs = {
			"As you enter the sulphur pits, you feel the dry, burning vapours of the sulphur all around you. Prove worthy, survive the acid.", -- on enter
			"The sulphur is burning your skin. You almost feel your body melting away in acid.", -- 30/60 seconds
			"The acid burning is now unbearable, your skin feels like a sieve. There's almost no strength left in you - act quickly!", -- 90 seconds
			"Embrace the stigma of vanity. The sulphur does not burn your skin anymore. You passed the trial.", -- step on the first tile
			"You are now ready to prove your worth. Take heart and cross the threshold of sulphur.", -- step on the second tile
			"The acid covering you has cooled down and fell off for the most part. Your body is not heated up anymore.", -- didn't step in time
		},
	},
}

local function sendConditionCults(playerId, _type, fromPos, toPos, time)
	local player = Player(playerId)
	if not player or not player:getPosition():isInRange(fromPos, toPos) then
		return false
	end

	local info = configQuest[_type]
	time = time + 2
	if time == 30 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[2])
	elseif time == 60 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[2])
	elseif time >= 90 then
		local stage = player:getStorageValue(info.storageBarkless) < 0 and 0 or player:getStorageValue(info.storageBarkless)
		if stage < 3 and stage ~= 1 and stage ~= 2 then
			if _type == "acid" and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Tar) ~= 3 then
				return true
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[3])
			player:setStorageValue(info.storageBarkless, 1)
			if _type == "fire" then
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.TarAccessDoor, 1)
			elseif _type == "acid" then
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.SulphurAccessDoor, 1)
			end
		end
	end
	player:getPosition():sendMagicEffect(info.effect)
	addEvent(sendConditionCults, 2000, playerId, _type, fromPos, toPos, time)
end

function passageFloor1ToFloor2(playerId, info, time)
	local player = Player(playerId)
	if not player then
		return true
	end
	local stage = player:getStorageValue(info.storageBarkless) < 0 and 0 or player:getStorageValue(info.storageBarkless)
	if time == 0 and stage < 3 then
		player:setStorageValue(info.storageBarkless, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[6])
		return true
	end
	if stage == 3 then
		return true
	end
	addEvent(passageFloor1ToFloor2, 1000, playerId, info, time - 1)
end

local tar = MoveEvent()

function tar.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for index, value in pairs(configQuest) do
		if item:getId() == value.itemId and fromPosition:compare(value.beginPos) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.msgs[1])
			sendConditionCults(player:getId(), index, value.fromPos, value.toPos, 0)
			return true
		elseif position:compare(value.firstTile) and player:getStorageValue(value.storageBarkless) == 1 then
			player:setStorageValue(value.storageBarkless, 2)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.msgs[4])
			passageFloor1ToFloor2(player:getId(), value, 60)
		elseif position:compare(value.secondTile) then
			if player:getStorageValue(value.storageBarkless) == 2 then
				player:setStorageValue(value.storageBarkless, 3)
				if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Sulphur) == 3 and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Tar) == 3 then
					player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Mission, 2)
				end
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.msgs[5])
			end
		end
	end
	return true
end

tar:type("stepin")
tar:aid(5530, 5531)
tar:register()

tar = MoveEvent()

function tar.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item:getActionId() == 5531 then
		if fromPosition.x == 32736 then
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Tar) < 3 then
				player:teleportTo(Position(32737, 31451, 8), true)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not ready yet.")
				return false
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You traverse the tar unharmed.")
		end
	end
	if item:getActionId() == 5530 then
		if fromPosition.x == 32717 then
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Sulphur) < 3 then
				player:teleportTo(Position(32718, 31444, 8), true)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not ready yet.")
				return false
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You traverse the sulphur unharmed.")
		end
	end
	return true
end

tar:type("stepout")
tar:aid(5530, 5531)
tar:register()
