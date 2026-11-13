-- Cosmetic state changes; the wooden dummy is decoration, not an exercise dummy.
local cycles = {
	{ 44030, 44031, 44032, 44033, 44034, 44035 },
	{ 51706, 51707, 51708, 51709, 51710, 51711, 51712, 51713 },
	{ 52867, 52868, 52869, 52870, 52871 },
}

local nextState = {}
local action = Action()
for _, cycle in ipairs(cycles) do
	for index, id in ipairs(cycle) do
		nextState[id] = cycle[index % #cycle + 1]
		action:id(id)
	end
end

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local nextId = nextState[item:getId()]
	if not nextId then
		return false
	end
	item:transform(nextId)
	return true
end

action:register()
