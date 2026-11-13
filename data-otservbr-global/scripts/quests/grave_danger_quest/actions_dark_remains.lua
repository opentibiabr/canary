local voc_table = {
	[31203] = { voc = 4 },
	[31204] = { voc = 3 },
	[31205] = { voc = 2 },
	[31206] = { voc = 1 },
	[50311] = { voc = 9 },
}

local dark_remains = Action()

function dark_remains.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local canUse = voc_table[item.itemid]

	return canUse and GraveDanger.useRemains(player, item, target, canUse.voc) or false
end

dark_remains:id(31203, 31204, 31205, 31206, 50311)
dark_remains:register()
