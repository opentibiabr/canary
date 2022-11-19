local desperateSoul = MoveEvent()

function desperateSoul.onStepIn(creature, item, position, fromPosition)
	local monster = creature:getMonster()
	if not monster or monster:getName():lower() ~= 'desperate soul' then
		return true
	end

	monster:remove()
	position:sendMagicEffect(CONST_ME_POFF)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.FerumbrasEssence, 1)
	addEvent(Game.setStorageValue, 2 * 60 * 1000, GlobalStorage.FerumbrasAscendant.FerumbrasEssence, 0)
	return true
end

desperateSoul:type("stepin")
desperateSoul:aid(54390)
desperateSoul:register()
