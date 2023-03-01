local vipGod = TalkAction("/vip")

function vipGod.onSay(player, words, param)
	if not configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		player:sendCancelMessage('Vip System are not enabled!')
		return false
	end

	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- create log
	logCommand(player, words, param)

	local params = param:split(',')
	if not params[2] then
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format('Player is required.\nUsage:\n%s <action>, <name>, [, <value>]\n\nAvailable actions:\ncheck, adddays, addinfinite, removedays, remove', words))
		return false
	end

	local targetName = params[2]:trim()
	local target = Player(targetName)
	if not target then
		player:sendCancelMessage(string.format('Player (%s) is not online. Usage: %s <action>, <player> [, <value>]', targetName, words))
		return false
	end

	local action = params[1]:trim():lower()
	if action == 'adddays' then
		local amount = tonumber(params[3])
		if not amount then
			player:sendCancelMessage('<value> has to be a numeric value.')
			return false
		end

		target:addVipDays(amount)
		player:sendTextMessage(MESSAGE_STATUS, string.format('%s received %s vip day(s) and now has %s vip day(s).', target:getName(), amount, target:getVipDays()))

	elseif action == 'removedays' then
		local amount = tonumber(params[3])
		if not amount then
			player:sendCancelMessage('<value> has to be a numeric value.')
			return false
		end

		target:removeVipDays(amount)
		player:sendTextMessage(MESSAGE_STATUS, string.format('%s lost %s vip day(s) and now has %s vip day(s).', target:getName(), amount, target:getVipDays()))

	elseif action == 'addinfinite' then
		target:addInfiniteVip()
		player:sendTextMessage(MESSAGE_STATUS, string.format('%s now has infinite vip time.', target:getName()))

	elseif action == 'remove' then
		target:removeVip()
		player:sendTextMessage(MESSAGE_STATUS, string.format('You removed all vip days from %s.', target:getName()))

	elseif action == 'check' then
		local days = target:getVipDays()
		player:sendTextMessage(MESSAGE_STATUS, string.format('%s has %s vip day(s).', target:getName(), (days == 0xFFFF and 'infinite' or days)))

	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format('Action is required.\nUsage:\n%s <action>, <name>, [, <value>]\n\nAvailable actions:\ncheck, adddays, addinfinite, removedays, remove', words))
	end
	return false
end

vipGod:separator(" ")
vipGod:register()
