local bigfootRepair = Action()
function bigfootRepair.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target:isMonster() then
		return false
	end

	if target:getName():lower() ~= "damaged crystal golem" then
		return false
	end

	if player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.MissionTinkersBell) ~= 1 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.GolemCount) >= 4 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have returned enough golems for now. Give the gnomes some time for their repairs. Report back now.")
		return true
	end

	player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.GolemCount, player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.GolemCount) + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The golem has been returned to the gnomish workshop.")
	target:remove()
	player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)

	return true
end

bigfootRepair:id(15832)
bigfootRepair:register()
