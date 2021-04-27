local config = {
	[4641] = {storageKey = {Storage.GravediggerOfDrefia.Mission32, Storage.GravediggerOfDrefia.Mission32a}, message = 'Shadows rise and engulf the candle. The statue flickers in an unearthly light.'},
	[4642] = {storageKey = {Storage.GravediggerOfDrefia.Mission32a, Storage.GravediggerOfDrefia.Mission32b}, message = 'The shadows of the statue swallow the candle hungrily.'},
	[4643] = {storageKey = {Storage.GravediggerOfDrefia.Mission32b, Storage.GravediggerOfDrefia.Mission33}, message = 'A shade emerges and snatches the candle from your hands.'}
}

local gravediggerMonks = Action()
function gravediggerMonks.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.actionid]
	if not targetItem then
		return true
	end

	local cStorages = targetItem.storageKey
	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetItem.message)
		item:remove(1)
	end
	return true
end

gravediggerMonks:id(21248)
gravediggerMonks:register()