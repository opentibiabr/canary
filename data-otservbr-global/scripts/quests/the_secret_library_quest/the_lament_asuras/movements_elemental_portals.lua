local entrances = {
	[1] = { position = Position(32860, 32798, 11), storage = false, toPosition = Position(32887, 32772, 9) },
	[2] = {
		position = Position(32858, 32766, 10),
		toPosition = Position(32882, 32791, 11),
		fromPos = Position(32877, 32790, 11),
		toPos = Position(32887, 32800, 11),
		exit = Position(32858, 32767, 10),
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.DiamondTimer,
		bossName = "the diamond blossom",
		bossPos = Position(32882, 32795, 11),
	},
	[3] = {
		position = Position(32818, 32780, 11),
		toPosition = Position(32857, 32740, 11),
		fromPos = Position(32852, 32739, 11),
		toPos = Position(32862, 32749, 11),
		exit = Position(32818, 32781, 11),
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.DarkTimer,
		bossName = "the lily of night",
		bossPos = Position(32857, 32744, 11),
	},
	[4] = {
		position = Position(32854, 32737, 10),
		toPosition = Position(32860, 32770, 11),
		fromPos = Position(32855, 32769, 11),
		toPos = Position(32865, 32779, 11),
		exit = Position(32854, 32738, 10),
		storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.BlazingTimer,
		bossName = "the blazing rose",
		bossPos = Position(32860, 32774, 11),
	},
}
local exits = {
	[1] = { position = Position(32857, 32739, 11), toPosition = Position(32818, 32781, 11) },
	[2] = { position = Position(32860, 32769, 11), toPosition = Position(32854, 32738, 10) },
	[3] = { position = Position(32882, 32790, 11), toPosition = Position(32858, 32767, 10) },
	[4] = { position = Position(32886, 32772, 9), toPosition = Position(32860, 32799, 11) },
	[5] = { position = Position(32881, 32829, 11), toPosition = Position(32809, 32765, 10) },
}
local defaultMessage = "You have ten minutes to kill and loot this monster, else you will lose that chance and will be kicked out."
local purplePosition = Position(32808, 32765, 10)
local quest = Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline
local toPosition_l = Position(32881, 32828, 11)
local hiddenMap1 = Position(32881, 32820, 11)
local hiddenMap2 = Position(32882, 32820, 11)

local function isPlayerInRoom(fromPos, toPos)
	for x = fromPos.x, toPos.x do
		for y = fromPos.y, toPos.y do
			for z = fromPos.z, toPos.z do
				local tile = Tile(Position(x, y, z))
				if tile then
					local creatures = tile:getCreatures()
					for _, creature in pairs(creatures) do
						if creature:isPlayer() then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

local function clearBossRoom(fromPos, toPos, exitPos)
	local spectators = Game.getSpectators(fromPos, false, false, 0, 0, 0, 0, toPos)
	for _, spec in pairs(spectators) do
		if spec:isMonster() then
			spec:remove()
		end
	end
end

local function startBattle(pid, position, b_name, middle)
	local player = Player(pid)
	if player then
		player:teleportTo(position, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say(defaultMessage, TALKTYPE_MONSTER_SAY)
		local monster = Game.createMonster(b_name, middle)
	end
end

local function expelPlayerFromRoom(cid, fromPos, toPos, exitPos)
	local player = Player(cid)
	if player then
		if player:getPosition():isInRange(fromPos, toPos) then
			player:teleportTo(exitPos)
			exitPos:sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You took too long, the battle has ended.")
		end
	end
end

local movements_asura_elemental_portals = MoveEvent()

function movements_asura_elemental_portals.onStepIn(creature, item, position, fromPosition)
	local player = Player(creature:getId())

	if not creature:isPlayer() then
		return false
	end

	if item.actionid == 4915 then
		if position == purplePosition then
			if player:getStorageValue(quest) >= 5 then
				player:teleportTo(toPosition_l)
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can not use this portal yet.")
				player:teleportTo(fromPosition, true)
			end
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
		for _, k in pairs(entrances) do
			if position == k.position then
				if isPlayerInRoom(k.fromPos, k.toPos) then
					return true
				end
				clearBossRoom(k.fromPos, k.toPos, k.exit)
				if k.storage then
					if player:getStorageValue(k.storage) < os.time() then
						startBattle(player:getId(), k.toPosition, k.bossName, k.bossPos)
						addEvent(expelPlayerFromRoom, 6000000, player:getId(), k.fromPos, k.toPos, k.exit)
						player:setStorageValue(k.storage, os.time() + (20 * 3600))
					else
						player:sendCancelMessage("You are still exhausted from your last battle.")
						player:teleportTo(fromPosition, true)
					end
				else
					player:teleportTo(k.toPosition)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		end
	elseif item.actionid == 4914 then
		if position == hiddenMap1 or hiddenMap2 then
			if player:getStorageValue(quest) == 5 then
				player:addItem(28908, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have discovered an old writing desk that contains an ancient map.")
				player:setStorageValue(quest, 6)
			end
		end
		for _, k in pairs(exits) do
			if position == k.position then
				player:teleportTo(k.toPosition)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	end

	return true
end

movements_asura_elemental_portals:aid(4914, 4915)
movements_asura_elemental_portals:register()
