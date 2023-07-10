local setting = {
	{
	tpPos = {x = 33176, y = 31894, z = 15},
	tpDestination = {x = 33166, y = 31894, z = 15},
	storage = Storage.CultsOfTibia.Minotaurs.BossTimer},
	{
	tpPos = {x = 33125, y = 31950, z = 15},
	tpDestination = {x = 33136, y = 31948, z = 15},
	storage = Storage.CultsOfTibia.Barkless.BossTimer},
	{
	tpPos = {x = 33096, y = 31963, z = 15},
	tpDestination = {x = 33095, y = 31953, z = 15},
	storage = Storage.CultsOfTibia.Humans.BossTimer},
	{
	tpPos = {x = 33114, y = 31887, z = 15},
	tpDestination = {x = 33131, y = 31899, z = 15},
	storage = Storage.CultsOfTibia.Misguided.BossTimer},
	{
	tpPos = {x = 33072, y = 31871, z = 15},
	tpDestination = {x = 33078, y = 31889, z = 15},
	storage = Storage.CultsOfTibia.FinalBoss.BossTimer},
	{
	tpPos = {x = 33178, y = 31845, z = 15},
	tpDestination = {x = 33164, y = 31866, z = 15},
	storage = Storage.CultsOfTibia.Orcs.BossTimer}
}

local bossTimer = MoveEvent()

function bossTimer.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	for b = 1, #setting do
		if player:getPosition() == Position(setting[b].tpPos) then
			if player:getStorageValue(setting[b].storage) > os.time() then
				player:sendCancelMessage("You need to wait for 20 hours to face this boss again.")
				player:teleportTo(fromPosition)
				return false
			end
		player:teleportTo(Position(setting[b].tpDestination))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return true
end

for a = 1, #setting do
	bossTimer:position(setting[a].tpPos)
end

bossTimer:register()
