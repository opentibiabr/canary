-- Record the runtime's legacy pairs order for declarations competing for one
-- item. Migration decisions reference this evidence, not source-file order.
dofile("data-otservbr-global/lib/core/storages.lua")
dofile("data-otservbr-global/startup/tables/chest.lua")
dofile("data-otservbr-global/startup/tables/tile.lua")
local cases = {
	{ name = "ChestUnique:5009/5010", values = ChestUnique, keys = { [5009] = true, [5010] = true } },
	{ name = "ChestUnique:6100/14036", values = ChestUnique, keys = { [6100] = true, [14036] = true } },
	{ name = "TileAction:25020/25021", values = TileAction, keys = { [25020] = true, [25021] = true } },
	{ name = "TileAction:50339/50340", values = TileAction, keys = { [50339] = true, [50340] = true } },
	{ name = "TileAction:50322/50346", values = TileAction, keys = { [50322] = true, [50346] = true } },
}
for _, case in ipairs(cases) do
	local order = {}
	for key in pairs(case.values) do
		if case.keys[key] then
			order[#order + 1] = tostring(key)
		end
	end
	assert(#order == 2)
	print("WORLD_LEGACY_ORDER " .. case.name .. " " .. table.concat(order, ","))
end
print("Legacy iteration characterization passed on " .. (jit and jit.version or _VERSION))
