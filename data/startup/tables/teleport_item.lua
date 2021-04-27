-- Look README.md for see the reserved action/unique numbers
-- This file is only for teleports items (miscellaneous) not for magic forcefields

TeleportItemAction = {
	[15001] = {
		itemId = false,
		itemPos = {
			{x = xxxxx, y = xxxxx, z = x}
		},
	}
}

TeleportItemUnique = {
	[15001] = {
		itemId = xxxx,
		itemPos = {x = xxxxx, y = xxxxx, z = x},
		destination = {x = xxxxx, y = xxxxx, z = x7},
		effect = CONST_ME_TELEPORT
	}
}
