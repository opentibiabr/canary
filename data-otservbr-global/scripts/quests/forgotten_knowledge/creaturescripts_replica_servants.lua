local servants = {
	["golden servant replica"] = {
		storage = Storage.Quest.U11_02.ForgottenKnowledge.GoldenServant,
		playerStorage = Storage.Quest.U11_02.ForgottenKnowledge.GoldenServantCounter,
	},
	["diamond servant replica"] = {
		storage = Storage.Quest.U11_02.ForgottenKnowledge.DiamondServant,
		playerStorage = Storage.Quest.U11_02.ForgottenKnowledge.DiamondServantCounter,
	},
}
local replicaServant = CreatureEvent("ReplicaServantDeath")
function replicaServant.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local bossConfig = servants[creature:getName():lower()]
	if not bossConfig then
		return true
	end
	if bossConfig.storage < 0 then
		Game.setStorageValue(bossConfig.storage, 0)
	end
	Game.setStorageValue(bossConfig.storage, Game.getStorageValue(bossConfig.storage) + 1)
	if Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.GoldenServant) >= 5 and Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.DiamondServant) >= 5 then
		if not Tile(Position(32815, 32870, 13)):getItemById(10840) then
			local teleport = Game.createItem(10840, 1, Position(32815, 32870, 13))
			if teleport then
				teleport:setActionId(26665)
			end
		end
	end
	local player = Player(mostDamageKiller)
	if not player then
		return true
	end
	if player:getStorageValue(bossConfig.playerStorage) < 0 then
		player:setStorageValue(bossConfig.playerStorage, 0)
	end
	player:setStorageValue(bossConfig.playerStorage, player:getStorageValue(bossConfig.playerStorage) + 1)
	return true
end

replicaServant:register()
