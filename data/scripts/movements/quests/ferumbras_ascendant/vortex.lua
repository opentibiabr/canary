local vortex = MoveEvent()

function vortex.onStepIn(creature, item, position, fromPosition)
	local monster = creature:getMonster()
	if not monster or monster:getName():lower() ~= 'ferumbras essence' then
		return true
	end

	monster:remove()
	position:sendMagicEffect(CONST_ME_POFF)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.FerumbrasEssence,
	Game.getStorageValue(GlobalStorage.FerumbrasAscendant.FerumbrasEssence) + 1)
	if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.FerumbrasEssence) >= 8 then
		Game.createMonster('Destabilized Ferumbras', Position(33392, 31473, 14), true, true)
		for i = 1, 20 do
			Game.createMonster('Rift Fragment', Position(math.random(33381, 33403), math.random(31462, 31483), 14), true, true)
		end
	end
	return true
end

vortex:type("stepin")
vortex:id(22455)
vortex:register()
