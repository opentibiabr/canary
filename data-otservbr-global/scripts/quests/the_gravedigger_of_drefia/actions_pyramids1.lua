local config = {
	[4646] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38a },
	[4647] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38a, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38b },
	[4648] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38b, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38c },
	[4649] = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission38c, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission39 },
}

local gravediggerPyramids1 = Action()
function gravediggerPyramids1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cStorages = config[target.actionid]
	if not cStorages then
		return true
	end

	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "<sizzle> <fizz>")
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

gravediggerPyramids1:id(19133)
gravediggerPyramids1:register()
