local function filter(list, f, i)
	if i < #list then
		if f(list[i]) then
			return list[i], filter(list, f, i + 1)
		else
			return filter(list, f, i + 1)
		end
	elseif list[i] and f(list[i]) then
		return list[i]
	end
end

local function spawnBoss(inf)
	local boss = Game.createMonster(inf.boss, inf.bossResp)
	boss:registerEvent('BossWarzoneDeath')
end

local warzoneBoss = MoveEvent()

function warzoneBoss.onStepIn(creature, item, pos, fromPosition)
	if not creature:isPlayer() then
		creature:teleportTo(fromPosition)
		return false
	end

	local warzone = warzoneConfig[item:getActionId()]
	if not warzone then
		return false
	end

	if creature:getStorageValue(warzone.storage) > os.time() then
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already cleared this warzone in the last 20 hours.")
		creature:teleportTo(fromPosition)
		return false
	end

	if warzone.locked then
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Please, wait until the room is cleared. \z
		This happens 30 minutes after the last team entered.")
		creature:teleportTo(fromPosition)
		return true
	end

	creature:teleportTo(warzone.teleportTo)
	creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have half an hour to heroically defeat the \z
	" .. warzone.boss .. ". Otherwise you'll be teleported out by the gnomish emergency device." )
	return true
end

warzoneBoss:type("stepin")
warzoneBoss:aid(45700, 45701, 45702)
warzoneBoss:register()
