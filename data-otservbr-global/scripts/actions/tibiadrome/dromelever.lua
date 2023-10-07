local positionLever = {
    [1] = Position(32245, 32179, 12),
    [2] = Position(32245, 32180, 12),
    [3] = Position(32245, 32181, 12),
    [4] = Position(32245, 32182, 12),
    [5] = Position(32245, 32183, 12),
}

local config = {
	specPos = {
		room = Position(32239, 32159, 12),
		range = 17,
	},
}

local function clearArena(player)
	local spectators = Game.getSpectators(config.specPos.room, false, false, config.specPos.range, config.specPos.range, config.specPos.range, config.specPos.range)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			player:sendCancelMessage('The room is occupied. Try Later!')
			return false
		else
			spectator:remove()
		end
	end
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, 'All your magic fields have been deleted.')
end

-- CleanArena = MoveEvent()

-- function CleanArena.onStepIn(player, item, position, fromPosition)
	-- clearArena(player)
-- end

CleanArena:type('stepin')
for index, value in pairs(positionLever) do
    CleanArena:position(value)
end
CleanArena:register()

ArenaLever = Action()

function ArenaLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(Storage.Tibiadrome.PlayerSession) > os.time() then
		clearArena()
end

ArenaLever:register()
