local config = {
	[1] = {
		pos = Position(32644, 32394, 8),
		stor = Storage.Quest.U12_20.GraveDanger.Graves.DarkCathedral,
		msg = "This grave now been sanctified and is safe!",
	},
	[2] = {
		pos = Position(32542, 31846, 6),
		stor = Storage.Quest.U12_20.GraveDanger.Graves.FemorHills,
		msg = "This grave is already defiled and the lich knight has left! There is nothing you can do here.",
	},
	[3] = {
		pos = Position(33376, 32806, 8),
		stor = Storage.Quest.U12_20.GraveDanger.Graves.Ankrahmun,
		msg = "This grave now been sanctified and is safe!",
	},
	[4] = {
		pos = Position(32959, 31534, 7),
		stor = Storage.Quest.U12_20.GraveDanger.Graves.Vengoth,
		msg = "This grave is already defiled and the lich knight has left! There is nothing you can do here.",
	},
	[5] = {
		pos = Position(32776, 31817, 8),
		stor = Storage.Quest.U12_20.GraveDanger.Graves.Orclands,
		msg = "This grave is already defiled and the lich knight has left! There is nothing you can do here.",
	},
	[6] = {
		pos = Position(32012, 31558, 7),
		stor = Storage.Quest.U12_20.GraveDanger.Graves.IceIslands,
		msg = "This grave is already defiled and the lich knight has left! There is nothing you can do here.",
	},
	[7] = {
		pos = Position(33813, 31624, 9),
		stor = Storage.Quest.U12_20.GraveDanger.Graves.Kilmaresh,
		msg = "This grave now been sanctified and is safe!",
	},
}

local function getGrave(pos)
	for i = 1, #config do
		if pos == config[i].pos then
			return i
		end
	end

	return true
end

local grave_sanctify = Action()

function grave_sanctify.onUse(player, item, fromPosition, itemEx, toPosition)
	local thing = config[getGrave(itemEx:getPosition())]

	if not thing then
		return true
	end

	if player:getStorageValue(thing.stor) < 1 then
		player:setStorageValue(thing.stor, 1)
		itemEx:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, thing.msg)
		player:setStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Progress, player:getStorageValue(Storage.Quest.U12_20.GraveDanger.Graves.Progress) + 1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, thing.msg)
	end

	return true
end

grave_sanctify:id(31612)
grave_sanctify:register()
