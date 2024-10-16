local raxias = {
	position = Position(33465, 32157, 7),
	fromPos = Position(33454, 32151, 8),
	toPos = Position(33477, 32171, 8),
	storage = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.RaxiasTimer,
	exit = Position(33462, 32159, 7),
	toPosition = Position(33466, 32156, 8),
	bossName = "Raxias",
	bossPos = Position(33466, 32161, 8),
}

local turtle = {
	fromPosition = Position(32460, 32928, 7),
	toPosition = Position(32316, 32701, 7),
	storageTimer = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Turtle,
}

local svargrond = {
	fromPosition = Position(32119, 31734, 7),
	toPosition = Position(32127, 31665, 7),
}

local defaultMessage = "You have ten minutes to kill and loot this monster, else you will lose that chance and will be kicked out."

local function resetRoom(position)
	local spec = Game.getSpectators(position, false, false, 5, 5, 5, 5)
	for _, c in pairs(spec) do
		if c and c:isPlayer() then
			return false
		end
	end

	for _, c in pairs(spec) do
		if c then
			c:remove()
		end
	end

	return true
end

local function startBattle(pid, position, b_name, middle)
	local player = Player(pid)

	if player then
		player:teleportTo(position)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say(defaultMessage, TALKTYPE_MONSTER_SAY)
		local monster = Game.createMonster(b_name, middle)
	end
end

local movements_isle_stepIn = MoveEvent()

function movements_isle_stepIn.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local player = Player(creature:getId())

	if position == turtle.fromPosition then
		if Game.getStorageValue(turtle.storageTimer) > os.time() then
			player:teleportTo(turtle.toPosition)
		else
			player:say("The turtle is hungry... You must feed it.", TALKTYPE_MONSTER_SAY)
			player:teleportTo(fromPosition, true)
		end
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	elseif position == svargrond.fromPosition then
		player:teleportTo(svargrond.toPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	elseif position == raxias.position then
		if resetRoom(raxias.bossPos) then
			if player:getStorageValue(raxias.storage) < os.time() then
				startBattle(player:getId(), raxias.toPosition, raxias.bossName, raxias.bossPos)
				player:setStorageValue(raxias.storage, os.time() + 20 * 60 * 60)
				addEvent(function(cid)
					local p = Player(cid)
					if p then
						if p:getPosition():isInRange(raxias.fromPos, raxias.toPos) then
							p:teleportTo(raxias.exit)
						end
					end
				end, 10 * 1000 * 60, player:getId())
			else
				player:sendCancelMessage("You are still exhausted from your last battle.")
				player:teleportTo(fromPosition, true)
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wait. Someone is challenging " .. raxias.bossName .. " now.")
			player:teleportTo(fromPosition, true)
		end
	end

	return true
end

movements_isle_stepIn:aid(4935)
movements_isle_stepIn:register()
