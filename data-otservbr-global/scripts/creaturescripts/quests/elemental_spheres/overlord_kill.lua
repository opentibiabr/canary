local overlords = {
	['energy overlord'] = {storage = Storage.ElementalSphere.BossStorage, globalStorage = GlobalStorage.ElementalSphere.KnightBoss},
	['fire overlord'] = {storage = Storage.ElementalSphere.BossStorage, globalStorage = GlobalStorage.ElementalSphere.SorcererBoss},
	['ice overlord'] = {storage = Storage.ElementalSphere.BossStorage, globalStorage = GlobalStorage.ElementalSphere.PaladinBoss},
	['earth overlord'] = {storage = Storage.ElementalSphere.BossStorage, globalStorage = GlobalStorage.ElementalSphere.DruidBoss},
	['lord of the elements'] = {}
}

local elementalSpheresOver = CreatureEvent("OverlordKill")
function elementalSpheresOver.onKill(creature, target)
	if not target:isMonster() then
		return true
	end

	local bossName = target:getName()
	local bossConfig = overlords[bossName:lower()]
	if not bossConfig then
		return true
	end

	if bossConfig.globalStorage then
		Game.setStorageValue(bossConfig.globalStorage, 0)
	end

	if bossConfig.storage and creature:getStorageValue(bossConfig.storage) < 1 then
		creature:setStorageValue(bossConfig.storage, 1)
	end

	creature:say('You slayed ' .. bossName .. '.', TALKTYPE_MONSTER_SAY)
	return true
end

elementalSpheresOver:register()
