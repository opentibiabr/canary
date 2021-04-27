local config = {
	leverTime = 15 * 60,
	leverPositions = {
		Position(32891, 32590, 11),
		Position(32843, 32649, 11),
		Position(32808, 32613, 11),
		Position(32775, 32583, 11),
		Position(32756, 32494, 11),
		Position(32799, 32556, 11)
	},

	gateLevers = {
		{position = Position(32862, 32555, 11), duration = 15 * 60, ignoreLevers = true},
		{position = Position(32862, 32557, 11), duration = 60, ignoreLevers = true}
	},

	walls = {
		{position = Position(32864, 32556, 11), itemId = 3474}
	}
}

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

local function revertWalls(leverPosition)
	revertLever(leverPosition)

	for i = 1, #config.walls do
		Game.createItem(config.walls[i].itemId, 1, config.walls[i].position)
	end
end

local theApeMiss9 = Action()
function theApeMiss9.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		player:sendTextMessage(MESSAGE_FAILURE, 'It doesn\'t move.')
		return true
	end

	if isInArray(config.leverPositions, toPosition) then
		item:transform(1946)
		addEvent(revertLever, config.leverTime * 1000, toPosition)
		return true
	end

	local gateLever
	for i = 1, #config.gateLevers do
		if toPosition == config.gateLevers[i].position then
			gateLever = config.gateLevers[i]
			break
		end
	end

	if not gateLever then
		return true
	end

	if not gateLever.ignoreLevers then
		for i = 1, #config.leverPositions do
			-- if lever not pushed, do not continue
			local leverItem = Tile(config.leverPositions[i]):getItemById(1946)
			if not leverItem then
				return false
			end
		end
	end

	-- open gate when all levers used
	for i = 1, #config.walls do
		local wallItem = Tile(config.walls[i].position):getItemById(config.walls[i].itemId)
		if not wallItem then
			player:say('The lever won\'t budge', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
			return true
		end

		wallItem:remove()
		config.walls[i].position:sendMagicEffect(CONST_ME_MAGIC_RED)
	end

	addEvent(revertWalls, gateLever.duration * 1000, toPosition)
	item:transform(1946)
	return true
end

theApeMiss9:uid(1040, 1041)
theApeMiss9:register()