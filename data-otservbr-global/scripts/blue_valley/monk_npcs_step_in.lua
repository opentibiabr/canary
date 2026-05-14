local targetPosition = Position(33603, 31461, 6)

local gatePositions = {
	Position(33602, 31458, 6),
	Position(33603, 31458, 6),
	Position(33604, 31458, 6),
	Position(33605, 31458, 6),
	Position(33606, 31458, 6),

	Position(33601, 31459, 6),
	Position(33602, 31459, 6),
	Position(33603, 31459, 6),
	Position(33604, 31459, 6),
	Position(33605, 31459, 6),
}

local npcMessages = {
	["Saih The Guardian"] = "Welcome",
	["Chesa The Guardian"] = "Greetings",
}

local function shouldSayMessage(pos, fromPos)
	if pos.y == 31458 then
		return fromPos.y < pos.y -- From above
	elseif pos.y == 31459 then
		return fromPos.y > pos.y -- From below
	end
	return false
end

local monkGate = MoveEvent()

function monkGate.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local isMonk = player:getVocation():getBaseId() == VOCATION.BASE_ID.MONK
	if not isMonk then
		player:teleportTo(targetPosition, true)
	end

	if isMonk and shouldSayMessage(position, fromPosition) then
		for name, msg in pairs(npcMessages) do
			local npc = Npc(name)
			if npc then
				npc:say(msg, TALKTYPE_MONSTER_SAY)
			end
		end
	end

	return true
end

for _, pos in ipairs(gatePositions) do
	monkGate:position(pos)
end

monkGate:register()
