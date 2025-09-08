local vortex = MoveEvent()

local config = AscendingFerumbrasConfig

function vortex.onStepIn(creature, item, position, fromPosition)
	local monster = creature:getMonster()
	if not monster or monster:getName():lower() ~= "ferumbras essence" then
		return true
	end

	monster:remove()
	position:sendMagicEffect(CONST_ME_POFF)
	Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence, Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence) + 1)
	if Game.getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence) >= 8 then
		Game.createMonster("Destabilized Ferumbras", config.bossPos, true, true)
		for i = 1, config.maxSummon do
			Game.createMonster("Rift Fragment", Position(math.random(33381, 33403), math.random(31462, 31483), 14), true, true)
		end
	end
	return true
end

vortex:type("stepin")
vortex:id(config.vortex)
vortex:register()
