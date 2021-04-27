dofile('data/modules/scripts/blessings/blessings.lua')

local blessStatus = TalkAction("/bless")

function blessStatus.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	Blessings.sendBlessStatus(player)
	return false
end

blessStatus:separator(" ")
blessStatus:register()
