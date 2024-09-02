local config = {
	[4663] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission62 },
	[4664] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38a, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission63 },
	[4665] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38b, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission64 },
	[4666] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38c, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission65 },
	[4667] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38c, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission66 },
}

local gravediggerPyramids2 = Action()
function gravediggerPyramids2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cStorages = config[target.actionid]
	if not cStorages then
		return true
	end

	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "<screeeech> <squeak> <squeaaaaal>")
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Mission already completed here!")
	end
	return true
end

gravediggerPyramids2:id(18932)
gravediggerPyramids2:register()
