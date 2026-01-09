local defaultTime = 20

local creaturescripts_library_bosses = CreatureEvent("killingLibrary")

function creaturescripts_library_bosses.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
	if not creature:isMonster() or creature:getMaster() then
		return true
	end

	local monsterStorages = {
		["grand commander soeren"] = { stg = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses, value = 1 },
		["preceptor lazare"] = { stg = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses, value = 2 },
		["grand chaplain gaunder"] = { stg = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses, value = 3 },
		["grand canon dominus"] = { stg = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses, value = 4 },
		["dazed leaf golem"] = { stg = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses, value = 5 },
		["grand master oberon"] = { stg = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses, value = 6, achievements = { "Millennial Falcon", "Master Debater" }, lastBoss = true },
		["brokul"] = { stg = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, value = 7 },
		["the flaming orchid"] = { stg = Storage.Quest.U11_80.TheSecretLibrary.Asuras.FlammingOrchid, value = 1 },
	}

	local monsterName = creature:getName():lower()
	local monsterStorage = monsterStorages[monsterName]

	if monsterStorage then
		for playerid, damage in pairs(creature:getDamageMap()) do
			local p = Player(playerid)
			if p then
				if p:getStorageValue(monsterStorage.stg) < monsterStorage.value then
					p:setStorageValue(monsterStorage.stg, monsterStorage.value)
				end
				if monsterStorage.achievements then
					for i = 1, #monsterStorage.achievements do
						p:addAchievement(monsterStorage.achievements[i])
					end
				end
				if monsterStorage.lastBoss then
					if p:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Questline) < 2 then
						p:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Questline, 2)
					end
				end
			end
		end
	end
	return true
end

creaturescripts_library_bosses:register()
