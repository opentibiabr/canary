local config = {
	scope = "dungeon-entrance",
	entrance = Position(1073, 1308, 11),
	destination = Position(1073, 1278, 11),
	noAccess = DungeonConfig.hurakExit,
	timeToEnterAgain = 20, -- minutes
}

local function canEnterDungeon(player)
	local cooldown = player:kv():scoped(config.scope):get("cooldown") or 0
	return cooldown <= os.time()
end

------------------ Player enter in Dungeon ------------------

local dungeonEntrance = MoveEvent()
function dungeonEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if not canEnterDungeon(player) and player:getGroup():getId() < GROUP_TYPE_GAMEMASTER then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait " .. config.timeToEnterAgain .. " minutes to face this Dungeon again!")
		player:teleportTo(config.noAccess)
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
		return true
	end
	player:kv():scoped(config.scope):set("cooldown", os.time() + config.timeToEnterAgain * 60)

	return true
end

dungeonEntrance:type("stepin")
dungeonEntrance:position(config.entrance)
dungeonEntrance:register()
