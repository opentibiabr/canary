local setting = {
		[5511] = {storage = Storage.CultsOfTibia.Minotaurs.BossTimer},
		[5513] = {storage = Storage.CultsOfTibia.Humans.BossTimer},
		[5514] = {storage = Storage.CultsOfTibia.Misguided.BossTimer},
		[5515] = {storage = Storage.CultsOfTibia.FinalBoss.BossTimer},
		[5516] = {storage = Storage.CultsOfTibia.Orcs.BossTimer},
		[5512] = {storage = Storage.CultsOfTibia.Barkless.BossTimer}
	}

local bossTimer = MoveEvent()

function bossTimer.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local bossTimer = setting[item.actionid]
	if bossTimer then
		if player:getStorageValue(bossTimer.storage) > os.time() then
			player:sendCancelMessage("You need to wait for 20 hours to face this boss again.")
			player:teleportTo(fromPosition)
			return false
		end
	end
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

bossTimer:type("stepin")

for index, value in pairs(setting) do
	bossTimer:aid(index)
end

bossTimer:register()
