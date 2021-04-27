local servants = {
	['golden servant replica'] = {
		storage = GlobalStorage.ForgottenKnowledge.GoldenServant,
		playerStorage = Storage.ForgottenKnowledge.GoldenServantCounter
	},
	['diamond servant replica'] = {
		storage = GlobalStorage.ForgottenKnowledge.DiamondServant,
		playerStorage = Storage.ForgottenKnowledge.DiamondServantCounter
	}
}
local replicaServant = CreatureEvent("ReplicaServant")
function replicaServant.onKill(creature, target)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end

	local bossConfig = servants[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end
	if bossConfig.storage < 0 then
		Game.setStorageValue(bossConfig.storage, 0)
	end
	Game.setStorageValue(bossConfig.storage, Game.getStorageValue(bossConfig.storage) + 1)
	if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.GoldenServant) >= 5 and Game.getStorageValue(GlobalStorage.ForgottenKnowledge.DiamondServant) >= 5 then
		if not Tile(Position(32815, 32870, 13)):getItemById(11796) then
			local teleport = Game.createItem(11796, 1, Position(32815, 32870, 13))
			if teleport then
				teleport:setActionId(26665)
			end
		end
	end
	if player:getStorageValue(bossConfig.playerStorage) < 0 then
		player:setStorageValue(bossConfig.playerStorage, 0)
	end
	player:setStorageValue(bossConfig.playerStorage, player:getStorageValue(bossConfig.playerStorage) + 1)
	return true
end
replicaServant:register()
