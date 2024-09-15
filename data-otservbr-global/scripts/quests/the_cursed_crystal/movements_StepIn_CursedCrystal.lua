local StepInCursedCrystal = MoveEvent()

local MIN_POS_GO = Position(31957, 32935, 9)
local MAX_POS_GO = Position(31966, 32942, 9)

local function isInArea(pos, fromPos, toPos)
	return pos.x >= fromPos.x and pos.x <= toPos.x and pos.y >= fromPos.y and pos.y <= toPos.y and pos.z == fromPos.z
end

function StepInCursedCrystal.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if item.actionid == 35001 then
		local playerPos = player:getPosition()

		if isInArea(playerPos, MIN_POS_GO, MAX_POS_GO) then
			player:teleportTo(Position(31961, 32938, 10))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:sendCancelMessage("You are not in the correct area.")
		end
	elseif item.actionid == 25018 then
		-- (O código para o actionid 25018 permanece o mesmo)
		local playerPos = player:getPosition()

		if playerPos == Position(31973, 32905, 11) then
			player:teleportTo(Position(31971, 32904, 10))
		elseif playerPos == Position(31973, 32905, 10) then
			player:teleportTo(Position(31975, 32911, 9))
		elseif playerPos == Position(32009, 32928, 9) then
			player:teleportTo(Position(32009, 32929, 10))
		elseif playerPos == Position(32009, 32928, 10) then
			player:teleportTo(Position(32009, 32929, 9))
		elseif playerPos == Position(32017, 32917, 10) or playerPos == Position(32017, 32918, 10) then
			if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline) == 0 then
				player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline, 1)
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This small room could once have been a shrine of some kind. You discover an old inscription between two ornate stone walls.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The text is partly crumbled: 'Take ... vial of emb... fl... and mix ... a medusa's bl.... Then .. the dust of ... crystal, so ... will get the Medusa's Ointm... powerful ... able to unpetrify ...")
			return true
		else
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end

		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

StepInCursedCrystal:type("stepin")
StepInCursedCrystal:aid(35001, 25018)
StepInCursedCrystal:register()
