local positionsTable = {
	-- Hunts
	[Position(33615, 31422, 10)] = Position(34009, 31014, 9), -- hunt infernal demon
	[Position(33618, 31422, 10)] = Position(33972, 31041, 11), -- hunt rotten
	[Position(33621, 31422, 10)] = Position(33894, 31019, 8), -- hunt bony sea devil
	[Position(33624, 31422, 10)] = Position(33858, 31831, 3), -- hunt cloak
	[Position(33627, 31422, 10)] = Position(33887, 31188, 10), -- hunt many faces

	[Position(34022, 31091, 11)] = Position(33685, 31599, 14), -- goshnar's malice entrance
}

local soul_war_entrances = MoveEvent()

function soul_war_entrances.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need level 250 to enter here.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return
	end

	-- Check if player has access to teleport from Flickering Soul npc: "hi/task/yes"
	local soulWarQuest = player:soulWarQuestKV()
	if not soulWarQuest:get("teleport-access") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your soul does not yet resonate with the frequency required to enter here.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return
	end

	for position, destination in pairs(positionsTable) do
		if position == player:getPosition() then
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(destination)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			break
		end
	end

	return true
end

for key, value in pairs(positionsTable) do
	soul_war_entrances:position(key)
end

soul_war_entrances:register()

local soul_war_megalomania_entrance = MoveEvent()

function soul_war_megalomania_entrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local soulWarQuest = player:soulWarQuestKV()
	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not allowed to enter here.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end

	local text = ""
	local soulWarCount = 0
	for bossName, completed in pairs(SoulWarBosses) do
		if soulWarQuest:get(bossName) == completed then
			soulWarCount = soulWarCount + 1
		else
			text = text .. "\n" .. bossName
		end
	end

	if soulWarCount < 5 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You still need to defeat:" .. text)
		player:teleportTo(fromPosition, true)
		return false
	end

	return true
end

soul_war_megalomania_entrance:position({ x = 33611, y = 31430, z = 10 })
soul_war_megalomania_entrance:register()

local areasConfig = {
	[Position(34013, 31049, 9)] = Position(34014, 31058, 9),
	[Position(34010, 31073, 10)] = Position(34012, 31063, 10),
	[Position(34009, 31038, 11)] = Position(34012, 31047, 11),
}

local soul_war_areas_timer = MoveEvent()

function soul_war_areas_timer.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local soulWarQuest = player:soulWarQuestKV()
	for tablePosition, toPosition in pairs(areasConfig) do
		if tablePosition == position then
			player:teleportTo(toPosition)
			toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			break
		end
	end

	return true
end

for key, value in pairs(areasConfig) do
	soul_war_areas_timer:position(key)
end

soul_war_areas_timer:register()

local goshnarSpiteEntrance = MoveEvent()

function goshnarSpiteEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local soulWarQuest = player:soulWarQuestKV()
	local killCount = soulWarQuest:get("hazardous-phantom-death") or 0
	if killCount < 20 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have killed " .. killCount .. " and need to kill 20 Hazardous Phantoms")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end

	if position == SoulWarQuest.goshnarSpiteEntrancePosition.fromPos then
		player:teleportTo(SoulWarQuest.goshnarSpiteEntrancePosition.toPos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	return false
end

goshnarSpiteEntrance:position(SoulWarQuest.goshnarSpiteEntrancePosition.fromPos)
goshnarSpiteEntrance:register()
