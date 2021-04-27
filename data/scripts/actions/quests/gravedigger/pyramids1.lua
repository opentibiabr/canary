local config = {
	[4646] = {Storage.GravediggerOfDrefia.Mission38, Storage.GravediggerOfDrefia.Mission38a},
	[4647] = {Storage.GravediggerOfDrefia.Mission38a, Storage.GravediggerOfDrefia.Mission38b},
	[4648] = {Storage.GravediggerOfDrefia.Mission38b, Storage.GravediggerOfDrefia.Mission38c},
	[4649] = {Storage.GravediggerOfDrefia.Mission38c, Storage.GravediggerOfDrefia.Mission39}
}

local gravediggerPyramids1 = Action()
function gravediggerPyramids1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cStorages = config[target.actionid]
	if not cStorages then
		return true
	end

	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<sizzle> <fizz>')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

gravediggerPyramids1:id(21449)
gravediggerPyramids1:register()