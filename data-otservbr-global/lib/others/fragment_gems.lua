MAX_GEM_BREAK = 10

FRAGMENT_GEMS = {
	small = { ids = { 44602, 44605, 44608, 44611 }, fragment = 46625, range = { 1, 4 } },
	medium = { ids = { 44603, 44606, 44609, 44612 }, fragment = 46625, range = { 2, 8 } },
	great = { ids = { 44604, 44607, 44610, 44613 }, fragment = 46626, range = { 1, 4 } },
}

function getGemData(id)
	for _, gem in pairs(FRAGMENT_GEMS) do
		if table.contains(gem.ids, id) then
			return gem.fragment, gem.range
		end
	end
	return nil
end
