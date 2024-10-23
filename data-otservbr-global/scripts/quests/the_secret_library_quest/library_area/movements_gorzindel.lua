local tomesPosition = {
	[1] = { position = Position(32687, 32707, 10), open = true },
	[2] = { position = Position(32698, 32715, 10), open = true },
	[3] = { position = Position(32693, 32729, 10), open = true },
	[4] = { position = Position(32681, 32729, 10), open = true },
	[5] = { position = Position(32676, 32715, 10), open = true },
}

local middlePosition = Position(32687, 32719, 10)

local movements_library_gorzindel = MoveEvent()

function movements_library_gorzindel.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local player = Player(creature:getId())

	for _, k in pairs(tomesPosition) do
		if k.open then
			player:teleportTo(k.position)
			k.open = false
			addEvent(function(cid)
				local p = Player(cid)
				if p then
					p:teleportTo(middlePosition)
					k.open = true
				end
			end, 10 * 1000, player:getId())
			break
		end
	end

	return true
end

movements_library_gorzindel:aid(4952)
movements_library_gorzindel:register()
