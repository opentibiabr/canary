local bosses = {
	["ushuriel"] = 200,
	["zugurosh"] = 201,
	["madareth"] = 202,
	["latrivan"] = 203,
	["golgordan"] = 203,
	["annihilon"] = 204,
	["hellgorak"] = 205,
}

local inquisitionBossKill = CreatureEvent("InquisitionBossDeath")
function inquisitionBossKill.onDeath(creature)
	local targetName = creature:getName():lower()
	local bossStorage = bosses[targetName]
	if not bossStorage then
		return true
	end

	local newValue = 2
	if targetName == "latrivan" or targetName == "golgordan" then
		newValue = math.max(0, Game.getStorageValue(bossStorage)) + 1
	end
	Game.setStorageValue(bossStorage, newValue)

	if newValue == 2 then
		onDeathForDamagingPlayers(creature, function(creature, player)
			player:say("You now have 10 minutes to exit this room through the teleporter. It will bring you to the next room.", TALKTYPE_MONSTER_SAY)
		end)
		addEvent(Game.setStorageValue, 10 * 60 * 1000, bossStorage, 0)
	end
	return true
end

inquisitionBossKill:register()
