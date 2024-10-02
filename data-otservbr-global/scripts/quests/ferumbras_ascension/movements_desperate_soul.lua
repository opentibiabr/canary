local desperateSoul = MoveEvent()

function desperateSoul.onStepIn(creature, item, position, fromPosition)
	if not creature:isMonster() or creature:getName():lower() ~= "desperate soul" then
		return true
	end

	creature:remove()
	position:sendMagicEffect(CONST_ME_POFF)

	local player = Tile(fromPosition):getTopCreature()
	if player and player:isPlayer() then
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence, 1)
		addEvent(function()
			player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence, 0)
		end, 2 * 60 * 1000)
	end

	return true
end

desperateSoul:type("stepin")
desperateSoul:aid(54390)
desperateSoul:register()
