local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 22000)
condition:setFormula(0.7, -56, 0.7, -56)

local strangelyGlowingMark = MoveEvent()

function strangelyGlowingMark.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.itemid == 24732 then
		if player:getStorageValue(199990) >= os.time() then
			return true
		end
		player:addHealth(200, true, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mythic fires beneath your feet heal you.")
		player:setStorageValue(199990, os.time() + 60)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	elseif item.itemid == 24733 then
		if player:getStorageValue(199991) >= os.time() then
			return true
		end
		player:addCondition(condition)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:setStorageValue(199991, os.time() + 60)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mythic fires beneath your feet gave you speed.")
	end
	return true
end

strangelyGlowingMark:type("stepin")
strangelyGlowingMark:id(24732, 24733)
strangelyGlowingMark:register()
