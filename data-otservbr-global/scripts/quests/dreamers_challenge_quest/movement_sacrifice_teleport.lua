local sacrificeTeleport = MoveEvent()

function sacrificeTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item.actionid == 50149 and player:getStorageValue(Storage.Quest.U7_9.NightmareOutfits.Outfits) >= 2 then
		player:teleportTo(Position(32835, 32225, 14)) --Sacrifice 2
		doSendMagicEffect(Position(32835, 32225, 14), CONST_ME_POFF) --Sacrifice 2
	elseif item.actionid == 50149 then
		player:teleportTo(Position(32844, 32228, 14)) --Sacrifice
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	else
		player:teleportTo(Position(32844, 32228, 14)) --Sacrifice
		if item.actionid == 50150 and player:getStorageValue(Storage.Quest.U7_9.BrotherhoodOutfits.Outfits) >= 2 then
			player:teleportTo(Position(32784, 32226, 14)) --Sacrifice 4
			doSendMagicEffect(Position(32835, 32225, 14), CONST_ME_POFF) --Sacrifice 2
		else
			player:teleportTo(Position(32790, 32227, 14)) --Sacrifice 3
		end
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end
end

sacrificeTeleport:type("stepin")
sacrificeTeleport:aid(50149, 50150)
sacrificeTeleport:register()
