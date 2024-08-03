local isVipStorage = 150001

local function migrateIsVipSystem(player)
	local isVipValue = player:getStorageValue(isVipStorage)
	if isVipValue > 0 then
		player:kv():scoped("account"):set("vip-system", true)
		player:setStorageValue(isVipStorage, -1)
	end
end

local migration = Migration("20241708362079_move_vip_system_to_kv")

function migration:onExecute()
	self:forEachPlayer(migrateIsVipSystem)
end

migration:register()
