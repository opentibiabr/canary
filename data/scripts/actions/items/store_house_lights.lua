-- Native 15.25 light states. Item identity carries the owning world; no shared mutable timers.
local cycles = {
	{ 43693, 43695 },
	{ 43694, 43696 },
	{ 44087, 44088 },
	{ 44148, 44149 },
	{ 44089, 44090 },
	{ 44146, 44147 },
	{ 44515, 44516 },
	{ 45345, 45346 },
	{ 45347, 45348 },
	{ 45517, 45519 },
	{ 45518, 45520 },
	{ 45521, 45522 },
	{ 49211, 49212 },
	{ 49213, 49214 },
	{ 49258, 49259 },
	{ 49260, 49261 },
	{ 51220, 51221 },
	{ 51772, 51773 },
	{ 44460, 44461, 44462, 44463 }, -- crystal floor lamp colours
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
