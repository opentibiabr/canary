local function migrateRoyalCostumeOutfit(player)
	local royalCostumeStorageValue = 51026
	local value = player:getStorageValue(royalCostumeStorageValue)

	if value > 0 then
		player:kv():set("golden-outfit-quest", value)
		player:setStorageValue(royalCostumeStorageValue, -1)
	end
end

local migration = Migration("20241711128698_royal_costume_outfit_to_kv")

function migration:onExecute()
	self:forEachPlayer(migrateRoyalCostumeOutfit)
end

migration:register()
