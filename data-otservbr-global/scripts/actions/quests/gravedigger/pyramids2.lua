local config = {
	[4663] = {Storage.GravediggerOfDrefia.Mission38, Storage.GravediggerOfDrefia.Mission62},
	[4664] = {Storage.GravediggerOfDrefia.Mission38a, Storage.GravediggerOfDrefia.Mission63},
	[4665] = {Storage.GravediggerOfDrefia.Mission38b, Storage.GravediggerOfDrefia.Mission64},
	[4666] = {Storage.GravediggerOfDrefia.Mission38c, Storage.GravediggerOfDrefia.Mission65},
	[4667] = {Storage.GravediggerOfDrefia.Mission38c, Storage.GravediggerOfDrefia.Mission66}
}

local gravediggerPyramids2 = Action()
function gravediggerPyramids2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cStorages = config[target.actionid]
	if not cStorages then
		return true
	end

	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
		else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Mission already completed here!')
	end
	return true
end

gravediggerPyramids2:id(21249)
gravediggerPyramids2:register()