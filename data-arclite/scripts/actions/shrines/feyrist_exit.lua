local backPositions = {
	{ actionId = 24999, toPos = Position(32972, 32227, 7), effect = CONST_ME_SMALLPLANTS },
	{ actionId = 25000, toPos = Position(32192, 31419, 2), effect = CONST_ME_ICEATTACK },
	{ actionId = 25001, toPos = Position(33059, 32716, 5), effect = CONST_ME_ENERGYHIT },
	{ actionId = 25002, toPos = Position(32911, 32336, 15), effect = CONST_ME_MAGIC_RED }
}

local feyristExit = Action()

function feyristExit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, feyrist in pairs(backPositions) do
		if item.actionid == feyrist.actionId then
			player:teleportTo(feyrist.toPos)
			player:getPosition():sendMagicEffect(feyrist.effect)
			return true
		end
	end
end

feyristExit:aid(24999, 25000, 25001, 25002)
feyristExit:register()
