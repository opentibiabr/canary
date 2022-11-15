local POLISHED_KEY_FRAGMENT01, POLISHED_KEY_FRAGMENT02 = 27264, 27263

local config = {
	[27261] = { POLISHED_KEY_FRAGMENT01 },
	[27262] = { POLISHED_KEY_FRAGMENT02 },
}

local metalFile = Action()
function metalFile.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.itemid]
	if not targetItem then
		return true
	end

	target:transform(targetItem[1])
	toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

metalFile:id(27270)
metalFile:register()
