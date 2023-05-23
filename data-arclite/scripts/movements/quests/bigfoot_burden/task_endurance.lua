local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 2000)
condition:setFormula(-0.9, 0, -0.9, 0)

local taskEndurance = MoveEvent()

function taskEndurance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 7816 then
		local chance = math.random(5)
		if chance == 1 then
			local chancegasp = math.random(10)
			if chancegasp == 4 then
				fromPosition:sendMagicEffect(CONST_ME_STUN)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "<gasp>")
			end
			player:teleportTo(fromPosition)
		elseif chance == 2 then
			player:teleportTo(Position(position.x, position.y + 1, position.z), true)
			player:setDirection(DIRECTION_SOUTH)
		elseif chance == 3 then
			player:teleportTo(fromPosition)
		end

	elseif item.actionid == 7817 then  --finish of the test
		player:setStorageValue(Storage.BigfootBurden.QuestLine, 18)
		player:teleportTo(Position(32760, 31811, 10))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	elseif item.actionid == 7818 then -- entrance to the test
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 17 then
			player:teleportTo(Position(32759, 31812, 11))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			local backPos = Position(32760, 31811, 10)
			player:teleportTo(backPos)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Luckily you do not have to take the endurance at this time.")
			backPos:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return true
end

taskEndurance:type("stepin")
taskEndurance:aid(7816, 7817, 7818)
taskEndurance:register()
