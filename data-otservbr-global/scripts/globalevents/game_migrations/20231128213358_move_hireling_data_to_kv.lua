local function migrateHirelingData(player)
	if not player then
		return false
	end

	logger.info("Migrating hireling data for player " .. player:getName())
end

local migration = Migration("20231128213158_move_hireling_data_to_kv")

function migration:onExecute()
	self:forEachPlayer(migrateHirelingData)
end

migration:register()
