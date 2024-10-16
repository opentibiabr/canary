local goPos = Position(32814, 32754, 9)

local actions_asura_mirror = Action()

function actions_asura_mirror.onUse(player, item, fromPosition, itemEx, toPosition)
	if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Asuras.FlammingOrchid) >= 1 and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline) >= 1 then
		if player:getLevel() >= 250 then
			player:teleportTo(goPos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:sendCancelMessage("You do not have enough level.")
		end
	else
		player:sendCancelMessage("You do not have permission.")
	end
end

actions_asura_mirror:aid(4910)
actions_asura_mirror:register()
