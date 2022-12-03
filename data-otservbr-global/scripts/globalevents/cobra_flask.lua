local position = Position(33395, 32666, 5)

local cobraEmptyFlask = GlobalEvent("Cobraflask")

function cobraEmptyFlask.onThink(interval)
	local flask = Tile(position):getItemById(31297)
	if not flask then
		Game.createItem(31297, 1, position)
	end
	return true
end

cobraEmptyFlask:interval(1000 * 60 * 60 *8) -- 8 hours
cobraEmptyFlask:register()
