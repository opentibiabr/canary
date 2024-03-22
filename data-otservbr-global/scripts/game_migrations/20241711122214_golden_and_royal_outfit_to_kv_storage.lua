local function migrateGoldenOutfit(player)
	local goldeOutfitStorageValue = 51015
	local value = player:getStorageValue(goldeOutfitStorageValue)

	if value > 0 then
		player:kv():set("golden-outfit-quest", value)
		player:setStorageValue(goldeOutfitStorageValue, -1)
	end
end

local function migrateRoyalCostumeOutfit(player)
	local royalCostumeStorageValue = 51026
	local value = player:getStorageValue(royalCostumeStorageValue)

	if value > 0 then
		player:kv():set("royal-costume-outfit-quest", value)
		player:setStorageValue(royalCostumeStorageValue, -1)
	end
end

local migration = Migration("20241711122214_golden_and_royal_outfit_to_kv_storage")

function migration:onExecute()
	self:forEachPlayer(migrateGoldenOutfit)
	self:forEachPlayer(migrateRoyalCostumeOutfit)
end

migration:register()
