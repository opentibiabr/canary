-- Set to which position items are teleported for each teleport item
-- If no position is set they will not be teleported anywhere
--[[
	[aid] = {destination = Postion(), effect = CONST_ME__}
]]

ItemTeleports = {
	[5630] = {destination = Position(33145, 32863, 7), effect = CONST_ME_MAGIC_GREEN},
	[5631] = {destination = Position(33147, 32864, 7), effect = CONST_ME_MAGIC_GREEN},

	-- Rookgaard level bridge
	[50240] = {destination = Position(32092, 32177, 6), effect = CONST_ME_MAGIC_BLUE},
	-- Rookgaard premium bridge
	[50241] = {destination = Position(32066, 32192, 7), effect = CONST_ME_MAGIC_BLUE}
}
