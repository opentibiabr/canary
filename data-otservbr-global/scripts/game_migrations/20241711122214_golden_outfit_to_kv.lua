local function migrateGoldenOutfit(player)
	local goldeOutfitStorageValue = 51015
	local value = player:getStorageValue(goldeOutfitStorageValue)

	if value > 0 then
		player:kv():set("royal-costume-outfit-quest", value)
		player:setStorageValue(goldeOutfitStorageValue, -1)
	end
end

local migration = Migration("20241711122214_golden_outfit_to_kv_storage")

function migration:onExecute()
	self:forEachPlayer(migrateGoldenOutfit)
end

migration:register()
