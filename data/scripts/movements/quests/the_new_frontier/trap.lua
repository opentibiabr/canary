local destination = Position(33170, 31253, 11)

local trap = MoveEvent()

function trap.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.TheNewFrontier.Questline) == 22 then
		--Questlog, The New Frontier Quest "Mission 07: Messengers Of Peace"
		player:setStorageValue(Storage.TheNewFrontier.Mission07, 2)
		player:setStorageValue(Storage.TheNewFrontier.Questline, 23)
	end

	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_POFF)
	player:say("So far for the negotiating peace. Now you have other problems to handle.", TALKTYPE_MONSTER_SAY)
	return true
end

trap:type("stepin")
trap:aid(8007)
trap:register()
