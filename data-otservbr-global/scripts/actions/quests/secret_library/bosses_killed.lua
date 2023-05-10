local bosses = {
	["ghulosh"] = {storage = Storage.Quest.U11_80.TheSecretLibrary.GhuloshKilled},
	["gorzindel"] = {storage = Storage.Quest.U11_80.TheSecretLibrary.GorzindelKilled},
	["lokathmor"] = {storage = Storage.Quest.U11_80.TheSecretLibrary.LokathmorKilled},
	["mazzinor"] = {storage = Storage.Quest.U11_80.TheSecretLibrary.MazzinorKilled},
	["scourge of oblivion"] = {storage = Storage.Quest.U11_80.TheSecretLibrary.ScourgeOfOblivionKilled},
}

local bossesSecretLibrary = CreatureEvent("SecretLibraryKill")
function bossesSecretLibrary.onKill(player, target)
	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end
	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end
	for key, value in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(key)
		if attackerPlayer then
			if bossConfig.storage then
				attackerPlayer:setStorageValue(bossConfig.storage, 1)
			end
		end
	end
	local bossesKilled = 0
	for value in pairs(bosses) do
		if player:getStorageValue(bosses[value].storage) > 0 then
			bossesKilled = bossesKilled + 1
		end
	end
	if bossesKilled >= 4 then -- number of mini bosses
		player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.ScourgeOfOblivionDoor, 1)
	end
	return true
end
bossesSecretLibrary:register()