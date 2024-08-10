local overlords = {
	["energy overlord"] = { storage = Storage.Quest.U8_2.ElementalSpheres.BossStorage, globalStorage = Storage.Quest.U8_2.ElementalSpheres.KnightBoss },
	["fire overlord"] = { storage = Storage.Quest.U8_2.ElementalSpheres.BossStorage, globalStorage = Storage.Quest.U8_2.ElementalSpheres.SorcererBoss },
	["ice overlord"] = { storage = Storage.Quest.U8_2.ElementalSpheres.BossStorage, globalStorage = Storage.Quest.U8_2.ElementalSpheres.PaladinBoss },
	["earth overlord"] = { storage = Storage.Quest.U8_2.ElementalSpheres.BossStorage, globalStorage = Storage.Quest.U8_2.ElementalSpheres.DruidBoss },
	["lord of the elements"] = {},
}

local elementalSpheresOver = CreatureEvent("ElementalOverlordDeath")
function elementalSpheresOver.onDeath(creature)
	local bossName = creature:getName()
	local bossConfig = overlords[bossName:lower()]
	if not bossConfig then
		return true
	end

	if bossConfig.globalStorage then
		Game.setStorageValue(bossConfig.globalStorage, 0)
	end
	if not bossConfig.storage then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(bossConfig.storage) < 1 then
			player:setStorageValue(bossConfig.storage, 1)
		end
		player:say("You slayed " .. bossName .. ".", TALKTYPE_MONSTER_SAY)
	end)

	return true
end

elementalSpheresOver:register()
