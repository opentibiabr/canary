local migration = Migration("20241711122214_golden_outfit_to_kv_storage")

local function migrateGoldenOutfit(player)
	local goldeOutfitStorageValue = 51015
	local value = player:getPlayerStorageValue(goldeOutfitStorageValue)

	if value > 0 then
		player:kv():set("golden-outfit-quest", value)
		player:setPlayerStorageValue(goldeOutfitStorageValue, -1)
	end
end

function migration:onExecute()
	self:forEachPlayer(migrateGoldenOutfit)
end

migration:register()
