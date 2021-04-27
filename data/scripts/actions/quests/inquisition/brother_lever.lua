local config = {
	[1006] = {
		wallPositions = {
			Position(33226, 31721, 11),
			Position(33227, 31721, 11),
			Position(33228, 31721, 11),
			Position(33229, 31721, 11),
			Position(33230, 31721, 11),
			Position(33231, 31721, 11),
			Position(33232, 31721, 11),
			Position(33233, 31721, 11),
			Position(33234, 31721, 11),
			Position(33235, 31721, 11),
			Position(33236, 31721, 11),
			Position(33237, 31721, 11),
			Position(33238, 31721, 11)
		},
		wallDown = 1524,
		wallUp = 1050
	},
	[1007] = {
		wallPositions = {
			Position(33223, 31724, 11),
			Position(33223, 31725, 11),
			Position(33223, 31726, 11),
			Position(33223, 31727, 11),
			Position(33223, 31728, 11),
			Position(33223, 31729, 11),
			Position(33223, 31730, 11),
			Position(33223, 31731, 11),
			Position(33223, 31732, 11)
		},
		wallDown = 1526,
		wallUp = 1049
	},
	[1008] = {
		wallPositions = {
			Position(33226, 31735, 11),
			Position(33227, 31735, 11),
			Position(33228, 31735, 11),
			Position(33229, 31735, 11),
			Position(33230, 31735, 11),
			Position(33231, 31735, 11),
			Position(33232, 31735, 11),
			Position(33233, 31735, 11),
			Position(33234, 31735, 11),
			Position(33235, 31735, 11),
			Position(33236, 31735, 11),
			Position(33237, 31735, 11),
			Position(33238, 31735, 11)
		},
		wallDown = 1524,
		wallUp = 1050
	},
	[1009] = {
		wallPositions = {
			Position(33241, 31724, 11),
			Position(33241, 31725, 11),
			Position(33241, 31726, 11),
			Position(33241, 31727, 11),
			Position(33241, 31728, 11),
			Position(33241, 31729, 11),
			Position(33241, 31730, 11),
			Position(33241, 31731, 11),
			Position(33241, 31732, 11)
		},
		wallDown = 1526,
		wallUp = 1049
	}
}

local inquisitionBrother = Action()
function inquisitionBrother.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetLever = config[item.uid]
	if not targetLever then
		return true
	end

	local tile, thing
	for i = 1, #targetLever.wallPositions do
		tile = Tile(targetLever.wallPositions[i])
		if tile then
			thing = tile:getItemById(item.itemid == 1945 and targetLever.wallDown or targetLever.wallUp)
			if thing then
				thing:transform(item.itemid == 1945 and targetLever.wallUp or targetLever.wallDown)
			end
		end
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

inquisitionBrother:uid(1006,1007,1008,1009)
inquisitionBrother:register()