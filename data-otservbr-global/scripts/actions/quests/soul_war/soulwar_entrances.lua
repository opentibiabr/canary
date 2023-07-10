local config = {
	{position = {x = 33615, y = 31422, z = 10}, destination = {x = 34009, y = 31014, z = 9}},  -- hunt infernal demon
	{position = {x = 33618, y = 31422, z = 10}, destination = {x = 33972, y = 31041, z = 11}}, -- hunt rotten
	{position = {x = 33621, y = 31422, z = 10}, destination = {x = 33894, y = 31019, z = 8}},  -- hunt bony sea devil
	{position = {x = 33624, y = 31422, z = 10}, destination = {x = 33858, y = 31831, z = 3}},  -- hunt cloak
	{position = {x = 33627, y = 31422, z = 10}, destination = {x = 33887, y = 31188, z = 10}}, -- hunt many faces
	{position = {x = 33950, y = 31109, z = 8}, destination = {x = 33780, y = 31634, z = 14}}, -- goshnar's spite entrance
	{position = {x = 33937, y = 31217, z = 11}, destination = {x = 33782, y = 31665, z = 14}}, -- goshnar's greed entrance
	{position = {x = 34022, y = 31091, z = 11}, destination = {x = 33685, y = 31599, z = 14}}, -- goshnar's malice entrance
	{position = {x = 33856, y = 31884, z = 5}, destination = {x = 33857, y = 31865, z = 6}},  -- goshnar's cruelty entrance
	{position = {x = 33889, y = 31873, z = 3}, destination = {x = 33830, y = 31881, z = 4}},  -- 1st to 2nd floor cloak
	{position = {x = 33829, y = 31880, z = 4}, destination = {x = 33856, y = 31890, z = 5}}  -- 2nd to 3rd floor cloak
	}	
	
local portal = {position = {x = 33914, y = 31032, z = 12}, destination = {x = 33780, y = 31601, z = 14}} -- goshnar's hatred entrance

local soulWarEntrances = MoveEvent()
function soulWarEntrances.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 250 to enter.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	for value in pairs(config) do
		if Position(config[value].position) == player:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

soulWarEntrances:type("stepin")
for value in pairs(config) do
	soulWarEntrances:position(config[value].position)
end
soulWarEntrances:register()

local portalHatred = Action()
function portalHatred.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 250 to enter.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	doSendMagicEffect(item:getPosition(), CONST_ME_TELEPORT)
	player:teleportTo(Position(portal.destination))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)		
	return true
end

portalHatred:position(portal.position)
portalHatred:register()
