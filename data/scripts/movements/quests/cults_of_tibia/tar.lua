local configQuest = {
	["fire"] = {
		itidCount = 3613,
		beginPos = Position(32748, 31488, 8),
		fromPos = Position(32737, 31489, 8),
		toPos = Position(32761, 31512, 8),
		effect = CONST_ME_HITBYFIRE,
		firstSqm = Position(32750, 31508, 8),
		secondSqm = Position(32746, 31469, 8),
		storageBarkless = Storage.CultsOfTibia.Barkless.Tar,
		msgs = {
			"As you enter the tar pits, you feel the heat around you rising dramatically. \z
			Survive the heat long enough to prove worthy.", -- on enter
			"Your body is heating up, the air around you is flickering.", -- 30/60 seconds
			"The heat is now unbearable, the blood in your body feels like lava. \z
			There's almost no strength left in you - act quickly!", -- 90 segunds
			"Embrace the stigma of bad fortune. The tar does not feel so hot anymore. \z
			You passed the tar trial.", -- step in the first tile
			"Your body reacts to this strange green substance as you reach out to touch it. \z
			You feel an urge for more of this energy.", -- step in the second tile
			"The tar covering you has cooled down and tell off for the most part. \z
			Your body is not heated up anymore.", -- there's no time to step
		}
	},
	["acid"] = {
		itidCount = 4417,
		beginPos = Position(32693, 31478, 8),
		fromPos = Position(32647, 31479, 8),
		toPos = Position(32710, 31519, 8),
		effect = CONST_ME_YELLOW_RINGS,
		firstSqm = Position(32680, 31485, 8),
		secondSqm = Position(32664, 31504, 8),
		storageBarkless = Storage.CultsOfTibia.Barkless.sulphur,
		msgs = {
			"As you enter the sulphur pits, you feel the dry, burning vapours of the sulphur all around you. Prove worthy, survive the acid.", -- on enter
			"The sulphur is burning your skin. You almost feel your body melting away in acid.", -- 30/60 segunds
			"The acid burning is now unbearable, you skin feels like a sieve. \z
			]There's almost no strength left in you - act quickly!", -- 90 segunds
			"Embrace the stigma of vanity. The sulphur does not burn your skin anymore. \z
			You passed the trial.", -- step in the first tile
			"You are now ready to prove your worth. \z
			Take heart and cross the threshold of sulphur.", -- step in the second tile
			"The acid covering you has cooled down and tell off for the most part. \z
			Your body is not heated up anymore.", --  there's no time to step
		}
	},
}

function sendConditionCults(playerid, _type, fromPos, toPos, tempo)
	local player = Player(playerid)
	if not player or not player:getPosition():isInRange(fromPos, toPos) then
		return false
	end

	local inf = configQuest[_type]
	tempo = tempo + 2
	if tempo == 30 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, inf.msgs[2])
	elseif tempo == 60 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, inf.msgs[2])
	elseif tempo >= 90 then
		local stg = player:getStorageValue(inf.storageBarkless) < 0 and 0 or player:getStorageValue(inf.storageBarkless)
		if stg < 3 and stg ~= 1 and stg ~= 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, inf.msgs[3])
			player:setStorageValue(inf.storageBarkless, 1)
		end
	end
	player:getPosition():sendMagicEffect(inf.effect)
	addEvent(sendConditionCults, 2000, playerid, _type, fromPos, toPos, tempo)
end

function passagemPiso1Piso2(playerid, info, tempo)
	local player = Player(playerid)
	if not player then
		return true
	end
	local stg = player:getStorageValue(info.storageBarkless) < 0 and 0 or player:getStorageValue(info.storageBarkless)
	if tempo == 0 and stg < 3 then
		player:setStorageValue(info.storageBarkless, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[6])
		return true
	end
	if stg == 3 then
		return true
	end
	addEvent(passagemPiso1Piso2, 1000, playerid, info, tempo - 1)
end

local tar = MoveEvent()

function tar.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for index, value in pairs(configQuest)do
		if item:getId() == value.itidCount and fromPosition:compare(value.beginPos) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.msgs[1])
			sendConditionCults(player:getId(), index, value.fromPos, value.toPos, 0)
			return true
		elseif position:compare(value.firstSqm) and player:getStorageValue(value.storageBarkless) == 1 then
			if player:getStorageValue(value.storageBarkless) ~= 1 then
				return true
			end
			player:setStorageValue(value.storageBarkless, 2)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.msgs[4])
			passagemPiso1Piso2(player:getId(), value, 60)
		elseif position:compare(value.secondSqm) then
			if player:getStorageValue(value.storageBarkless) == 2 then
				player:setStorageValue(value.storageBarkless, 3)
				if player:getStorageValue(Storage.CultsOfTibia.Barkless.sulphur) == 3 and
				player:getStorageValue(Storage.CultsOfTibia.Barkless.Tar) == 3 then
					player:setStorageValue(Storage.CultsOfTibia.Barkless.Mission, 2)
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
			if player:getStorageValue(Storage.CultsOfTibia.Barkless.Tar) < 3 then
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
			if player:getStorageValue(Storage.CultsOfTibia.Barkless.sulphur) < 3 then
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
