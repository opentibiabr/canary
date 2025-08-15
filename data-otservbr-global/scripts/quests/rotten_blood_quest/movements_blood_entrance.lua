local config = {
	entrance = Position(32953, 32398, 9),
	noAccess = Position(32955, 32398, 9),
	destination = Position(34070, 31975, 14),
}

local function getDamage(currentHealth)
	local damage = math.max(math.floor(currentHealth * 0.20), 1)
	local newHealth = currentHealth - damage
	return newHealth > 10 and damage or 0
end

local accessBlood = MoveEvent()
function accessBlood.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 250 to enter.")
		player:teleportTo(fromPosition, true)
		return false
	end

	local access = player:kv():scoped("rotten-blood-quest"):get("access") or 0
	if access < 4 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You offerings to this sanguine master of this realm have been insufficient. You can not pass.")
		player:teleportTo(config.noAccess, true)
		player:addHealth(-getDamage(player:getHealth()), COMBAT_PHYSICALDAMAGE)
		return false
	end

	if config.entrance == position then
		player:teleportTo(config.destination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

accessBlood:type("stepin")
accessBlood:position(config.entrance)
accessBlood:register()

----------- Leave from Rotten -----------
local leaveBlood = MoveEvent()
function leaveBlood.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:teleportTo(Position(32955, 32398, 9))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

leaveBlood:type("stepin")
leaveBlood:position(Position(34070, 31974, 14))
leaveBlood:register()
